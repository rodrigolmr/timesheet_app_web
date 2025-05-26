import 'package:flutter/material.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';

/// Dropdown field padronizado para seleção de itens em uma lista
class AppDropdownField<T> extends StatefulWidget {
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
  State<AppDropdownField<T>> createState() => _AppDropdownFieldState<T>();
}

class _AppDropdownFieldState<T> extends State<AppDropdownField<T>> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Padding fixo para reservar espaço para o glow (igual ao AppInputFieldBase)
    const glowPadding = 4.0;
    
    // Define o padding interno (igual ao AppInputFieldBase)
    final effectiveContentPadding = EdgeInsets.symmetric(
      horizontal: context.dimensions.paddingMedium,
      vertical: context.dimensions.paddingSmall,
    );
    
    return Padding(
      padding: const EdgeInsets.all(glowPadding),
      child: Container(
        width: widget.maxWidth ?? double.infinity,
        height: widget.height,
        decoration: widget.hasError
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                boxShadow: [
                  BoxShadow(
                    color: context.colors.error.withOpacity(0.5),
                    blurRadius: 6,
                    spreadRadius: 0,
                    offset: const Offset(0, 0),
                  ),
                ],
              )
            : null,
        child: DropdownButtonFormField<T>(
          value: widget.value,
          focusNode: _focusNode,
          items: widget.items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: widget.itemBuilder != null
                  ? widget.itemBuilder!(item).child!
                  : Text(
                      widget.itemLabelBuilder != null
                          ? widget.itemLabelBuilder!(item)
                          : item.toString(),
                      style: context.textStyles.bodyMedium.copyWith(
                        color: context.colors.onSurface,
                      ),
                    ),
            );
          }).toList(),
          onChanged: widget.enabled 
              ? (newValue) {
                  if (widget.hasError && widget.onClearError != null) {
                    widget.onClearError!();
                  }
                  if (widget.onChanged != null) {
                    widget.onChanged!(newValue);
                  }
                }
              : null,
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: context.textStyles.labelMedium.copyWith(
              color: widget.hasError 
                  ? context.colors.error 
                  : _isFocused
                      ? context.colors.primary 
                      : context.colors.onSurfaceVariant,
            ),
            floatingLabelStyle: context.textStyles.labelSmall.copyWith(
              color: widget.hasError ? context.colors.error : context.colors.primary,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            prefixText: widget.prefixText,
            prefixIcon: widget.prefixIcon,
            filled: true,
            fillColor: !widget.enabled 
                ? context.colors.surfaceVariant.withOpacity(0.5)
                : context.colors.surfaceAccent.withOpacity(0.85), // Mantém sempre o amarelo do tema
            errorText: widget.hasError && widget.errorText != null ? widget.errorText : null,
            errorStyle: context.textStyles.labelSmall.copyWith(color: context.colors.error),
            contentPadding: effectiveContentPadding,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.hasError ? context.colors.error : context.colors.secondary,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(context.dimensions.borderRadiusMedium),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.hasError ? context.colors.error : context.colors.primary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(context.dimensions.borderRadiusMedium),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: context.colors.secondary.withOpacity(0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(context.dimensions.borderRadiusMedium),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: context.colors.error,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(context.dimensions.borderRadiusMedium),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: context.colors.error,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(context.dimensions.borderRadiusMedium),
            ),
          ),
          icon: Icon(
            Icons.arrow_drop_down,
            color: widget.enabled
                ? context.colors.onSurfaceVariant
                : context.colors.onSurfaceVariant.withOpacity(0.3),
          ),
          style: context.textStyles.bodyMedium.copyWith(
            color: context.colors.onSurface,
            height: null,
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