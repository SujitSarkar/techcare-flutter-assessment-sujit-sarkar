import 'package:flutter/material.dart';
import 'package:take_home/core/constants/app_color.dart';
import 'package:take_home/core/constants/app_strings.dart';
import 'package:take_home/domain/entities/transaction.dart';

class TransactionTypeSelector extends StatefulWidget {
  final TransactionType selectedType;
  final ValueChanged<TransactionType> onTypeChanged;

  const TransactionTypeSelector({super.key, required this.selectedType, required this.onTypeChanged});

  @override
  State<TransactionTypeSelector> createState() => _TransactionTypeSelectorState();
}

class _TransactionTypeSelectorState extends State<TransactionTypeSelector> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIncome = widget.selectedType == TransactionType.income;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.transactionType, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTypeButton(
                      context,
                      TransactionType.expense,
                      AppStrings.transactionTypeExpense,
                      AppColors.errorColor,
                      Icons.arrow_upward,
                      !isIncome,
                    ),
                  ),
                  Expanded(
                    child: _buildTypeButton(
                      context,
                      TransactionType.income,
                      AppStrings.transactionTypeIncome,
                      AppColors.successColor,
                      Icons.arrow_downward,
                      isIncome,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTypeButton(
    BuildContext context,
    TransactionType type,
    String label,
    Color color,
    IconData icon,
    bool isSelected,
  ) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        if (widget.selectedType != type) {
          _animationController.reset();
          _animationController.forward();
          widget.onTypeChanged(type);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(21),
          boxShadow: isSelected
              ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))]
              : null,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  icon,
                  key: ValueKey(isSelected),
                  color: isSelected ? theme.colorScheme.onPrimary : color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style:
                    theme.textTheme.titleSmall?.copyWith(
                      color: isSelected ? theme.colorScheme.onPrimary : color,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ) ??
                    TextStyle(
                      color: isSelected ? theme.colorScheme.onPrimary : color,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
