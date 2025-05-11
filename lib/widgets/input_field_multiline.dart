// lib/widgets/input_field_multiline.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timesheet_app_web/core/theme/app_theme.dart';
import 'input_field_core.dart';
import 'text_formatter.dart';

/// Um campo de entrada para texto multi-linha com suporte para formatação de texto.
///
/// Este widget é útil para inserção de textos mais longos como descrições, notas
/// e comentários. Ele suporta múltiplas linhas e formatação de capitalização.
class InputFieldMultiline extends StatefulWidget {
  /// Rótulo do campo de entrada.
  final String label;
  
  /// Texto de dica exibido quando o campo está vazio.
  final String hintText;
  
  /// Controlador para o campo de texto (opcional).
  final TextEditingController? controller;
  
  /// Indica se o campo contém um erro.
  final bool error;
  
  /// Função chamada para limpar o estado de erro.
  final VoidCallback? onClearError;
  
  /// Texto a ser exibido como prefixo no campo.
  final String? prefixText;
  
  /// Número máximo de linhas a serem exibidas.
  final int maxLines;
  
  /// Configuração de capitalização do texto.
  final TextCapitalization textCapitalization;
  
  /// Formatadores de entrada para o campo.
  final List<TextInputFormatter>? inputFormatters;
  
  /// Função chamada quando o texto é alterado.
  final ValueChanged<String>? onChanged;
  
  /// Altura mínima do campo (em pixels).
  final double minHeight;
  
  /// Construtor para o campo de entrada multi-linha.
  const InputFieldMultiline({
    Key? key,
    required this.label,
    required this.hintText,
    this.controller,
    this.error = false,
    this.onClearError,
    this.prefixText,
    this.maxLines = 5,
    this.textCapitalization = TextCapitalization.sentences,
    this.inputFormatters,
    this.onChanged,
    this.minHeight = 120.0,
  }) : super(key: key);

  @override
  State<InputFieldMultiline> createState() => _InputFieldMultilineState();
}

class _InputFieldMultilineState extends State<InputFieldMultiline> {
  late final FocusNode _focusNode;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    
    _focusNode = FocusNode()
      ..addListener(() {
        if (_focusNode.hasFocus) {
          // Limpa o erro quando o campo recebe foco
          if (widget.error && widget.onClearError != null) {
            widget.onClearError!();
          }
        } else {
          // Remove espaços em branco extras quando o campo perde o foco
          final trimmed = _controller.text.trimRight();
          if (trimmed != _controller.text) {
            _controller.text = trimmed;
            widget.onChanged?.call(trimmed);
          }
        }
      });
  }

  @override
  void dispose() {
    // Só descarta o controlador se foi criado internamente
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Configura os formatadores de texto
    final formatters = widget.inputFormatters ??
        [TextFormatter.capitalization(CapitalizationType.sentences)];

    // Define o padding para o campo multi-linha
    final contentPadding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 12,
    );

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: widget.minHeight),
      // Removido decoration do Container para evitar a borda dupla
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
        child: TextField(
          focusNode: _focusNode,
          controller: _controller,
          maxLines: widget.maxLines,
          minLines: 3,
          textCapitalization: widget.textCapitalization,
          autocorrect: widget.textCapitalization != TextCapitalization.none,
          enableSuggestions: widget.textCapitalization != TextCapitalization.none,
          inputFormatters: formatters,
          onChanged: widget.onChanged,
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
            error: widget.error,
            contentPadding: contentPadding,
          ),
        ),
      ),
    );
  }
}