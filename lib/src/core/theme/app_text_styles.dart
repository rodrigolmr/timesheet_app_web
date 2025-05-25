import 'package:flutter/material.dart';

/// Classe que define todos os estilos de texto usados no aplicativo.
///
/// Centraliza definições de fontes, tamanhos e pesos para garantir
/// consistência tipográfica em toda a aplicação.
class AppTextStyles {
  /// Estilo para títulos principais (como nome do app e cabeçalhos de seção)
  final TextStyle headline;
  
  /// Estilo para títulos de tela
  final TextStyle title;
  
  /// Estilo para subtítulos e cabeçalhos secundários
  final TextStyle subtitle;
  
  /// Estilo para texto de corpo principal
  final TextStyle body;
  
  /// Estilo para texto de corpo principal em negrito
  TextStyle get bodyBold => body.copyWith(fontWeight: FontWeight.bold);
  
  /// Estilo para texto pequeno e auxiliar
  final TextStyle caption;
  
  /// Estilo para texto em botões
  final TextStyle button;
  
  /// Estilo para rótulos de campos de entrada
  final TextStyle inputLabel;
  
  /// Estilo para texto em campos de entrada
  final TextStyle input;
  
  /// Estilo para texto flutuante de campos de entrada
  final TextStyle inputFloatingLabel;
  
  /// Estilo para texto de dica em campos de entrada
  final TextStyle inputHint;
  
  /// Estilo para título da barra de navegação (BaseLayout)
  final TextStyle appBarTitle;
  
  // Material 3 style mapping
  TextStyle get titleLarge => title;
  TextStyle get titleMedium => subtitle;
  TextStyle get titleSmall => caption;
  TextStyle get headlineSmall => headline.copyWith(fontSize: 20);
  TextStyle get bodyMedium => body;
  TextStyle get labelMedium => inputLabel;
  TextStyle get labelSmall => inputFloatingLabel;
  TextStyle get labelLarge => button;
  
  /// Construtor principal da classe AppTextStyles
  const AppTextStyles({
    required this.headline,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.caption,
    required this.button,
    required this.inputLabel,
    required this.input,
    required this.inputFloatingLabel,
    required this.inputHint,
    required this.appBarTitle,
  });

  /// Cria estilos de texto para o tema light
  factory AppTextStyles.light() {
    return AppTextStyles(
      headline: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 32,  // Reduzido de 42 para melhor responsividade
        fontWeight: FontWeight.w800,
        color: Color(0xFF0205D3),
        letterSpacing: -1.0,
      ),
      
      title: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 24,  // Reduzido de 30 para melhor responsividade
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      
      subtitle: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,  // Reduzido de 18 para melhor responsividade
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      
      body: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,  // Reduzido de 16 para melhor responsividade
        fontWeight: FontWeight.normal,
        color: Colors.black87,
      ),
      
      caption: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 11,  // Reduzido de 12 para melhor responsividade
        fontWeight: FontWeight.normal,
        color: Colors.black54,
      ),
      
      button: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 12,  // Mantido
        fontWeight: FontWeight.bold,
        color: Colors.white,
        height: 1.0,
      ),
      
      inputLabel: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,  // Reduzido de 16 para melhor responsividade
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      
      input: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 15,  // Reduzido de 16 para melhor responsividade
        fontWeight: FontWeight.normal,
        color: Colors.black87,
      ),
      
      inputFloatingLabel: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 11,  // Reduzido de 12 para melhor responsividade
        fontWeight: FontWeight.bold,
        color: Color(0xFF0205D3),
      ),
      
      inputHint: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,  // Reduzido de 16 para melhor responsividade
        fontWeight: FontWeight.normal,  // Mudado de bold para normal
        color: Colors.grey,
      ),
      
      appBarTitle: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 20,  // Reduzido significativamente de 30 para melhor responsividade
        fontWeight: FontWeight.w700,
        color: Color(0xFF0205D3),
      ),
    );
  }

  /// Cria estilos de texto para o tema dark
  factory AppTextStyles.dark() {
    return AppTextStyles(
      headline: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 32,  // Reduzido de 42 para melhor responsividade
        fontWeight: FontWeight.w800,
        color: Color(0xFF4D4FFF),  // Azul mais claro para dark mode
        letterSpacing: -1.0,
      ),
      
      title: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 24,  // Reduzido de 30 para melhor responsividade
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      
      subtitle: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,  // Reduzido de 18 para melhor responsividade
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      
      body: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,  // Reduzido de 16 para melhor responsividade
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
      
      caption: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 11,  // Reduzido de 12 para melhor responsividade
        fontWeight: FontWeight.normal,
        color: Colors.white70,
      ),
      
      button: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 12,  // Mantido
        fontWeight: FontWeight.bold,
        color: Colors.white,
        height: 1.0,
      ),
      
      inputLabel: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,  // Reduzido de 16 para melhor responsividade
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      
      input: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 15,  // Reduzido de 16 para melhor responsividade
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
      
      inputFloatingLabel: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 11,  // Reduzido de 12 para melhor responsividade
        fontWeight: FontWeight.bold,
        color: Color(0xFF4D4FFF),  // Azul mais claro para dark mode
      ),
      
      inputHint: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,  // Reduzido de 16 para melhor responsividade
        fontWeight: FontWeight.normal,  // Mudado de bold para normal
        color: Colors.grey,
      ),
      
      appBarTitle: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 20,  // Reduzido significativamente de 30 para melhor responsividade
        fontWeight: FontWeight.w700,
        color: Color(0xFF4D4FFF),  // Azul mais claro para dark mode
      ),
    );
  }

  /// Cria estilos de texto para o tema feminino
  factory AppTextStyles.feminine() {
    return AppTextStyles(
      headline: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 32,  // Reduzido de 42 para melhor responsividade
        fontWeight: FontWeight.w800,
        color: Color(0xFFD81B60),  // Rosa
        letterSpacing: -1.0,
      ),
      
      title: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 24,  // Reduzido de 30 para melhor responsividade
        fontWeight: FontWeight.bold,
        color: Color(0xFF424242),
      ),
      
      subtitle: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,  // Reduzido de 18 para melhor responsividade
        fontWeight: FontWeight.w600,
        color: Color(0xFF424242),
      ),
      
      body: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,  // Reduzido de 16 para melhor responsividade
        fontWeight: FontWeight.normal,
        color: Color(0xFF424242),
      ),
      
      caption: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 11,  // Reduzido de 12 para melhor responsividade
        fontWeight: FontWeight.normal,
        color: Color(0xFF757575),
      ),
      
      button: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 12,  // Mantido
        fontWeight: FontWeight.bold,
        color: Colors.white,
        height: 1.0,
      ),
      
      inputLabel: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,  // Reduzido de 16 para melhor responsividade
        fontWeight: FontWeight.bold,
        color: Color(0xFF424242),
      ),
      
      input: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 15,  // Reduzido de 16 para melhor responsividade
        fontWeight: FontWeight.normal,
        color: Color(0xFF424242),
      ),
      
      inputFloatingLabel: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 11,  // Reduzido de 12 para melhor responsividade
        fontWeight: FontWeight.bold,
        color: Color(0xFFD81B60),  // Rosa
      ),
      
      inputHint: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,  // Reduzido de 16 para melhor responsividade
        fontWeight: FontWeight.normal,  // Mudado de bold para normal
        color: Colors.grey,
      ),
      
      appBarTitle: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 20,  // Reduzido significativamente de 30 para melhor responsividade
        fontWeight: FontWeight.w700,
        color: Color(0xFFD81B60),  // Rosa
      ),
    );
  }

  /// Cria estilos de texto para o tema verde
  factory AppTextStyles.green() {
    return AppTextStyles(
      headline: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 32,  // Reduzido de 42 para melhor responsividade
        fontWeight: FontWeight.w800,
        color: Color(0xFF00695C),  // Verde escuro
        letterSpacing: -1.0,
      ),
      
      title: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 24,  // Reduzido de 30 para melhor responsividade
        fontWeight: FontWeight.bold,
        color: Color(0xFF00695C),
      ),
      
      subtitle: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,  // Reduzido de 18 para melhor responsividade
        fontWeight: FontWeight.w600,
        color: Color(0xFF424242),
      ),
      
      body: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,  // Reduzido de 16 para melhor responsividade
        fontWeight: FontWeight.normal,
        color: Color(0xFF424242),
      ),
      
      caption: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 11,  // Reduzido de 12 para melhor responsividade
        fontWeight: FontWeight.normal,
        color: Color(0xFF757575),
      ),
      
      button: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 12,  // Mantido
        fontWeight: FontWeight.bold,
        color: Colors.white,
        height: 1.0,
      ),
      
      inputLabel: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,  // Reduzido de 16 para melhor responsividade
        fontWeight: FontWeight.bold,
        color: Color(0xFF424242),
      ),
      
      input: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 15,  // Reduzido de 16 para melhor responsividade
        fontWeight: FontWeight.normal,
        color: Color(0xFF424242),
      ),
      
      inputFloatingLabel: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 11,  // Reduzido de 12 para melhor responsividade
        fontWeight: FontWeight.bold,
        color: Color(0xFF00695C),  // Verde escuro
      ),
      
      inputHint: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,  // Reduzido de 16 para melhor responsividade
        fontWeight: FontWeight.normal,  // Mudado de bold para normal
        color: Colors.grey,
      ),
      
      appBarTitle: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 20,  // Reduzido significativamente de 30 para melhor responsividade
        fontWeight: FontWeight.w700,
        color: Color(0xFF00695C),  // Verde escuro
      ),
    );
  }
}