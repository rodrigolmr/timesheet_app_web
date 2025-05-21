import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/input/app_input_field_base.dart';

/// Campo de texto com seletor de intervalo de datas
class AppDateRangePickerField extends StatefulWidget {
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

  /// Callback quando um intervalo de datas é selecionado
  final ValueChanged<DateTimeRange?>? onDateRangeSelected;

  /// Formato de data para exibição no campo
  final intl.DateFormat? dateFormat;
  
  /// Intervalo inicial para o calendário
  final DateTimeRange? initialDateRange;
  
  /// Data mínima selecionável (padrão: 1 ano atrás)
  final DateTime? firstDate;
  
  /// Data máxima selecionável (padrão: 1 ano à frente)
  final DateTime? lastDate;

  /// Indica se o campo está desabilitado
  final bool enabled;

  /// Largura máxima do campo (null = ocupar a largura disponível)
  final double? maxWidth;

  /// Construtor padrão
  const AppDateRangePickerField({
    Key? key,
    required this.label,
    required this.hintText,
    this.controller,
    this.hasError = false,
    this.errorText,
    this.focusNode,
    this.onClearError,
    this.onDateRangeSelected,
    this.dateFormat,
    this.initialDateRange,
    this.firstDate,
    this.lastDate,
    this.enabled = true,
    this.maxWidth,
  }) : super(key: key);

  @override
  State<AppDateRangePickerField> createState() => _AppDateRangePickerFieldState();
}

class _AppDateRangePickerFieldState extends State<AppDateRangePickerField> {
  late TextEditingController _controller;
  late intl.DateFormat _dateFormat;
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _dateFormat = widget.dateFormat ?? intl.DateFormat('MM/dd/yyyy');
    
    // Inicializamos com o intervalo inicial, se fornecido
    if (widget.initialDateRange != null) {
      _selectedDateRange = widget.initialDateRange;
      _updateControllerText();
    }
  }

  @override
  void dispose() {
    // Só descartamos o controller se não foi fornecido externamente
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _updateControllerText() {
    if (_selectedDateRange != null) {
      final start = _dateFormat.format(_selectedDateRange!.start);
      final end = _dateFormat.format(_selectedDateRange!.end);
      _controller.text = '$start - $end';
    } else {
      _controller.text = '';
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    if (!widget.enabled) return;
    
    // Definições padrão para o seletor de intervalo de datas
    final DateTime now = DateTime.now();
    final DateTimeRange initialDateRange = widget.initialDateRange ?? 
        _selectedDateRange ?? 
        DateTimeRange(
          start: now.subtract(const Duration(days: 7)), 
          end: now,
        );
    
    final DateTime firstDate = widget.firstDate ?? DateTime(now.year - 1, now.month, now.day);
    final DateTime lastDate = widget.lastDate ?? DateTime(now.year + 1, now.month, now.day);
    
    // Solicitamos foco primeiro para garantir que o campo parece ativo
    widget.focusNode?.requestFocus();
    
    // Removemos o erro automaticamente ao interagir com o campo
    if (widget.hasError && widget.onClearError != null) {
      widget.onClearError!();
    }
    
    // Mostramos o seletor de intervalo de datas
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: initialDateRange,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        // Adaptamos o seletor ao tema do aplicativo
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.colors.primary,
              onPrimary: context.colors.onPrimary,
              surface: context.colors.surface,
              onSurface: context.colors.textPrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: context.colors.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    
    // Se um intervalo foi selecionado, atualizamos o campo e notificamos o callback
    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
        _updateControllerText();
      });
      
      if (widget.onDateRangeSelected != null) {
        widget.onDateRangeSelected!(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppInputFieldBase(
      label: widget.label,
      hintText: widget.hintText,
      controller: _controller,
      hasError: widget.hasError,
      errorText: widget.errorText,
      focusNode: widget.focusNode,
      onClearError: widget.onClearError,
      enabled: widget.enabled,
      maxWidth: widget.maxWidth,
      onTap: () => _selectDateRange(context),
      readOnly: true, // Sempre somente leitura pois o texto é gerenciado pelo seletor
      suffixIcon: Icon(
        Icons.date_range,
        color: widget.hasError 
            ? context.colors.error 
            : context.colors.primary,
        size: 20,
      ),
    );
  }
}