import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:take_home/core/constants/app_strings.dart';
import 'package:take_home/core/utils/debouncer.dart';
import 'package:take_home/core/widgets/confirmation_dialog.dart';
import 'package:take_home/core/widgets/error_widget.dart';
import 'package:take_home/core/widgets/loading_mask.dart';
import 'package:take_home/domain/entities/transaction.dart';
import 'package:take_home/presentation/category/bloc/category_bloc.dart';
import 'package:take_home/presentation/transactions/bloc/transactions_bloc.dart';
import 'package:take_home/presentation/transactions/pages/edit_transaction_page.dart';
import 'package:take_home/presentation/transactions/widgets/grouped_transactions_list.dart';
import 'package:take_home/presentation/transactions/widgets/transaction_details_modal.dart';
import 'package:take_home/presentation/transactions/widgets/transaction_empty_state.dart';
import 'package:take_home/presentation/transactions/widgets/transaction_filter_bottom_sheet.dart';
import 'package:take_home/presentation/transactions/widgets/transaction_shimmer.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> with TickerProviderStateMixin {
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
      _transactionBloc.add(
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
    _transactionBloc.add(
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
      _transactionBloc.add(
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
    _transactionBloc.add(
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
    final state = _transactionBloc.state;
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

              _transactionBloc.add(
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
          _transactionBloc.add(ResetFiltersEvent());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<TransactionsBloc, TransactionsState>(
      listener: (context, state) {
        if (state is TransactionAddedState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppStrings.transactionAddedSuccessfully)));
        } else if (state is TransactionUpdatedState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(AppStrings.transactionUpdatedSuccessfully)));
        } else if (state is TransactionDeletedState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(AppStrings.transactionDeletedSuccessfully)));
        } else if (state is TransactionsErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
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
                            style: TextStyle(
                              color: theme.colorScheme.onError,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
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
                    return AppErrorWidget(
                      message: state.message,
                      onRetry: () {
                        _transactionBloc.add(const LoadTransactionsEvent());
                      },
                    );
                  } else if (state is TransactionsEmptyState) {
                    return TransactionEmptyState(
                      onRetry: () {
                        _transactionBloc.add(const LoadTransactionsEvent());
                      },
                    );
                  } else if (state is TransactionsLoadedState) {
                    return Stack(
                      children: [
                        RefreshIndicator(
                          backgroundColor: theme.colorScheme.onPrimary,
                          onRefresh: () async {
                            _onRefresh();
                          },
                          child: GroupedTransactionsList(
                            padding: const EdgeInsets.only(bottom: 60),
                            transactions: state.filteredTransactions,
                            isLoadingMore: state.isLoadingMore,
                            scrollController: _scrollController,
                            onEditTransaction: (transaction) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => EditTransactionPage(transaction: transaction)),
                              );
                            },
                            onDeleteTransaction: (transaction) {
                              _showDeleteConfirmation(context, transaction);
                            },
                            onTap: (transaction) {
                              _showTransactionDetails(context, transaction);
                            },
                          ),
                        ),
                        if (state.isLoading) const LoadingMask(),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Transaction transaction) {
    ConfirmationDialog.showDeleteTransactionConfirmation(
      context,
      onConfirm: () {
        _transactionBloc.add(DeleteTransactionEvent(transactionId: transaction.id ?? ''));
      },
    );
  }

  void _showTransactionDetails(BuildContext context, Transaction transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TransactionDetailsModal(
        transaction: transaction,
        onEdit: () {
          Navigator.of(context).pop();
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => EditTransactionPage(transaction: transaction)));
        },
        onDelete: () {
          _showDeleteConfirmation(context, transaction);
        },
      ),
    );
  }
}
