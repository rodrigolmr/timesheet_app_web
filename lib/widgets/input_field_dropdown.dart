// lib/widgets/input_field_dropdown.dart

import 'package:flutter/material.dart';
import 'package:timesheet_app_web/core/theme/app_theme.dart';
import 'input_field_core.dart';

/// Um campo de seleção dropdown com suporte para tipos genéricos.
///
/// Este widget permite criar campos de seleção dropdown com estilo consistente
/// e suporte para diferentes tipos de dados.
class InputFieldDropdown<T> extends StatefulWidget {
  /// Rótulo exibido acima do campo.
  final String label;
  
  /// Lista de itens do dropdown.
  final List<DropdownMenuItem<T>> items;
  
  /// Valor selecionado atualmente.
  final T? value;
  
  /// Função chamada quando o valor selecionado muda.
  final ValueChanged<T?>? onChanged;
  
  /// Indica se o campo contém um erro.
  final bool error;
  
  /// Função chamada para limpar o estado de erro.
  final VoidCallback? onClearError;
  
  /// Texto a ser exibido como prefixo no campo.
  final String? prefixText;
  
  /// Ícone exibido à direita do campo.
  final Widget? suffixIcon;
  
  /// Texto exibido quando nenhum item está selecionado (opcional).
  final String? placeholderText;
  
  /// Construtor para o campo dropdown.
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
    this.placeholderText,
  }) : super(key: key);

  @override
  State<InputFieldDropdown<T>> createState() => _InputFieldDropdownState<T>();
}

class _InputFieldDropdownState<T> extends State<InputFieldDropdown<T>> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()
      ..addListener(() {
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
    // Texto do placeholder com base no rótulo, se não for fornecido
    final placeholder = widget.placeholderText ?? 
                        'Select ${widget.label.toLowerCase()}';
    
    // Item de placeholder
    Widget? hint = Text(
      placeholder,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: AppTheme.bodyTextSize,
        color: AppTheme.textGrayColor,
      ),
    );
    
    return Container(
      width: double.infinity,
      height: AppTheme.inputFieldHeight,
      decoration: InputFieldCore.containerDecoration(widget.error),
      child: DropdownButtonFormField<T>(
        focusNode: _focusNode,
        value: widget.value,
        items: widget.items,
        onChanged: widget.onChanged,
        icon: widget.suffixIcon ?? const Icon(
          Icons.arrow_drop_down,
          color: AppTheme.primaryBlue,
        ),
        iconSize: 24,
        hint: hint,
        isExpanded: true,
        dropdownColor: Colors.white,
        menuMaxHeight: 300,
        style: const TextStyle(
          fontSize: AppTheme.bodyTextSize,
          fontWeight: FontWeight.normal,
          color: AppTheme.textDarkColor,
        ),
        decoration: InputFieldCore.decoration(
          label: widget.label,
          hintText: '', // Vazio para evitar conflito com o hint
          prefixText: widget.prefixText,
          error: widget.error,
        ),
      ),
    );
  }
}