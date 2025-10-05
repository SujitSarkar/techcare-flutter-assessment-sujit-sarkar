import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:take_home/domain/usecases/get_transactions.dart';
import 'package:take_home/domain/usecases/get_categories.dart';
import 'package:take_home/domain/entities/transaction.dart';
import 'package:take_home/domain/entities/category.dart';
import 'package:take_home/presentation/transactions/bloc/transactions_bloc.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetTransactions getTransactions;
  final GetCategories getCategories;
  final TransactionsBloc transactionsBloc;

  StreamSubscription<TransactionsState>? _transactionsSubscription;

  DashboardBloc({required this.getTransactions, required this.getCategories, required this.transactionsBloc})
    : super(DashboardInitialState()) {
    on<LoadDashboardDataEvent>(_onLoadDashboardData);
    on<RefreshDashboardEvent>(_onRefreshDashboard);
    on<ToggleBalanceVisibilityEvent>(_onToggleBalanceVisibility);
    on<UpdateDashboardFromTransactionsEvent>(_onUpdateDashboardFromTransactions);

    // Listen to transactions BLoC changes
    _transactionsSubscription = transactionsBloc.stream.listen(_onTransactionsStateChanged);
  }

  @override
  Future<void> close() {
    _transactionsSubscription?.cancel();
    return super.close();
  }

  void _onTransactionsStateChanged(TransactionsState transactionsState) {
    if (transactionsState is TransactionAddedState ||
        transactionsState is TransactionUpdatedState ||
        transactionsState is TransactionDeletedState) {
      add(const UpdateDashboardFromTransactionsEvent());
    }
  }

  Future<void> _onLoadDashboardData(LoadDashboardDataEvent event, Emitter<DashboardState> emit) async {
    emit(DashboardLoadingState());

    try {
      // Load transactions and categories in parallel
      final transactionsResponse = await getTransactions.call();
      final categories = await getCategories.call();

      await _updateDashboardData(emit, transactionsResponse.transactions, categories);
    } catch (e) {
      emit(DashboardErrorState(message: e.toString()));
    }
  }

  Future<void> _onUpdateDashboardFromTransactions(
    UpdateDashboardFromTransactionsEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final currentState = state;
    if (currentState is DashboardLoaded) {
      try {
        List<Transaction> allTransactions = currentState.allTransactions;

        // Get current transactions from transactions BLoC
        final transactionsState = transactionsBloc.state;

        if (transactionsState is TransactionAddedState) {
          allTransactions.insert(0, transactionsState.transaction);
        } else if (transactionsState is TransactionUpdatedState) {
          final int index = allTransactions.indexWhere(
            (transaction) => transaction.id == transactionsState.transaction.id,
          );
          if (index != -1) {
            allTransactions[index] = transactionsState.transaction;
          }
        } else if (transactionsState is TransactionDeletedState) {
          final int index = allTransactions.indexWhere(
            (transaction) => transaction.id == transactionsState.transactionId,
          );
          if (index != -1) {
            allTransactions.removeAt(index);
          }
        }

        await _updateDashboardData(emit, allTransactions, currentState.categories);
      } catch (e) {
        emit(DashboardErrorState(message: e.toString()));
      }
    }
  }

  Future<void> _updateDashboardData(
    Emitter<DashboardState> emit,
    List<Transaction> transactions,
    List<Category> categories,
  ) async {
    transactions.sort((a, b) => (b.date ?? DateTime.now()).compareTo(a.date ?? DateTime.now()));
    // Get recent transactions (last 10)
    final recentTransactions = transactions.take(10).toList();

    // Calculate monthly totals
    final now = DateTime.now();
    final monthlyTransactions = transactions.where((transaction) {
      return transaction.date?.year == now.year && transaction.date?.month == now.month;
    }).toList();

    final monthlyIncome = monthlyTransactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + (t.amount ?? 0));

    final monthlyExpense = monthlyTransactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + (t.amount ?? 0));

    final totalBalance = monthlyIncome - monthlyExpense;

    // Calculate category spending
    final categorySpending = <String, double>{};
    for (final transaction in monthlyTransactions.where((t) => t.type == TransactionType.expense)) {
      final categoryName = transaction.category?.name ?? 'Unknown';
      categorySpending[categoryName] = (categorySpending[categoryName] ?? 0) + (transaction.amount ?? 0);
    }

    emit(
      DashboardLoaded(
        allTransactions: transactions,
        recentTransactions: recentTransactions,
        categories: categories,
        totalBalance: totalBalance,
        monthlyIncome: monthlyIncome,
        monthlyExpense: monthlyExpense,
        isBalanceVisible: state is DashboardLoaded ? (state as DashboardLoaded).isBalanceVisible : true,
        categorySpending: categorySpending,
      ),
    );
  }

  Future<void> _onRefreshDashboard(RefreshDashboardEvent event, Emitter<DashboardState> emit) async {
    add(const LoadDashboardDataEvent());
  }

  void _onToggleBalanceVisibility(ToggleBalanceVisibilityEvent event, Emitter<DashboardState> emit) {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      emit(currentState.copyWith(isBalanceVisible: !currentState.isBalanceVisible));
    }
  }
}
