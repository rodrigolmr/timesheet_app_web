import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'input_field_core.dart';

class DatePickerField extends StatefulWidget {
  final String label;
  final String hintText;
  final DateTime? initialDate;
  final ValueChanged<DateTime> onDateSelected;
  final bool error;
  final VoidCallback? onClearError;

  const DatePickerField({
    Key? key,
    required this.label,
    required this.hintText,
    this.initialDate,
    required this.onDateSelected,
    this.error = false,
    this.onClearError,
  }) : super(key: key);

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late DateTime? _selectedDate;
  late TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _controller = TextEditingController();
    _updateController();

    _focusNode = FocusNode()
      ..addListener(() {
        if (_focusNode.hasFocus && widget.error && widget.onClearError != null) {
          widget.onClearError!();
        }
      });
  }

  void _updateController() {
    if (_selectedDate != null) {
      _controller.text = DateFormat.yMd().format(_selectedDate!);
    } else {
      _controller.clear();
    }
  }

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? today,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _updateController();
      });
      widget.onClearError?.call();
      widget.onDateSelected(picked);
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 20;
    return Container(
      width: width < 0 ? 0 : width,
      height: 40,
      decoration: InputFieldCore.containerDecoration(widget.error),
      child: TextField(
        focusNode: _focusNode,
        controller: _controller,
        readOnly: true,
        onTap: _pickDate,
        decoration: InputFieldCore.decoration(
          label: widget.label,
          hintText: widget.hintText,
          suffixIcon: const Icon(Icons.calendar_today),
          error: widget.error,
        ),
      ),
    );
  }
}
