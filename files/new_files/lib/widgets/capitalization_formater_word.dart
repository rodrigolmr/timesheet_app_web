import 'package:flutter/services.dart';

/// Capitalizes the first letter of each word as the user types.
class CapitalizationFormaterWord extends TextInputFormatter {
  const CapitalizationFormaterWord();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    final words = text.split(' ');
    final capitalizedWords = words.map((word) {
      if (word.isEmpty) return '';
      final first = word[0].toUpperCase();
      final rest = word.length > 1 ? word.substring(1) : '';
      return first + rest;
    }).toList();
    final newText = capitalizedWords.join(' ');
    final delta = newText.length - text.length;
    final newSelection = newValue.selection.copyWith(
      baseOffset: newValue.selection.baseOffset + delta,
      extentOffset: newValue.selection.extentOffset + delta,
    );
    return TextEditingValue(
      text: newText,
      selection: newSelection,
    );
  }
}
