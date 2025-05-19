import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/input/app_input_field_base.dart';

/// Campo de texto padronizado para entrada de texto com múltiplas linhas
class AppMultilineTextField extends StatelessWidget {
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

  /// Formatadores de entrada para validar/formatar o texto
  final List<TextInputFormatter>? inputFormatters;

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

  /// Número máximo de linhas (null = sem limite)
  final int? maxLines;

  /// Número mínimo de linhas
  final int? minLines;

  /// Se o campo deve se expandir para preencher o espaço disponível
  final bool expands;

  /// Se o campo deve crescer automaticamente com o conteúdo
  final bool autoGrow;

  /// Tipo de teclado para este campo
  final TextInputType? keyboardType;

  /// Construtor padrão
  const AppMultilineTextField({
    Key? key,
    required this.label,
    required this.hintText,
    this.controller,
    this.hasError = false,
    this.errorText,
    this.focusNode,
    this.onClearError,
    this.inputFormatters,
    this.enabled = true,
    this.maxWidth,
    this.height,
    this.textCapitalization = TextCapitalization.sentences,
    this.onChanged,
    this.maxLines = 5,
    this.minLines = 1,
    this.expands = false,
    this.autoGrow = false,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Se autoGrow é true, não define altura fixa e permite crescimento automático
    // Para multiline, sempre deixar null para que o Flutter calcule automaticamente
    final effectiveHeight = height;  // Sem altura padrão, deixa o Flutter calcular
    final effectiveMaxLines = autoGrow ? null : maxLines;
    final effectiveMinLines = autoGrow ? (minLines ?? 3) : minLines;
    
    return AppInputFieldBase(
      label: label,
      hintText: hintText,
      controller: controller,
      hasError: hasError,
      errorText: errorText,
      focusNode: focusNode,
      onClearError: onClearError,
      keyboardType: keyboardType ?? TextInputType.multiline,
      inputFormatters: inputFormatters,
      enabled: enabled,
      maxWidth: maxWidth,
      height: effectiveHeight,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      onTap: null, // Usando o comportamento padrão
      multiline: true,
      maxLines: effectiveMaxLines,
      minLines: effectiveMinLines,
      expands: expands,
      readOnly: false,
      obscureText: false,
      textAlignVertical: TextAlignVertical.top, // Alinha texto no topo para campos multiline
    );
  }

  /// Cria um campo multiline para descrições
  factory AppMultilineTextField.description({
    Key? key,
    String label = "Description",
    String hintText = "Enter description",
    TextEditingController? controller,
    bool hasError = false,
    String? errorText,
    FocusNode? focusNode,
    VoidCallback? onClearError,
    bool enabled = true,
    double? maxWidth,
    double? height,
    ValueChanged<String>? onChanged,
    int? maxLines,
  }) {
    return AppMultilineTextField(
      key: key,
      label: label,
      hintText: hintText,
      controller: controller,
      hasError: hasError,
      errorText: errorText,
      focusNode: focusNode,
      onClearError: onClearError,
      textCapitalization: TextCapitalization.sentences,
      enabled: enabled,
      maxWidth: maxWidth,
      height: height,
      onChanged: onChanged,
      maxLines: maxLines ?? 5,
    );
  }

  /// Cria um campo multiline para comentários
  factory AppMultilineTextField.comment({
    Key? key,
    String label = "Comments",
    String hintText = "Enter your comments",
    TextEditingController? controller,
    bool hasError = false,
    String? errorText,
    FocusNode? focusNode,
    VoidCallback? onClearError,
    bool enabled = true,
    double? maxWidth,
    double? height,
    ValueChanged<String>? onChanged,
    int? maxLines,
  }) {
    return AppMultilineTextField(
      key: key,
      label: label,
      hintText: hintText,
      controller: controller,
      hasError: hasError,
      errorText: errorText,
      focusNode: focusNode,
      onClearError: onClearError,
      textCapitalization: TextCapitalization.sentences,
      enabled: enabled,
      maxWidth: maxWidth,
      height: height,
      onChanged: onChanged,
      maxLines: maxLines ?? 3,
    );
  }
}