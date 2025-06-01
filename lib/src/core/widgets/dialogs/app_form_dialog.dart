import 'package:flutter/material.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';

enum DialogMode { create, edit, view }

class AppFormDialog extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget content;
  final List<Widget>? actions;
  final bool showCloseButton;
  final DialogMode mode;
  final double? maxWidth;
  final double? maxHeight;
  final EdgeInsetsGeometry? contentPadding;
  final bool scrollable;

  const AppFormDialog({
    super.key,
    required this.title,
    required this.content,
    this.icon,
    this.actions,
    this.showCloseButton = true,
    this.mode = DialogMode.create,
    this.maxWidth,
    this.maxHeight,
    this.contentPadding,
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = context.isMobile;
    
    final double defaultMaxWidth = isMobile ? screenWidth - 32 : 550;
    final double defaultMaxHeight = isMobile ? screenHeight - 48 : screenHeight * 0.9;
    
    final dialogContent = Padding(
      padding: contentPadding ?? EdgeInsets.all(
        isMobile ? context.dimensions.spacingM : context.dimensions.spacingL
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: context.dimensions.spacingM),
          if (scrollable)
            Flexible(child: SingleChildScrollView(child: content))
          else
            content,
          if (actions != null && actions!.isNotEmpty) ...[
            SizedBox(height: context.dimensions.spacingL),
            _buildActions(context),
          ],
        ],
      ),
    );

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 40,
        vertical: isMobile ? 24 : 40,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? defaultMaxWidth,
          maxHeight: maxHeight ?? defaultMaxHeight,
        ),
        child: dialogContent,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final Color iconColor = _getIconColor(context);
    
    return Row(
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            color: iconColor,
            size: 28,
          ),
          SizedBox(width: context.dimensions.spacingM),
        ],
        Expanded(
          child: Text(
            title,
            style: context.textStyles.title,
          ),
        ),
        if (showCloseButton)
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    if (actions == null || actions!.isEmpty) return const SizedBox.shrink();
    
    return Row(
      children: actions!.map((action) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.dimensions.spacingXS,
            ),
            child: action,
          ),
        );
      }).toList(),
    );
  }

  Color _getIconColor(BuildContext context) {
    switch (mode) {
      case DialogMode.create:
        return context.colors.primary;
      case DialogMode.edit:
        return context.colors.warning;
      case DialogMode.view:
        return context.colors.textSecondary;
    }
  }
}

class AppFormDialogActions extends StatelessWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final String? cancelText;
  final String? confirmText;
  final bool isLoading;
  final DialogMode mode;

  const AppFormDialogActions({
    super.key,
    this.onCancel,
    this.onConfirm,
    this.cancelText,
    this.confirmText,
    this.isLoading = false,
    this.mode = DialogMode.create,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: isLoading ? null : (onCancel ?? () => Navigator.of(context).pop()),
            child: Text(cancelText ?? 'Cancel'),
          ),
        ),
        SizedBox(width: context.dimensions.spacingS),
        Expanded(
          child: ElevatedButton(
            onPressed: isLoading ? null : onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: _getConfirmButtonColor(context),
              foregroundColor: context.colors.onPrimary,
            ),
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        context.colors.onPrimary,
                      ),
                    ),
                  )
                : Text(_getConfirmText()),
          ),
        ),
      ],
    );
  }

  String _getConfirmText() {
    if (confirmText != null) return confirmText!;
    
    switch (mode) {
      case DialogMode.create:
        return 'Add';
      case DialogMode.edit:
        return 'Save';
      case DialogMode.view:
        return 'Close';
    }
  }

  Color _getConfirmButtonColor(BuildContext context) {
    switch (mode) {
      case DialogMode.create:
      case DialogMode.view:
        return context.colors.primary;
      case DialogMode.edit:
        return context.colors.warning;
    }
  }
}


// Helper function to show dialog
Future<T?> showAppFormDialog<T>({
  required BuildContext context,
  required String title,
  required Widget content,
  IconData? icon,
  List<Widget>? actions,
  DialogMode mode = DialogMode.create,
  double? maxWidth,
  double? maxHeight,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (_) => AppFormDialog(
      title: title,
      icon: icon,
      content: content,
      actions: actions,
      mode: mode,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    ),
  );
}

