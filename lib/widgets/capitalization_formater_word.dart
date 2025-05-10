// lib/widgets/capitalization_formater_word.dart

import 'package:flutter/services.dart';

/// Formatador que capitaliza a primeira letra de cada palavra.
///
/// Este formatador de texto automaticamente capitaliza a primeira letra
/// de cada palavra em um texto, incluindo palavras após quebras de linha.
class CapitalizationFormaterWord extends TextInputFormatter {
  /// Constrói um formatador de capitalização de palavras.
  const CapitalizationFormaterWord();

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
    
    // Separa as palavras considerando espaços e quebras de linha
    final separators = RegExp(r'[ \n\r\t]');
    final words = text.split(separators);
    
    // Capitaliza a primeira letra de cada palavra
    final capitalizedWords = words.map((word) {
      if (word.isEmpty) return '';
      
      // Pega o primeiro caractere e o restante da palavra
      final first = word[0].toUpperCase();
      final rest = word.length > 1 ? word.substring(1) : '';
      
      return first + rest;
    }).toList();
    
    // Reconstrói o texto com as palavras capitalizadas
    String newText = '';
    int wordIndex = 0;
    
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      
      // Se for um separador, adicione-o ao novo texto
      if (separators.hasMatch(char)) {
        newText += char;
      } else {
        // Se for o início de uma nova palavra
        if (i == 0 || separators.hasMatch(text[i - 1])) {
          // Adiciona a palavra capitalizada
          newText += capitalizedWords[wordIndex];
          
          // Pula o resto da palavra
          final wordLength = words[wordIndex].length;
          i += wordLength - 1;
          wordIndex++;
        }
      }
    }
    
    // Preserva a posição do cursor
    return TextEditingValue(
      text: newText,
      selection: newValue.selection,
      composing: newValue.composing,
    );
  }
}