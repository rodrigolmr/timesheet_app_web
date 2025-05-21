import 'package:flutter/material.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';

/// Action button for toolbars and filter interfaces
class AppActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? size;

  const AppActionButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: (iconColor ?? context.colors.primary).withOpacity(0.3),
              width: 1,
            ),
            color: backgroundColor ?? context.colors.surface,
          ),
          child: Icon(
            icon,
            size: 16,
            color: iconColor ?? context.colors.primary,
          ),
        ),
      ),
    );
  }
}

/// Compact action button with contextual styling based on tooltip
class AppCompactActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? size;

  const AppCompactActionButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    // Contextual colors based on tooltip for better UX
    Color bgColor = backgroundColor ?? context.colors.surface;
    Color iColor = iconColor ?? context.colors.primary;
    
    if (tooltip.contains('Clear')) {
      bgColor = context.colors.surface;
      iColor = context.colors.error;
    } else if (tooltip.contains('Apply')) {
      bgColor = context.colors.surface;
      iColor = context.colors.primary;
    } else if (tooltip.contains('Minimize') || tooltip.contains('Expand')) {
      bgColor = context.colors.surface;
      iColor = context.colors.primary;
    }
    
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: iColor.withOpacity(0.2),
              width: 1,
            ),
            color: bgColor,
          ),
          child: Icon(
            icon,
            size: 16,
            color: iColor,
          ),
        ),
      ),
    );
  }
}