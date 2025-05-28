import 'package:flutter/material.dart';

/// Classe que define todas as dimensões usadas no aplicativo.
///
/// Centraliza valores de espaçamento, bordas, tamanhos de botões e outros
/// elementos para garantir consistência em toda a aplicação.
class AppDimensions {
  // Static constants for compatibility
  static const double padding12 = 12.0;
  static const double padding16 = 16.0;
  static const double padding24 = 24.0;
  static const double spacing8 = 8.0;
  static const double spacing16 = 16.0;
  static const double spacing24 = 24.0;
  static const double radiusMedium = 10.0;
  /// Espaçamento extra pequeno
  final double spacingXS;
  
  /// Espaçamento pequeno
  final double spacingS;
  
  /// Espaçamento médio (padrão)
  final double spacingM;
  
  /// Espaçamento grande
  final double spacingL;
  
  /// Espaçamento extra grande
  final double spacingXL;
  
  /// Raio de borda pequeno
  final double borderRadiusS;
  
  /// Raio de borda médio
  final double borderRadiusM;
  
  /// Raio de borda grande
  final double borderRadiusL;
  
  /// Largura padrão de botão
  final double buttonWidth;
  
  /// Altura padrão de botão
  final double buttonHeight;
  
  /// Tamanho de ícone pequeno
  final double iconSizeS;
  
  /// Tamanho de ícone médio
  final double iconSizeM;
  
  /// Tamanho de ícone grande
  final double iconSizeL;
  
  /// Altura padrão de campo de entrada
  final double inputHeight;
  
  /// Largura de borda de ativação em campos de entrada
  final double inputActiveBorderWidth;
  
  /// Altura da barra de navegação (AppBar)
  final double appBarHeight;
  
  // Material compatibility properties
  double get paddingSmall => spacingS;
  double get paddingMedium => spacingM;
  double get borderRadiusMedium => borderRadiusM;
  
  /// Construtor principal da classe AppDimensions
  const AppDimensions({
    required this.spacingXS,
    required this.spacingS,
    required this.spacingM,
    required this.spacingL,
    required this.spacingXL,
    required this.borderRadiusS,
    required this.borderRadiusM,
    required this.borderRadiusL,
    required this.buttonWidth,
    required this.buttonHeight,
    required this.iconSizeS,
    required this.iconSizeM,
    required this.iconSizeL,
    required this.inputHeight,
    required this.inputActiveBorderWidth,
    required this.appBarHeight,
  });

  /// Retorna o padding horizontal padrão baseado no espaçamento médio
  EdgeInsets get horizontalPadding => EdgeInsets.symmetric(horizontal: spacingM);
  
  /// Retorna o padding vertical padrão baseado no espaçamento médio
  EdgeInsets get verticalPadding => EdgeInsets.symmetric(vertical: spacingM);
  
  /// Retorna o padding padrão (em todos os lados) baseado no espaçamento médio
  EdgeInsets get padding => EdgeInsets.all(spacingM);

  /// Cria dimensões padrão para o aplicativo
  factory AppDimensions.standard() {
    return const AppDimensions(
      // Espaçamentos
      spacingXS: 4.0,
      spacingS: 8.0,
      spacingM: 16.0,
      spacingL: 24.0,
      spacingXL: 32.0,
      
      // Bordas
      borderRadiusS: 5.0,
      borderRadiusM: 10.0,
      borderRadiusL: 20.0,
      
      // Botões
      buttonWidth: 60.0,
      buttonHeight: 60.0,
      
      // Ícones
      iconSizeS: 16.0,
      iconSizeM: 24.0,
      iconSizeL: 40.0,
      
      // Campos de entrada
      inputHeight: 40.0,
      inputActiveBorderWidth: 2.0,
      
      // Barra de navegação
      appBarHeight: 60.0,
    );
  }

  /// Cria dimensões compactas para telas menores
  factory AppDimensions.compact() {
    return const AppDimensions(
      // Espaçamentos reduzidos
      spacingXS: 2.0,
      spacingS: 4.0,
      spacingM: 8.0,
      spacingL: 16.0,
      spacingXL: 24.0,
      
      // Bordas menores
      borderRadiusS: 3.0,
      borderRadiusM: 6.0,
      borderRadiusL: 12.0,
      
      // Botões menores
      buttonWidth: 50.0,
      buttonHeight: 50.0,
      
      // Ícones menores
      iconSizeS: 12.0,
      iconSizeM: 20.0,
      iconSizeL: 32.0,
      
      // Campos de entrada mais baixos
      inputHeight: 36.0, 
      inputActiveBorderWidth: 1.5,
      
      // Barra de navegação mais baixa
      appBarHeight: 50.0,
    );
  }
}