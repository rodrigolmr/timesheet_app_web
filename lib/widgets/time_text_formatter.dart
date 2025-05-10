// lib/widgets/time_text_formatter.dart

import 'package:flutter/services.dart';

/// Formatador de texto para entrada de horário no formato HH:MM.
///
/// Este formatador permite que o usuário insira um horário digitando
/// apenas os números, com formatação automática no formato HH:MM.
class TimeTextFormatter extends TextInputFormatter {
  /// Formato máximo de horas permitido (12 ou 24).
  final int hoursFormat;
  
  /// Constrói um formatador de texto para entrada de horário.
  ///
  /// O [hoursFormat] especifica se o horário deve ser formatado para 12 ou 24 horas.
  const TimeTextFormatter({this.hoursFormat = 24});

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