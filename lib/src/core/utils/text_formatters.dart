import 'package:flutter/services.dart';

/// Utility class for cleaning text fields
class TextCleaners {
  /// Cleans a text field by:
  /// - Trimming whitespace from start and end
  /// - Removing trailing empty lines (but keeping empty lines in the middle)
  static String cleanTextField(String? text) {
    if (text == null || text.isEmpty) return '';
    
    // First trim to remove leading/trailing whitespace
    String cleaned = text.trim();
    
    // Remove trailing newlines only (keep newlines in the middle)
    // This regex removes one or more newlines at the end of the string
    cleaned = cleaned.replaceAll(RegExp(r'\n+$'), '');
    
    return cleaned;
  }
  
  /// Cleans all string fields in a JSON map based on the provided field list
  static Map<String, dynamic> cleanJsonFields(
    Map<String, dynamic> json, 
    List<String> cleanableFields,
  ) {
    final cleaned = Map<String, dynamic>.from(json);
    
    for (final field in cleanableFields) {
      if (cleaned.containsKey(field) && cleaned[field] is String) {
        cleaned[field] = cleanTextField(cleaned[field] as String);
      }
    }
    
    return cleaned;
  }
}

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
      
      // Se a palavra já tem letras maiúsculas além da primeira, mantém como está
      // Isso permite que o usuário digite palavras em ALL CAPS
      final hasUppercaseLetters = word.substring(1).contains(RegExp(r'[A-Z]'));
      if (hasUppercaseLetters) {
        return word;
      }
      
      // Caso contrário, capitaliza apenas a primeira letra
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