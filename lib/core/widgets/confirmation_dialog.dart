import 'package:flutter/material.dart';
import 'package:take_home/core/constants/app_strings.dart';

class ConfirmationDialog {
  static Future<bool?> showDeleteTransactionConfirmation(
    BuildContext context, {
    String? title,
    String? message,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) async {
    final theme = Theme.of(context);

    return await showDialog<bool>(
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
                Navigator.of(dialogContext).pop(false);
                onCancel?.call();
              },
              child: Text(AppStrings.cancel, style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
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
