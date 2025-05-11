// lib/widgets/base_layout.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/responsive/responsive.dart';
import '../core/theme/app_theme.dart';
import '../providers.dart';
import 'title_box.dart';

enum LayoutType {
  standard,    // Com cabeçalho completo e título
  noHeader,    // Sem cabeçalho (tipo login)
  noTitleBox,  // Com cabeçalho mas sem título (tipo home)
  minimal      // Sem cabeçalho e sem título
}

enum LayoutAlignment {
  top,     // Alinhamento no topo para páginas normais
  center,  // Alinhamento centralizado para páginas como login e home
}

class BaseLayout extends ConsumerWidget {
  final Widget child;
  final String title;
  final bool showHeader;
  final bool showTitleBox;
  final List<Widget>? actions; // Ações adicionais na barra superior
  final Widget? floatingActionButton;
  final Color? titleBoxColor;
  final VoidCallback? onBackPressed;
  final bool automaticallyImplyLeading;
  final LayoutAlignment verticalAlignment;

  const BaseLayout({
    Key? key,
    required this.child,
    required this.title,
    this.showHeader = true,
    this.showTitleBox = true,
    this.actions,
    this.floatingActionButton,
    this.titleBoxColor,
    this.onBackPressed,
    this.automaticallyImplyLeading = true,
    this.verticalAlignment = LayoutAlignment.top, // Por padrão, layout alinhado ao topo
  }) : super(key: key);

  // Construtores de fábrica para diferentes tipos de layout
  factory BaseLayout.standard({
    required Widget child,
    required String title,
    List<Widget>? actions,
    Widget? floatingActionButton,
    Color? titleBoxColor,
    VoidCallback? onBackPressed,
    LayoutAlignment verticalAlignment = LayoutAlignment.top,
  }) {
    return BaseLayout(
      child: child,
      title: title,
      showHeader: true,
      showTitleBox: true,
      actions: actions,
      floatingActionButton: floatingActionButton,
      titleBoxColor: titleBoxColor,
      onBackPressed: onBackPressed,
      verticalAlignment: verticalAlignment,
    );
  }

  factory BaseLayout.noHeader({
    required Widget child,
    required String title,
    Widget? floatingActionButton,
    LayoutAlignment verticalAlignment = LayoutAlignment.top,
  }) {
    return BaseLayout(
      child: child,
      title: title,
      showHeader: false,
      showTitleBox: true,
      floatingActionButton: floatingActionButton,
      verticalAlignment: verticalAlignment,
    );
  }

  factory BaseLayout.noTitleBox({
    required Widget child,
    required String title,
    List<Widget>? actions,
    Widget? floatingActionButton,
    VoidCallback? onBackPressed,
    LayoutAlignment verticalAlignment = LayoutAlignment.top, // Alinhamento pelo topo por padrão
  }) {
    return BaseLayout(
      child: child,
      title: title,
      showHeader: true,
      showTitleBox: false,
      actions: actions,
      floatingActionButton: floatingActionButton,
      onBackPressed: onBackPressed,
      verticalAlignment: verticalAlignment,
    );
  }

  factory BaseLayout.minimal({
    required Widget child,
    required String title,
    Widget? floatingActionButton,
    LayoutAlignment verticalAlignment = LayoutAlignment.center, // Login page é centralizada por padrão
  }) {
    return BaseLayout(
      child: child,
      title: title,
      showHeader: false,
      showTitleBox: false,
      floatingActionButton: floatingActionButton,
      verticalAlignment: verticalAlignment,
    );
  }

  // Método para construir o tipo de layout a partir de um enum
  factory BaseLayout.fromType({
    required LayoutType type,
    required Widget child,
    required String title,
    List<Widget>? actions,
    Widget? floatingActionButton,
    Color? titleBoxColor,
    VoidCallback? onBackPressed,
    LayoutAlignment? verticalAlignment,
  }) {
    switch (type) {
      case LayoutType.standard:
        return BaseLayout.standard(
          child: child,
          title: title,
          actions: actions,
          floatingActionButton: floatingActionButton,
          titleBoxColor: titleBoxColor,
          onBackPressed: onBackPressed,
          verticalAlignment: verticalAlignment ?? LayoutAlignment.top,
        );
      case LayoutType.noHeader:
        return BaseLayout.noHeader(
          child: child,
          title: title,
          floatingActionButton: floatingActionButton,
          verticalAlignment: verticalAlignment ?? LayoutAlignment.top,
        );
      case LayoutType.noTitleBox:
        return BaseLayout.noTitleBox(
          child: child,
          title: title,
          actions: actions,
          floatingActionButton: floatingActionButton,
          onBackPressed: onBackPressed,
          verticalAlignment: verticalAlignment ?? LayoutAlignment.center,
        );
      case LayoutType.minimal:
        return BaseLayout.minimal(
          child: child,
          title: title,
          floatingActionButton: floatingActionButton,
          verticalAlignment: verticalAlignment ?? LayoutAlignment.center,
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logoutCallback = ref.watch(logoutCallbackProvider);
    final responsive = ResponsiveSizing(context);

    // Valores responsivos para os elementos do layout
    final headerHeight = responsive.responsiveValue(
      mobile: AppTheme.headerHeight * 0.9,
      tablet: AppTheme.headerHeight,
      desktop: AppTheme.headerHeight * 1.1,
    );

    final horizontalPadding = responsive.responsiveValue(
      mobile: AppTheme.defaultSpacing * 0.75,
      tablet: AppTheme.defaultSpacing,
      desktop: AppTheme.defaultSpacing * 1.5,
    );

    final spacing = responsive.responsiveValue(
      mobile: AppTheme.defaultSpacing * 0.75,
      tablet: AppTheme.defaultSpacing,
      desktop: AppTheme.defaultSpacing * 1.25,
    );

    final menuIconSize = responsive.responsiveValue(
      mobile: 24.0,
      tablet: 28.0,
      desktop: 32.0,
    );

    final headerTitleStyle = responsive.responsiveValue(
      mobile: AppTheme.headingStyle.copyWith(fontSize: 22),
      tablet: AppTheme.headingStyle,
      desktop: AppTheme.headingStyle.copyWith(fontSize: 36),
    );

    // Criar o conteúdo principal com o cabeçalho, título e conteúdo
    Widget mainContent = Column(
      children: [
        if (showHeader)
          SafeArea(
            bottom: false,
            child: Container(
              height: headerHeight,
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: AppTheme.defaultShadow,
              ),
              child: Row(
                children: [
                  // Botão de voltar ou menu
                  if (onBackPressed != null)
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: menuIconSize,
                      ),
                      color: AppTheme.primaryBlue,
                      onPressed: onBackPressed,
                      tooltip: 'Back',
                    )
                  else if (automaticallyImplyLeading && Navigator.of(context).canPop())
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: menuIconSize,
                      ),
                      color: AppTheme.primaryBlue,
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'Back',
                    )
                  else
                    _buildMenuButton(context, logoutCallback, menuIconSize),

                  SizedBox(width: spacing),

                  // Logo da empresa
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Central Island Floors",
                          style: headerTitleStyle,
                        ),
                      ),
                    ),
                  ),

                  // Espaço para ações adicionais
                  if (actions != null) ...actions!,
                  if (actions == null) SizedBox(width: responsive.isMobile ? 32 : 48),
                ],
              ),
            ),
          ),

        // Adiciona espaço adequado entre o cabeçalho e o título
        if (showHeader && showTitleBox)
          SizedBox(height: responsive.responsiveValue(
            mobile: AppTheme.defaultSpacing, // 16px para telas pequenas (320px)
            tablet: AppTheme.mediumSpacing, // 20px para tablets
            desktop: AppTheme.largeSpacing, // 24px para desktop
          )),

        // TitleBox
        if (showTitleBox)
          TitleBox(
            title: title,
            backgroundColor: titleBoxColor,
          ),

        // Não é mais necessário SizedBox após o title box, o padding no conteúdo cuidará disso

        // O resto do conteúdo, que será diferente dependendo do alinhamento
        // Usando Padding para adicionar espaço consistente após o titleBox
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              top: showTitleBox ? responsive.responsiveValue(
                mobile: AppTheme.defaultSpacing, // 16px para telas pequenas (320px)
                tablet: AppTheme.mediumSpacing, // 20px para tablets
                desktop: AppTheme.largeSpacing, // 24px para desktop
              ) : 0,
            ),
            child: verticalAlignment == LayoutAlignment.top
              // Para alinhamento superior, usar Align com alinhamento para o topo
              ? Align(
                  alignment: Alignment.topCenter,
                  child: child,
                )
              // Para alinhamento centralizado, usar Center para centralizar verticalmente
              : Center(
                  child: child,
                ),
          ),
        ),
      ],
    );

    // Layout final com o conteúdo
    final layoutContent = mainContent;

    // Para layouts complexos que precisam de variações significativas entre dispositivos,
    // podemos envolver o conteúdo em um ResponsiveLayout para versões muito diferentes
    return Scaffold(
      floatingActionButton: floatingActionButton,
      body: layoutContent,
    );
  }

  Widget _buildMenuButton(BuildContext context, LogoutCallback logoutCallback, double iconSize) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.menu,
        color: Color(0xFF0205D3),
        size: iconSize,
      ),
      tooltip: 'Menu',
      onSelected: (v) async {
        if (v == 'Home') {
          context.go('/');
        } else if (v == 'Settings') {
          context.go('/settings');
        } else if (v == 'Debug') {
          context.go('/debug');
        } else if (v == 'Test') {
          context.go('/test');
        } else if (v == 'Layout Test') {
          context.go('/layout-test');
        } else if (v == 'Button Showcase') {
          context.go('/button-showcase');
        } else if (v == 'Feedback Showcase') {
          context.go('/feedback-showcase');
        } else if (v == 'Logout') {
          await logoutCallback();
          if (context.mounted) {
            context.go('/login');
          }
        }
      },
      itemBuilder: (context) {
        // Use responsive text sizes for menu items
        final responsive = ResponsiveSizing(context);
        final menuIconSize = responsive.responsiveValue(
          mobile: 16.0,
          tablet: 18.0,
          desktop: 20.0,
        );

        final textStyle = TextStyle(
          fontSize: responsive.responsiveValue(
            mobile: 14.0,
            tablet: 16.0,
            desktop: 18.0,
          ),
        );

        return [
          PopupMenuItem(
            value: 'Home',
            child: Text('Home', style: textStyle),
          ),
          PopupMenuItem(
            value: 'Settings',
            child: Text('Settings', style: textStyle),
          ),
          PopupMenuItem(
            value: 'Debug',
            child: Row(
              children: [
                Icon(Icons.bug_report, size: menuIconSize),
                SizedBox(width: 8),
                Text('Debug', style: textStyle),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'Test',
            child: Row(
              children: [
                Icon(Icons.science, size: menuIconSize),
                SizedBox(width: 8),
                Text('Test Page', style: textStyle),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'Layout Test',
            child: Row(
              children: [
                Icon(Icons.dashboard_customize, size: menuIconSize),
                SizedBox(width: 8),
                Text('Layout Test', style: textStyle),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'Button Showcase',
            child: Row(
              children: [
                Icon(Icons.touch_app, size: menuIconSize),
                SizedBox(width: 8),
                Text('Button Showcase', style: textStyle),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'Feedback Showcase',
            child: Row(
              children: [
                Icon(Icons.notifications, size: menuIconSize),
                SizedBox(width: 8),
                Text('Feedback Showcase', style: textStyle),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'Logout',
            child: Row(
              children: [
                Icon(Icons.logout, color: Colors.red, size: menuIconSize),
                SizedBox(width: 8),
                Text('Logout', style: textStyle.copyWith(color: Colors.red)),
              ],
            ),
          ),
        ];
      },
    );
  }
}