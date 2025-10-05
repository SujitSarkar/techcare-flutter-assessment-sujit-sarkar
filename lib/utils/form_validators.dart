import 'package:take_home/core/constants/app_strings.dart';

class FormValidators {
  FormValidators._();

  static String? requiredTextValidator(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? AppStrings.titleRequired;
    }
    return null;
  }

  static String? maxLengthValidator(String? value, int max, {String? message}) {
    if (value != null && value.length > max) {
      return message;
    }
    return null;
  }

  static String? descriptionLengthValidator(String? value) {
    if (value != null && value.length > 500) {
      return AppStrings.descriptionMaxLength;
    }
    return null;
  }

  static String? amountInputValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.amountRequired;
    }
    final cleanValue = value.replaceAll(',', '');
    final amount = double.tryParse(cleanValue);
    if (amount == null || amount <= 0) {
      return AppStrings.amountMustBeGreaterThanZero;
    }
    return null;
  }

  static bool doubleAmountValidator(double? amount) {
    return amount != null && amount > 0;
  }

  static bool dateNotInFutureValidator(DateTime dateTime) {
    return !dateTime.isAfter(DateTime.now());
  }
}
