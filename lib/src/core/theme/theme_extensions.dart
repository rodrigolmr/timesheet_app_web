import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../responsive/responsive.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_text_styles.dart';
import 'app_theme_data.dart';
import 'theme_controller.dart';
import 'theme_variant.dart';

/// Extensão que fornece acesso fácil ao tema atual através do BuildContext
extension ThemeExtension on BuildContext {
  /// Retorna o tema completo atual
  AppThemeData get theme {
    return ProviderScope.containerOf(this).read(themeControllerProvider);
  }
  
  /// Retorna as cores do tema atual
  AppColors get colors => theme.colors;
  
  /// Retorna os estilos de texto do tema atual
  AppTextStyles get textStyles => theme.textStyles;
  
  /// Retorna as dimensões do tema atual
  AppDimensions get dimensions => theme.dimensions;
  
  /// Retorna a variante atual do tema
  ThemeVariant get themeVariant => theme.variant;
  
  /// Retorna o brilho atual do tema (claro ou escuro)
  Brightness get themeBrightness => theme.brightness;
  
  /// Retorna verdadeiro se o tema atual for escuro
  bool get isDarkTheme => theme.brightness == Brightness.dark;
  
  /// Retorna a cor de uma categoria específica usando o enum CategoryType
  Color categoryColor(CategoryType type) => colors.categoryColors[type]!;
  
  /// Retorna a cor de uma categoria específica usando o nome da categoria como string
  /// Este método evita a necessidade de importar CategoryType diretamente nos componentes
  Color categoryColorByName(String? categoryName) {
    if (categoryName == null) return colors.primary;
    
    switch (categoryName) {
      case "timesheet": 
        return colors.categoryColors[CategoryType.timesheet] ?? colors.primary;
      case "receipt": 
        return colors.categoryColors[CategoryType.receipt] ?? colors.primary;
      case "settings": 
        return colors.categoryColors[CategoryType.settings] ?? colors.primary;
      case "add": 
        return colors.categoryColors[CategoryType.add] ?? colors.primary;
      case "cancel": 
        return colors.categoryColors[CategoryType.cancel] ?? colors.primary;
      case "navigation": 
        return colors.categoryColors[CategoryType.navigation] ?? colors.primary;
      case "user": 
        return colors.categoryColors[CategoryType.user] ?? colors.primary;
      case "worker": 
        return colors.categoryColors[CategoryType.worker] ?? colors.primary;
      case "card": 
        return colors.categoryColors[CategoryType.card] ?? colors.primary;
      case "pdf": 
        return colors.categoryColors[CategoryType.pdf] ?? colors.primary;
      default: 
        return colors.primary;
    }
  }
  
  /// Atalho para o espaçamento padrão/médio
  double get spacing => dimensions.spacingM;
  
  /// Atalho para o padding horizontal
  EdgeInsets get horizontalPadding => dimensions.horizontalPadding;
  
  /// Atalho para o padding vertical
  EdgeInsets get verticalPadding => dimensions.verticalPadding;
  
  /// Atalho para o padding completo (todos os lados)
  EdgeInsets get padding => dimensions.padding;
}

/// Extensão que integra o sistema de temas com o sistema responsivo
extension ResponsiveThemeExtension on BuildContext {
  /// Retorna uma cor que se adapta ao tamanho da tela
  Color responsiveColor({
    required Color xs,
    Color? sm,
    Color? md,
    Color? lg,
    Color? xl,
  }) {
    return responsive<Color>(
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
    );
  }
  
  /// Retorna um estilo de texto que se adapta ao tamanho da tela
  TextStyle responsiveTextStyle({
    required TextStyle xs,
    TextStyle? sm,
    TextStyle? md,
    TextStyle? lg,
    TextStyle? xl,
  }) {
    return responsive<TextStyle>(
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
    );
  }
}

/// Extensão para WidgetRef que permite controlar o tema
extension ThemeControllerExtension on WidgetRef {
  /// Altera o tema para a variante especificada
  void setTheme(ThemeVariant variant) {
    read(themeControllerProvider.notifier).setTheme(variant);
  }
  
  /// Alterna entre os temas claro e escuro
  void toggleLightDark() {
    read(themeControllerProvider.notifier).toggleLightDark();
  }
}