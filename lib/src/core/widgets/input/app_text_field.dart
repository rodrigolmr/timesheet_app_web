import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timesheet_app_web/src/core/widgets/input/app_input_field_base.dart';

/// Campo de texto padronizado para entrada de texto simples (linha única)
class AppTextField extends StatelessWidget {
  /// Texto do rótulo do campo
  final String label;

  /// Texto de sugestão exibido quando o campo está vazio
  final String hintText;

  /// Controlador para gerenciar o conteúdo do campo
  final TextEditingController? controller;

  /// Indica se o campo está com erro
  final bool hasError;

  /// Mensagem de erro a ser exibida (quando hasError = true)
  final String? errorText;

  /// Nó de foco para este campo
  final FocusNode? focusNode;

  /// Callback quando o erro deve ser limpo
  final VoidCallback? onClearError;

  /// Tipo de teclado para este campo
  final TextInputType? keyboardType;

  /// Formatadores de entrada para validar/formatar o texto
  final List<TextInputFormatter>? inputFormatters;

  /// Texto prefixado antes do valor do campo
  final String? prefixText;

  /// Widget prefixado antes do valor do campo
  final Widget? prefixIcon;

  /// Widget sufixado após o valor do campo
  final Widget? suffixIcon;

  /// Indica se o campo está desabilitado
  final bool enabled;

  /// Largura máxima do campo (null = ocupar a largura disponível)
  final double? maxWidth;

  /// Altura fixa do campo (null = altura padrão)
  final double? height;

  /// Capitalization do teclado
  final TextCapitalization textCapitalization;

  /// Callback quando o valor do campo muda
  final ValueChanged<String>? onChanged;

  /// Callback quando o campo é submetido
  final ValueChanged<String>? onSubmitted;

  /// Indica se o campo é o último de um formulário
  final bool isLastField;

  /// Nó de foco para passar quando o campo é submetido
  final FocusNode? nextFocusNode;

  /// Construtor padrão
  const AppTextField({
    Key? key,
    required this.label,
    required this.hintText,
    this.controller,
    this.hasError = false,
    this.errorText,
    this.focusNode,
    this.onClearError,
    this.keyboardType,
    this.inputFormatters,
    this.prefixText,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.maxWidth,
    this.height,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.onSubmitted,
    this.isLastField = false,
    this.nextFocusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppInputFieldBase(
      label: label,
      hintText: hintText,
      controller: controller,
      hasError: hasError,
      errorText: errorText,
      focusNode: focusNode,
      onClearError: onClearError,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      prefixText: prefixText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabled: enabled,
      maxWidth: maxWidth,
      height: height,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      onTap: null, // Usando o comportamento padrão
      multiline: false,
      maxLines: 1,
      expands: false,
      readOnly: false,
      obscureText: false,
    );
  }

  /// Cria um campo de texto para entrada de nome
  factory AppTextField.name({
    Key? key,
    required String label,
    String? hintText,
    TextEditingController? controller,
    bool hasError = false,
    String? errorText,
    FocusNode? focusNode,
    VoidCallback? onClearError,
    bool enabled = true,
    double? maxWidth,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    bool isLastField = false,
    FocusNode? nextFocusNode,
  }) {
    return AppTextField(
      key: key,
      label: label,
      hintText: hintText ?? "Enter name",
      controller: controller,
      hasError: hasError,
      errorText: errorText,
      focusNode: focusNode,
      onClearError: onClearError,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      enabled: enabled,
      maxWidth: maxWidth,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      isLastField: isLastField,
      nextFocusNode: nextFocusNode,
    );
  }

  /// Cria um campo de texto para entrada de email
  factory AppTextField.email({
    Key? key,
    String label = "Email",
    String hintText = "Enter your email",
    TextEditingController? controller,
    bool hasError = false,
    String? errorText,
    FocusNode? focusNode,
    VoidCallback? onClearError,
    bool enabled = true,
    double? maxWidth,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    bool isLastField = false,
    FocusNode? nextFocusNode,
  }) {
    return AppTextField(
      key: key,
      label: label,
      hintText: hintText,
      controller: controller,
      hasError: hasError,
      errorText: errorText,
      focusNode: focusNode,
      onClearError: onClearError,
      keyboardType: TextInputType.emailAddress,
      textCapitalization: TextCapitalization.none,
      enabled: enabled,
      maxWidth: maxWidth,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      isLastField: isLastField,
      nextFocusNode: nextFocusNode,
    );
  }

  /// Cria um campo de texto para entrada de número de telefone
  factory AppTextField.phone({
    Key? key,
    String label = "Phone Number",
    String hintText = "Enter phone number",
    TextEditingController? controller,
    bool hasError = false,
    String? errorText,
    FocusNode? focusNode,
    VoidCallback? onClearError,
    bool enabled = true,
    double? maxWidth,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    bool isLastField = false,
    FocusNode? nextFocusNode,
  }) {
    return AppTextField(
      key: key,
      label: label,
      hintText: hintText,
      controller: controller,
      hasError: hasError,
      errorText: errorText,
      focusNode: focusNode,
      onClearError: onClearError,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textCapitalization: TextCapitalization.none,
      enabled: enabled,
      maxWidth: maxWidth,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      isLastField: isLastField,
      nextFocusNode: nextFocusNode,
    );
  }

  /// Cria um campo de texto para entrada de números
  factory AppTextField.number({
    Key? key,
    required String label,
    String? hintText,
    TextEditingController? controller,
    bool hasError = false,
    String? errorText,
    FocusNode? focusNode,
    VoidCallback? onClearError,
    bool enabled = true,
    double? maxWidth,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    bool isLastField = false,
    FocusNode? nextFocusNode,
    String? prefixText,
  }) {
    return AppTextField(
      key: key,
      label: label,
      hintText: hintText ?? "Enter a number",
      controller: controller,
      hasError: hasError,
      errorText: errorText,
      focusNode: focusNode,
      onClearError: onClearError,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      prefixText: prefixText,
      textCapitalization: TextCapitalization.none,
      enabled: enabled,
      maxWidth: maxWidth,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      isLastField: isLastField,
      nextFocusNode: nextFocusNode,
    );
  }
}