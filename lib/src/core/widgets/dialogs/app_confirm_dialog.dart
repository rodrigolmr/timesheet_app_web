import 'package:flutter/material.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';

enum ConfirmActionType { normal, danger, warning }

class AppConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  final ConfirmActionType actionType;
  final IconData? icon;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
    this.actionType = ConfirmActionType.normal,
    this.icon,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            icon ?? _getDefaultIcon(),
            color: _getIconColor(context),
            size: 24,
          ),
          SizedBox(width: context.dimensions.spacingS),
          Expanded(
            child: Text(
              title,
              style: context.textStyles.title,
            ),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isMobile ? double.infinity : 400,
        ),
        child: Text(
          message,
          style: context.textStyles.body,
        ),
      ),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(false),
          child: Text(cancelText ?? 'Cancel'),
        ),
        ElevatedButton(
          onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: _getButtonColor(context),
            foregroundColor: _getButtonTextColor(context),
          ),
          child: Text(confirmText ?? _getDefaultConfirmText()),
        ),
      ],
    );
  }

  IconData _getDefaultIcon() {
    switch (actionType) {
      case ConfirmActionType.danger:
        return Icons.warning_amber_rounded;
      case ConfirmActionType.warning:
        return Icons.info_outline;
      case ConfirmActionType.normal:
        return Icons.help_outline;
    }
  }

  Color _getIconColor(BuildContext context) {
    switch (actionType) {
      case ConfirmActionType.danger:
        return context.colors.error;
      case ConfirmActionType.warning:
        return context.colors.warning;
      case ConfirmActionType.normal:
        return context.colors.primary;
    }
  }

  Color _getButtonColor(BuildContext context) {
    switch (actionType) {
      case ConfirmActionType.danger:
        return context.colors.error;
      case ConfirmActionType.warning:
        return context.colors.warning;
      case ConfirmActionType.normal:
        return context.colors.primary;
    }
  }

  Color _getButtonTextColor(BuildContext context) {
    switch (actionType) {
      case ConfirmActionType.danger:
        return context.colors.onError;
      case ConfirmActionType.warning:
        return context.colors.onPrimary;
      case ConfirmActionType.normal:
        return context.colors.onPrimary;
    }
  }

  String _getDefaultConfirmText() {
    switch (actionType) {
      case ConfirmActionType.danger:
        return 'Delete';
      case ConfirmActionType.warning:
        return 'Proceed';
      case ConfirmActionType.normal:
        return 'Confirm';
    }
  }
}

// Helper function to show confirm dialog
Future<bool?> showAppConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? confirmText,
  String? cancelText,
  ConfirmActionType actionType = ConfirmActionType.normal,
  IconData? icon,
}) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => AppConfirmDialog(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      actionType: actionType,
      icon: icon,
    ),
  );
}