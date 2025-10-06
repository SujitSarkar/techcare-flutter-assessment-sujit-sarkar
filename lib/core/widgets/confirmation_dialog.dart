import 'package:flutter/material.dart';
import 'package:finance_tracker/core/constants/app_strings.dart';

class ConfirmationDialog {
  static Future<void> showDeleteTransactionConfirmation(
    BuildContext context, {
    String? title,
    String? message,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) async {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            title ?? AppStrings.deleteTransaction,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          content: Text(message ?? AppStrings.deleteConfirmationMessage, style: theme.textTheme.bodyMedium),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onCancel?.call();
              },
              child: Text(AppStrings.cancel, style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onConfirm?.call();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
              child: const Text(AppStrings.delete),
            ),
          ],
        );
      },
    );
  }
}
