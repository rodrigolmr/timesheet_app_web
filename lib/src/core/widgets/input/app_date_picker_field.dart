import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/input/app_input_field_base.dart';

/// Campo de texto com seletor de data
class AppDatePickerField extends StatefulWidget {
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

  /// Callback quando uma data é selecionada
  final ValueChanged<DateTime?>? onDateSelected;

  /// Formato de data para exibição no campo
  final intl.DateFormat? dateFormat;
  
  /// Data inicial para o calendário (padrão: data atual)
  final DateTime? initialDate;
  
  /// Data mínima selecionável (padrão: 5 anos atrás)
  final DateTime? firstDate;
  
  /// Data máxima selecionável (padrão: 5 anos à frente)
  final DateTime? lastDate;

  /// Indica se o campo está desabilitado
  final bool enabled;

  /// Largura máxima do campo (null = ocupar a largura disponível)
  final double? maxWidth;

  /// Construtor padrão
  const AppDatePickerField({
    Key? key,
    required this.label,
    required this.hintText,
    this.controller,
    this.hasError = false,
    this.errorText,
    this.focusNode,
    this.onClearError,
    this.onDateSelected,
    this.dateFormat,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.enabled = true,
    this.maxWidth,
  }) : super(key: key);

  @override
  State<AppDatePickerField> createState() => _AppDatePickerFieldState();
}

class _AppDatePickerFieldState extends State<AppDatePickerField> {
  late TextEditingController _controller;
  late intl.DateFormat _dateFormat;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _dateFormat = widget.dateFormat ?? intl.DateFormat('MM/dd/yyyy');
    
    // Se houver texto inicial e estiver no formato correto, não fazemos nada
    // Se não houver texto inicial ou não estiver no formato correto, verificamos initialDate
    if (_controller.text.isEmpty) {
      final initialDate = widget.initialDate;
      if (initialDate != null) {
        _controller.text = _dateFormat.format(initialDate);
      }
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

  Future<void> _selectDate(BuildContext context) async {
    if (!widget.enabled) return;
    
    // Definições padrão para o seletor de data
    final DateTime now = DateTime.now();
    final DateTime initialDate = widget.initialDate ?? now;
    final DateTime firstDate = widget.firstDate ?? DateTime(now.year - 5, now.month, now.day);
    final DateTime lastDate = widget.lastDate ?? DateTime(now.year + 5, now.month, now.day);
    
    // Solicitamos foco primeiro para garantir que o campo parece ativo
    widget.focusNode?.requestFocus();
    
    // Removemos o erro automaticamente ao interagir com o campo
    if (widget.hasError && widget.onClearError != null) {
      widget.onClearError!();
    }
    
    // Mostramos o seletor de data
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
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
    
    // Se uma data foi selecionada, atualizamos o campo e notificamos o callback
    if (picked != null) {
      final formattedDate = _dateFormat.format(picked);
      setState(() {
        _controller.text = formattedDate;
      });
      if (widget.onDateSelected != null) {
        widget.onDateSelected!(picked);
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
      onTap: () => _selectDate(context),
      readOnly: true, // Sempre somente leitura pois o texto é gerenciado pelo seletor
      suffixIcon: Icon(
        Icons.calendar_today_outlined,
        color: widget.hasError 
            ? context.colors.error 
            : context.colors.primary,
        size: 20,
      ),
    );
  }
}