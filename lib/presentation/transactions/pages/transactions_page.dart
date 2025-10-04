import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:take_home/core/constants/app_strings.dart';
import 'package:take_home/core/utils/debouncer.dart';
import 'package:take_home/domain/entities/transaction.dart';
import 'package:take_home/presentation/category/bloc/category_bloc.dart';
import 'package:take_home/presentation/transactions/bloc/transactions_bloc.dart';
import 'package:take_home/presentation/transactions/widgets/grouped_transactions_list.dart';
import 'package:take_home/presentation/transactions/widgets/transaction_empty_state.dart';
import 'package:take_home/presentation/transactions/widgets/transaction_filter_bottom_sheet.dart';
import 'package:take_home/presentation/transactions/widgets/transaction_shimmer.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  late TransactionsBloc _transactionBloc;
  late CategoryBloc _categoryBloc;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer();
  final ValueNotifier<String?> _searchQuery = ValueNotifier(null);

  DateTime? _startDate;
  DateTime? _endDate;
  List<String> _selectedCategories = [];
  double? _minAmount;
  double? _maxAmount;
  TransactionType? _transactionType;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Load initial transactions and categories
    _transactionBloc = context.read<TransactionsBloc>();
    _categoryBloc = context.read<CategoryBloc>();

    _transactionBloc.add(const LoadTransactionsEvent());

    final categoryState = _categoryBloc.state;
    if (categoryState is! CategoryLoadedState) {
      _categoryBloc.add(FetchCategoriesEvent());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<TransactionsBloc>().add(
        LoadMoreTransactionsEvent(
          searchQuery: _searchQuery.value,
          startDate: _startDate,
          endDate: _endDate,
          selectedCategories: _selectedCategories,
          minAmount: _minAmount,
          maxAmount: _maxAmount,
          transactionType: _transactionType,
        ),
      );
    }
  }

  void _onRefresh() {
    context.read<TransactionsBloc>().add(
      RefreshTransactionsEvent(
        searchQuery: _searchQuery.value,
        startDate: _startDate,
        endDate: _endDate,
        selectedCategories: _selectedCategories,
        minAmount: _minAmount,
        maxAmount: _maxAmount,
        transactionType: _transactionType,
      ),
    );
  }

  void _onSearchChanged(String query) {
    _searchQuery.value = query;
    _debouncer.run(() {
      context.read<TransactionsBloc>().add(
        LoadTransactionsEvent(
          searchQuery: _searchQuery.value,
          startDate: _startDate,
          endDate: _endDate,
          selectedCategories: _selectedCategories,
          minAmount: _minAmount,
          maxAmount: _maxAmount,
          transactionType: _transactionType,
        ),
      );
    });
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<TransactionsBloc>().add(
      RefreshTransactionsEvent(
        searchQuery: _searchQuery.value,
        startDate: _startDate,
        endDate: _endDate,
        selectedCategories: _selectedCategories,
        minAmount: _minAmount,
        maxAmount: _maxAmount,
        transactionType: _transactionType,
      ),
    );
    _searchQuery.value = null;
  }

  void _showFilterBottomSheet(BuildContext context) {
    final state = context.read<TransactionsBloc>().state;
    if (state is! TransactionsLoadedState) return;

    // Get categories from CategoryBloc
    final categoryState = context.read<CategoryBloc>().state;
    List<String> availableCategories = [];

    if (categoryState is CategoryLoadedState) {
      availableCategories = categoryState.categories
          .map((category) => category.name ?? '')
          .where((name) => name.isNotEmpty)
          .toList();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionFilterBottomSheet(
        startDate: state.startDate,
        endDate: state.endDate,
        selectedCategories: state.selectedCategories,
        minAmount: state.minAmount,
        maxAmount: state.maxAmount,
        transactionType: state.transactionType,
        availableCategories: availableCategories,
        onApplyFilters:
            ({
              DateTime? startDate,
              DateTime? endDate,
              List<String> selectedCategories = const [],
              double? minAmount,
              double? maxAmount,
              TransactionType? transactionType,
            }) {
              _startDate = startDate;
              _endDate = endDate;
              _selectedCategories = selectedCategories;
              _minAmount = minAmount;
              _maxAmount = maxAmount;
              _transactionType = transactionType;

              context.read<TransactionsBloc>().add(
                LoadTransactionsEvent(
                  searchQuery: _searchQuery.value,
                  startDate: startDate,
                  endDate: endDate,
                  selectedCategories: selectedCategories,
                  minAmount: minAmount,
                  maxAmount: maxAmount,
                  transactionType: transactionType,
                ),
              );
            },
        onResetFilters: () {
          _startDate = null;
          _endDate = null;
          _selectedCategories = [];
          _minAmount = null;
          _maxAmount = null;
          _transactionType = null;
          context.read<TransactionsBloc>().add(ResetFiltersEvent());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.transactions),
        actions: [
          BlocBuilder<TransactionsBloc, TransactionsState>(
            builder: (context, state) {
              int activeFilterCount = 0;
              if (state is TransactionsLoadedState) {
                activeFilterCount = state.activeFilterCount;
              }

              return Stack(
                children: [
                  IconButton(
                    onPressed: () => _showFilterBottomSheet(context),
                    icon: Icon(Icons.filter_list, color: theme.colorScheme.onSurfaceVariant),
                  ),
                  if (activeFilterCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          '$activeFilterCount',
                          style: TextStyle(color: theme.colorScheme.onError, fontSize: 12, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: AppStrings.searchTransactionsHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: ValueListenableBuilder(
                  valueListenable: _searchQuery,
                  builder: (context, value, child) {
                    return value != null && value.isNotEmpty
                        ? IconButton(icon: Icon(Icons.clear), onPressed: _clearSearch)
                        : SizedBox.shrink();
                  },
                ),
                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
          // Transactions List
          Expanded(
            child: BlocBuilder<TransactionsBloc, TransactionsState>(
              builder: (context, state) {
                if (state is TransactionsLoadingState) {
                  return const TransactionShimmer();
                } else if (state is TransactionsErrorState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
                        const SizedBox(height: 16),
                        Text(
                          AppStrings.somethingWentWrong,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<TransactionsBloc>().add(const LoadTransactionsEvent());
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text(AppStrings.retry),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is TransactionsEmptyState) {
                  return TransactionEmptyState(
                    onRetry: () {
                      context.read<TransactionsBloc>().add(const LoadTransactionsEvent());
                    },
                  );
                } else if (state is TransactionsLoadedState) {
                  return RefreshIndicator(
                    backgroundColor: theme.colorScheme.onPrimary,
                    onRefresh: () async {
                      _onRefresh();
                    },
                    child: GroupedTransactionsList(
                      transactions: state.filteredTransactions,
                      isLoadingMore: state.isLoadingMore,
                      scrollController: _scrollController,
                      onEditTransaction: () {},
                      onDeleteTransaction: () {},
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
