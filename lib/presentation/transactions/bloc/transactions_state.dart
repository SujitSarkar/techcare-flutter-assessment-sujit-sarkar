part of 'transactions_bloc.dart';

sealed class TransactionsState extends Equatable {
  const TransactionsState();

  @override
  List<Object> get props => [];
}

class TransactionsInitialState extends TransactionsState {}

class TransactionsLoadingState extends TransactionsState {}

class TransactionsLoadedState extends TransactionsState {
  final bool isLoading;
  final List<Transaction> transactions;
  final List<Transaction> filteredTransactions;
  final int currentPage;
  final int itemsPerPage;
  final bool hasMore;
  final bool isLoadingMore;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> selectedCategories;
  final double? minAmount;
  final double? maxAmount;
  final TransactionType? transactionType;

  const TransactionsLoadedState({
    this.isLoading = false,
    required this.transactions,
    required this.filteredTransactions,
    this.currentPage = 1,
    this.itemsPerPage = 20,
    required this.hasMore,
    this.isLoadingMore = false,
    this.startDate,
    this.endDate,
    this.selectedCategories = const [],
    this.minAmount,
    this.maxAmount,
    this.transactionType,
  });

  @override
  List<Object> get props => [
    isLoading,
    transactions,
    filteredTransactions,
    currentPage,
    itemsPerPage,
    hasMore,
    isLoadingMore,
    startDate ?? '',
    endDate ?? '',
    selectedCategories,
    minAmount ?? 0.0,
    maxAmount ?? 0.0,
    transactionType ?? '',
  ];

  TransactionsLoadedState copyWith({
    bool? isLoading,
    List<Transaction>? transactions,
    List<Transaction>? filteredTransactions,
    int? currentPage,
    int? itemsPerPage,
    bool? hasMore,
    bool? isLoadingMore,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? selectedCategories,
    double? minAmount,
    double? maxAmount,
    TransactionType? transactionType,
  }) {
    return TransactionsLoadedState(
      isLoading: isLoading ?? this.isLoading,
      transactions: transactions ?? this.transactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      transactionType: transactionType ?? this.transactionType,
    );
  }

  int get activeFilterCount {
    int count = 0;
    if (startDate != null || endDate != null) count++;
    if (selectedCategories.isNotEmpty) count++;
    if (minAmount != null || maxAmount != null) count++;
    if (transactionType != null) count++;
    return count;
  }
}

class TransactionsErrorState extends TransactionsState {
  final String message;

  const TransactionsErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class TransactionsEmptyState extends TransactionsState {
  const TransactionsEmptyState();

  @override
  List<Object> get props => [];
}

class TransactionAddedState extends TransactionsState {
  final Transaction transaction;

  const TransactionAddedState({required this.transaction});

  @override
  List<Object> get props => [transaction];
}

class TransactionUpdatedState extends TransactionsState {
  final Transaction transaction;

  const TransactionUpdatedState({required this.transaction});

  @override
  List<Object> get props => [transaction];
}

class TransactionDeletedState extends TransactionsState {
  final String transactionId;

  const TransactionDeletedState({required this.transactionId});

  @override
  List<Object> get props => [transactionId];
}
