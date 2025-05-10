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
  }) {
    return AppTheme.inputDecoration(
      label: label,
      hintText: hintText,
      prefixText: prefixText,
      suffixIcon: suffixIcon,
      error: error,
      contentPadding: contentPadding,
    );
  }
}