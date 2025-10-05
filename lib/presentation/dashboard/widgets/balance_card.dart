import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:take_home/core/constants/app_strings.dart';

class BalanceCard extends StatefulWidget {
  final double totalBalance;
  final double monthlyIncome;
  final double monthlyExpense;
  final bool isBalanceVisible;
  final VoidCallback onToggleVisibility;

  const BalanceCard({
    super.key,
    required this.totalBalance,
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.isBalanceVisible,
    required this.onToggleVisibility,
  });

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> with TickerProviderStateMixin {
  late AnimationController _flipController;
  late AnimationController _numberController;
  late Animation<double> _flipAnimation;
  late Animation<double> _numberAnimation;

  @override
  void initState() {
    super.initState();

    _flipController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);

    _numberController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    _flipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _flipController, curve: Curves.easeInOut));

    _numberAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _numberController, curve: Curves.easeOutCubic));

    _numberController.forward();
  }

  @override
  void dispose() {
    _flipController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  void _toggleVisibility() {
    _flipController.forward().then((_) {
      widget.onToggleVisibility();
      _flipController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.1),
            theme.colorScheme.secondary.withValues(alpha: 0.1),
          ],
        ),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with toggle button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.totalBalance,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: _toggleVisibility,
                      child: Icon(
                        widget.isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        size: 24,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Balance amount with flip animation
                Expanded(
                  child: Center(
                    child: AnimatedBuilder(
                      animation: Listenable.merge([_numberAnimation, _flipAnimation]),
                      builder: (context, child) {
                        final animatedBalance = widget.totalBalance * _numberAnimation.value;
                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(_flipAnimation.value * 3.14159),
                          child: Text(
                            widget.isBalanceVisible
                                ? '${AppStrings.currencySymbol} ${animatedBalance.toStringAsFixed(2)}'
                                : '••••••',
                            style: theme.textTheme.headlineLarge?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Income and Expense summary
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryItem(
                        context,
                        AppStrings.income,
                        widget.monthlyIncome,
                        Colors.green,
                        Icons.trending_up,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSummaryItem(
                        context,
                        AppStrings.expense,
                        widget.monthlyExpense,
                        Colors.red,
                        Icons.trending_down,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, String label, double amount, Color color, IconData icon) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${AppStrings.currencySymbol} ${amount.toStringAsFixed(0)}',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
