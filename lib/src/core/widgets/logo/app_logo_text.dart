import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';

/// Widget de logotipo com texto para o aplicativo.
///
/// Este widget renderiza o logotipo textual do aplicativo dentro de uma borda,
/// seguindo o estilo visual da aplicação e com suporte a responsividade.
class AppLogoText extends StatelessWidget {
  /// Se deve usar tamanho reduzido para o logo
  final bool small;
  
  /// Se deve centralizar o conteúdo
  final bool centered;
  
  /// Construtor padrão
  const AppLogoText({
    Key? key,
    this.small = false,
    this.centered = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Usamos responsive para adaptar o tamanho do logo às diferentes telas
    final containerWidth = context.responsive<double>(
      xs: small ? 200 : 260,
      sm: small ? 230 : 300, 
      md: small ? 260 : 330,
      lg: small ? 280 : 350,
    );
    
    final containerHeight = context.responsive<double>(
      xs: small ? 85 : 110,
      sm: small ? 95 : 125,
      md: small ? 105 : 140,
      lg: small ? 115 : 150,
    );
    
    final fontSize = context.responsive<double>(
      xs: small ? 24 : 32,
      sm: small ? 28 : 36,
      md: small ? 32 : 42,
      lg: small ? 34 : 46,
    );
    
    final borderWidth = context.responsive<double>(
      xs: small ? 3 : 4, 
      md: small ? 4 : 5,
    );
    
    final borderRadius = context.responsive<double>(
      xs: 12,
      sm: 16,
      md: 20,
    );

    // Widget principal
    final logoWidget = Container(
      width: containerWidth,
      height: containerHeight,
      decoration: BoxDecoration(
        border: Border.all(
          color: context.colors.primary,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Primeira linha do texto
          Text(
            'Central Island',
            style: GoogleFonts.playfairDisplay(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: context.colors.primary,
              letterSpacing: 1.0,
              height: 1.0,
            ),
          ),
          
          // Segunda linha do texto
          Text(
            'Floors',
            style: GoogleFonts.playfairDisplay(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: context.colors.primary,
              letterSpacing: 1.0,
              height: 1.0,
            ),
          ),
        ],
      ),
    );

    // Retornamos o widget centralizado ou não, dependendo do parâmetro
    if (centered) {
      return Center(child: logoWidget);
    } else {
      return logoWidget;
    }
  }
}