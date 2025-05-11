// lib/widgets/input_field.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/responsive/responsive.dart';
import '../core/theme/app_theme.dart';
import 'input_field_core.dart';
import 'text_formatter.dart';

class InputField extends StatefulWidget {
  /// Rótulo do campo exibido como label ou placeholder.
  final String label;

  /// Texto de dica exibido quando o campo está vazio.
  final String hintText;

  /// Controlador para o campo de entrada.
  final TextEditingController? controller;

  /// Indica se o campo contém um erro.
  final bool error;

  /// Mensagem de erro a ser exibida.
  final String? errorText;

  /// Função chamada para limpar o estado de erro.
  final VoidCallback? onClearError;

  /// Tipo de teclado a ser exibido.
  final TextInputType? keyboardType;

  /// Formatadores de entrada para o campo.
  final List<TextInputFormatter>? inputFormatters;

  /// Texto a ser exibido como prefixo.
  final String? prefixText;

  /// Define se o campo deve ocultar o texto (senha).
  final bool obscureText;

  /// Ícone exibido à direita do campo.
  final Widget? suffixIcon;

  /// Configuração de capitalização do texto.
  final TextCapitalization textCapitalization;

  /// Tipo de capitalização para aplicar através dos formatters.
  final CapitalizationType capitalizationType;

  /// Função chamada quando o conteúdo do campo muda.
  final ValueChanged<String>? onChanged;

  /// Ação do teclado ao pressionar "Enter" ou "Próximo".
  final TextInputAction? textInputAction;

  /// Função chamada quando o campo é submetido.
  final ValueChanged<String>? onSubmitted;

  /// Largura máxima em pixels para o campo (null para usar largura total).
  final double? maxWidth;

  const InputField({
    Key? key,
    required this.label,
    required this.hintText,
    this.controller,
    this.error = false,
    this.errorText,
    this.onClearError,
    this.keyboardType,
    this.inputFormatters,
    this.prefixText,
    this.obscureText = false,
    this.suffixIcon,
    this.textCapitalization = TextCapitalization.words,
    this.capitalizationType = CapitalizationType.words,
    this.onChanged,
    this.textInputAction,
    this.onSubmitted,
    this.maxWidth,
  }) : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(() {
      if (_focusNode.hasFocus) {
        if (widget.error && widget.onClearError != null) {
          widget.onClearError!();
        }
      } else if (widget.controller != null) {
        final c = widget.controller!;
        final trimmed = c.text.trim();
        if (trimmed != c.text) c.text = trimmed;
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Usa o sistema de formatação unificado
    final formatters = widget.inputFormatters ??
        [TextFormatter.capitalization(widget.capitalizationType)];

    // Acessa as configurações responsivas
    final responsive = ResponsiveSizing(context);
    final inputHeight = responsive.inputHeight;

    // Aplica constraints responsivos com largura máxima opcional
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final useWidth = widget.maxWidth != null
            ? (widget.maxWidth! > availableWidth ? availableWidth : widget.maxWidth!)
            : availableWidth;

        return Container(
          width: useWidth,
          constraints: BoxConstraints(
            minHeight: inputHeight,
          ),
          decoration: InputFieldCore.containerDecoration(widget.error),
          child: Material(
            // Material para efeitos de toque
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
            child: TextField(
              focusNode: _focusNode,
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              textCapitalization: widget.textCapitalization,
              inputFormatters: formatters,
              obscureText: widget.obscureText,
              autocorrect: widget.textCapitalization != TextCapitalization.none,
              enableSuggestions: widget.textCapitalization != TextCapitalization.none,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              onTap: () {
                if (widget.error && widget.onClearError != null) {
                  widget.onClearError!();
                }
              },
              style: const TextStyle(
                fontSize: AppTheme.bodyTextSize,
                color: AppTheme.textDarkColor,
              ),
              decoration: InputFieldCore.decoration(
                label: widget.label,
                hintText: widget.hintText,
                prefixText: widget.prefixText,
                suffixIcon: widget.suffixIcon,
                error: widget.error,
                errorText: widget.errorText,
              ),
            ),
          ),
        );
      }
    );
  }
}