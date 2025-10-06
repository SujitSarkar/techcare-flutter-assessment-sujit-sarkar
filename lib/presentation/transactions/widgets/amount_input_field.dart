import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:finance_tracker/core/constants/app_strings.dart';
import 'package:finance_tracker/core/constants/app_regex.dart';
import 'package:finance_tracker/utils/form_validators.dart';

class AmountInputField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const AmountInputField({super.key, required this.controller, this.onChanged});

  @override
  State<AmountInputField> createState() => _AmountInputFieldState();
}

class _AmountInputFieldState extends State<AmountInputField> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.amount, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Text(
                AppStrings.currencySymbol,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(AppRegex.allowedAmountChars),
                    _AmountInputFormatter(),
                  ],
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: AppStrings.enterAmount,
                    hintStyle: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) {
                    widget.onChanged?.call(value);
                  },
                  validator: FormValidators.amountInputValidator,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AmountInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digit characters except decimal point
    String cleanText = newValue.text.replaceAll(AppRegex.nonDigitExceptDot, '');

    // Ensure only one decimal point
    if (cleanText.split('.').length > 2) {
      cleanText = '${cleanText.split('.').first}.${cleanText.split('.').skip(1).join('')}';
    }

    // Limit decimal places to 2
    if (cleanText.contains('.')) {
      final parts = cleanText.split('.');
      if (parts[1].length > 2) {
        cleanText = '${parts[0]}.${parts[1].substring(0, 2)}';
      }
    }

    // Add comma separators
    if (cleanText.isNotEmpty) {
      final parts = cleanText.split('.');
      final integerPart = parts[0];
      final decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

      // Add commas to integer part
      final formattedInteger = _addCommas(integerPart);
      cleanText = formattedInteger + decimalPart;
    }

    return TextEditingValue(
      text: cleanText,
      selection: TextSelection.collapsed(offset: cleanText.length),
    );
  }

  String _addCommas(String number) {
    if (number.isEmpty) return number;

    final reversed = number.split('').reversed.join('');
    final chunks = <String>[];

    for (int i = 0; i < reversed.length; i += 3) {
      chunks.add(reversed.substring(i, i + 3 > reversed.length ? reversed.length : i + 3));
    }

    return chunks.join(',').split('').reversed.join('');
  }
}
