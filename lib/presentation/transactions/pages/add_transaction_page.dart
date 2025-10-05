import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:take_home/core/constants/app_strings.dart';
import 'package:take_home/domain/entities/category.dart';
import 'package:take_home/domain/entities/transaction.dart';
import 'package:take_home/presentation/category/bloc/category_bloc.dart';
import 'package:take_home/presentation/transactions/bloc/transactions_bloc.dart';
import 'package:take_home/presentation/transactions/widgets/amount_input_field.dart';
import 'package:take_home/presentation/transactions/widgets/category_selection_chips.dart';
import 'package:take_home/presentation/transactions/widgets/transaction_type_selector.dart';

class AddTransactionPage extends StatefulWidget {
  final TransactionType initialType;

  const AddTransactionPage({super.key, this.initialType = TransactionType.expense});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  TransactionType _selectedType = TransactionType.expense;
  Category? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
    _selectedTime = TimeOfDay.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<TransactionsBloc, TransactionsState>(
      listener: (context, state) {
        if (state is TransactionAddedState) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppStrings.transactionAddedSuccessfully)));
        } else if (state is TransactionsErrorState) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.addTransaction),
          actions: [
            TextButton(
              onPressed: _isLoading ? null : _saveTransaction,
              child: Text(
                _isLoading ? AppStrings.saving : AppStrings.save,
                style: TextStyle(
                  color: _isLoading ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Amount Input Field
                AmountInputField(
                  controller: _amountController,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 20),

                // Transaction Type Selector
                TransactionTypeSelector(
                  selectedType: _selectedType,
                  onTypeChanged: (type) {
                    setState(() {
                      _selectedType = type;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Category Selection
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoadedState) {
                      return CategorySelectionChips(
                        categories: state.categories,
                        selectedCategory: _selectedCategory,
                        onCategorySelected: (category) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      );
                    } else if (state is CategoryLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return Text(
                        AppStrings.failedToFetchCategories,
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),

                // Transaction Title
                Text(
                  AppStrings.transactionTitle,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  maxLines: 3,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: AppStrings.enterTitle,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppStrings.titleRequired;
                    }
                    if (value.length > 100) {
                      return AppStrings.titleMaxLength;
                    }
                    return null;
                  },
                  maxLength: 100,
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  AppStrings.transactionDescription,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    hintText: AppStrings.enterDescription,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  maxLines: 5,
                  minLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  maxLength: 500,
                  validator: (value) {
                    if (value != null && value.length > 500) {
                      return AppStrings.descriptionMaxLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Date and Time Selection
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.selectDate,
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: _selectDate,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: theme.colorScheme.outline),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today, color: theme.colorScheme.primary, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    DateFormat(AppStrings.dateFormatShort).format(_selectedDate),
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.selectTime,
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: _selectTime,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: theme.colorScheme.outline),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.access_time, color: theme.colorScheme.primary, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    _selectedTime != null ? _selectedTime!.format(context) : 'Not set',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text(AppStrings.cancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveTransaction,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: _isLoading
                            ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text(AppStrings.save),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: _selectedTime ?? TimeOfDay.now());
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveTransaction() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppStrings.categoryRequired)));
      return;
    }

    // Validate amount
    final amountText = _amountController.text.replaceAll(',', '');
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppStrings.amountMustBeGreaterThanZero)));
      return;
    }

    // Validate date
    final now = DateTime.now();
    final selectedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime?.hour ?? 0,
      _selectedTime?.minute ?? 0,
    );
    if (selectedDateTime.isAfter(now)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppStrings.dateCannotBeInFuture)));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      amount: amount,
      type: _selectedType,
      category: _selectedCategory,
      date: selectedDateTime,
    );

    context.read<TransactionsBloc>().add(AddTransactionEvent(transaction: transaction));
  }
}
