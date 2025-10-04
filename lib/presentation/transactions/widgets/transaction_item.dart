import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:take_home/core/constants/app_color.dart';
import 'package:take_home/core/constants/app_strings.dart';
import 'package:take_home/core/utils/utils.dart';
import 'package:take_home/domain/entities/transaction.dart';
import 'package:take_home/presentation/transactions/widgets/transaction_details_modal.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TransactionItem({super.key, required this.transaction, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIncome = transaction.type == TransactionType.income;
    final amountColor = isIncome ? AppColors.successColor : AppColors.errorColor;

    return Dismissible(
      key: Key(transaction.id ?? ''),
      direction: DismissDirection.horizontal,
      background: Container(
        color: AppColors.errorColor,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete, color: theme.colorScheme.onError),
      ),
      secondaryBackground: Container(
        color: theme.colorScheme.primary,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.edit, color: theme.colorScheme.onPrimary),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onDelete?.call();
        } else {
          onEdit?.call();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: () => _showTransactionDetails(context),
          borderRadius: BorderRadius.circular(12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              transaction.title ?? '',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: transaction.category?.color?.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Utils.getCategoryIcon(transaction.category?.icon ?? ''),
                        color: transaction.category?.color,
                        size: 15,
                      ),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        transaction.category?.name ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
                if (transaction.description?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 2),
                  Text(
                    transaction.description ?? '',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  DateFormat(AppStrings.dateFormatShortWithTime).format(transaction.date ?? DateTime.now()),
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Hero(
                  tag: 'amount_${transaction.id}',
                  child: Text(
                    '\$${NumberFormat('#,##0.00').format(transaction.amount ?? 0.0)}',
                    style: theme.textTheme.titleMedium?.copyWith(color: amountColor, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: amountColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isIncome ? AppStrings.income : AppStrings.expense,
                    style: theme.textTheme.labelSmall?.copyWith(color: amountColor, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTransactionDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TransactionDetailsModal(transaction: transaction, onEdit: onEdit, onDelete: onDelete),
    );
  }
}
