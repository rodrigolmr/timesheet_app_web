import 'package:flutter/material.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/input/app_text_field.dart';

/// A reusable address input field
class AppAddressField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool hasError;
  final String? errorText;
  final FocusNode? focusNode;
  final VoidCallback? onClearError;
  final bool isRequired;
  final String? Function(String?)? validator;

  const AppAddressField({
    super.key,
    required this.label,
    this.hintText = 'Enter address',
    this.controller,
    this.initialValue,
    this.onChanged,
    this.enabled = true,
    this.hasError = false,
    this.errorText,
    this.focusNode,
    this.onClearError,
    this.isRequired = false,
    this.validator,
  });

  @override
  State<AppAddressField> createState() => _AppAddressFieldState();
}

class _AppAddressFieldState extends State<AppAddressField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: _controller,
      focusNode: _focusNode,
      label: widget.label,
      hintText: widget.hintText,
      hasError: widget.hasError,
      errorText: widget.errorText,
      enabled: widget.enabled,
      onClearError: widget.onClearError,
      onChanged: widget.onChanged,
      prefixIcon: Icon(
        Icons.location_on_outlined,
        size: 20,
        color: context.colors.textSecondary,
      ),
    );
  }
}