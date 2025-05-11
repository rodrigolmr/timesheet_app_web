// lib/widgets/input_field_core.dart

import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class InputFieldCore {
  static BoxDecoration containerDecoration(bool error) {
    return AppTheme.inputContainerDecoration(error);
  }

  static InputDecoration decoration({
    required String label,
    required String hintText,
    String? prefixText,
    Widget? suffixIcon,
    bool error = false,
    EdgeInsetsGeometry? contentPadding,
    String? errorText,
  }) {
    return AppTheme.inputDecoration(
      label: label,
      hintText: hintText,
      prefixText: prefixText,
      suffixIcon: suffixIcon,
      error: error,
      contentPadding: contentPadding,
    ).copyWith(
      // Adicionado feedback visual interativo (ripple effect)
      errorText: error ? (errorText ?? ' ') : null,
      // Animação durante interação com campo
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: AppTheme.primaryBlue,
          width: AppTheme.mediumBorder,
        ),
        borderRadius: BorderRadius.all(Radius.circular(AppTheme.defaultRadius)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: AppTheme.primaryBlue,
          width: AppTheme.thinBorder,
        ),
        borderRadius: BorderRadius.all(Radius.circular(AppTheme.defaultRadius)),
      ),
      // Adiciona efeito tátil visual
      hoverColor: AppTheme.primaryBlue.withOpacity(0.05),
    );
  }

  // Método auxiliar para criar Material com feedback visual de toque
  static Widget wrapWithFeedback(Widget child) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: AppTheme.primaryBlue.withOpacity(0.1),
        highlightColor: AppTheme.primaryBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
        onTap: () {}, // Captura o toque para mostrar o efeito
        child: child,
      ),
    );
  }
}