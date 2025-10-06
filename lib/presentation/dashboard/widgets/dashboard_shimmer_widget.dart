import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:take_home/core/decorations/app_decorations.dart';

class DashboardShimmerWidget extends StatelessWidget {
  const DashboardShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Shimmer.fromColors(
      baseColor: theme.colorScheme.surfaceContainerHighest,
      highlightColor: theme.colorScheme.surface,
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          // Header Skeleton
          SliverToBoxAdapter(
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.1),
                    theme.colorScheme.primary.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 24,
                          width: 120,
                          decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(4)),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 16,
                          width: 100,
                          decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(4)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(color: theme.cardColor, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(color: theme.cardColor, shape: BoxShape.circle),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Balance Card Skeleton
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              height: 200,
              decoration: AppDecorations.cardDecoration(context),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 20,
                          width: 100,
                          decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(4)),
                        ),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(color: theme.cardColor, shape: BoxShape.circle),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Center(
                        child: Container(
                          height: 40,
                          width: 200,
                          decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Spending Overview Skeleton
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: AppDecorations.cardDecoration(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: 150,
                    decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(4)),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(color: theme.cardColor, shape: BoxShape.circle),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: List.generate(
                              4,
                              (index) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(color: theme.cardColor, shape: BoxShape.circle),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Container(
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: theme.cardColor,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Recent Transactions Skeleton
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: AppDecorations.cardDecoration(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 20,
                          width: 140,
                          decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(4)),
                        ),
                        Container(
                          height: 16,
                          width: 60,
                          decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(4)),
                        ),
                      ],
                    ),
                  ),
                  ...List.generate(
                    5,
                    (index) => ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(color: theme.cardColor, shape: BoxShape.circle),
                      ),
                      title: Container(
                        height: 16,
                        width: 120,
                        decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(4)),
                      ),
                      subtitle: Container(
                        height: 12,
                        width: 80,
                        decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(4)),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 14,
                            width: 60,
                            decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(4)),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 10,
                            width: 40,
                            decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(4)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
