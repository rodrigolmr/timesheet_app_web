// lib/widgets/base_input.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/responsive/responsive.dart';
import '../core/theme/app_theme.dart';
import 'input_field_core.dart';
import 'text_formatter.dart';
import 'input_validator.dart';

/// Estado de validação para campos de entrada.
enum InputValidationState {
  /// Nenhuma validação foi realizada.
  none,
  
  /// Validação passou com sucesso.
  valid,
  
  /// Validação falhou.
  invalid
}

/// Classe base abstrata para todos os widgets de entrada na aplicação.
///
/// Esta classe define a interface comum e comportamentos para todos os
/// campos de entrada, garantindo consistência e reutilização de código.
abstract class BaseInput extends StatefulWidget {
  /// Rótulo do campo de entrada.
  final String label;
  
  /// Texto de dica exibido quando o campo está vazio.
  final String hintText;
  
  /// Mensagem de erro a ser exibida quando o campo estiver inválido.
  final String? errorText;
  
  /// Estado de validação atual.
  final InputValidationState validationState;
  
  /// Função para validar o valor do campo.
  final String? Function(String?)? validator;
  
  /// Função chamada quando o conteúdo do campo muda.
  final ValueChanged<String>? onChanged;
  
  /// Função chamada quando o campo é submetido.
  final ValueChanged<String>? onSubmitted;
  
  /// Texto a ser exibido como prefixo no campo.
  final String? prefixText;
  
  /// Ícone ou widget exibido à direita do campo.
  final Widget? suffixIcon;
  
  /// Ação do teclado ao pressionar "Enter" ou "Próximo".
  final TextInputAction? textInputAction;
  
  /// Tipo de teclado a ser exibido.
  final TextInputType? keyboardType;
  
  /// Define se o campo deve ocultar o texto (senha).
  final bool obscureText;
  
  /// Largura máxima em pixels para o campo (null para largura total).
  final double? maxWidth;

  /// Construtor base para todos os campos de entrada.
  const BaseInput({
    Key? key,
    required this.label,
    required this.hintText,
    this.errorText,
    this.validationState = InputValidationState.none,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.prefixText,
    this.suffixIcon,
    this.textInputAction,
    this.keyboardType,
    this.obscureText = false,
    this.maxWidth,
  }) : super(key: key);
}

/// Mixin para gerenciar o comportamento do foco em campos de entrada.
mixin InputFocusBehavior<T extends BaseInput> on State<T> {
  late FocusNode focusNode;
  
  @override
  void initState() {
    super.initState();
    focusNode = FocusNode()..addListener(_onFocusChange);
  }
  
  @override
  void dispose() {
    focusNode.removeListener(_onFocusChange);
    focusNode.dispose();
    super.dispose();
  }
  
  /// Método chamado quando o estado do foco muda.
  void _onFocusChange() {
    if (focusNode.hasFocus) {
      // Comportamento quando o campo recebe foco
      onFocusGained();
    } else {
      // Comportamento quando o campo perde foco
      onFocusLost();
    }
  }
  
  /// Método que deve ser implementado para tratar quando o campo ganha foco.
  void onFocusGained();
  
  /// Método que deve ser implementado para tratar quando o campo perde foco.
  void onFocusLost();
}

/// Widget base que implementa um container responsivo para envolver campos de entrada.
class BaseInputContainer extends StatelessWidget {
  /// Conteúdo do container.
  final Widget child;
  
  /// Estado de validação do campo.
  final InputValidationState validationState;
  
  /// Largura máxima desejada para o campo.
  final double? maxWidth;
  
  /// Altura mínima do campo.
  final double? minHeight;
  
  /// Semântica para acessibilidade.
  final String? semanticLabel;

  /// Cria um container base para campos de entrada.
  const BaseInputContainer({
    Key? key,
    required this.child,
    required this.validationState,
    this.maxWidth,
    this.minHeight,
    this.semanticLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Acessa configurações responsivas
    final responsive = ResponsiveSizing(context);
    final inputHeight = minHeight ?? responsive.inputHeight;
    
    // Verifica se tem erro para decoração
    final hasError = validationState == InputValidationState.invalid;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final useWidth = maxWidth != null 
            ? (maxWidth! > availableWidth ? availableWidth : maxWidth!)
            : availableWidth;
        
        return Semantics(
          label: semanticLabel,
          textField: true,
          child: Container(
            width: useWidth,
            constraints: BoxConstraints(
              minHeight: inputHeight,
            ),
            decoration: InputFieldCore.containerDecoration(hasError),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
              child: child,
            ),
          ),
        );
      }
    );
  }
}