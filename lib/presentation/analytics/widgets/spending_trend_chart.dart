import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:take_home/core/constants/app_strings.dart';
import 'package:take_home/core/decorations/app_decorations.dart';
import 'package:take_home/domain/entities/analytics.dart';

class SpendingTrendChart extends StatefulWidget {
  final List<MonthlyTrend> monthlyTrend;

  const SpendingTrendChart({super.key, required this.monthlyTrend});

  @override
  State<SpendingTrendChart> createState() => _SpendingTrendChartState();
}

class _SpendingTrendChartState extends State<SpendingTrendChart> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _curveAnimation;

  double _minX = 0;
  double _maxX = 0;
  double _minY = 0;
  double _maxY = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    _curveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _calculateBounds();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _calculateBounds() {
    if (widget.monthlyTrend.isEmpty) return;

    final incomeValues = widget.monthlyTrend.map((e) => e.income).toList();
    final expenseValues = widget.monthlyTrend.map((e) => e.expense).toList();

    _minX = 0;
    _maxX = widget.monthlyTrend.length - 1.0;
    _minY = 0;
    _maxY = [...incomeValues, ...expenseValues].reduce((a, b) => a > b ? a : b) * 1.1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(10),
      decoration: AppDecorations.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.spendingTrend,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: AnimatedBuilder(
              animation: _curveAnimation,
              builder: (context, child) {
                return LineChart(
                  LineChartData(
                    minX: _minX,
                    maxX: _maxX,
                    minY: _minY,
                    maxY: _maxY,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      horizontalInterval: (_maxY - _minY) / 5,
                      verticalInterval: (_maxX - _minX) / 6,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                          strokeWidth: 1,
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: (_maxX - _minX) / 6,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() < widget.monthlyTrend.length) {
                              final month = widget.monthlyTrend[value.toInt()].month;
                              return Text(month.split('-')[1], style: Theme.of(context).textTheme.bodySmall);
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: (_maxY - _minY) / 5,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${(value / 1000).toStringAsFixed(0)}k',
                              style: Theme.of(context).textTheme.bodySmall,
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: widget.monthlyTrend.asMap().entries.map((entry) {
                          return FlSpot(entry.key.toDouble(), entry.value.income * _curveAnimation.value);
                        }).toList(),
                        isCurved: true,
                        curveSmoothness: 0.35,
                        color: Colors.green,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.green.withValues(alpha: 0.1),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.green.withValues(alpha: 0.2), Colors.green.withValues(alpha: 0.05)],
                          ),
                        ),
                      ),
                      LineChartBarData(
                        spots: widget.monthlyTrend.asMap().entries.map((entry) {
                          return FlSpot(entry.key.toDouble(), entry.value.expense * _curveAnimation.value);
                        }).toList(),
                        isCurved: true,
                        curveSmoothness: 0.35,
                        color: Colors.red,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.red.withValues(alpha: 0.1),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.red.withValues(alpha: 0.2), Colors.red.withValues(alpha: 0.05)],
                          ),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (touchedSpot) {
                          return Theme.of(context).colorScheme.surfaceContainerHighest;
                        },
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final index = spot.x.toInt();
                            if (index < widget.monthlyTrend.length) {
                              final trend = widget.monthlyTrend[index];
                              return LineTooltipItem(
                                '${trend.month}\n${AppStrings.income}: ${AppStrings.currencySymbol}${trend.income.toStringAsFixed(0)}\n${AppStrings.expense}: ${AppStrings.currencySymbol}${trend.expense.toStringAsFixed(0)}',
                                TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 12),
                              );
                            }
                            return null;
                          }).toList();
                        },
                      ),
                    ),
                    extraLinesData: ExtraLinesData(
                      horizontalLines: [
                        HorizontalLine(
                          y: _maxY * 0.5,
                          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        ),
                      ],
                    ),
                  ),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildLegendItem(context, AppStrings.income, Colors.green),
              const SizedBox(width: 16),
              _buildLegendItem(context, AppStrings.expense, Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
