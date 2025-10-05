import 'package:flutter/material.dart';
import 'package:take_home/core/constants/app_strings.dart';

import 'package:take_home/core/decorations/app_decorations.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final double value;
  final IconData icon;
  final Color color;
  final Animation<double> animation;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: AppDecorations.cardDecorationWithBorder(context, borderColor: color.withValues(alpha: 0.3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),

          AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              final animatedValue = value * animation.value;
              return FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${AppStrings.currencySymbol} ${animatedValue.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: color),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
