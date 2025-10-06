import 'package:flutter/material.dart';

import 'package:finance_tracker/core/constants/app_strings.dart';

class CustomDateField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final Function(DateTime?) onChanged;
  final DateTime? startDate;
  final DateTime? endDate;

  const CustomDateField({
    super.key,
    required this.label,
    required this.date,
    required this.onChanged,
    this.startDate,
    this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: label == AppStrings.from ? DateTime(2020) : (startDate ?? DateTime(2020)),
          lastDate: DateTime.now(), // Prevent selecting future dates for both fields
        );
        if (selectedDate != null) {
          // Validate date range
          if (label == AppStrings.from && endDate != null && selectedDate.isAfter(endDate!)) {
            _showDateValidationError(context, AppStrings.fromDateGreaterThanToDate);
            return;
          }
          if (label == AppStrings.to && startDate != null && selectedDate.isBefore(startDate!)) {
            _showDateValidationError(context, AppStrings.toDateLessThanFromDate);
            return;
          }
          onChanged(selectedDate);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.surfaceContainerHighest),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                date != null ? _formatDate(date!) : label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: date != null
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showDateValidationError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
