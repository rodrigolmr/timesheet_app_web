import 'package:flutter/material.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/input/app_input_field_base.dart';

/// Dropdown field padronizado para seleção de itens em uma lista
class AppDropdownField<T> extends StatelessWidget {
  /// Texto do rótulo do campo
  final String label;

  /// Texto de sugestão exibido quando nenhum item está selecionado
  final String hintText;

  /// Lista de itens disponíveis para seleção
  final List<T> items;

  /// Função para converter o item em texto para exibição
  final String Function(T)? itemLabelBuilder;

  /// Valor atualmente selecionado
  final T? value;

  /// Callback ao selecionar um novo valor
  final ValueChanged<T?>? onChanged;

  /// Indica se o campo está com erro
  final bool hasError;

  /// Mensagem de erro a ser exibida (quando hasError = true)
  final String? errorText;

  /// Nó de foco para este campo
  final FocusNode? focusNode;

  /// Callback quando o erro deve ser limpo
  final VoidCallback? onClearError;

  /// Texto prefixado antes do valor do campo
  final String? prefixText;

  /// Widget prefixado antes do valor do campo
  final Widget? prefixIcon;

  /// Indica se o campo está desabilitado
  final bool enabled;

  /// Largura máxima do campo (null = ocupar a largura disponível)
  final double? maxWidth;

  /// Altura fixa do campo (null = altura padrão)
  final double? height;

  /// Builder personalizado para os itens do dropdown
  final DropdownMenuItem<T> Function(T)? itemBuilder;

  /// Construtor padrão
  const AppDropdownField({
    Key? key,
    required this.label,
    required this.hintText,
    required this.items,
    this.itemLabelBuilder,
    this.value,
    this.onChanged,
    this.hasError = false,
    this.errorText,
    this.focusNode,
    this.onClearError,
    this.prefixText,
    this.prefixIcon,
    this.enabled = true,
    this.maxWidth,
    this.height,
    this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determinamos a altura efetiva para o dropdown - um pouco menor que o input padrão
    final effectiveHeight = height ?? 52.0;
    
    // Construímos um padding específico para compensar o espaço do ícone de dropdown
    final dropdownPadding = EdgeInsets.symmetric(
      horizontal: context.dimensions.paddingMedium,
      vertical: 0, // Ajustamos o vertical para centralizar melhor o conteúdo
    );

    // Criamos o container que terá a mesma aparência de um AppInputFieldBase
    return Container(
      width: maxWidth ?? double.infinity,
      height: effectiveHeight,
      decoration: hasError
          ? BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: context.colors.error.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            )
          : null,
      child: DropdownButtonFormField<T>(
        focusNode: focusNode,
        value: value,
        isExpanded: true,
        alignment: AlignmentDirectional.center,
        icon: Icon(
          Icons.arrow_drop_down,
          color: hasError 
              ? context.colors.error 
              : context.colors.onSurfaceVariant,
        ),
        
        // Estilo do item selecionado no dropdown
        style: context.textStyles.input.copyWith(
          color: context.colors.textPrimary,
        ),
        dropdownColor: context.colors.surfaceAccent,
        
        // Widget exibido quando nenhum valor está selecionado
        hint: Text(
          hintText,
          style: context.textStyles.inputHint.copyWith(
            color: context.colors.onSurfaceVariant.withOpacity(0.6),
          ),
          textAlign: TextAlign.center,
        ),
        
        // O que acontece quando o valor muda
        onChanged: enabled 
            ? (newValue) {
                if (hasError && onClearError != null) {
                  onClearError!();
                }
                if (onChanged != null) {
                  onChanged!(newValue);
                }
              }
            : null,
        
        // Transforma cada item da lista em um DropdownMenuItem
        items: items.map((item) {
          if (itemBuilder != null) {
            return itemBuilder!(item);
          }
          
          return DropdownMenuItem<T>(
            value: item,
            alignment: Alignment.center,
            child: Text(
              itemLabelBuilder != null 
                  ? itemLabelBuilder!(item) 
                  : item.toString(),
              style: context.textStyles.input.copyWith(
                color: context.colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }).toList(),
        
        // Aplicamos uma decoração consistente com outros campos
        decoration: InputDecoration(
          labelText: label,
          labelStyle: context.textStyles.inputLabel.copyWith(
            color: hasError 
                ? context.colors.error 
                : (focusNode?.hasFocus ?? false) 
                    ? context.colors.primary 
                    : context.colors.onSurfaceVariant,
          ),
          floatingLabelStyle: context.textStyles.inputFloatingLabel.copyWith(
            color: hasError ? context.colors.error : context.colors.primary,
          ),
          prefixText: prefixText,
          prefixIcon: prefixIcon,
          filled: true,
          fillColor: !enabled 
              ? context.colors.surfaceVariant.withOpacity(0.5)
              : context.colors.surfaceAccent.withOpacity(0.85),
          errorText: hasError && errorText != null ? errorText : null,
          errorStyle: context.textStyles.inputFloatingLabel.copyWith(color: context.colors.error),
          contentPadding: dropdownPadding,
          floatingLabelAlignment: FloatingLabelAlignment.center,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: hasError ? context.colors.error : context.colors.outline,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: hasError ? context.colors.error : context.colors.primary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: context.colors.outline.withOpacity(0.5),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: context.colors.error,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: context.colors.error,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
          ),
        ),
      ),
    );
  }

  /// Cria um dropdown para seleção de status genérico
  static AppDropdownField<String> status({
    Key? key,
    required String label,
    String hintText = "Select status",
    required List<String> statusOptions,
    String? value,
    ValueChanged<String?>? onChanged,
    bool hasError = false,
    String? errorText,
    FocusNode? focusNode,
    VoidCallback? onClearError,
    bool enabled = true,
    double? maxWidth,
  }) {
    return AppDropdownField<String>(
      key: key,
      label: label,
      hintText: hintText,
      items: statusOptions,
      value: value,
      onChanged: onChanged,
      hasError: hasError,
      errorText: errorText,
      focusNode: focusNode,
      onClearError: onClearError,
      enabled: enabled,
      maxWidth: maxWidth,
    );
  }
}