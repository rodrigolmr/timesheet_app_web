import 'package:flutter/material.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';

/// Helper para criar IconButtons compactos seguindo padrões do Flutter
class CompactIconButton {
  /// Cria um IconButton compacto para ações de filtro
  static Widget create({
    required BuildContext context,
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    double size = 28,
  }) {
    // Cores específicas baseadas no tooltip
    Color iconColor = context.colors.primary;
    
    if (tooltip.contains('Clear')) {
      iconColor = context.colors.error;
    } else if (tooltip.contains('Apply')) {
      iconColor = context.colors.primary;
    } else if (tooltip.contains('Minimize') || tooltip.contains('Expand')) {
      iconColor = context.colors.primary;
    }
    
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      iconSize: size * 0.6,
      tooltip: tooltip,
      color: iconColor,
      style: IconButton.styleFrom(
        backgroundColor: context.colors.surface,
        padding: EdgeInsets.all(size * 0.15),
        minimumSize: Size(size, size),
        maximumSize: Size(size, size),
        side: BorderSide(
          color: iconColor.withOpacity(0.2),
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

/// Helper para criar botões de ação padrão
class ActionIconButton {
  /// Cria um IconButton padrão
  static Widget create({
    required BuildContext context,
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    double size = 32,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      iconSize: size * 0.5,
      tooltip: tooltip,
      color: context.colors.primary,
      style: IconButton.styleFrom(
        backgroundColor: context.colors.surface,
        padding: EdgeInsets.all(size * 0.15),
        minimumSize: Size(size, size),
        maximumSize: Size(size, size),
        side: BorderSide(
          color: context.colors.outline.withOpacity(0.3),
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}