import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:finance_tracker/core/decorations/app_decorations.dart';

class AnalyticsShimmer extends StatelessWidget {
  const AnalyticsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Shimmer.fromColors(
      baseColor: theme.colorScheme.surfaceContainerHighest,
      highlightColor: theme.colorScheme.surface,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Time Period Selector Shimmer
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title shimmer
                  Container(
                    height: 20,
                    width: 120,
                    decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(4)),
                  ),
                  const SizedBox(height: 12),
                  // Filter chips shimmer
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(4, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Container(
                            height: 32,
                            width: 80 + (index * 20).toDouble(),
                            decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(16)),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Summary Cards Shimmer
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: index < 2 ? 12 : 0),
                      padding: const EdgeInsets.all(16),
                      decoration: AppDecorations.cardDecoration(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: theme.cardColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: theme.cardColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 24,
                            width: 80,
                            decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(4)),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Spending Trend Chart Shimmer
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 250,
                padding: const EdgeInsets.all(16),
                decoration: AppDecorations.cardDecoration(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 20,
                      width: 140,
                      decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(4)),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(children: [_buildLegendShimmer(theme), const SizedBox(width: 16), _buildLegendShimmer(theme)]),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Category Breakdown Shimmer
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: AppDecorations.cardDecoration(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 20,
                      width: 160,
                      decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(4)),
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(5, (index) {
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
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: theme.cardColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      height: 14,
                                      width: 100 + (index * 20).toDouble(),
                                      decoration: BoxDecoration(
                                        color: theme.cardColor,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 14,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: theme.cardColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 8,
                              decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(4)),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              height: 12,
                              width: 40,
                              decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(4)),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Budget Progress Shimmer
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: AppDecorations.cardDecoration(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 20,
                      width: 140,
                      decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(4)),
                    ),
                    const SizedBox(height: 16),
                    // Budget progress rows
                    ...List.generate(3, (rowIndex) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Expanded(child: _buildBudgetProgressShimmer(theme)),
                            const SizedBox(width: 16),
                            Expanded(child: rowIndex < 2 ? _buildBudgetProgressShimmer(theme) : const SizedBox()),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildLegendShimmer(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: theme.cardColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Container(
          height: 12,
          width: 40,
          decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(4)),
        ),
      ],
    );
  }

  Widget _buildBudgetProgressShimmer(ThemeData theme) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(color: theme.cardColor, shape: BoxShape.circle),
        ),
        const SizedBox(height: 12),
        Container(
          height: 14,
          width: 80,
          decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(height: 6),
        Container(
          height: 12,
          width: 100,
          decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(4)),
        ),
      ],
    );
  }
}
