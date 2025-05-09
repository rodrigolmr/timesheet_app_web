import 'package:flutter/material.dart';
import 'input_field_core.dart';

class InputFieldDropdown<T> extends StatefulWidget {
  final String label;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final bool error;
  final VoidCallback? onClearError;
  final String? prefixText;
  final Widget? suffixIcon;

  const InputFieldDropdown({
    Key? key,
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.error = false,
    this.onClearError,
    this.prefixText,
    this.suffixIcon,
  }) : super(key: key);

  @override
  State<InputFieldDropdown<T>> createState() => _InputFieldDropdownState<T>();
}

class _InputFieldDropdownState<T> extends State<InputFieldDropdown<T>> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode =
        FocusNode()..addListener(() {
          if (_focusNode.hasFocus &&
              widget.error &&
              widget.onClearError != null) {
            widget.onClearError!();
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
    final placeholder = 'Select ${widget.label.toLowerCase()}';
    return Container(
      decoration: InputFieldCore.containerDecoration(widget.error),
      child: DropdownButtonFormField<T>(
        focusNode: _focusNode,
        value: widget.value,
        items: widget.items,
        onChanged: widget.onChanged,
        hint: Text(
          placeholder,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.grey, // mesmo hintGray estilo do core
          ),
        ),
        decoration: InputFieldCore.decoration(
          label: widget.label,
          hintText: '', // deixamos vazio para não conflitar
          prefixText: widget.prefixText,
          suffixIcon: widget.suffixIcon,
          error: widget.error,
        ),
      ),
    );
  }
}
