import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:take_home/domain/entities/transaction.dart';
import 'package:take_home/domain/usecases/get_transactions.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final GetTransactions getTransactions;

  TransactionsBloc({required this.getTransactions}) : super(TransactionsInitialState()) {
    on<LoadTransactionsEvent>(_onLoadTransactions);
    on<RefreshTransactionsEvent>(_onRefreshTransactions);
    on<LoadMoreTransactionsEvent>(_onLoadMoreTransactions);
    on<ResetFiltersEvent>(_onResetFilters);
  }

  Future<void> _onLoadTransactions(LoadTransactionsEvent event, Emitter<TransactionsState> emit) async {
    emit(TransactionsLoadingState());

    try {
      final response = await getTransactions.call(page: 1, limit: 20);
      List<Transaction> transactions = response.transactions;

      if (response.transactions.isEmpty) {
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
    } catch (e) {
      emit(TransactionsErrorState(e.toString()));
    }
  }

  Future<void> _onRefreshTransactions(RefreshTransactionsEvent event, Emitter<TransactionsState> emit) async {
    if (state is TransactionsLoadedState) {
      try {
        emit(TransactionsLoadingState());

        final response = await getTransactions.call(page: 1, limit: 20);

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
      } catch (e) {
        emit(TransactionsErrorState(e.toString()));
      }
    }
  }

  Future<void> _onLoadMoreTransactions(LoadMoreTransactionsEvent event, Emitter<TransactionsState> emit) async {
    if (state is TransactionsLoadedState) {
      final currentState = state as TransactionsLoadedState;

      if (!currentState.hasMore || currentState.isLoadingMore) {
        return;
      }

      emit(currentState.copyWith(isLoadingMore: true));

      try {
        final response = await getTransactions.call(
          page: currentState.currentPage + 1,
          limit: currentState.itemsPerPage,
        );

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
      } catch (e) {
        emit(currentState.copyWith(isLoadingMore: false));
        emit(TransactionsErrorState(e.toString()));
      }
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
