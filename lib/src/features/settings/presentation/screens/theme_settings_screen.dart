import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/app_header.dart';

/// Tela para seleção e configuração de temas
class ThemeSettingsScreen extends ConsumerWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppHeader(
        title: 'Settings',
        showBackButton: true,
        showNavigationMenu: false,
      ),
      body: Center(
        child: Text(
          'Theme settings will be implemented here',
          style: context.textStyles.body.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
      ),
    );
  }
}