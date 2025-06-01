import 'package:flutter/material.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';

enum AlertType { error, warning, info, success }

class AppAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final AlertType type;
  final String? buttonText;
  final VoidCallback? onPressed;
  final Widget? content;

  const AppAlertDialog({
    super.key,
    required this.title,
    required this.message,
    required this.type,
    this.buttonText,
    this.onPressed,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        constraints: BoxConstraints(
          maxWidth: isMobile ? double.infinity : 450,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(context.dimensions.spacingL),
              decoration: BoxDecoration(
                color: _getBackgroundColor(context),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(context.dimensions.borderRadiusL),
                  topRight: Radius.circular(context.dimensions.borderRadiusL),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _getIcon(),
                    size: 48,
                    color: _getIconColor(context),
                  ),
                  SizedBox(height: context.dimensions.spacingM),
                  Text(
                    title,
                    style: context.textStyles.title.copyWith(
                      color: _getTextColor(context),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(context.dimensions.spacingL),
              child: Column(
                children: [
                  Text(
                    message,
                    style: context.textStyles.body,
                    textAlign: TextAlign.center,
                  ),
                  if (content != null) ...[
                    SizedBox(height: context.dimensions.spacingM),
                    content!,
                  ],
                  SizedBox(height: context.dimensions.spacingL),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onPressed ?? () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getButtonColor(context),
                        foregroundColor: context.colors.onPrimary,
                        padding: EdgeInsets.symmetric(
                          vertical: context.dimensions.spacingM,
                        ),
                      ),
                      child: Text(buttonText ?? 'OK'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (type) {
      case AlertType.error:
        return Icons.error_outline;
      case AlertType.warning:
        return Icons.warning_amber_rounded;
      case AlertType.info:
        return Icons.info_outline;
      case AlertType.success:
        return Icons.check_circle_outline;
    }
  }

  Color _getBackgroundColor(BuildContext context) {
    switch (type) {
      case AlertType.error:
        return context.colors.error.withOpacity(0.1);
      case AlertType.warning:
        return context.colors.warning.withOpacity(0.1);
      case AlertType.info:
        return context.colors.primary.withOpacity(0.1);
      case AlertType.success:
        return context.colors.success.withOpacity(0.1);
    }
  }

  Color _getIconColor(BuildContext context) {
    switch (type) {
      case AlertType.error:
        return context.colors.error;
      case AlertType.warning:
        return context.colors.warning;
      case AlertType.info:
        return context.colors.primary;
      case AlertType.success:
        return context.colors.success;
    }
  }

  Color _getTextColor(BuildContext context) {
    switch (type) {
      case AlertType.error:
        return context.colors.error;
      case AlertType.warning:
        return context.colors.warning;
      case AlertType.info:
        return context.colors.primary;
      case AlertType.success:
        return context.colors.success;
    }
  }

  Color _getButtonColor(BuildContext context) {
    switch (type) {
      case AlertType.error:
        return context.colors.error;
      case AlertType.warning:
        return context.colors.warning;
      case AlertType.info:
        return context.colors.primary;
      case AlertType.success:
        return context.colors.success;
    }
  }
}

// Helper functions to show alert dialogs
Future<void> showAppAlertDialog({
  required BuildContext context,
  required String title,
  required String message,
  required AlertType type,
  String? buttonText,
  Widget? content,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => AppAlertDialog(
      title: title,
      message: message,
      type: type,
      buttonText: buttonText,
      content: content,
    ),
  );
}

// Convenience methods for common alerts
Future<void> showErrorDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? buttonText,
}) async {
  return showAppAlertDialog(
    context: context,
    title: title,
    message: message,
    type: AlertType.error,
    buttonText: buttonText,
  );
}

Future<void> showSuccessDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? buttonText,
}) async {
  return showAppAlertDialog(
    context: context,
    title: title,
    message: message,
    type: AlertType.success,
    buttonText: buttonText,
  );
}

Future<void> showWarningDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? buttonText,
}) async {
  return showAppAlertDialog(
    context: context,
    title: title,
    message: message,
    type: AlertType.warning,
    buttonText: buttonText,
  );
}

Future<void> showInfoDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? buttonText,
}) async {
  return showAppAlertDialog(
    context: context,
    title: title,
    message: message,
    type: AlertType.info,
    buttonText: buttonText,
  );
}