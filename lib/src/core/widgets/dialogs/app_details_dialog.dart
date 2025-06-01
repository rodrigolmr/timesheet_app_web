import 'package:flutter/material.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';

class AppDetailsDialog extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget content;
  final List<Widget>? actions;
  final bool showCloseButton;
  final double? maxWidth;
  final double? maxHeight;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? statusBadge;

  const AppDetailsDialog({
    super.key,
    required this.title,
    required this.content,
    this.icon,
    this.actions,
    this.showCloseButton = true,
    this.maxWidth,
    this.maxHeight,
    this.contentPadding,
    this.statusBadge,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = context.isMobile;
    
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 40,
        vertical: isMobile ? 24 : 40,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? (isMobile ? screenWidth - 32 : 550),
          maxHeight: maxHeight ?? (isMobile ? screenHeight - 48 : screenHeight * 0.9),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: contentPadding ?? EdgeInsets.all(
              isMobile ? context.dimensions.spacingM : context.dimensions.spacingL
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isMobile) ...[
                  _buildDesktopHeader(context),
                  SizedBox(height: context.dimensions.spacingL),
                ] else if (statusBadge != null) ...[
                  statusBadge!,
                  SizedBox(height: context.dimensions.spacingL),
                ],
                content,
                if (actions != null && actions!.isNotEmpty) ...[
                  SizedBox(height: context.dimensions.spacingL),
                  ...actions!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopHeader(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            color: context.colors.primary,
            size: 28,
          ),
          SizedBox(width: context.dimensions.spacingM),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textStyles.title,
              ),
              if (statusBadge != null) ...[
                SizedBox(height: context.dimensions.spacingXS),
                statusBadge!,
              ],
            ],
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
}

// Helper function to show details dialog
Future<T?> showAppDetailsDialog<T>({
  required BuildContext context,
  required String title,
  required Widget content,
  IconData? icon,
  List<Widget>? actions,
  Widget? statusBadge,
  double? maxWidth,
  double? maxHeight,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (_) => AppDetailsDialog(
      title: title,
      icon: icon,
      content: content,
      actions: actions,
      statusBadge: statusBadge,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    ),
  );
}