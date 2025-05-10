// lib/widgets/base_layout.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../providers.dart';
import 'title_box.dart';

enum LayoutType {
  standard,    // Com cabeçalho completo e título
  noHeader,    // Sem cabeçalho (tipo login)
  noTitleBox,  // Com cabeçalho mas sem título (tipo home)
  minimal      // Sem cabeçalho e sem título
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
  }) : super(key: key);

  // Construtores de fábrica para diferentes tipos de layout
  factory BaseLayout.standard({
    required Widget child,
    required String title,
    List<Widget>? actions,
    Widget? floatingActionButton,
    Color? titleBoxColor,
    VoidCallback? onBackPressed,
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
    );
  }

  factory BaseLayout.noHeader({
    required Widget child,
    required String title,
    Widget? floatingActionButton,
  }) {
    return BaseLayout(
      child: child,
      title: title,
      showHeader: false,
      showTitleBox: true,
      floatingActionButton: floatingActionButton,
    );
  }

  factory BaseLayout.noTitleBox({
    required Widget child,
    required String title,
    List<Widget>? actions,
    Widget? floatingActionButton,
    VoidCallback? onBackPressed,
  }) {
    return BaseLayout(
      child: child,
      title: title,
      showHeader: true,
      showTitleBox: false,
      actions: actions,
      floatingActionButton: floatingActionButton,
      onBackPressed: onBackPressed,
    );
  }

  factory BaseLayout.minimal({
    required Widget child,
    required String title,
    Widget? floatingActionButton,
  }) {
    return BaseLayout(
      child: child,
      title: title,
      showHeader: false,
      showTitleBox: false,
      floatingActionButton: floatingActionButton,
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
        );
      case LayoutType.noHeader:
        return BaseLayout.noHeader(
          child: child,
          title: title,
          floatingActionButton: floatingActionButton,
        );
      case LayoutType.noTitleBox:
        return BaseLayout.noTitleBox(
          child: child,
          title: title,
          actions: actions,
          floatingActionButton: floatingActionButton,
          onBackPressed: onBackPressed,
        );
      case LayoutType.minimal:
        return BaseLayout.minimal(
          child: child,
          title: title,
          floatingActionButton: floatingActionButton,
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logoutCallback = ref.watch(logoutCallbackProvider);

    return Scaffold(
      floatingActionButton: floatingActionButton,
      body: Column(
        children: [
          if (showHeader)
            SafeArea(
              bottom: false,
              child: Container(
                height: AppTheme.headerHeight,
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.defaultSpacing),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: AppTheme.defaultShadow,
                ),
                child: Row(
                  children: [
                    // Botão de voltar ou menu
                    if (onBackPressed != null)
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: AppTheme.primaryBlue,
                        onPressed: onBackPressed,
                      )
                    else if (automaticallyImplyLeading && Navigator.of(context).canPop())
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: AppTheme.primaryBlue,
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    else
                      _buildMenuButton(context, logoutCallback),

                    const SizedBox(width: 16),

                    // Logo da empresa
                    Expanded(
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Central Island Floors",
                            style: AppTheme.headingStyle,
                          ),
                        ),
                      ),
                    ),

                    // Espaço para ações adicionais
                    if (actions != null) ...actions!,
                    if (actions == null) const SizedBox(width: 48),
                  ],
                ),
              ),
            ),

          // Adiciona espaço apenas se ambos cabeçalho e título forem mostrados
          if (showHeader && showTitleBox) const SizedBox(height: AppTheme.defaultSpacing),

          // TitleBox
          if (showTitleBox)
            TitleBox(
              title: title,
              backgroundColor: titleBoxColor,
            ),
            
          // Adiciona espaço apenas se o título for mostrado
          if (showTitleBox) const SizedBox(height: AppTheme.defaultSpacing),

          // Conteúdo principal
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, LogoutCallback logoutCallback) {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.menu,
        color: Color(0xFF0205D3),
        size: 32,
      ),
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
      itemBuilder: (_) => const [
        PopupMenuItem(value: 'Home', child: Text('Home')),
        PopupMenuItem(value: 'Settings', child: Text('Settings')),
        PopupMenuItem(
          value: 'Debug',
          child: Row(
            children: [
              Icon(Icons.bug_report, size: 18),
              SizedBox(width: 8),
              Text('Debug'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'Test',
          child: Row(
            children: [
              Icon(Icons.science, size: 18),
              SizedBox(width: 8),
              Text('Test Page'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'Layout Test',
          child: Row(
            children: [
              Icon(Icons.dashboard_customize, size: 18),
              SizedBox(width: 8),
              Text('Layout Test'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'Button Showcase',
          child: Row(
            children: [
              Icon(Icons.touch_app, size: 18),
              SizedBox(width: 8),
              Text('Button Showcase'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'Feedback Showcase',
          child: Row(
            children: [
              Icon(Icons.notifications, size: 18),
              SizedBox(width: 8),
              Text('Feedback Showcase'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'Logout',
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.red, size: 18),
              SizedBox(width: 8),
              Text('Logout', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }
}