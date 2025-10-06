import 'package:flutter/material.dart';

import 'package:finance_tracker/core/constants/app_strings.dart';
import 'package:finance_tracker/domain/entities/transaction.dart';
import 'package:finance_tracker/presentation/transactions/widgets/grouped_transactions_list.dart';

class RecentTransactionsWidget extends StatelessWidget {
  final List<Transaction> transactions;
  final VoidCallback? onViewAll;
  final Function(Transaction)? onEdit;
  final Function(Transaction)? onDelete;
  final Function(Transaction)? onTap;

  const RecentTransactionsWidget({
    super.key,
    required this.transactions,
    this.onViewAll,
    this.onEdit,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.recentTransactions,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              if (onViewAll != null)
                TextButton(
                  onPressed: onViewAll,
                  child: Text(
                    AppStrings.viewAll,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Transactions List
        if (transactions.isEmpty)
          _buildEmptyState(theme)
        else
          GroupedTransactionsList(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            transactions: transactions.toList(),
            onEditTransaction: onEdit,
            onDeleteTransaction: (transaction) {
              onDelete?.call(transaction);
            },
            onTap: onTap,
          ),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.receipt_long_outlined, size: 48, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            Text(
              AppStrings.noRecentTransactions,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
            ),
          ],
        ),
      ),
    );
  }
}
