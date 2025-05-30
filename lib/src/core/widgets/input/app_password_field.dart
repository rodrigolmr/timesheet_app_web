import 'package:flutter/material.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/input/app_input_field_base.dart';

/// Campo de texto padronizado para entrada de senhas
class AppPasswordField extends StatefulWidget {
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

  /// Indica se o campo está desabilitado
  final bool enabled;

  /// Largura máxima do campo (null = ocupar a largura disponível)
  final double? maxWidth;

  /// Callback quando o valor do campo muda
  final ValueChanged<String>? onChanged;

  /// Callback quando o campo é submetido
  final ValueChanged<String>? onSubmitted;

  /// Indica se o campo é o último de um formulário
  final bool isLastField;

  /// Nó de foco para passar quando o campo é submetido
  final FocusNode? nextFocusNode;

  /// Controla se o botão de visualização da senha deve ser exibido
  final bool showVisibilityToggle;

  /// Ícone exibido no início do campo
  final Widget? prefixIcon;

  /// Construtor padrão
  const AppPasswordField({
    Key? key,
    this.label = "Password",
    this.hintText = "Enter your password",
    this.controller,
    this.hasError = false,
    this.errorText,
    this.focusNode,
    this.onClearError,
    this.enabled = true,
    this.maxWidth,
    this.onChanged,
    this.onSubmitted,
    this.isLastField = false,
    this.nextFocusNode,
    this.showVisibilityToggle = true,
    this.prefixIcon,
  }) : super(key: key);

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {    
    Widget? suffixIcon;
    
    if (widget.showVisibilityToggle) {
      suffixIcon = IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: widget.hasError 
              ? context.colors.error 
              : context.colors.onSurfaceVariant,
          size: 20,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        splashRadius: 20,
      );
    }

    return AppInputFieldBase(
      label: widget.label,
      hintText: widget.hintText,
      controller: widget.controller,
      hasError: widget.hasError,
      errorText: widget.errorText,
      focusNode: widget.focusNode,
      onClearError: widget.onClearError,
      keyboardType: TextInputType.visiblePassword,
      prefixIcon: widget.prefixIcon,
      suffixIcon: suffixIcon,
      enabled: widget.enabled,
      maxWidth: widget.maxWidth,
      textCapitalization: TextCapitalization.none,
      onChanged: widget.onChanged,
      multiline: false,
      maxLines: 1,
      expands: false,
      readOnly: false,
      obscureText: _obscureText,
      onSubmitted: widget.onSubmitted,
    );
  }
}