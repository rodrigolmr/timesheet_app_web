import 'package:flutter/services.dart';

/// TextInputFormatter que capitaliza a primeira letra de cada palavra
class WordCapitalizationFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    // Capitaliza a primeira letra de cada palavra
    final words = text.split(' ');
    final capitalizedWords = words.map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();

    final newText = capitalizedWords.join(' ');
    
    // Se o texto mudou, retorna o novo valor
    if (newText != text) {
      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: newValue.selection.baseOffset,
        ),
      );
    }
    
    return newValue;
  }
}

/// TextInputFormatter que capitaliza a primeira letra de cada sentença
class SentenceCapitalizationFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    // Capitaliza a primeira letra do texto
    var newText = text;
    if (text.isNotEmpty) {
      newText = text[0].toUpperCase() + text.substring(1);
    }

    // Capitaliza após pontos, exclamações, interrogações e quebras de linha
    final sentenceEndings = ['. ', '! ', '? ', '\n'];
    for (final ending in sentenceEndings) {
      final parts = newText.split(ending);
      for (int i = 0; i < parts.length - 1; i++) {
        if (i + 1 < parts.length && parts[i + 1].isNotEmpty) {
          parts[i + 1] = parts[i + 1][0].toUpperCase() + parts[i + 1].substring(1);
        }
      }
      newText = parts.join(ending);
    }
    
    // Se o texto mudou, retorna o novo valor
    if (newText != text) {
      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: newValue.selection.baseOffset,
        ),
      );
    }
    
    return newValue;
  }
}