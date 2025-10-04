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

class AddTransactionEvent extends TransactionsEvent {
  final Transaction transaction;

  const AddTransactionEvent({required this.transaction});

  @override
  List<Object> get props => [transaction];
}

class UpdateTransactionEvent extends TransactionsEvent {
  final Transaction transaction;

  const UpdateTransactionEvent({required this.transaction});

  @override
  List<Object> get props => [transaction];
}

class DeleteTransactionEvent extends TransactionsEvent {
  final String transactionId;

  const DeleteTransactionEvent({required this.transactionId});

  @override
  List<Object> get props => [transactionId];
}
