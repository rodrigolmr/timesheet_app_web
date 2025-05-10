// lib/widgets/capitalization_formater_sentence.dart

import 'package:flutter/services.dart';

/// Formatador que capitaliza a primeira letra de cada sentença.
///
/// Este formatador de texto capitaliza automaticamente a primeira letra
/// de cada sentença, incluindo após pontos finais, pontos de exclamação,
/// pontos de interrogação e quebras de linha.
class CapitalizationFormaterSentence extends TextInputFormatter {
  /// Constrói um formatador de capitalização de sentenças.
  const CapitalizationFormaterSentence();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Se não houve mudança no texto, retorna o valor sem modificação
    if (oldValue.text == newValue.text) {
      return newValue;
    }
    
    final text = newValue.text;
    final buffer = StringBuffer();
    bool capitalizeNext = true;

    // Processa cada caractere
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      
      // Capitaliza o próximo caractere se não for espaço ou quebra de linha
      if (capitalizeNext && char.trim().isNotEmpty) {
        buffer.write(char.toUpperCase());
        capitalizeNext = false;
      } else {
        buffer.write(char);
      }
      
      // Define que o próximo caractere deve ser capitalizado após pontuações
      // que finalizam sentenças
      if (char == '.' || char == '!' || char == '?' || char == '\n') {
        capitalizeNext = true;
      }
    }

    // Constrói o novo valor mantendo a posição do cursor
    final newText = buffer.toString();
    return TextEditingValue(
      text: newText,
      selection: newValue.selection,
      composing: newValue.composing,
    );
  }
}