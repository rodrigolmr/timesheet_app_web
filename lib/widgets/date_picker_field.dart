// lib/widgets/date_picker_field.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timesheet_app_web/core/theme/app_theme.dart';
import 'input_field_core.dart';

/// Um campo de seleção de data que exibe um calendário quando clicado.
///
/// Este widget fornece uma interface amigável para seleção de datas,
/// integrado com o sistema de temas do aplicativo.
class DatePickerField extends StatefulWidget {
  /// Rótulo exibido acima do campo.
  final String label;
  
  /// Texto de dica exibido quando nenhuma data está selecionada.
  final String hintText;
  
  /// Data inicial a ser exibida no campo (opcional).
  final DateTime? initialDate;
  
  /// Função chamada quando uma data é selecionada.
  final ValueChanged<DateTime> onDateSelected;
  
  /// Indica se o campo contém um erro.
  final bool error;
  
  /// Função chamada para limpar o estado de erro.
  final VoidCallback? onClearError;
  
  /// Formato personalizado para exibição da data (opcional).
  final DateFormat? dateFormat;
  
  /// Data mínima permitida para seleção (opcional).
  final DateTime? firstDate;
  
  /// Data máxima permitida para seleção (opcional).
  final DateTime? lastDate;
  
  /// Construtor para o campo de seleção de data.
  const DatePickerField({
    Key? key,
    required this.label,
    required this.hintText,
    this.initialDate,
    required this.onDateSelected,
    this.error = false,
    this.onClearError,
    this.dateFormat,
    this.firstDate,
    this.lastDate,
  }) : super(key: key);

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late DateTime? _selectedDate;
  late TextEditingController _controller;
  late final FocusNode _focusNode;
  late final DateFormat _dateFormat;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _controller = TextEditingController();
    _dateFormat = widget.dateFormat ?? DateFormat.yMd();
    _updateController();

    _focusNode = FocusNode()
      ..addListener(() {
        if (_focusNode.hasFocus && widget.error && widget.onClearError != null) {
          widget.onClearError!();
        }
      });
  }

  @override
  void didUpdateWidget(DatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Atualiza o controlador se a data inicial mudar externamente
    if (oldWidget.initialDate != widget.initialDate) {
      _selectedDate = widget.initialDate;
      _updateController();
    }
    
    // Atualiza o formato se for alterado
    if (oldWidget.dateFormat != widget.dateFormat && widget.dateFormat != null) {
      _dateFormat = widget.dateFormat!;
      _updateController();
    }
  }

  void _updateController() {
    if (_selectedDate != null) {
      _controller.text = _dateFormat.format(_selectedDate!);
    } else {
      _controller.clear();
    }
  }

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final firstDate = widget.firstDate ?? DateTime(1900);
    final lastDate = widget.lastDate ?? DateTime(today.year + 10, 12, 31);
    
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? today,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        // Use o tema do aplicativo para o seletor de data
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.primaryBlue,
              onSurface: AppTheme.textDarkColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryBlue,
              ),
            ),
          ),
          child: child!,
        );
      },
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
    return Container(
      width: double.infinity,
      height: AppTheme.inputFieldHeight,
      decoration: InputFieldCore.containerDecoration(widget.error),
      child: TextField(
        focusNode: _focusNode,
        controller: _controller,
        readOnly: true,
        onTap: _pickDate,
        decoration: InputFieldCore.decoration(
          label: widget.label,
          hintText: widget.hintText,
          suffixIcon: Icon(
            Icons.calendar_today,
            color: widget.error ? AppTheme.primaryRed : AppTheme.primaryBlue,
            size: 20,
          ),
          error: widget.error,
        ),
        style: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: AppTheme.bodyTextSize,
        ),
      ),
    );
  }
}