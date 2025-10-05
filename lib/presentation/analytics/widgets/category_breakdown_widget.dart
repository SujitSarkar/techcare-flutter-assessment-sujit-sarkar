import 'package:flutter/material.dart';

import 'package:take_home/core/constants/app_strings.dart';
import 'package:take_home/core/decorations/app_decorations.dart';
import 'package:take_home/core/utils/utils.dart';
import 'package:take_home/domain/entities/analytics.dart';

class CategoryBreakdownWidget extends StatelessWidget {
  final List<CategoryBreakdown> categoryBreakdown;

  const CategoryBreakdownWidget({super.key, required this.categoryBreakdown});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: AppDecorations.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.categoryBreakdown,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          ...categoryBreakdown.map((breakdown) => _buildCategoryBar(context, breakdown)),
        ],
      ),
    );
  }

  Widget _buildCategoryBar(BuildContext context, CategoryBreakdown breakdown) {
    // For now, we'll use a simple percentage calculation
    // In a real app, you'd want to pass the full list to calculate max
    final percentage = breakdown.percentage / 100;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Utils.getCategoryIcon(breakdown.category.icon ?? ''), size: 16, color: breakdown.category.color),
                  const SizedBox(width: 8),
                  Text(
                    breakdown.category.name ?? AppStrings.unknown,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Text(
                '${AppStrings.currencySymbol} ${breakdown.amount.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage,
              child: Container(
                decoration: BoxDecoration(color: breakdown.category.color, borderRadius: BorderRadius.circular(4)),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${breakdown.percentage.toStringAsFixed(1)}%',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
