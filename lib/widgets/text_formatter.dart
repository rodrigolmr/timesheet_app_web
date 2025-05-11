// lib/widgets/text_formatter.dart

import 'package:flutter/services.dart';

/// Tipo de capitalização a ser aplicado pelo formatador de texto.
enum CapitalizationType {
  /// Capitaliza a primeira letra de cada palavra.
  words,
  
  /// Capitaliza a primeira letra de cada sentença.
  sentences,
  
  /// Não aplica capitalização.
  none,
}

/// Tipo de formatação numérica a ser aplicado.
enum NumericFormatterType {
  /// Números inteiros somente.
  integer,
  
  /// Números decimais com ponto.
  decimal,
  
  /// Formato de horário (HH:MM).
  time,
  
  /// Formato monetário com dois decimais.
  money,
}

/// Classe centralizadora para formatação de texto em inputs.
///
/// Esta classe fornece métodos estáticos para criar formatadores de texto
/// para diferentes cenários de uso, permitindo uma abordagem consistente
/// e centralizada de formatação em toda a aplicação.
class TextFormatter {
  /// Cria um formatador de capitalização baseado no tipo especificado.
  static TextInputFormatter capitalization(CapitalizationType type) {
    switch (type) {
      case CapitalizationType.words:
        return const _CapitalizationFormatterWord();
      case CapitalizationType.sentences:
        return const _CapitalizationFormatterSentence();
      case CapitalizationType.none:
        return FilteringTextInputFormatter.singleLineFormatter;
    }
  }

  /// Cria um formatador para números com base no tipo especificado.
  static TextInputFormatter numeric(NumericFormatterType type) {
    switch (type) {
      case NumericFormatterType.integer:
        return FilteringTextInputFormatter.digitsOnly;
      case NumericFormatterType.decimal:
        return FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'));
      case NumericFormatterType.time:
        return const _TimeTextFormatter(hoursFormat: 24);
      case NumericFormatterType.money:
        return _MoneyTextInputFormatter();
    }
  }

  /// Cria um formatador personalizado para valores monetários com simbolo.
  static TextInputFormatter money({String symbol = 'R\$'}) {
    return _MoneyTextInputFormatter(symbol: symbol);
  }

  /// Cria um formatador de tempo com a opção de formato 12h ou 24h.
  static TextInputFormatter time({int hoursFormat = 24}) {
    return _TimeTextFormatter(hoursFormat: hoursFormat);
  }

  /// Cria um formatador para limitar o número máximo de caracteres.
  static TextInputFormatter maxLength(int length) {
    return LengthLimitingTextInputFormatter(length);
  }

  /// Retorna uma lista de formatadores para casos comuns.
  static List<TextInputFormatter> getFormatters({
    CapitalizationType capitalization = CapitalizationType.none,
    NumericFormatterType? numericType,
    int? maxLength,
  }) {
    final formatters = <TextInputFormatter>[];
    
    // Adiciona formatador de capitalização se necessário
    if (capitalization != CapitalizationType.none) {
      formatters.add(TextFormatter.capitalization(capitalization));
    }
    
    // Adiciona formatador numérico se especificado
    if (numericType != null) {
      formatters.add(TextFormatter.numeric(numericType));
    }
    
    // Adiciona limitador de comprimento se especificado
    if (maxLength != null) {
      formatters.add(TextFormatter.maxLength(maxLength));
    }
    
    return formatters;
  }
}

// Implementações internas dos formatadores

/// Formatador que capitaliza a primeira letra de cada palavra.
class _CapitalizationFormatterWord extends TextInputFormatter {
  const _CapitalizationFormatterWord();

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

/// Formatador que capitaliza a primeira letra de cada sentença.
class _CapitalizationFormatterSentence extends TextInputFormatter {
  const _CapitalizationFormatterSentence();

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

/// Formatador de texto para entrada de horário no formato HH:MM.
class _TimeTextFormatter extends TextInputFormatter {
  final int hoursFormat;
  
  const _TimeTextFormatter({this.hoursFormat = 24});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Se não houve mudança no texto, retorna o valor sem modificação
    if (oldValue.text == newValue.text) {
      return newValue;
    }
    
    // Extrai somente os dígitos do texto
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Limita a quantidade de dígitos
    if (digits.length > 4) {
      digits = digits.substring(0, 4);
    }
    
    // Formata o texto de acordo com a quantidade de dígitos
    String formatted;
    switch (digits.length) {
      case 0:
      case 1:
      case 2:
        formatted = digits;
        break;
      case 3:
        formatted = '${digits[0]}:${digits.substring(1)}';
        break;
      default:
        // Converte para o formato correto de horas
        int hours = int.parse(digits.substring(0, 2));
        if (hoursFormat == 12 && hours > 12) {
          hours = 12;
          digits = hours.toString().padLeft(2, '0') + digits.substring(2);
        } else if (hoursFormat == 24 && hours > 23) {
          hours = 23;
          digits = hours.toString().padLeft(2, '0') + digits.substring(2);
        }
        
        // Verifica os minutos
        int minutes = int.parse(digits.substring(2, 4));
        if (minutes > 59) {
          minutes = 59;
          digits = digits.substring(0, 2) + minutes.toString().padLeft(2, '0');
        }
        
        formatted = '${digits.substring(0, 2)}:${digits.substring(2)}';
    }
    
    // Retorna o valor formatado, mantendo a posição do cursor
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Formatador para valores monetários no formato R$ 0,00
class _MoneyTextInputFormatter extends TextInputFormatter {
  final String symbol;
  
  _MoneyTextInputFormatter({this.symbol = 'R\$'});
  
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    
    // Remove tudo que não for dígito
    final value = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Converte para centavos
    final cents = int.parse(value);
    
    // Formata como moeda
    final formatted = '$symbol ${(cents / 100).toStringAsFixed(2)}';
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}