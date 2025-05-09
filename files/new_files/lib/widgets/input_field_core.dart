// lib/widgets/input_field_core.dart

import 'package:flutter/material.dart';

class InputFieldCore {
  static const Color appBlueColor   = Color(0xFF0205D3);
  static const Color appYellowColor = Color(0xFFFFFDD0);
  static const Color hintGrayColor  = Colors.grey;  // ← adicionado

  static BoxDecoration containerDecoration(bool error) {
    if (error) {
      return BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      );
    }
    return const BoxDecoration();
  }

  static InputDecoration decoration({
    required String label,
    required String hintText,
    String? prefixText,
    Widget? suffixIcon,
    bool error = false,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: hintGrayColor,             // agora usa hintGrayColor
      ),
      floatingLabelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: appBlueColor,
      ),
      hintText: hintText,
      hintStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: hintGrayColor,             // e aqui
      ),
      prefixText: prefixText,
      filled: true,
      fillColor: appYellowColor,
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: appBlueColor, width: 1),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: appBlueColor, width: 2),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: appBlueColor, width: 1),
      ),
      errorText: error ? ' ' : null,
      errorStyle: const TextStyle(fontSize: 0, height: 0),
      suffixIcon: suffixIcon,
      contentPadding:
          contentPadding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}
