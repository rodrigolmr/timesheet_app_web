// lib/widgets/input_validator.dart

import 'package:flutter/material.dart';

/// Classe de validação centralizada para campos de entrada em toda aplicação.
///
/// Fornece métodos de validação para tipos comuns de dados como: texto,
/// números, emails, etc. Facilita a consistência de validação em todo o app.
class InputValidator {
  /// Valida se o campo não está vazio
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return 'O campo ${fieldName ?? ""}não pode estar vazio';
    }
    return null;
  }

  /// Valida se o campo contém um email válido
  static String? validateEmail(String? value, {bool required = true}) {
    if (required && (value == null || value.trim().isEmpty)) {
      return 'O email não pode estar vazio';
    }
    
    if (value != null && value.trim().isNotEmpty) {
      // Expressão regular para validação de email
      final emailRegExp = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      
      if (!emailRegExp.hasMatch(value)) {
        return 'Formato de email inválido';
      }
    }
    
    return null;
  }

  /// Valida se o campo contém um número válido
  static String? validateNumber(String? value, {bool required = true, bool allowDecimal = false}) {
    if (required && (value == null || value.trim().isEmpty)) {
      return 'Este campo não pode estar vazio';
    }
    
    if (value != null && value.trim().isNotEmpty) {
      if (allowDecimal) {
        // Permite números decimais
        if (double.tryParse(value) == null) {
          return 'Digite um número válido';
        }
      } else {
        // Apenas números inteiros
        if (int.tryParse(value) == null) {
          return 'Digite um número inteiro válido';
        }
      }
    }
    
    return null;
  }

  /// Valida se o valor está dentro de um intervalo mínimo/máximo
  static String? validateRange(String? value, {double? min, double? max}) {
    if (value == null || value.trim().isEmpty) {
      return null; // Vazio é permitido nesta validação
    }
    
    final numValue = double.tryParse(value);
    if (numValue == null) {
      return 'Digite um número válido';
    }
    
    if (min != null && numValue < min) {
      return 'O valor deve ser maior ou igual a $min';
    }
    
    if (max != null && numValue > max) {
      return 'O valor deve ser menor ou igual a $max';
    }
    
    return null;
  }

  /// Valida comprimento mínimo e máximo de texto
  static String? validateLength(String? value, {int? minLength, int? maxLength}) {
    if (value == null || value.trim().isEmpty) {
      return null; // Vazio é permitido nesta validação
    }
    
    if (minLength != null && value.length < minLength) {
      return 'Deve ter pelo menos $minLength caracteres';
    }
    
    if (maxLength != null && value.length > maxLength) {
      return 'Deve ter no máximo $maxLength caracteres';
    }
    
    return null;
  }

  /// Valida um horário no formato HH:MM
  static String? validateTime(String? value, {bool required = true}) {
    if (required && (value == null || value.trim().isEmpty)) {
      return 'O horário não pode estar vazio';
    }
    
    if (value != null && value.trim().isNotEmpty) {
      // Expressão regular para validação de horário no formato HH:MM
      final timeRegExp = RegExp(r'^([0-1]?[0-9]|2[0-3]):([0-5][0-9])$');
      
      if (!timeRegExp.hasMatch(value)) {
        return 'Formato de horário inválido (use HH:MM)';
      }
    }
    
    return null;
  }

  /// Valida nome de trabalhador na lista
  static String? validateWorkerName(String? value, List<String> validNames) {
    if (value == null || value.trim().isEmpty) {
      return 'O nome do trabalhador não pode estar vazio';
    }
    
    if (!validNames.contains(value)) {
      return 'Selecione um trabalhador da lista';
    }
    
    return null;
  }

  /// Método composto para executar múltiplas validações
  static String? validate(String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) {
        return error;
      }
    }
    return null;
  }
}