import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/navigation/routes.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/auth_providers.dart';

/// Cabeçalho padrão utilizado em todas as telas do aplicativo
class AppHeader extends ConsumerWidget implements PreferredSizeWidget {
  /// Título principal exibido no cabeçalho
  final String title;
  
  /// Ícone para o botão de ação principal (à direita)
  final IconData? actionIcon;
  
  /// Callback para o botão de ação principal
  final VoidCallback? onActionPressed;
  
  /// Tooltip para o botão de ação principal
  final String? actionTooltip;
  
  /// Lista de widgets de ações adicionais
  final List<Widget>? actions;
  
  /// Controla se deve exibir o botão de voltar
  final bool showBackButton;
  
  /// Callback para o botão de voltar (se null, usa Navigator.pop)
  final VoidCallback? onBackPressed;
  
  /// Cor de fundo do cabeçalho (se null, usa a cor primária do tema)
  final Color? backgroundColor;
  
  /// Cor do texto e ícones (se null, usa a cor onPrimary do tema)
  final Color? foregroundColor;
  
  /// Valor de elevação do cabeçalho
  final double elevation;
  
  /// Indica se o cabeçalho possui abas
  final bool hasTabBar;
  
  /// Mostra o menu de navegação (Home, Logout)
  final bool showNavigationMenu;
  
  /// Cria um cabeçalho padrão para o aplicativo
  const AppHeader({
    Key? key,
    required this.title,
    this.actionIcon,
    this.onActionPressed,
    this.actionTooltip,
    this.actions,
    this.showBackButton = false,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 2,
    this.hasTabBar = false,
    this.showNavigationMenu = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Acesso ao tema através das extensões de contexto
    final colors = context.colors;
    final textStyles = context.textStyles;
    final dimensions = context.dimensions;
    
    // Define as cores baseadas nas prioridades: props > tema
    final bgColor = backgroundColor ?? colors.primary;
    final fgColor = foregroundColor ?? colors.onPrimary;
    
    // Lista de ações
    final actionsList = <Widget>[];
    
    // Adiciona o botão de ação principal se fornecido
    if (actionIcon != null) {
      actionsList.add(
        IconButton(
          icon: Icon(actionIcon),
          onPressed: onActionPressed,
          tooltip: actionTooltip,
        ),
      );
    }
    
    // Adiciona ações extras se fornecidas
    if (actions != null) {
      actionsList.addAll(actions!);
    }

    return AppBar(
      title: Text(
        title,
        style: context.responsiveTitle.copyWith(
          color: fgColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      elevation: elevation,
      centerTitle: true,
      automaticallyImplyLeading: showBackButton,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () => context.pop(),
              tooltip: 'Back',
            )
          : (showNavigationMenu
              ? PopupMenuButton<String>(
                  icon: Icon(Icons.menu, color: fgColor),
                  tooltip: 'Menu',
                  onSelected: (value) {
                    switch (value) {
                      case 'home':
                        context.go(AppRoute.home.path);
                        break;
                      case 'logout':
                        _confirmLogout(context, ref);
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'home',
                      child: Row(
                        children: [
                          Icon(Icons.home, size: 20, color: colors.primary),
                          SizedBox(width: dimensions.spacingS),
                          Text('Home', style: textStyles.body),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout, size: 20, color: colors.error),
                          SizedBox(width: dimensions.spacingS),
                          Text('Logout', style: textStyles.body.copyWith(color: colors.error)),
                        ],
                      ),
                    ),
                  ],
                )
              : null),
      actions: actionsList,
    );
  }
  
  // Função para confirmar logout
  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: context.colors.surface,
          title: Text(
            'Logout',
            style: context.textStyles.title.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: context.textStyles.body.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: context.colors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(authStateProvider.notifier).signOut();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.categoryColorByName("cancel"),
                foregroundColor: Colors.white,
              ),
              child: const Text('Yes, Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(hasTabBar ? 100.0 : 56.0);
  
  /// Cria um cabeçalho com um TabBar
  factory AppHeader.withTabs({
    required String title,
    required TabBar tabBar,
    IconData? actionIcon,
    VoidCallback? onActionPressed,
    String? actionTooltip,
    List<Widget>? actions,
    bool showBackButton = false,
    VoidCallback? onBackPressed,
    Color? backgroundColor,
    Color? foregroundColor,
    double elevation = 2,
    bool showNavigationMenu = false,
  }) {
    return _AppHeaderWithTabs(
      title: title,
      tabBar: tabBar,
      actionIcon: actionIcon,
      onActionPressed: onActionPressed,
      actionTooltip: actionTooltip,
      actions: actions,
      showBackButton: showBackButton,
      onBackPressed: onBackPressed,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      showNavigationMenu: showNavigationMenu,
    );
  }
}

/// Implementação especializada de AppHeader que inclui um TabBar
class _AppHeaderWithTabs extends AppHeader {
  @override
  final bool showNavigationMenu;
  
  /// TabBar a ser exibido na parte inferior do cabeçalho
  final TabBar tabBar;

  const _AppHeaderWithTabs({
    required super.title,
    required this.tabBar,
    super.actionIcon,
    super.onActionPressed,
    super.actionTooltip,
    super.actions,
    super.showBackButton = false,
    super.onBackPressed,
    super.backgroundColor,
    super.foregroundColor,
    super.elevation = 2,
    required this.showNavigationMenu,
    super.key,
  }) : super(hasTabBar: true, showNavigationMenu: showNavigationMenu);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Acesso ao tema através das extensões de contexto
    final colors = context.colors;
    final textStyles = context.textStyles;
    final dimensions = context.dimensions;
    
    // Define as cores baseadas nas prioridades: props > tema
    final bgColor = backgroundColor ?? colors.primary;
    final fgColor = foregroundColor ?? colors.onPrimary;
    
    // Lista de ações
    final actionsList = <Widget>[];
    
    // Adiciona o botão de ação principal se fornecido
    if (actionIcon != null) {
      actionsList.add(
        IconButton(
          icon: Icon(actionIcon),
          onPressed: onActionPressed,
          tooltip: actionTooltip,
        ),
      );
    }
    
    // Adiciona ações extras se fornecidas
    if (actions != null) {
      actionsList.addAll(actions!);
    }

    return AppBar(
      title: Text(
        title,
        style: context.responsiveTitle.copyWith(
          color: fgColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      elevation: elevation,
      centerTitle: true,
      automaticallyImplyLeading: showBackButton,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () => context.pop(),
              tooltip: 'Back',
            )
          : (showNavigationMenu
              ? PopupMenuButton<String>(
                  icon: Icon(Icons.menu, color: fgColor),
                  tooltip: 'Menu',
                  onSelected: (value) {
                    switch (value) {
                      case 'home':
                        context.go(AppRoute.home.path);
                        break;
                      case 'logout':
                        _confirmLogout(context, ref);
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'home',
                      child: Row(
                        children: [
                          Icon(Icons.home, size: 20, color: colors.primary),
                          SizedBox(width: dimensions.spacingS),
                          Text('Home', style: textStyles.body),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout, size: 20, color: colors.error),
                          SizedBox(width: dimensions.spacingS),
                          Text('Logout', style: textStyles.body.copyWith(color: colors.error)),
                        ],
                      ),
                    ),
                  ],
                )
              : null),
      actions: actionsList,
      bottom: tabBar,
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(kToolbarHeight + tabBar.preferredSize.height);
  }
}