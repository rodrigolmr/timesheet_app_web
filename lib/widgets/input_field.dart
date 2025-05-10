// lib/widgets/input_field.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_theme.dart';
import 'input_field_core.dart';
import 'capitalization_formater_word.dart';

class InputField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final bool error;
  final VoidCallback? onClearError;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? prefixText;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  const InputField({
    Key? key,
    required this.label,
    required this.hintText,
    this.controller,
    this.error = false,
    this.onClearError,
    this.keyboardType,
    this.inputFormatters,
    this.prefixText,
    this.obscureText = false,
    this.suffixIcon,
    this.textCapitalization = TextCapitalization.words,
    this.onChanged,
    this.textInputAction,
    this.onSubmitted,
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
    final width = MediaQuery.of(context).size.width - 20;
    final formatters = widget.inputFormatters != null
        ? widget.inputFormatters!
        : <TextInputFormatter>[const CapitalizationFormaterWord()];
    
    return Container(
      width: width < 0 ? 0 : width,
      height: AppTheme.inputFieldHeight,
      decoration: InputFieldCore.containerDecoration(widget.error),
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
        decoration: InputFieldCore.decoration(
          label: widget.label,
          hintText: widget.hintText,
          prefixText: widget.prefixText,
          suffixIcon: widget.suffixIcon,
          error: widget.error,
        ),
      ),
    );
  }
}