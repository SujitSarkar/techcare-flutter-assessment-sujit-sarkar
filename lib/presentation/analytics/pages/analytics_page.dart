import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:take_home/core/constants/app_strings.dart';
import 'package:take_home/core/widgets/error_widget.dart';
import 'package:take_home/domain/entities/analytics.dart';
import 'package:take_home/presentation/analytics/bloc/analytics_bloc.dart';
import 'package:take_home/presentation/analytics/widgets/analytics_shimmer.dart';
import 'package:take_home/presentation/analytics/widgets/summary_card.dart';
import 'package:take_home/presentation/analytics/widgets/spending_trend_chart.dart';
import 'package:take_home/presentation/analytics/widgets/category_breakdown_widget.dart';
import 'package:take_home/presentation/analytics/widgets/budget_progress_widget.dart';
import 'package:take_home/presentation/analytics/widgets/custom_date_range_widget.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> with TickerProviderStateMixin {
  late AnalyticsBloc _analyticsBloc;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String _selectedPeriod = AppStrings.thisMonth;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _analyticsBloc = context.read<AnalyticsBloc>();
    _fetchAnalytics();
  }

  void _initAnimation() {
    _animationController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _fetchAnalytics() {
    _analyticsBloc.add(GetAnalyticsEvent(startDate: _startDate, endDate: _endDate));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<AnalyticsBloc, AnalyticsState>(
      listener: (context, state) {
        if (state is AnalyticsError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is AnalyticsLoaded) {
          _initAnimation();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text(AppStrings.analyticsPage), elevation: 0),
        body: RefreshIndicator(
          color: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.surface,
          onRefresh: () async {
            _fetchAnalytics();
          },
          child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
            builder: (context, state) {
              if (state is AnalyticsLoading) {
                return const AnalyticsShimmer();
              } else if (state is AnalyticsError) {
                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverFillRemaining(
                      child: AppErrorWidget(
                        message: '${AppStrings.error}: ${state.message}',
                        onRetry: () {
                          _fetchAnalytics();
                        },
                      ),
                    ),
                  ],
                );
              } else if (state is AnalyticsLoaded) {
                return _buildAnalyticsContent(state.analytics, theme);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyticsContent(Analytics analytics, ThemeData theme) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Time Period Selector
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.timePeriod,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    _buildTimePeriodSelector(theme),

                    if (_selectedPeriod == AppStrings.custom) ...[
                      const SizedBox(height: 10),
                      CustomDateRangeWidget(
                        startDate: _startDate,
                        endDate: _endDate,
                        onStartDateChanged: (date) {
                          setState(() => _startDate = date);
                        },
                        onEndDateChanged: (date) {
                          setState(() => _endDate = date);
                        },
                        onApply: _fetchAnalytics,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
            ),

            // Summary Statistics
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSummaryCards(analytics.summary),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Spending Trend Chart
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SpendingTrendChart(monthlyTrend: analytics.monthlyTrend),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Category Breakdown
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CategoryBreakdownWidget(categoryBreakdown: analytics.categoryBreakdown),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Budget Progress Indicators
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BudgetProgressWidget(categoryBreakdown: analytics.categoryBreakdown),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePeriodSelector(ThemeData theme) {
    final periods = [AppStrings.thisWeek, AppStrings.thisMonth, AppStrings.last3Months, AppStrings.custom];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: periods.map((period) {
          final isSelected = _selectedPeriod == period;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(period),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedPeriod = period;
                  if (period == AppStrings.custom) {
                    // Set default custom date range (last 30 days)
                    _endDate = DateTime.now();
                    _startDate = DateTime.now().subtract(const Duration(days: 30));
                  }
                });

                // Only fetch analytics if not selecting custom chip
                if (period != AppStrings.custom) {
                  _fetchAnalytics();
                }
              },
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              selectedColor: theme.colorScheme.primaryContainer,
              labelStyle: theme.textTheme.bodySmall?.copyWith(
                color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSummaryCards(AnalyticsSummary summary) {
    return Row(
      children: [
        Expanded(
          child: SummaryCard(
            title: AppStrings.totalIncome,
            value: summary.totalIncome,
            icon: Icons.trending_up,
            color: Colors.green,
            animation: _animationController,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SummaryCard(
            title: AppStrings.totalExpenses,
            value: summary.totalExpense,
            icon: Icons.trending_down,
            color: Colors.red,
            animation: _animationController,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SummaryCard(
            title: AppStrings.netBalance,
            value: summary.netBalance,
            icon: Icons.account_balance_wallet,
            color: Colors.blue,
            animation: _animationController,
          ),
        ),
      ],
    );
  }
}
