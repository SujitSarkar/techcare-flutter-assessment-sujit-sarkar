import 'package:flutter/material.dart';
import 'package:take_home/core/constants/app_strings.dart';
import 'package:take_home/core/utils/utils.dart';
import 'package:take_home/domain/entities/category.dart';

class CategorySelectionChips extends StatelessWidget {
  final List<Category> categories;
  final Category? selectedCategory;
  final ValueChanged<Category> onCategorySelected;

  const CategorySelectionChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.selectCategory, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory?.id == category.id;

              return Padding(
                padding: EdgeInsets.only(right: index < categories.length - 1 ? 8 : 0),
                child: _buildCategoryChip(context, category, isSelected),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(BuildContext context, Category category, bool isSelected) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => onCategorySelected(category),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? category.color?.withValues(alpha: 0.2) ?? theme.colorScheme.primary.withValues(alpha: 0.2)
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected
                ? category.color ?? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: category.color?.withValues(alpha: 0.2) ?? theme.colorScheme.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Utils.getCategoryIcon(category.icon ?? ''),
                color: category.color ?? theme.colorScheme.primary,
                size: 14,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              category.name ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected ? category.color ?? theme.colorScheme.primary : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
