import 'package:flutter/material.dart';
import 'package:take_home/core/constants/app_strings.dart';
import 'package:take_home/presentation/analytics/widgets/custom_date_field.dart';

class CustomDateRangeWidget extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime?) onStartDateChanged;
  final Function(DateTime?) onEndDateChanged;
  final VoidCallback onApply;

  const CustomDateRangeWidget({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: CustomDateField(
            label: AppStrings.from,
            date: startDate,
            onChanged: onStartDateChanged,
            startDate: startDate,
            endDate: endDate,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CustomDateField(
            label: AppStrings.to,
            date: endDate,
            onChanged: onEndDateChanged,
            startDate: startDate,
            endDate: endDate,
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: startDate != null && endDate != null ? onApply : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(
            AppStrings.apply,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
