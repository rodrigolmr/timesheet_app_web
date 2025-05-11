// lib/core/responsive/responsive_sizing.dart

import 'package:flutter/material.dart';
import 'responsive_breakpoints.dart';

class ResponsiveSizing {
  final BuildContext context;
  final double _width;
  final double _height;
  final double _shortestSide;
  final Orientation _orientation;
  
  ResponsiveSizing._internal(this.context)
      : _width = MediaQuery.of(context).size.width,
        _height = MediaQuery.of(context).size.height,
        _shortestSide = MediaQuery.of(context).size.shortestSide,
        _orientation = MediaQuery.of(context).orientation;
  
  // Construtor factory para cache de instâncias
  static final Map<BuildContext, ResponsiveSizing> _cache = {};
  
  factory ResponsiveSizing(BuildContext context) {
    return _cache.putIfAbsent(
      context, 
      () => ResponsiveSizing._internal(context)
    );
  }
  
  // Valores de dimensão
  double get width => _width;
  double get height => _height;
  double get shortestSide => _shortestSide;
  Orientation get orientation => _orientation;
  
  // Verifica a orientação
  bool get isPortrait => _orientation == Orientation.portrait;
  bool get isLandscape => _orientation == Orientation.landscape;
  
  // Classificações de dispositivo
  bool get isMobileSmall => ResponsiveBreakpoints.isMobileSmall(_width);
  bool get isMobileMedium => ResponsiveBreakpoints.isMobileMedium(_width);
  bool get isMobileLarge => ResponsiveBreakpoints.isMobileLarge(_width);
  bool get isTablet => ResponsiveBreakpoints.isTablet(_width);
  bool get isTabletLarge => ResponsiveBreakpoints.isTabletLarge(_width);
  bool get isDesktopSmall => ResponsiveBreakpoints.isDesktopSmall(_width);
  bool get isDesktopLarge => ResponsiveBreakpoints.isDesktopLarge(_width);
  
  // Agrupamentos
  bool get isMobile => ResponsiveBreakpoints.isMobile(_width);
  bool get isTabletOrSmaller => ResponsiveBreakpoints.isTabletOrSmaller(_width);
  bool get isDesktop => ResponsiveBreakpoints.isDesktop(_width);
  
  // Retorna um valor dependendo do tamanho da tela
  T responsiveValue<T>({
    required T mobile,
    T? mobileLarge,
    T? tablet,
    T? tabletLarge,
    T? desktop,
  }) {
    if (isDesktop && desktop != null) {
      return desktop;
    }
    if (isTabletLarge && tabletLarge != null) {
      return tabletLarge;
    }
    if (isTablet && tablet != null) {
      return tablet;
    }
    if ((isMobileLarge || isMobileMedium) && mobileLarge != null) {
      return mobileLarge;
    }
    return mobile;
  }
  
  // Retorna valores de dimensão adaptáveis
  double scaledWidth(double percentage) => _width * percentage;
  double scaledHeight(double percentage) => _height * percentage;
  
  // Calcula valores de espaçamento responsivos
  double get spacing => responsiveValue(
    mobile: 8.0,
    mobileLarge: 12.0,
    tablet: 16.0,
    tabletLarge: 20.0,
    desktop: 24.0,
  );
  
  // Calcula tamanhos de fonte responsivos
  double get fontScaleFactor => responsiveValue(
    mobile: 1.0,
    mobileLarge: 1.1,
    tablet: 1.2,
    tabletLarge: 1.3,
    desktop: 1.4,
  );
  
  // Calcula padding responsivo - otimizado para telas a partir de 320px
  EdgeInsets get screenPadding => responsiveValue(
    mobile: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0), // Padrão para telas pequenas (320px)
    mobileLarge: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
    tablet: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
    tabletLarge: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 28.0),
    desktop: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 32.0),
  );
  
  // Calcula largura máxima para conteúdo centralizado
  double get contentMaxWidth => responsiveValue(
    mobile: double.infinity,
    tablet: 700.0,
    desktop: 900.0,
  );
  
  // Calcula altura de campos de entrada
  double get inputHeight => responsiveValue(
    mobile: 40.0,
    mobileLarge: 44.0,
    tablet: 48.0,
    desktop: 52.0,
  );
  
  // Calcula altura de botões
  double get buttonHeight => responsiveValue(
    mobile: 44.0,
    mobileLarge: 48.0,
    tablet: 52.0,
    desktop: 56.0,
  );
}