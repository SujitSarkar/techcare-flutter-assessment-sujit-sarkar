import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:take_home/core/constants/app_strings.dart';
import 'package:take_home/core/decorations/app_decorations.dart';
import 'package:take_home/domain/entities/category.dart';

class SpendingOverviewWidget extends StatefulWidget {
  final Map<String, double> categorySpending;
  final List<Category> categories;

  const SpendingOverviewWidget({super.key, required this.categorySpending, required this.categories});

  @override
  State<SpendingOverviewWidget> createState() => _SpendingOverviewWidgetState();
}

class _SpendingOverviewWidgetState extends State<SpendingOverviewWidget> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
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

    if (widget.categorySpending.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: AppDecorations.cardDecoration(context),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.pie_chart_outline, size: 48, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
              const SizedBox(height: 12),
              Text(
                'No spending data available',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.spendingOverview, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            _touchedIndex = -1;
                            return;
                          }
                          _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    sectionsSpace: 2,
                    centerSpaceRadius: 60,
                    sections: _buildPieChartSections(theme),
                  ),
                );
              },
            ),
          ),

          // Legend
          _buildLegend(theme),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(ThemeData theme) {
    final totalSpending = widget.categorySpending.values.fold(0.0, (sum, amount) => sum + amount);
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];

    return widget.categorySpending.entries.map((entry) {
      final index = widget.categorySpending.keys.toList().indexOf(entry.key);
      final percentage = (entry.value / totalSpending) * 100;
      final isTouched = index == _touchedIndex;
      final radius = isTouched ? 50.0 : 40.0;

      return PieChartSectionData(
        color: colors[index % colors.length],
        value: entry.value * _animation.value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(fontSize: isTouched ? 14 : 12, fontWeight: FontWeight.bold, color: Colors.white),
        titlePositionPercentageOffset: 0.6,
      );
    }).toList();
  }

  Widget _buildLegend(ThemeData theme) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.categorySpending.entries.map((entry) {
        final index = widget.categorySpending.keys.toList().indexOf(entry.key);
        final isTouched = index == _touchedIndex;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isTouched ? colors[index % colors.length].withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: colors[index % colors.length], shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  entry.key,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: isTouched ? FontWeight.w600 : FontWeight.normal,
                    color: isTouched ? colors[index % colors.length] : theme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${AppStrings.currencySymbol} ${entry.value.toStringAsFixed(0)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
