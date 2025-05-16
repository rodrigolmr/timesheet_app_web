import 'package:flutter/material.dart';

export 'responsive_container.dart';

/// Breakpoints for different screen sizes
class Breakpoints {
  /// Small mobile (320px-399px)
  static const double xs = 320;
  
  /// Regular mobile (400px-599px)
  static const double sm = 400;
  
  /// Small tablet (600px-839px)
  static const double md = 600;
  
  /// Large tablet/Small desktop (840px-1199px)  
  static const double lg = 840;
  
  /// Desktop (1200px+)
  static const double xl = 1200;
}

/// Extension on BuildContext to provide responsive values
extension ResponsiveContext on BuildContext {
  /// Returns the screen width
  double get screenWidth => MediaQuery.of(this).size.width;
  
  /// Returns the screen height
  double get screenHeight => MediaQuery.of(this).size.height;
  
  /// Returns the device pixel ratio
  double get pixelRatio => MediaQuery.of(this).devicePixelRatio;
  
  /// Returns if the current screen is extra small (below 400px)
  bool get isExtraSmall => screenWidth < Breakpoints.sm;
  
  /// Returns if the current screen is mobile (below 600px)
  bool get isMobile => screenWidth < Breakpoints.md;
  
  /// Returns if the current screen is tablet (between 600px and 1200px)
  bool get isTablet => 
    screenWidth >= Breakpoints.md && screenWidth < Breakpoints.xl;
  
  /// Returns if the current screen is desktop (1200px or more)
  bool get isDesktop => screenWidth >= Breakpoints.xl;
  
  /// Returns the appropriate value based on screen size
  /// 
  /// Usage:
  /// ```dart
  /// final fontSize = context.responsive<double>(
  ///   xs: 14,  // Extra small screens (<400px)
  ///   sm: 16,  // Small screens (400px-599px)
  ///   md: 18,  // Medium screens (600px-839px)
  ///   lg: 20,  // Large screens (840px-1199px)
  ///   xl: 22,  // Extra large screens (≥1200px)
  /// );
  /// ```
  /// 
  /// Parameters:
  /// - xs: Value for extra small screens (required)
  /// - sm: Value for small screens (optional, falls back to xs)
  /// - md: Value for medium screens (optional, falls back to sm or xs)
  /// - lg: Value for large screens (optional, falls back to md, sm, or xs)
  /// - xl: Value for extra large screens (optional, falls back to lg, md, sm, or xs)
  T responsive<T>({
    required T xs,
    T? sm,
    T? md,
    T? lg,
    T? xl,
  }) {
    if (screenWidth >= Breakpoints.xl) return xl ?? lg ?? md ?? sm ?? xs;
    if (screenWidth >= Breakpoints.lg) return lg ?? md ?? sm ?? xs;
    if (screenWidth >= Breakpoints.md) return md ?? sm ?? xs;
    if (screenWidth >= Breakpoints.sm) return sm ?? xs;
    return xs;
  }
  
  /// Returns the default spacing for current screen size
  double get spacing => responsive<double>(
    xs: 8,
    sm: 12,
    md: 16, 
    lg: 24,
    xl: 32,
  );
  
  /// Returns the default padding for current screen size
  EdgeInsets get padding => EdgeInsets.all(spacing);
  
  /// Returns horizontal padding based on screen size
  EdgeInsets get horizontalPadding => EdgeInsets.symmetric(
    horizontal: responsive<double>(
      xs: 12,
      sm: 16,
      md: 24,
      lg: 32,
      xl: 48,
    ),
  );
  
  /// Returns font sizes for different text styles
  double get fontSizeCaption => responsive<double>(xs: 10, sm: 11, md: 12, lg: 13, xl: 14);
  double get fontSizeBody => responsive<double>(xs: 14, sm: 15, md: 16, lg: 17, xl: 18);
  double get fontSizeSubtitle => responsive<double>(xs: 16, sm: 17, md: 18, lg: 20, xl: 22);
  double get fontSizeTitle => responsive<double>(xs: 18, sm: 20, md: 24, lg: 28, xl: 32);
  double get fontSizeHeadline => responsive<double>(xs: 22, sm: 26, md: 30, lg: 36, xl: 42);
  
  /// Returns button sizes
  double get buttonSizeSmall => responsive<double>(xs: 32, sm: 36, md: 40, lg: 44, xl: 48);
  double get buttonSizeMedium => responsive<double>(xs: 40, sm: 48, md: 56, lg: 64, xl: 72);
  double get buttonSizeLarge => responsive<double>(xs: 48, sm: 56, md: 64, lg: 72, xl: 80);
  
  /// Returns icon sizes
  double get iconSizeSmall => responsive<double>(xs: 16, sm: 18, md: 20, lg: 22, xl: 24);
  double get iconSizeMedium => responsive<double>(xs: 20, sm: 22, md: 24, lg: 26, xl: 28);
  double get iconSizeLarge => responsive<double>(xs: 24, sm: 28, md: 32, lg: 36, xl: 40);
  
  /// Returns border radius values
  double get borderRadiusSmall => responsive<double>(xs: 4, sm: 6, md: 8, lg: 10, xl: 12);
  double get borderRadiusMedium => responsive<double>(xs: 8, sm: 10, md: 12, lg: 16, xl: 20);
  double get borderRadiusLarge => responsive<double>(xs: 12, sm: 16, md: 20, lg: 24, xl: 32);
}

/// Widget that displays different layouts based on screen size
class ResponsiveLayout extends StatelessWidget {
  /// Widget to display on mobile screens
  final Widget mobile;
  
  /// Widget to display on tablet screens (optional)
  final Widget? tablet;
  
  /// Widget to display on desktop screens (optional)
  final Widget? desktop;

  /// Constructor
  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.isDesktop) {
      return desktop ?? tablet ?? mobile;
    } else if (context.isTablet) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }
}

/// Widget that adjusts its width based on screen size
class ResponsiveContainer extends StatelessWidget {
  /// Child widget
  final Widget child;
  
  /// Max width for small screens
  final double? maxWidthSm;
  
  /// Max width for medium screens
  final double? maxWidthMd;
  
  /// Max width for large screens
  final double? maxWidthLg;
  
  /// Max width for extra large screens
  final double? maxWidthXl;
  
  /// Padding around the container
  final EdgeInsetsGeometry? padding;

  /// Constructor
  const ResponsiveContainer({
    Key? key,
    required this.child,
    this.maxWidthSm,
    this.maxWidthMd,
    this.maxWidthLg,
    this.maxWidthXl,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? maxWidth;
    
    if (context.isDesktop && maxWidthXl != null) {
      maxWidth = maxWidthXl;
    } else if (context.isTablet) {
      if (context.screenWidth >= Breakpoints.lg && maxWidthLg != null) {
        maxWidth = maxWidthLg;
      } else if (maxWidthMd != null) {
        maxWidth = maxWidthMd;
      }
    } else if (maxWidthSm != null) {
      maxWidth = maxWidthSm;
    }
    
    return Center(
      child: Container(
        constraints: maxWidth != null
            ? BoxConstraints(maxWidth: maxWidth)
            : null,
        padding: padding ?? context.padding,
        child: child,
      ),
    );
  }
}