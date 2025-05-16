import 'package:flutter/material.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';

/// Item de menu para uso com AppMenuButton
class MenuItemData {
  /// Título do item do menu
  final String title;
  
  /// Ícone opcional para o item
  final IconData? icon;
  
  /// Ação a ser executada quando o item for selecionado
  final VoidCallback onTap;
  
  /// Se o item deve ser destacado como perigoso (ex: excluir, sair)
  final bool isDangerous;
  
  /// Se o item está desabilitado
  final bool isDisabled;
  
  /// Construtor padrão
  const MenuItemData({
    required this.title,
    this.icon,
    required this.onTap,
    this.isDangerous = false,
    this.isDisabled = false,
  });
}

/// Botão de menu dropdown personalizado
///
/// Exibe um ícone que, quando clicado, abre um menu com opções
class AppMenuButton extends StatelessWidget {
  /// Ícone do botão
  final IconData icon;
  
  /// Título opcional para exibir ao lado do ícone
  final String? title;
  
  /// Itens do menu
  final List<MenuItemData> items;
  
  /// Tooltip para o botão
  final String? tooltip;
  
  /// Tamanho do ícone
  final double iconSize;
  
  /// Posição do menu (acima ou abaixo do botão)
  final bool positionedBelow;
  
  /// Construtor padrão
  const AppMenuButton({
    Key? key,
    required this.icon,
    this.title,
    required this.items,
    this.tooltip,
    this.iconSize = 24.0,
    this.positionedBelow = true,
  }) : super(key: key);
  
  /// Menu de opções
  factory AppMenuButton.options({
    List<MenuItemData> items = const [],
    String? tooltip,
    double iconSize = 24.0,
    bool positionedBelow = true,
  }) {
    return AppMenuButton(
      icon: Icons.more_vert,
      items: items,
      tooltip: tooltip ?? 'Opções',
      iconSize: iconSize,
      positionedBelow: positionedBelow,
    );
  }
  
  /// Menu de filtros
  factory AppMenuButton.filter({
    List<MenuItemData> items = const [],
    String? tooltip,
    double iconSize = 24.0,
    bool positionedBelow = true,
  }) {
    return AppMenuButton(
      icon: Icons.filter_list,
      title: 'Filtrar',
      items: items,
      tooltip: tooltip ?? 'Filtrar',
      iconSize: iconSize,
      positionedBelow: positionedBelow,
    );
  }
  
  /// Menu de ordenação
  factory AppMenuButton.sort({
    List<MenuItemData> items = const [],
    String? tooltip,
    double iconSize = 24.0,
    bool positionedBelow = true,
  }) {
    return AppMenuButton(
      icon: Icons.sort,
      title: 'Ordenar',
      items: items,
      tooltip: tooltip ?? 'Ordenar',
      iconSize: iconSize,
      positionedBelow: positionedBelow,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget button = title != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: iconSize,
                color: context.colors.primary,
              ),
              const SizedBox(width: 4),
              Text(
                title!,
                style: TextStyle(
                  color: context.colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        : Icon(
            icon,
            size: iconSize,
            color: context.colors.primary,
          );
    
    return PopupMenuButton<int>(
      icon: button,
      tooltip: tooltip,
      position: positionedBelow ? PopupMenuPosition.under : PopupMenuPosition.over,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
      ),
      itemBuilder: (context) {
        return List.generate(
          items.length,
          (index) => _buildMenuItem(context, index),
        );
      },
      onSelected: (index) {
        if (!items[index].isDisabled) {
          items[index].onTap();
        }
      },
    );
  }
  
  // Constrói um item de menu com o estilo apropriado
  PopupMenuItem<int> _buildMenuItem(BuildContext context, int index) {
    final item = items[index];
    
    final textColor = item.isDisabled
        ? context.colors.textSecondary.withOpacity(0.5)
        : item.isDangerous
            ? context.colors.error
            : context.colors.textPrimary;
    
    final iconColor = item.isDisabled
        ? context.colors.textSecondary.withOpacity(0.5)
        : item.isDangerous
            ? context.colors.error
            : context.colors.primary;
    
    return PopupMenuItem<int>(
      value: index,
      enabled: !item.isDisabled,
      height: 40.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.icon != null) ...[
            Icon(
              item.icon!,
              size: 20.0,
              color: iconColor,
            ),
            const SizedBox(width: 12.0),
          ],
          Flexible(
            child: Text(
              item.title,
              style: TextStyle(
                color: textColor,
                fontWeight: item.isDangerous ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}