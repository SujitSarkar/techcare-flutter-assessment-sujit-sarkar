import 'package:flutter/material.dart';
import 'package:finance_tracker/core/constants/app_strings.dart';
import 'package:finance_tracker/core/widgets/date_range_widget.dart';
import 'package:finance_tracker/domain/entities/transaction.dart';

class TransactionFilterBottomSheet extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> selectedCategories;
  final double? minAmount;
  final double? maxAmount;
  final TransactionType? transactionType;
  final List<String> availableCategories;
  final Function({
    DateTime? startDate,
    DateTime? endDate,
    List<String> selectedCategories,
    double? minAmount,
    double? maxAmount,
    TransactionType? transactionType,
  })
  onApplyFilters;
  final VoidCallback onResetFilters;

  const TransactionFilterBottomSheet({
    super.key,
    this.startDate,
    this.endDate,
    this.selectedCategories = const [],
    this.minAmount,
    this.maxAmount,
    this.transactionType,
    required this.availableCategories,
    required this.onApplyFilters,
    required this.onResetFilters,
  });

  @override
  State<TransactionFilterBottomSheet> createState() => _TransactionFilterBottomSheetState();
}

class _TransactionFilterBottomSheetState extends State<TransactionFilterBottomSheet> {
  late DateTime? _startDate;
  late DateTime? _endDate;
  late List<String> _selectedCategories;
  late double? _minAmount;
  late double? _maxAmount;
  late TransactionType? _transactionType;
  late double _tempMinAmount;
  late double _tempMaxAmount;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
    _selectedCategories = List.from(widget.selectedCategories);
    _minAmount = widget.minAmount;
    _maxAmount = widget.maxAmount;
    _transactionType = widget.transactionType;

    // Initialize temp values for sliders
    _tempMinAmount = _minAmount ?? 0.0;
    _tempMaxAmount = _maxAmount ?? 10000.0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppStrings.filter, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: _resetFilters,
                  child: Text(
                    AppStrings.reset,
                    style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.primary),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Range Section
                  DateRangeWidget(
                    title: AppStrings.dateRange,
                    startDate: _startDate,
                    endDate: _endDate,
                    onDateRangeChanged: (startDate, endDate) {
                      setState(() {
                        _startDate = startDate;
                        _endDate = endDate;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Categories Section
                  _buildSectionTitle(AppStrings.categories),
                  _buildCategoriesSection(),
                  const SizedBox(height: 24),

                  // Amount Range Section
                  _buildSectionTitle(AppStrings.amountRange),
                  _buildAmountRangeSection(),
                  const SizedBox(height: 24),

                  // Transaction Type Section
                  _buildSectionTitle(AppStrings.transactionType),
                  _buildTransactionTypeSection(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Apply Button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  AppStrings.apply,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 0,
      children: widget.availableCategories.map((category) {
        final isSelected = _selectedCategories.contains(category);
        return FilterChip(
          label: Text(category),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedCategories.add(category);
              } else {
                _selectedCategories.remove(category);
              }
            });
          },
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          selectedColor: theme.colorScheme.primaryContainer,
          labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurfaceVariant,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAmountRangeSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${AppStrings.minAmount}: ${AppStrings.currencySymbol} ${_tempMinAmount.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '${AppStrings.maxAmount}: ${AppStrings.currencySymbol} ${_tempMaxAmount.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        RangeSlider(
          values: RangeValues(_tempMinAmount, _tempMaxAmount),
          min: 0,
          max: 10000,
          divisions: 100,
          onChanged: (values) {
            setState(() {
              _tempMinAmount = values.start;
              _tempMaxAmount = values.end;
            });
          },
          onChangeEnd: (values) {
            setState(() {
              _minAmount = values.start;
              _maxAmount = values.end;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTransactionTypeSection() {
    return Row(
      children: [
        Expanded(child: _buildTypeChip(AppStrings.all, null)),
        const SizedBox(width: 8),
        Expanded(child: _buildTypeChip(AppStrings.income, TransactionType.income)),
        const SizedBox(width: 8),
        Expanded(child: _buildTypeChip(AppStrings.expense, TransactionType.expense)),
      ],
    );
  }

  Widget _buildTypeChip(String label, TransactionType? type) {
    final theme = Theme.of(context);
    final isSelected = _transactionType == type;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _transactionType = selected ? type : null;
        });
      },
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      selectedColor: theme.colorScheme.primaryContainer,
      labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  void _applyFilters() {
    widget.onApplyFilters(
      startDate: _startDate,
      endDate: _endDate,
      selectedCategories: _selectedCategories,
      minAmount: _minAmount,
      maxAmount: _maxAmount,
      transactionType: _transactionType,
    );
    Navigator.of(context).pop();
  }

  void _resetFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _selectedCategories.clear();
      _minAmount = null;
      _maxAmount = null;
      _transactionType = null;
      _tempMinAmount = 0.0;
      _tempMaxAmount = 10000.0;
    });
    widget.onResetFilters();
  }
}
