import 'package:flutter/material.dart';
import 'package:zip_search/core/commons/app_strings.dart';

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
    var scaffoldMessenger = ScaffoldMessenger.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(message),
        duration: const Duration(seconds: 5),
        shape: const StadiumBorder(),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
            label: AppStrings.okText,
            textColor: Colors.white,
            onPressed: () {
              scaffoldMessenger.hideCurrentSnackBar();
            }),
      ),
    );
  }
}

extension Te on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
