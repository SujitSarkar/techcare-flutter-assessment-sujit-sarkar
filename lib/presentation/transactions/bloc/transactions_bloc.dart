import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:take_home/core/errors/failure.dart';
import 'package:take_home/domain/entities/transaction.dart';
import 'package:take_home/domain/usecases/get_transactions.dart';
import 'package:take_home/domain/usecases/add_transaction.dart';
import 'package:take_home/domain/usecases/update_transaction.dart';
import 'package:take_home/domain/usecases/delete_transaction.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final GetTransactions getTransactions;
  final AddTransaction addTransaction;
  final UpdateTransaction updateTransaction;
  final DeleteTransaction deleteTransaction;

  TransactionsBloc({
    required this.getTransactions,
    required this.addTransaction,
    required this.updateTransaction,
    required this.deleteTransaction,
  }) : super(TransactionsInitialState()) {
    on<LoadTransactionsEvent>(_onLoadTransactions);
    on<RefreshTransactionsEvent>(_onRefreshTransactions);
    on<LoadMoreTransactionsEvent>(_onLoadMoreTransactions);
    on<ResetFiltersEvent>(_onResetFilters);
    on<AddTransactionEvent>(_onAddTransaction);
    on<UpdateTransactionEvent>(_onUpdateTransaction);
    on<DeleteTransactionEvent>(_onDeleteTransaction);
  }

  Future<void> _onLoadTransactions(LoadTransactionsEvent event, Emitter<TransactionsState> emit) async {
    emit(TransactionsLoadingState());

    final result = await getTransactions.call(page: 1, limit: 20);
    result.fold(
      onSuccess: (response) {
        final transactions = response.transactions;
        if (transactions.isEmpty) {
          emit(const TransactionsEmptyState());
        } else {
          final filteredTransactions = _applyAllFilters(
            transactions,
            event.searchQuery,
            event.startDate,
            event.endDate,
            event.selectedCategories,
            event.minAmount,
            event.maxAmount,
            event.transactionType,
          );
          emit(
            TransactionsLoadedState(
              transactions: transactions,
              filteredTransactions: filteredTransactions,
              currentPage: response.currentPage,
              hasMore: response.hasMore,
              startDate: event.startDate,
              endDate: event.endDate,
              selectedCategories: event.selectedCategories,
              minAmount: event.minAmount,
              maxAmount: event.maxAmount,
              transactionType: event.transactionType,
            ),
          );
        }
      },
      onFailure: (Failure failure) => emit(TransactionsErrorState(failure.message)),
    );
  }

  Future<void> _onRefreshTransactions(RefreshTransactionsEvent event, Emitter<TransactionsState> emit) async {
    if (state is TransactionsLoadedState) {
      emit(TransactionsLoadingState());
      final result = await getTransactions.call(page: 1, limit: 20);
      result.fold(
        onFailure: (failure) => emit(TransactionsErrorState(failure.message)),
        onSuccess: (response) {
          if (response.transactions.isEmpty) {
            emit(const TransactionsEmptyState());
          } else {
            emit(
              TransactionsLoadedState(
                transactions: response.transactions,
                filteredTransactions: response.transactions,
                currentPage: response.currentPage,
                hasMore: response.hasMore,
                isLoadingMore: false,
              ),
            );
          }
        },
      );
    }
  }

  Future<void> _onLoadMoreTransactions(LoadMoreTransactionsEvent event, Emitter<TransactionsState> emit) async {
    if (state is TransactionsLoadedState) {
      final currentState = state as TransactionsLoadedState;

      if (!currentState.hasMore || currentState.isLoadingMore) {
        return;
      }

      emit(currentState.copyWith(isLoadingMore: true));

      final result = await getTransactions.call(page: currentState.currentPage + 1, limit: currentState.itemsPerPage);

      result.fold(
        onFailure: (failure) {
          emit(currentState.copyWith(isLoadingMore: false));
          emit(TransactionsErrorState(failure.message));
        },
        onSuccess: (response) {
          List<Transaction> updatedTransactions = List<Transaction>.from(currentState.transactions)
            ..addAll(response.transactions);

          final filteredTransactions = _applyAllFilters(
            updatedTransactions,
            event.searchQuery,
            event.startDate,
            event.endDate,
            event.selectedCategories,
            event.minAmount,
            event.maxAmount,
            event.transactionType,
          );

          emit(
            currentState.copyWith(
              transactions: updatedTransactions,
              filteredTransactions: filteredTransactions,
              currentPage: response.currentPage,
              hasMore: response.hasMore,
              isLoadingMore: false,
              startDate: event.startDate,
              endDate: event.endDate,
              selectedCategories: event.selectedCategories,
              minAmount: event.minAmount,
              maxAmount: event.maxAmount,
              transactionType: event.transactionType,
            ),
          );
        },
      );
    }
  }

  void _onResetFilters(ResetFiltersEvent event, Emitter<TransactionsState> emit) {
    if (state is TransactionsLoadedState) {
      final currentState = state as TransactionsLoadedState;
      emit(
        currentState.copyWith(
          filteredTransactions: currentState.transactions,
          startDate: null,
          endDate: null,
          selectedCategories: const [],
          minAmount: null,
          maxAmount: null,
          transactionType: null,
        ),
      );
    }
  }

  Future<void> _onAddTransaction(AddTransactionEvent event, Emitter<TransactionsState> emit) async {
    final currentState = state;

    if (currentState is TransactionsLoadedState) {
      emit(currentState.copyWith(isLoading: true));

      final result = await addTransaction.call(event.transaction);
      result.fold(
        onFailure: (failure) {
          emit(currentState.copyWith(isLoading: false));
          emit(TransactionsErrorState(failure.message));
        },
        onSuccess: (addedTransaction) async {
          emit(TransactionAddedState(transaction: addedTransaction));
          await Future.delayed(const Duration(milliseconds: 100));

          final updatedTransactions = List<Transaction>.from(currentState.transactions)..insert(0, addedTransaction);
          final filteredTransactions = updatedTransactions;

          emit(
            currentState.copyWith(
              transactions: updatedTransactions,
              filteredTransactions: filteredTransactions,
              isLoading: false,
            ),
          );
        },
      );
    }
  }

  Future<void> _onUpdateTransaction(UpdateTransactionEvent event, Emitter<TransactionsState> emit) async {
    final currentState = state;

    if (currentState is TransactionsLoadedState) {
      emit(currentState.copyWith(isLoading: true));

      final result = await updateTransaction.call(event.transaction);
      result.fold(
        onFailure: (failure) {
          emit(currentState.copyWith(isLoading: false));
          emit(TransactionsErrorState(failure.message));
        },
        onSuccess: (updatedTransaction) async {
          emit(TransactionUpdatedState(transaction: updatedTransaction));
          await Future.delayed(const Duration(milliseconds: 100));

          final int index = currentState.transactions.indexWhere(
            (transaction) => transaction.id == updatedTransaction.id,
          );
          final updatedTransactions = List<Transaction>.from(currentState.transactions)..[index] = updatedTransaction;

          final filteredTransactions = updatedTransactions;

          emit(
            currentState.copyWith(
              transactions: updatedTransactions,
              filteredTransactions: filteredTransactions,
              isLoading: false,
            ),
          );
        },
      );
    }
  }

  Future<void> _onDeleteTransaction(DeleteTransactionEvent event, Emitter<TransactionsState> emit) async {
    final currentState = state;

    if (currentState is TransactionsLoadedState) {
      emit(currentState.copyWith(isLoading: true));

      final result = await deleteTransaction.call(event.transactionId);
      result.fold(
        onFailure: (failure) {
          emit(currentState.copyWith(isLoading: false));
          emit(TransactionsErrorState(failure.message));
        },
        onSuccess: (success) async {
          if (success) {
            emit(TransactionDeletedState(transactionId: event.transactionId));
            await Future.delayed(const Duration(milliseconds: 100));

            final int index = currentState.transactions.indexWhere(
              (transaction) => transaction.id == event.transactionId,
            );

            final updatedTransactions = List<Transaction>.from(currentState.transactions)..removeAt(index);
            final filteredTransactions = updatedTransactions;

            emit(
              currentState.copyWith(
                transactions: updatedTransactions,
                filteredTransactions: filteredTransactions,
                isLoading: false,
              ),
            );
          } else {
            emit(TransactionsErrorState('Failed to delete transaction'));
          }
        },
      );
    }
  }

  List<Transaction> _applyAllFilters(
    List<Transaction> transactions,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
    List<String> selectedCategories,
    double? minAmount,
    double? maxAmount,
    TransactionType? transactionType,
  ) {
    return transactions.where((transaction) {
      // Search query filter
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final title = transaction.title?.toLowerCase() ?? '';
        final description = transaction.description?.toLowerCase() ?? '';
        final categoryName = transaction.category?.name?.toLowerCase() ?? '';
        if (!title.contains(searchQuery) && !description.contains(searchQuery) && !categoryName.contains(searchQuery)) {
          return false;
        }
      }
      // Date range filter
      if (startDate != null || endDate != null) {
        final transactionDate = transaction.date;
        if (transactionDate == null) return false;

        if (startDate != null && transactionDate.isBefore(startDate)) return false;
        if (endDate != null && transactionDate.isAfter(endDate)) return false;
      }

      // Category filter
      if (selectedCategories.isNotEmpty) {
        final categoryName = transaction.category?.name ?? '';
        if (!selectedCategories.contains(categoryName)) return false;
      }

      // Amount range filter
      if (minAmount != null || maxAmount != null) {
        final amount = transaction.amount ?? 0.0;
        if (minAmount != null && amount < minAmount) return false;
        if (maxAmount != null && amount > maxAmount) return false;
      }

      // Transaction type filter
      if (transactionType != null && transaction.type != transactionType) {
        return false;
      }

      return true;
    }).toList();
  }
}
