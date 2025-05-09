import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'input_field_core.dart';
import 'capitalization_formater_sentence.dart';

class InputFieldMultiline extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final bool error;
  final VoidCallback? onClearError;
  final String? prefixText;
  final int maxLines;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged; // ✅ ADICIONADO

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
    this.onChanged, // ✅ ADICIONADO
  }) : super(key: key);

  @override
  State<InputFieldMultiline> createState() => _InputFieldMultilineState();
}

class _InputFieldMultilineState extends State<InputFieldMultiline> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode =
        FocusNode()..addListener(() {
          if (_focusNode.hasFocus) {
            if (widget.error && widget.onClearError != null) {
              widget.onClearError!();
            }
          } else if (widget.controller != null) {
            final c = widget.controller!;
            final trimmed = c.text.trimRight();
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
    final width = MediaQuery.of(context).size.width - 20;
    final formatters =
        widget.inputFormatters != null
            ? widget.inputFormatters!
            : <TextInputFormatter>[const CapitalizationFormaterSentence()];
    return Container(
      width: width < 0 ? 0 : width,
      decoration: InputFieldCore.containerDecoration(widget.error),
      child: TextField(
        focusNode: _focusNode,
        controller: widget.controller,
        maxLines: widget.maxLines,
        textCapitalization: widget.textCapitalization,
        autocorrect: widget.textCapitalization != TextCapitalization.none,
        enableSuggestions: widget.textCapitalization != TextCapitalization.none,
        inputFormatters: formatters,
        onChanged: widget.onChanged, // ✅ ADICIONADO
        onTap: () {
          if (widget.error && widget.onClearError != null) {
            widget.onClearError!();
          }
        },
        decoration: InputFieldCore.decoration(
          label: widget.label,
          hintText: widget.hintText,
          prefixText: widget.prefixText,
          error: widget.error,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
