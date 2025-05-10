// lib/core/responsive/responsive_breakpoints.dart

class ResponsiveBreakpoints {
  // Breakpoints baseados em dispositivos comuns
  static const double mobileSmall = 320; // iPhone SE
  static const double mobileMedium = 375; // iPhone X/11/12
  static const double mobileLarge = 428; // iPhone Pro Max
  static const double tablet = 768; // iPad Mini/Air
  static const double tabletLarge = 1024; // iPad Pro
  static const double desktopSmall = 1280; // Laptop
  static const double desktopLarge = 1440; // Desktop
  
  // Intervalos para facilitar a lógica condicional
  static bool isMobileSmall(double width) => width < mobileMedium;
  static bool isMobileMedium(double width) => width >= mobileMedium && width < mobileLarge;
  static bool isMobileLarge(double width) => width >= mobileLarge && width < tablet;
  static bool isTablet(double width) => width >= tablet && width < tabletLarge;
  static bool isTabletLarge(double width) => width >= tabletLarge && width < desktopSmall;
  static bool isDesktopSmall(double width) => width >= desktopSmall && width < desktopLarge;
  static bool isDesktopLarge(double width) => width >= desktopLarge;
  
  // Agrupamentos para simplicidade
  static bool isMobile(double width) => width < tablet;
  static bool isTabletOrSmaller(double width) => width < desktopSmall;
  static bool isDesktop(double width) => width >= desktopSmall;
}