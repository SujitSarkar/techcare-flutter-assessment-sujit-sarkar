import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'transaction_item.dart';
import 'package:take_home/core/constants/app_strings.dart';
import 'package:take_home/domain/entities/transaction.dart';

class GroupedTransactionsList extends StatelessWidget {
  final List<Transaction> transactions;
  final bool isLoadingMore;
  final ScrollController? scrollController;
  final VoidCallback? onLoadMore;
  final Function(Transaction)? onEditTransaction;
  final Function(Transaction)? onTap;
  final Function(Transaction)? onDeleteTransaction;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final EdgeInsets? padding;

  const GroupedTransactionsList({
    super.key,
    required this.transactions,
    this.isLoadingMore = false,
    this.scrollController,
    this.onLoadMore,
    this.onEditTransaction,
    this.onTap,
    this.onDeleteTransaction,
    this.shrinkWrap = false,
    this.physics,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final groupedTransactions = _groupTransactionsByDate(transactions);

    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding,
      controller: scrollController,
      itemCount: groupedTransactions.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == groupedTransactions.length) {
          // Loading more indicator
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final entry = groupedTransactions.entries.elementAt(index);
        final date = entry.key;
        final transactionsForDate = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sticky header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Text(
                _formatDateHeader(date),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            // Transactions for this date
            ...transactionsForDate.map(
              (transaction) => TransactionItem(
                transaction: transaction,
                onEdit: () => onEditTransaction?.call(transaction),
                onDelete: () => onDeleteTransaction?.call(transaction),
                onTap: () => onTap?.call(transaction),
              ),
            ),
          ],
        );
      },
    );
  }

  Map<DateTime, List<Transaction>> _groupTransactionsByDate(List<Transaction> transactions) {
    final Map<DateTime, List<Transaction>> grouped = {};

    for (final transaction in transactions) {
      final date = DateTime(
        transaction.date?.year ?? DateTime.now().year,
        transaction.date?.month ?? DateTime.now().month,
        transaction.date?.day ?? DateTime.now().day,
      );
      grouped.putIfAbsent(date, () => []).add(transaction);
    }

    // Sort dates in descending order (newest first)
    final sortedEntries = grouped.entries.toList()..sort((a, b) => b.key.compareTo(a.key));

    return Map.fromEntries(sortedEntries);
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (date == today) {
      return AppStrings.today;
    } else if (date == yesterday) {
      return AppStrings.yesterday;
    } else {
      return DateFormat(AppStrings.dateFormatPattern).format(date);
    }
  }
}
