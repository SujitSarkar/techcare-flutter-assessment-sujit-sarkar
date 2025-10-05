import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import 'package:take_home/core/constants/app_color.dart';
import 'package:take_home/core/constants/app_strings.dart';
import 'package:take_home/core/widgets/confirmation_dialog.dart';
import 'package:take_home/core/widgets/error_widget.dart';
import 'package:take_home/domain/entities/transaction.dart';
import 'package:take_home/presentation/bottom_nav_bar/bloc/bottom_nav_bar_bloc.dart';
import 'package:take_home/presentation/dashboard/bloc/dashboard_bloc.dart';
import 'package:take_home/presentation/dashboard/widgets/dashboard_header.dart';
import 'package:take_home/presentation/dashboard/widgets/balance_card.dart';
import 'package:take_home/presentation/dashboard/widgets/spending_overview_widget.dart';
import 'package:take_home/presentation/dashboard/widgets/recent_transactions_widget.dart';
import 'package:take_home/presentation/dashboard/widgets/dashboard_shimmer_widget.dart';
import 'package:take_home/presentation/transactions/bloc/transactions_bloc.dart';
import 'package:take_home/presentation/transactions/pages/add_transaction_page.dart';
import 'package:take_home/presentation/transactions/pages/edit_transaction_page.dart';
import 'package:take_home/presentation/transactions/widgets/transaction_details_modal.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with TickerProviderStateMixin {
  late DashboardBloc _dashboardBloc;
  late BottomNavBarBloc _bottomNavBarBloc;
  final GlobalKey<ExpandableFabState> _fabKey = GlobalKey<ExpandableFabState>();

  @override
  void initState() {
    super.initState();
    _dashboardBloc = context.read<DashboardBloc>();
    _bottomNavBarBloc = context.read<BottomNavBarBloc>();

    _dashboardBloc.add(const LoadDashboardDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocListener<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is DashboardErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoadingState) {
              return const DashboardShimmerWidget();
            } else if (state is DashboardErrorState) {
              return AppErrorWidget(
                message: state.message,
                onRetry: () {
                  _dashboardBloc.add(const LoadDashboardDataEvent());
                },
              );
            } else if (state is DashboardLoaded) {
              return _buildDashboardContent(context, state, theme);
            }

            return const DashboardShimmerWidget();
          },
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: _fabKey,
        childrenAnimation: ExpandableFabAnimation.none,
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(Icons.add),
          fabSize: ExpandableFabSize.regular,
        ),
        closeButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(Icons.close),
          fabSize: ExpandableFabSize.regular,
        ),
        type: ExpandableFabType.up,
        distance: 70,
        children: [
          Row(
            children: [
              Text(
                AppStrings.addIncome,
                style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.successColor, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 8),
              FloatingActionButton.small(
                heroTag: 'addIncome',
                enableFeedback: true,
                onPressed: () {
                  _fabKey.currentState?.close();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AddTransactionPage(initialType: TransactionType.income),
                    ),
                  );
                },
                backgroundColor: AppColors.successColor,
                child: Icon(Icons.arrow_downward, color: theme.colorScheme.onPrimary),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                AppStrings.addExpense,
                style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.errorColor, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 8),
              FloatingActionButton.small(
                heroTag: 'addExpense',
                enableFeedback: true,
                onPressed: () {
                  _fabKey.currentState?.close();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AddTransactionPage(initialType: TransactionType.expense),
                    ),
                  );
                },
                backgroundColor: AppColors.errorColor,
                child: Icon(Icons.arrow_upward, color: theme.colorScheme.onPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, DashboardLoaded state, ThemeData theme) {
    return RefreshIndicator(
      color: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.surface,
      onRefresh: () async {
        _dashboardBloc.add(const RefreshDashboardEvent());
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Fixed Header with parallax effect
          DashboardHeader(notificationCount: 3, onNotificationTap: () {}, onProfileTap: () {}),

          // Balance Card
          SliverToBoxAdapter(
            child: BalanceCard(
              totalBalance: state.totalBalance,
              monthlyIncome: state.monthlyIncome,
              monthlyExpense: state.monthlyExpense,
              isBalanceVisible: state.isBalanceVisible,
              onToggleVisibility: () {
                _dashboardBloc.add(const ToggleBalanceVisibilityEvent());
              },
            ),
          ),

          // Spending Overview
          SliverToBoxAdapter(
            child: SpendingOverviewWidget(categorySpending: state.categorySpending, categories: state.categories),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Recent Transactions
          SliverToBoxAdapter(
            child: RecentTransactionsWidget(
              transactions: state.recentTransactions,
              onViewAll: () {
                _bottomNavBarBloc.add(const BottomNavBarTabChangedEvent(1));
              },
              onEdit: (transaction) {},
              onDelete: (transaction) {},
              onTap: (transaction) {
                _showTransactionDetails(context, transaction);
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Transaction transaction) {
    ConfirmationDialog.showDeleteTransactionConfirmation(
      context,
      onConfirm: () {
        context.read<TransactionsBloc>().add(DeleteTransactionEvent(transactionId: transaction.id ?? ''));
      },
    );
  }

  void _showTransactionDetails(BuildContext context, Transaction transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TransactionDetailsModal(
        hideActionButtons: true,
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
