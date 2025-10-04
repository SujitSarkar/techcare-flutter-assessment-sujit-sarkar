part of 'transactions_bloc.dart';

sealed class TransactionsEvent extends Equatable {
  const TransactionsEvent();

  @override
  List<Object> get props => [];
}

class LoadTransactionsEvent extends TransactionsEvent {
  final String? searchQuery;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> selectedCategories;
  final double? minAmount;
  final double? maxAmount;
  final TransactionType? transactionType;
  const LoadTransactionsEvent({
    this.searchQuery,
    this.startDate,
    this.endDate,
    this.selectedCategories = const [],
    this.minAmount,
    this.maxAmount,
    this.transactionType,
  });

  @override
  List<Object> get props => [
    searchQuery ?? '',
    startDate ?? '',
    endDate ?? '',
    selectedCategories,
    minAmount ?? 0.0,
    maxAmount ?? 0.0,
    transactionType ?? '',
  ];
}

class RefreshTransactionsEvent extends TransactionsEvent {
  final String? searchQuery;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> selectedCategories;
  final double? minAmount;
  final double? maxAmount;
  final TransactionType? transactionType;
  const RefreshTransactionsEvent({
    this.searchQuery,
    this.startDate,
    this.endDate,
    this.selectedCategories = const [],
    this.minAmount,
    this.maxAmount,
    this.transactionType,
  });

  @override
  List<Object> get props => [
    searchQuery ?? '',
    startDate ?? '',
    endDate ?? '',
    selectedCategories,
    minAmount ?? 0.0,
    maxAmount ?? 0.0,
    transactionType ?? '',
  ];
}

class LoadMoreTransactionsEvent extends TransactionsEvent {
  final String? searchQuery;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> selectedCategories;
  final double? minAmount;
  final double? maxAmount;
  final TransactionType? transactionType;
  const LoadMoreTransactionsEvent({
    this.searchQuery,
    this.startDate,
    this.endDate,
    this.selectedCategories = const [],
    this.minAmount,
    this.maxAmount,
    this.transactionType,
  });

  @override
  List<Object> get props => [
    searchQuery ?? '',
    startDate ?? '',
    endDate ?? '',
    selectedCategories,
    minAmount ?? 0.0,
    maxAmount ?? 0.0,
    transactionType ?? '',
  ];
}

class ResetFiltersEvent extends TransactionsEvent {
  const ResetFiltersEvent();

  @override
  List<Object> get props => [];
}
