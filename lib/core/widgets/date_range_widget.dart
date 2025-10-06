import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finance_tracker/core/constants/app_strings.dart';

class DateRangeWidget extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime? startDate, DateTime? endDate) onDateRangeChanged;
  final String? title;

  const DateRangeWidget({super.key, this.startDate, this.endDate, required this.onDateRangeChanged, this.title});

  @override
  State<DateRangeWidget> createState() => _DateRangeWidgetState();
}

class _DateRangeWidgetState extends State<DateRangeWidget> {
  late DateTime? _startDate;
  late DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
  }

  @override
  void didUpdateWidget(DateRangeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startDate != widget.startDate) {
      _startDate = widget.startDate;
    }
    if (oldWidget.endDate != widget.endDate) {
      _endDate = widget.endDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title (optional)
        if (widget.title != null) ...[_buildSectionTitle(widget.title!), const SizedBox(height: 12)],

        // Date Presets
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildDatePresetChip(AppStrings.today, () => _setDatePreset(0), _isTodaySelected()),
            _buildDatePresetChip(AppStrings.thisWeek, () => _setDatePreset(7), _isThisWeekSelected()),
            _buildDatePresetChip(AppStrings.thisMonth, () => _setDatePreset(30), _isThisMonthSelected()),
            _buildDatePresetChip(AppStrings.last3Months, () => _setDatePreset(90), _isLast3MonthsSelected()),
            _buildDatePresetChip(AppStrings.custom, () => _setCustomDate(), _isCustomSelected()),
          ],
        ),
        const SizedBox(height: 16),

        // Custom Date Range
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                AppStrings.from,
                _startDate,
                (date) => setState(() {
                  _startDate = date;
                  widget.onDateRangeChanged(_startDate, _endDate);
                }),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDateField(
                AppStrings.to,
                _endDate,
                (date) => setState(() {
                  _endDate = date;
                  widget.onDateRangeChanged(_startDate, _endDate);
                }),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface),
    );
  }

  Widget _buildDatePresetChip(String label, VoidCallback onTap, bool isSelected) {
    final theme = Theme.of(context);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => onTap(),
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      selectedColor: theme.colorScheme.primaryContainer,
      labelStyle: theme.textTheme.bodySmall?.copyWith(
        color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildDateField(String label, DateTime? date, Function(DateTime?) onChanged) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: label == AppStrings.from ? DateTime(2020) : (_startDate ?? DateTime(2020)),
          lastDate: label == AppStrings.to ? DateTime.now() : (_endDate ?? DateTime.now()),
        );
        if (selectedDate != null) {
          // Validate date range
          if (label == AppStrings.from && _endDate != null && selectedDate.isAfter(_endDate!)) {
            _showDateValidationError(AppStrings.fromDateGreaterThanToDate);
            return;
          }
          if (label == AppStrings.to && _startDate != null && selectedDate.isBefore(_startDate!)) {
            _showDateValidationError(AppStrings.toDateLessThanFromDate);
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
                date != null ? DateFormat(AppStrings.dateFormatShort).format(date) : label,
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

  void _setDatePreset(int days) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    setState(() {
      _endDate = today;

      if (days == 30) {
        // This Month - start from 1st day of current month
        _startDate = DateTime(now.year, now.month, 1);
      } else {
        // Other presets - subtract days from today
        _startDate = today.subtract(Duration(days: days));
      }
    });
    widget.onDateRangeChanged(_startDate, _endDate);
  }

  void _setCustomDate() {
    // Custom option doesn't set any specific dates
    // It just indicates that custom dates are being used
    setState(() {
      // Don't change the dates, just mark as custom
    });
  }

  bool _isTodaySelected() {
    if (_startDate == null || _endDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startDateOnly = DateTime(_startDate!.year, _startDate!.month, _startDate!.day);
    final endDateOnly = DateTime(_endDate!.year, _endDate!.month, _endDate!.day);
    return startDateOnly.isAtSameMomentAs(today) && endDateOnly.isAtSameMomentAs(today);
  }

  bool _isThisWeekSelected() {
    if (_startDate == null || _endDate == null) return false;
    final now = DateTime.now();
    final weekAgo = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 7));
    final startDateOnly = DateTime(_startDate!.year, _startDate!.month, _startDate!.day);
    final endDateOnly = DateTime(_endDate!.year, _endDate!.month, _endDate!.day);
    return startDateOnly.isAtSameMomentAs(weekAgo) &&
        endDateOnly.isAtSameMomentAs(DateTime(now.year, now.month, now.day));
  }

  bool _isThisMonthSelected() {
    if (_startDate == null || _endDate == null) return false;
    final now = DateTime.now();
    final firstOfMonth = DateTime(now.year, now.month, 1);
    final startDateOnly = DateTime(_startDate!.year, _startDate!.month, _startDate!.day);
    final endDateOnly = DateTime(_endDate!.year, _endDate!.month, _endDate!.day);
    return startDateOnly.isAtSameMomentAs(firstOfMonth) &&
        endDateOnly.isAtSameMomentAs(DateTime(now.year, now.month, now.day));
  }

  bool _isLast3MonthsSelected() {
    if (_startDate == null || _endDate == null) return false;
    final now = DateTime.now();
    final threeMonthsAgo = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 90));
    final startDateOnly = DateTime(_startDate!.year, _startDate!.month, _startDate!.day);
    final endDateOnly = DateTime(_endDate!.year, _endDate!.month, _endDate!.day);
    return startDateOnly.isAtSameMomentAs(threeMonthsAgo) &&
        endDateOnly.isAtSameMomentAs(DateTime(now.year, now.month, now.day));
  }

  bool _isCustomSelected() {
    if (_startDate == null || _endDate == null) return false;

    // Check if the current dates don't match any of the presets
    return !_isTodaySelected() && !_isThisWeekSelected() && !_isThisMonthSelected() && !_isLast3MonthsSelected();
  }

  void _showDateValidationError(String message) {
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
