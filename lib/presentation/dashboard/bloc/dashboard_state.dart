part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

final class DashboardInitial extends DashboardState {}

final class DashboardLoading extends DashboardState {}

final class DashboardLoaded extends DashboardState {
  final List<Transaction> allTransactions;
  final List<Transaction> recentTransactions;
  final List<Category> categories;
  final double totalBalance;
  final double monthlyIncome;
  final double monthlyExpense;
  final bool isBalanceVisible;
  final Map<String, double> categorySpending;

  const DashboardLoaded({
    required this.allTransactions,
    required this.recentTransactions,
    required this.categories,
    required this.totalBalance,
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.isBalanceVisible,
    required this.categorySpending,
  });

  @override
  List<Object> get props => [
    allTransactions,
    recentTransactions,
    categories,
    totalBalance,
    monthlyIncome,
    monthlyExpense,
    isBalanceVisible,
    categorySpending,
  ];

  DashboardLoaded copyWith({
    List<Transaction>? allTransactions,
    List<Transaction>? recentTransactions,
    List<Category>? categories,
    double? totalBalance,
    double? monthlyIncome,
    double? monthlyExpense,
    bool? isBalanceVisible,
    Map<String, double>? categorySpending,
  }) {
    return DashboardLoaded(
      allTransactions: allTransactions ?? this.allTransactions,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      categories: categories ?? this.categories,
      totalBalance: totalBalance ?? this.totalBalance,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      monthlyExpense: monthlyExpense ?? this.monthlyExpense,
      isBalanceVisible: isBalanceVisible ?? this.isBalanceVisible,
      categorySpending: categorySpending ?? this.categorySpending,
    );
  }
}

final class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object> get props => [message];
}
