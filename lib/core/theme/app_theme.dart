// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Cores principais do app
  static const Color primaryBlue = Color(0xFF0205D3);
  static const Color primaryGreen = Color(0xFF17DB4E);
  static const Color primaryRed = Color(0xFFDE4545);
  static const Color primaryYellow = Color(0xFFFAB515);
  static const Color backgroundYellow = Color(0xFFFFFDD0);

  // Cores secundárias
  static const Color purpleColor = Color(0xFF6E44FF);
  static const Color orangeColor = Color(0xFFFF9800);
  static const Color darkGrayColor = Color(0xFF444444);
  static const Color lightGrayColor = Color(0xFFBDBDBD);
  static const Color indigoColor = Color(0xFF3F51B5);
  static const Color blueColor = Color(0xFF2196F3);
  static const Color tealColor = Color(0xFF009688);
  static const Color brownColor = Color(0xFF6B4423);
  static const Color pinkColor = Color(0xFFD81B60);
  static const Color lightBlueColor = Color(0xFF0277BD);
  static const Color purpleDeepColor = Color(0xFF9C27B0);

  // Cores adicionais (previamente hardcoded)
  static const Color noteColor = Color(0xFF4287F5);
  static const Color pdfRedColor = Color(0xFFFF0000);
  static const Color mediumGrayColor = Color(0xFF757575);
  static const Color lightGrayAltColor = Color(0xFF9E9E9E);

  // Cores para feedbacks e estados
  static const Color successColor = primaryGreen;
  static const Color errorColor = primaryRed;
  static const Color warningColor = primaryYellow;
  static const Color infoColor = primaryBlue;
  static const Color disabledColor = lightGrayColor;
  static const Color loadingColor = darkGrayColor;

  // Cores de texto
  static const Color textDarkColor = Color(0xFF212121);
  static const Color textGrayColor = Colors.grey;
  static const Color textLightColor = Colors.white;

  // Espaçamentos
  static const double defaultSpacing = 16.0;
  static const double smallSpacing = 8.0;
  static const double largeSpacing = 24.0;
  static const double extraLargeSpacing = 32.0;

  // Raios de borda
  static const double defaultRadius = 5.0;
  static const double largeRadius = 10.0;
  static const double extraLargeRadius = 20.0;

  // Alturas
  static const double headerHeight = 60.0;
  static const double titleBoxHeight = 70.0;
  static const double inputFieldHeight = 40.0;
  static const double buttonHeight = 50.0;
  static const double miniButtonHeight = 25.0;

  // Larguras
  static const double buttonWidth = 50.0;
  static const double miniButtonWidth = 45.0;
  static const double maxFormWidth = 500.0;
  static const double maxContainerWidth = 600.0;

  // Tamanhos de texto
  static const double headerTextSize = 32.0;
  static const double titleTextSize = 24.0;
  static const double bodyTextSize = 16.0;
  static const double smallTextSize = 14.0;
  static const double microTextSize = 12.0;
  static const double buttonTextSize = 12.0;

  // Espessuras de borda
  static const double thinBorder = 1.0;
  static const double mediumBorder = 2.0;
  static const double thickBorder = 5.0;

  // Sombras
  static List<BoxShadow> get defaultShadow => [
    const BoxShadow(
      color: Colors.black26,
      offset: Offset(0, 2),
      blurRadius: 4,
    ),
  ];

  static List<BoxShadow> get errorShadow => [
    BoxShadow(
      color: primaryRed.withOpacity(0.3),
      offset: const Offset(0, 2),
      blurRadius: 4,
    ),
  ];

  static List<BoxShadow> get successShadow => [
    BoxShadow(
      color: primaryGreen.withOpacity(0.3),
      offset: const Offset(0, 2),
      blurRadius: 4,
    ),
  ];

  // Durações de animação
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Curvas de animação
  static const Curve defaultAnimationCurve = Curves.easeInOut;
  static const Curve fastAnimationCurve = Curves.easeOutQuint;
  static const Curve bounceAnimationCurve = Curves.elasticOut;

  // Durações para notificações e feedbacks
  static const Duration shortFeedbackDuration = Duration(seconds: 2);
  static const Duration mediumFeedbackDuration = Duration(seconds: 3);
  static const Duration longFeedbackDuration = Duration(seconds: 4);

  // Estilos de texto
  static TextStyle get headingStyle => GoogleFonts.raleway(
    fontSize: headerTextSize,
    fontWeight: FontWeight.bold,
    color: primaryBlue,
  );

  static TextStyle get titleStyle => const TextStyle(
    fontSize: titleTextSize,
    fontWeight: FontWeight.bold,
    color: textDarkColor,
  );

  static TextStyle get labelStyle => const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: bodyTextSize,
    color: textGrayColor,
  );

  static TextStyle get floatingLabelStyle => const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: microTextSize,
    color: primaryBlue,
  );

  static TextStyle get hintStyle => const TextStyle(
    fontWeight: FontWeight.bold,
    color: textGrayColor,
  );

  static TextStyle get buttonTextStyle => const TextStyle(
    fontWeight: FontWeight.bold,
    color: textLightColor,
  );

  static TextStyle get microTextStyle => const TextStyle(
    fontSize: microTextSize,
    color: textGrayColor,
  );

  static TextStyle get logoTextStyle => GoogleFonts.poppins(
    fontSize: 42.0,
    fontWeight: FontWeight.w800,
    color: primaryBlue,
    letterSpacing: -1.5,
  );

  // Decorações
  static InputDecoration inputDecoration({
    required String label,
    required String hintText,
    String? prefixText,
    Widget? suffixIcon,
    bool error = false,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: labelStyle,
      floatingLabelStyle: floatingLabelStyle,
      hintText: hintText,
      hintStyle: hintStyle,
      prefixText: prefixText,
      filled: true,
      fillColor: backgroundYellow,
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: primaryBlue, width: thinBorder),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: primaryBlue, width: mediumBorder),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: primaryBlue, width: thinBorder),
      ),
      errorText: error ? ' ' : null,
      errorStyle: const TextStyle(fontSize: 0, height: 0),
      suffixIcon: suffixIcon,
      contentPadding:
          contentPadding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  static BoxDecoration inputContainerDecoration(bool error) {
    if (error) {
      return BoxDecoration(
        boxShadow: errorShadow,
      );
    }
    return const BoxDecoration();
  }

  static BoxDecoration titleBoxDecoration(Color backgroundColor) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.all(Radius.circular(largeRadius)),
    );
  }

  static BoxDecoration logoBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: primaryBlue, width: thickBorder),
      borderRadius: BorderRadius.circular(extraLargeRadius),
    );
  }

  // Temas para botões
  static ButtonStyle elevatedButtonStyle({
    required Color backgroundColor,
    required Color borderColor,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: textLightColor,
      side: BorderSide(color: borderColor, width: mediumBorder),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
      padding: EdgeInsets.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      minimumSize: const Size(0, 0),
    );
  }

  // Métodos helper para estilos de botões
  static ButtonStyle outlineButtonStyle({
    required Color borderColor,
    Color textColor = textLightColor,
    Color? overlayColor,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: textColor,
      side: BorderSide(color: borderColor, width: mediumBorder),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
      padding: EdgeInsets.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      minimumSize: const Size(0, 0),
      elevation: 0,
      shadowColor: Colors.transparent,
    );
  }

  static ButtonStyle textButtonStyle({
    required Color textColor,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: textColor,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
      padding: EdgeInsets.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      minimumSize: const Size(0, 0),
      elevation: 0,
      shadowColor: Colors.transparent,
    );
  }

  static ButtonStyle iconButtonStyle({
    required Color backgroundColor,
    required Color borderColor,
  }) {
    return elevatedButtonStyle(
      backgroundColor: backgroundColor,
      borderColor: borderColor,
    ).copyWith(
      padding: MaterialStateProperty.all(EdgeInsets.zero),
      minimumSize: MaterialStateProperty.all(const Size(buttonHeight, buttonHeight)),
      maximumSize: MaterialStateProperty.all(const Size(buttonHeight, buttonHeight)),
    );
  }

  // Decorações para feedback visual
  static BoxDecoration feedbackDecoration({
    required Color backgroundColor,
    double radius = defaultRadius,
    List<BoxShadow>? boxShadow,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: boxShadow ?? defaultShadow,
    );
  }

  // Decorações para estados de feedback
  static BoxDecoration successFeedbackDecoration() {
    return feedbackDecoration(
      backgroundColor: successColor,
      boxShadow: successShadow,
    );
  }

  static BoxDecoration errorFeedbackDecoration() {
    return feedbackDecoration(
      backgroundColor: errorColor,
      boxShadow: errorShadow,
    );
  }

  static BoxDecoration warningFeedbackDecoration() {
    return feedbackDecoration(
      backgroundColor: warningColor,
    );
  }

  static BoxDecoration infoFeedbackDecoration() {
    return feedbackDecoration(
      backgroundColor: infoColor,
    );
  }

  // Tema de contêiner adaptável
  static BoxDecoration containerDecoration({
    Color? backgroundColor,
    double radius = defaultRadius,
    List<BoxShadow>? boxShadow,
    Color? borderColor,
    double borderWidth = thinBorder,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: boxShadow,
      border: borderColor != null
          ? Border.all(color: borderColor, width: borderWidth)
          : null,
    );
  }

  // Tema global do app
  static ThemeData lightTheme() {
    return ThemeData(
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: primaryBlue,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: elevatedButtonStyle(
          backgroundColor: primaryBlue,
          borderColor: primaryBlue,
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        secondary: primaryGreen,
        error: primaryRed,
      ),
      textTheme: TextTheme(
        titleLarge: titleStyle,
        bodyLarge: labelStyle,
        bodyMedium: const TextStyle(fontSize: bodyTextSize),
        bodySmall: microTextStyle,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundYellow,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryBlue),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryBlue),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryBlue, width: mediumBorder),
        ),
        labelStyle: labelStyle,
        floatingLabelStyle: floatingLabelStyle,
        hintStyle: hintStyle,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(defaultRadius)),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: ZoomPageTransitionsBuilder(),
          TargetPlatform.linux: ZoomPageTransitionsBuilder(),
          TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
        },
      ),
    );
  }
}