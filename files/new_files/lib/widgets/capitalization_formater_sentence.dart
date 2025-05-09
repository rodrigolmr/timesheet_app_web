import 'package:flutter/services.dart';

/// Capitalizes the first letter of each sentence (including after new lines).
class CapitalizationFormaterSentence extends TextInputFormatter {
  const CapitalizationFormaterSentence();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    final buffer = StringBuffer();
    bool capitalizeNext = true;

    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      if (capitalizeNext && char != ' ' && char != '\n') {
        buffer.write(char.toUpperCase());
        capitalizeNext = false;
      } else {
        buffer.write(char);
      }
      if (char == '.' || char == '!' || char == '?' || char == '\n') {
        capitalizeNext = true;
      }
    }

    final newText = buffer.toString();
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
