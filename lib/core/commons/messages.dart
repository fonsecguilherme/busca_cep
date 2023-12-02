import 'package:flutter/material.dart';

class Messages {
  final BuildContext context;
  Messages._(this.context);

  factory Messages.of(BuildContext context) {
    return Messages._(context);
  }

  void showError(String message) =>
      _showMessage(message, context.colorScheme.error);

  void showSuccess(String message) =>
      _showMessage(message, context.colorScheme.primary);

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(message),
        duration: const Duration(seconds: 3),
        shape: const StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

extension Te on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
