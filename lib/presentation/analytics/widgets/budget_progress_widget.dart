import 'package:flutter/material.dart';

import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:finance_tracker/core/constants/app_strings.dart';
import 'package:finance_tracker/core/decorations/app_decorations.dart';
import 'package:finance_tracker/domain/entities/analytics.dart';

class BudgetProgressWidget extends StatelessWidget {
  final List<CategoryBreakdown> categoryBreakdown;

  const BudgetProgressWidget({super.key, required this.categoryBreakdown});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: AppDecorations.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.budgetProgress,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          // Create rows with exactly 2 items each
          ...List.generate((categoryBreakdown.length / 2).ceil(), (rowIndex) {
            final startIndex = rowIndex * 2;
            final endIndex = (startIndex + 2).clamp(0, categoryBreakdown.length);
            final rowItems = categoryBreakdown.sublist(startIndex, endIndex);

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // First item
                  Expanded(child: _buildBudgetProgressCard(context, rowItems[0])),
                  const SizedBox(width: 16),
                  // Second item (if exists)
                  Expanded(
                    child: rowItems.length > 1 ? _buildBudgetProgressCard(context, rowItems[1]) : const SizedBox(),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBudgetProgressCard(BuildContext context, CategoryBreakdown breakdown) {
    final utilization = breakdown.budgetUtilization / 100;
    Color progressColor;
    if (utilization <= 0.7) {
      progressColor = AppColors.successColor;
    } else if (utilization <= 0.9) {
      progressColor = Colors.orangeAccent;
    } else {
      progressColor = AppColors.errorColor;
    }

    return Column(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: utilization,
                strokeWidth: 12,
                strokeCap: StrokeCap.round,
                constraints: BoxConstraints(minHeight: 80, minWidth: 80),
                backgroundColor: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
              Center(
                child: Text(
                  '${breakdown.budgetUtilization.toStringAsFixed(0)}%',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: progressColor),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          breakdown.category.name ?? AppStrings.unknown,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Text(
          '${AppStrings.currencySymbol} ${breakdown.amount.toStringAsFixed(0)} / ${breakdown.budget.toStringAsFixed(0)}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
