import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_dimensions.dart';
import 'theme_variant.dart';

/// Classe principal que encapsula todos os elementos do tema.
///
/// Esta classe reúne cores, estilos de texto e dimensões em um único objeto
/// que pode ser facilmente acessado em toda a aplicação.
class AppThemeData {
  /// Cores do tema
  final AppColors colors;
  
  /// Estilos de texto
  final AppTextStyles textStyles;
  
  /// Dimensões e espaçamentos
  final AppDimensions dimensions;
  
  /// Brilho do tema (claro ou escuro)
  final Brightness brightness;
  
  /// Variante atual do tema
  final ThemeVariant variant;

  /// Construtor principal da classe AppThemeData
  const AppThemeData({
    required this.colors,
    required this.textStyles,
    required this.dimensions,
    required this.brightness,
    required this.variant,
  });

  /// Cria o tema light padrão
  factory AppThemeData.light() {
    return AppThemeData(
      colors: AppColors.light(),
      textStyles: AppTextStyles.light(),
      dimensions: AppDimensions.standard(),
      brightness: Brightness.light,
      variant: ThemeVariant.light,
    );
  }

  /// Cria o tema dark
  factory AppThemeData.dark() {
    return AppThemeData(
      colors: AppColors.dark(),
      textStyles: AppTextStyles.dark(),
      dimensions: AppDimensions.standard(),
      brightness: Brightness.dark,
      variant: ThemeVariant.dark,
    );
  }

  /// Cria o tema feminino
  factory AppThemeData.feminine() {
    return AppThemeData(
      colors: AppColors.feminine(),
      textStyles: AppTextStyles.feminine(),
      dimensions: AppDimensions.standard(),
      brightness: Brightness.light,
      variant: ThemeVariant.feminine,
    );
  }

  /// Cria o tema verde
  factory AppThemeData.green() {
    return AppThemeData(
      colors: AppColors.green(),
      textStyles: AppTextStyles.green(),
      dimensions: AppDimensions.standard(),
      brightness: Brightness.light,
      variant: ThemeVariant.green,
    );
  }

  /// Cria o tema de acordo com a variante especificada
  factory AppThemeData.fromVariant(ThemeVariant variant) {
    switch (variant) {
      case ThemeVariant.light:
        return AppThemeData.light();
      case ThemeVariant.dark:
        return AppThemeData.dark();
      case ThemeVariant.feminine:
        return AppThemeData.feminine();
      case ThemeVariant.green:
        return AppThemeData.green();
    }
  }

  /// Converte este tema para um ThemeData do Flutter para uso no MaterialApp
  ThemeData toThemeData() {
    return ThemeData(
      brightness: brightness,
      primaryColor: colors.primary,
      scaffoldBackgroundColor: colors.background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        secondary: colors.secondary,
        onSecondary: colors.onSecondary,
        error: colors.error,
        onError: colors.onError,
        background: colors.background,
        onBackground: colors.textPrimary,
        surface: colors.surface,
        onSurface: colors.textPrimary,
      ),
      textTheme: TextTheme(
        displayLarge: textStyles.headline,
        headlineLarge: textStyles.title,
        titleLarge: textStyles.subtitle,
        bodyLarge: textStyles.body,
        bodyMedium: textStyles.body,
        labelLarge: textStyles.button,
        bodySmall: textStyles.caption,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceAccent,
        labelStyle: textStyles.inputLabel,
        hintStyle: textStyles.inputHint,
        floatingLabelStyle: textStyles.inputFloatingLabel,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: colors.primary),
          borderRadius: BorderRadius.circular(dimensions.borderRadiusS),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.primary),
          borderRadius: BorderRadius.circular(dimensions.borderRadiusS),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colors.primary,
            width: dimensions.inputActiveBorderWidth,
          ),
          borderRadius: BorderRadius.circular(dimensions.borderRadiusS),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.error),
          borderRadius: BorderRadius.circular(dimensions.borderRadiusS),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colors.error,
            width: dimensions.inputActiveBorderWidth,
          ),
          borderRadius: BorderRadius.circular(dimensions.borderRadiusS),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: dimensions.spacingM,
          vertical: dimensions.spacingS,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(colors.primary),
          foregroundColor: MaterialStateProperty.all(colors.onPrimary),
          textStyle: MaterialStateProperty.all(textStyles.button),
          padding: MaterialStateProperty.all(EdgeInsets.all(dimensions.spacingM)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(dimensions.borderRadiusS),
            ),
          ),
        ),
      ),
    );
  }

  /// Cria uma cópia deste tema com os valores especificados alterados
  AppThemeData copyWith({
    AppColors? colors,
    AppTextStyles? textStyles,
    AppDimensions? dimensions,
    Brightness? brightness,
    ThemeVariant? variant,
  }) {
    return AppThemeData(
      colors: colors ?? this.colors,
      textStyles: textStyles ?? this.textStyles,
      dimensions: dimensions ?? this.dimensions,
      brightness: brightness ?? this.brightness,
      variant: variant ?? this.variant,
    );
  }
}