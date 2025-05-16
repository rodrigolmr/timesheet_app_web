import 'package:flutter/material.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';

/// Componente de chip interativo para ações e filtros
class AppActionChip extends StatelessWidget {
  /// Rótulo do chip
  final String label;
  
  /// Ícone opcional a ser exibido no chip
  final IconData? icon;
  
  /// Função a ser executada quando o chip for pressionado
  final VoidCallback? onPressed;
  
  /// Função a ser executada quando o chip for fechado
  final VoidCallback? onDeleted;
  
  /// Se o chip está selecionado (apenas visual)
  final bool isSelected;
  
  /// Se o chip está desabilitado
  final bool isDisabled;
  
  /// Cor personalizada do chip
  final Color? color;
  
  /// Categoria do chip para usar cor específica
  final String? categoryName;
  
  /// Construtor padrão
  const AppActionChip({
    Key? key,
    required this.label,
    this.icon,
    this.onPressed,
    this.onDeleted,
    this.isSelected = false,
    this.isDisabled = false,
    this.color,
    this.categoryName,
  }) : super(key: key);
  
  /// Chip de filtro para seleção de opções
  factory AppActionChip.filter({
    required String label,
    IconData? icon,
    VoidCallback? onPressed,
    bool isSelected = false,
    bool isDisabled = false,
  }) {
    return AppActionChip(
      label: label,
      icon: icon,
      onPressed: onPressed,
      isSelected: isSelected,
      isDisabled: isDisabled,
    );
  }
  
  /// Chip para demonstrar status (com cor específica)
  factory AppActionChip.status({
    required String label,
    IconData? icon,
    required String categoryName,
    VoidCallback? onPressed,
    bool isDisabled = false,
  }) {
    return AppActionChip(
      label: label,
      icon: icon,
      onPressed: onPressed,
      isSelected: true,
      isDisabled: isDisabled,
      categoryName: categoryName,
    );
  }
  
  /// Chip para opção removível (com ícone de fechar)
  factory AppActionChip.removable({
    required String label,
    IconData? icon,
    required VoidCallback onDeleted,
    VoidCallback? onPressed,
    bool isSelected = false,
    bool isDisabled = false,
    Color? color,
    String? categoryName,
  }) {
    return AppActionChip(
      label: label,
      icon: icon,
      onPressed: onPressed,
      onDeleted: onDeleted,
      isSelected: isSelected,
      isDisabled: isDisabled,
      color: color,
      categoryName: categoryName,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // Determina as cores do chip com base no estado e parâmetros
    final chipColor = _getChipColor(context);
    final textColor = _getTextColor(context, chipColor);
    final labelStyle = TextStyle(
      color: textColor,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    
    // Ícone a ser exibido no chip (se fornecido)
    Widget? avatarWidget;
    if (icon != null) {
      avatarWidget = CircleAvatar(
        backgroundColor: isSelected ? textColor : chipColor,
        radius: 12,
        child: Icon(
          icon!,
          size: 14,
          color: isSelected ? chipColor : textColor,
        ),
      );
    }
    
    // Função que lida com o clique no chip
    final effectiveOnPressed = (isDisabled || (onPressed == null && onDeleted == null))
        ? null
        : onPressed;
        
    // Função que lida com o clique no ícone de exclusão
    final effectiveOnDeleted = isDisabled ? null : onDeleted;
    
    // Constrói o tipo de chip apropriado
    if (effectiveOnPressed != null) {
      return ActionChip(
        label: Text(label, style: labelStyle),
        avatar: avatarWidget,
        onPressed: effectiveOnPressed,
        backgroundColor: chipColor,
        side: isSelected ? null : BorderSide(color: textColor.withOpacity(0.5)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      );
    } else {
      return Chip(
        label: Text(label, style: labelStyle),
        avatar: avatarWidget,
        deleteIcon: onDeleted != null ? Icon(Icons.close, size: 16) : null,
        onDeleted: effectiveOnDeleted,
        backgroundColor: chipColor,
        side: isSelected ? null : BorderSide(color: textColor.withOpacity(0.5)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      );
    }
  }
  
  // Determina a cor de fundo do chip
  Color _getChipColor(BuildContext context) {
    if (isDisabled) {
      return context.colors.textSecondary.withOpacity(0.2);
    }
    
    // Se estiver selecionado, usa a cor determinada
    if (isSelected) {
      if (color != null) return color!;
      
      if (categoryName != null) {
        // Usa o método de extensão que não requer importação de CategoryType
        return context.categoryColorByName(categoryName);
      }
      
      return context.colors.primary;
    }
    
    // Se não estiver selecionado, usa cor de fundo
    return context.colors.surfaceAccent;
  }
  
  // Determina a cor do texto do chip
  Color _getTextColor(BuildContext context, Color chipColor) {
    if (isDisabled) {
      return context.colors.textSecondary.withOpacity(0.5);
    }
    
    // Se estiver selecionado, texto branco sobre o fundo colorido
    if (isSelected) {
      return Colors.white;
    }
    
    // Se não estiver selecionado, usa cor do texto primário
    if (color != null || categoryName != null) {
      return chipColor;
    }
    
    return context.colors.textPrimary;
  }
}