import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';

/// Widget base para campos de entrada padronizados no aplicativo.
///
/// Esta classe fornece uma base comum para todos os tipos de campos de entrada
/// (texto, multiline, dropdown, etc) com estilos e comportamentos consistentes.
class AppInputFieldBase extends StatelessWidget {
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

  /// Tipo de teclado para este campo
  final TextInputType? keyboardType;

  /// Formatadores de entrada para validar/formatar o texto
  final List<TextInputFormatter>? inputFormatters;

  /// Texto prefixado antes do valor do campo
  final String? prefixText;

  /// Widget prefixado antes do valor do campo
  final Widget? prefixIcon;

  /// Widget sufixado após o valor do campo
  final Widget? suffixIcon;

  /// Indica se o campo está desabilitado
  final bool enabled;

  /// Largura máxima do campo (null = ocupar a largura disponível)
  final double? maxWidth;

  /// Altura fixa do campo (null = altura padrão)
  final double? height;

  /// Estilo do texto de entrada
  final TextStyle? textStyle;

  /// Capitalization do teclado
  final TextCapitalization textCapitalization;

  /// Alinhamento vertical do texto
  final TextAlignVertical? textAlignVertical;

  /// Se o campo permite múltiplas linhas
  final bool multiline;

  /// Número máximo de linhas (para campos multiline)
  final int? maxLines;

  /// Número mínimo de linhas (para campos multiline que crescem automaticamente)
  final int? minLines;

  /// Expande para preencher o espaço disponível (para campos multiline)
  final bool expands;

  /// Callback quando o valor do campo muda
  final ValueChanged<String>? onChanged;

  /// Callback quando o campo recebe um tap
  final VoidCallback? onTap;

  /// Se o campo é somente leitura
  final bool readOnly;

  /// Se o campo deve obscurecer o texto (para senhas)
  final bool obscureText;

  /// Padding interno do campo
  final EdgeInsetsGeometry? contentPadding;

  /// Callback quando o campo é submetido (Enter pressionado)
  final ValueChanged<String>? onSubmitted;

  /// Construtor padrão
  const AppInputFieldBase({
    Key? key,
    required this.label,
    required this.hintText,
    this.controller,
    this.hasError = false,
    this.errorText,
    this.focusNode,
    this.onClearError,
    this.keyboardType,
    this.inputFormatters,
    this.prefixText,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.maxWidth,
    this.height,
    this.textStyle,
    this.textCapitalization = TextCapitalization.none,
    this.textAlignVertical,
    this.multiline = false,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.obscureText = false,
    this.contentPadding,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define a largura com base no parâmetro maxWidth e na responsividade
    final effectiveMaxWidth = maxWidth ?? double.infinity;
    
    // Define a altura com base no multiline e no parâmetro height
    // Para ambos os casos, se não há altura específica, deixa null para o Flutter calcular
    final effectiveHeight = height;
    
    // Define o padding interno
    final effectiveContentPadding = contentPadding ?? EdgeInsets.symmetric(
      horizontal: context.dimensions.paddingMedium,
      vertical: context.dimensions.paddingSmall,
    );
    
    // Define o estilo do texto de entrada
    final effectiveTextStyle = textStyle ?? context.textStyles.bodyMedium.copyWith(
      color: context.colors.onSurface,
      height: multiline ? 1.4 : null,
    );
    
    // Padding fixo para reservar espaço para o glow
    const glowPadding = 4.0;
    
    return Padding(
      padding: const EdgeInsets.all(glowPadding),
      child: Container(
        width: effectiveMaxWidth,
        height: expands ? null : effectiveHeight,
        decoration: hasError
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
        child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        textCapitalization: textCapitalization,
        style: effectiveTextStyle,
        textAlignVertical: textAlignVertical ?? 
            (multiline ? TextAlignVertical.top : TextAlignVertical.center),
        enabled: enabled,
        maxLines: expands ? null : maxLines,
        minLines: minLines,
        expands: expands,
        onChanged: onChanged,
        readOnly: readOnly,
        obscureText: obscureText,
        onSubmitted: onSubmitted,
        onTap: () {
          // Sempre limpa o erro ao clicar se houver callback
          if (hasError && onClearError != null) {
            onClearError!();
          }
          // Depois executa o onTap personalizado se existir
          if (onTap != null) {
            onTap!();
          }
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: context.textStyles.labelMedium.copyWith(
            color: hasError 
                ? context.colors.error 
                : (focusNode?.hasFocus ?? false) 
                    ? context.colors.primary 
                    : context.colors.onSurfaceVariant,
          ),
          floatingLabelStyle: context.textStyles.labelSmall.copyWith(
            color: hasError ? context.colors.error : context.colors.primary,
          ),
          hintText: hintText,
          hintStyle: context.textStyles.bodyMedium.copyWith(
            color: context.colors.onSurfaceVariant.withOpacity(0.6),
          ),
          prefixText: prefixText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: !enabled 
              ? context.colors.surfaceVariant.withOpacity(0.5)
              : context.colors.surfaceAccent.withOpacity(0.85),  // Mantém sempre o amarelo do tema
          errorText: hasError && errorText != null ? errorText : null,
          errorStyle: context.textStyles.labelSmall.copyWith(color: context.colors.error),
          contentPadding: effectiveContentPadding,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: hasError ? context.colors.error : context.colors.secondary,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(context.dimensions.borderRadiusMedium),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: hasError ? context.colors.error : context.colors.primary,
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
      ),
      ),
    );
  }
}