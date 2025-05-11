// lib/widgets/input_field_new.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_theme.dart';
import 'input_field_core.dart';
import 'text_formatter.dart';
import 'base_input.dart';

/// Campo de entrada padrão para texto com suporte a validação e formatação.
///
/// Este widget herda da classe base para garantir consistência com outros
/// componentes de entrada na aplicação.
class InputField extends BaseInput {
  /// Controlador para o campo de texto.
  final TextEditingController? controller;
  
  /// Tipo de capitalização a ser aplicado.
  final CapitalizationType capitalizationType;
  
  /// Formatadores personalizados para o campo.
  final List<TextInputFormatter>? inputFormatters;
  
  /// Configuração de capitalização do Flutter.
  final TextCapitalization textCapitalization;
  
  /// Texto semântico para acessibilidade.
  final String? semanticLabel;

  /// Cria um campo de entrada padrão.
  /// 
  /// [label]: Rótulo exibido acima do campo.
  /// [hintText]: Texto de dica quando o campo está vazio.
  /// [controller]: Controlador opcional para o campo.
  /// [errorText]: Mensagem de erro quando o campo é inválido.
  /// [validationState]: Estado de validação atual do campo.
  const InputField({
    Key? key,
    required String label,
    required String hintText,
    this.controller,
    String? errorText,
    InputValidationState validationState = InputValidationState.none,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    String? prefixText,
    Widget? suffixIcon,
    TextInputAction? textInputAction,
    TextInputType? keyboardType,
    bool obscureText = false,
    double? maxWidth,
    this.capitalizationType = CapitalizationType.words,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.words,
    this.semanticLabel,
  }) : super(
    key: key,
    label: label,
    hintText: hintText,
    errorText: errorText,
    validationState: validationState,
    validator: validator,
    onChanged: onChanged,
    onSubmitted: onSubmitted,
    prefixText: prefixText,
    suffixIcon: suffixIcon,
    textInputAction: textInputAction,
    keyboardType: keyboardType,
    obscureText: obscureText,
    maxWidth: maxWidth,
  );

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> with InputFocusBehavior<InputField> {
  late final TextEditingController _controller;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _errorMessage = widget.errorText;
  }
  
  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }
  
  @override
  void onFocusGained() {
    // Limpa o erro quando o campo recebe foco
    if (widget.validationState == InputValidationState.invalid && mounted) {
      setState(() {
        _errorMessage = null;
      });
    }
  }
  
  @override
  void onFocusLost() {
    // Faz trim no texto quando perde o foco
    if (_controller.text.trim() != _controller.text) {
      _controller.text = _controller.text.trim();
      widget.onChanged?.call(_controller.text);
    }
    
    // Valida o campo quando perde o foco se houver validator
    if (widget.validator != null) {
      final error = widget.validator!(_controller.text);
      if (error != null && mounted) {
        setState(() {
          _errorMessage = error;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // Usa o sistema de formatação unificado
    final formatters = widget.inputFormatters ?? 
        [TextFormatter.capitalization(widget.capitalizationType)];
    
    // Verifica o estado de validação
    final validationState = _errorMessage != null 
        ? InputValidationState.invalid 
        : widget.validationState;
    
    return BaseInputContainer(
      validationState: validationState,
      maxWidth: widget.maxWidth,
      semanticLabel: widget.semanticLabel ?? widget.label,
      child: TextField(
        focusNode: focusNode,
        controller: _controller,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        textCapitalization: widget.textCapitalization,
        inputFormatters: formatters,
        obscureText: widget.obscureText,
        autocorrect: widget.textCapitalization != TextCapitalization.none,
        enableSuggestions: widget.textCapitalization != TextCapitalization.none,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        style: const TextStyle(
          fontSize: AppTheme.bodyTextSize,
          color: AppTheme.textDarkColor,
        ),
        decoration: InputFieldCore.decoration(
          label: widget.label,
          hintText: widget.hintText,
          prefixText: widget.prefixText,
          suffixIcon: widget.suffixIcon,
          error: validationState == InputValidationState.invalid,
          errorText: _errorMessage,
        ),
      ),
    );
  }
}