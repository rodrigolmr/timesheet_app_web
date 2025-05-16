import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';

/// Modo de exibição do logotipo
enum LogoDisplayMode {
  /// Modo vertical com texto em duas linhas (padrão)
  vertical,
  
  /// Modo horizontal com texto em uma linha
  horizontal,
  
  /// Apenas o texto principal (sem a borda)
  textOnly,
  
  /// Modo compacto apenas com as iniciais "CIF"
  monogram
}

/// Widget de logotipo completo para o aplicativo.
///
/// Versão aprimorada do logotipo que suporta diferentes modos de exibição,
/// como vertical, horizontal, apenas texto ou monograma (iniciais).
class AppLogo extends StatelessWidget {
  /// Modo de exibição do logotipo
  final LogoDisplayMode displayMode;
  
  /// Se deve usar tamanho reduzido para o logo
  final bool small;
  
  /// Se deve centralizar o conteúdo
  final bool centered;
  
  /// Construtor padrão
  const AppLogo({
    Key? key,
    this.displayMode = LogoDisplayMode.vertical,
    this.small = false,
    this.centered = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determinamos o widget do logo com base no modo de exibição
    Widget logoWidget;
    
    switch (displayMode) {
      case LogoDisplayMode.vertical:
        logoWidget = _buildVerticalLogo(context);
        break;
      case LogoDisplayMode.horizontal:
        logoWidget = _buildHorizontalLogo(context);
        break;
      case LogoDisplayMode.textOnly:
        logoWidget = _buildTextOnlyLogo(context);
        break;
      case LogoDisplayMode.monogram:
        logoWidget = _buildMonogramLogo(context);
        break;
    }

    // Retornamos o widget centralizado ou não, dependendo do parâmetro
    if (centered) {
      return Center(child: logoWidget);
    } else {
      return logoWidget;
    }
  }

  // Constrói o logo no modo vertical (tradicional)
  Widget _buildVerticalLogo(BuildContext context) {
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

    return Container(
      width: containerWidth,
      height: containerHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colors.primary,
            context.colors.primary.withOpacity(0.7),
          ],
          stops: const [0.2, 1.0],
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: context.colors.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                context.colors.surface,
                context.colors.surface.withOpacity(0.95),
              ],
            ),
            borderRadius: BorderRadius.circular(borderRadius - 3),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Central Island',
                  style: GoogleFonts.poppins(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w700,
                    color: context.colors.primary,
                    letterSpacing: 0.5,
                    height: 1.2,
                    shadows: [
                    Shadow(
                      color: context.colors.primary.withOpacity(0.15),
                      offset: const Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Floors',
                style: GoogleFonts.poppins(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                  color: context.colors.primary,
                  letterSpacing: 0.5,
                  height: 1.2,
                  shadows: [
                    Shadow(
                      color: context.colors.primary.withOpacity(0.15),
                      offset: const Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Constrói o logo no modo horizontal
  Widget _buildHorizontalLogo(BuildContext context) {
    final containerWidth = context.responsive<double>(
      xs: small ? 280 : 340,
      sm: small ? 320 : 380, 
      md: small ? 360 : 420,
      lg: small ? 400 : 460,
    );
    
    final containerHeight = context.responsive<double>(
      xs: small ? 60 : 75,
      sm: small ? 70 : 85,
      md: small ? 80 : 95,
      lg: small ? 90 : 105,
    );
    
    final fontSize = context.responsive<double>(
      xs: small ? 20 : 26,
      sm: small ? 24 : 30,
      md: small ? 28 : 34,
      lg: small ? 32 : 38,
    );
    
    final borderRadius = context.responsive<double>(
      xs: 10,
      sm: 12,
      md: 16,
    );

    return Container(
      width: containerWidth,
      height: containerHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colors.primary,
            context.colors.primary.withOpacity(0.7),
          ],
          stops: const [0.2, 1.0],
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: context.colors.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                context.colors.surface,
                context.colors.surface.withOpacity(0.95),
              ],
            ),
            borderRadius: BorderRadius.circular(borderRadius - 3),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Central Island Floors',
                style: GoogleFonts.poppins(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                  color: context.colors.primary,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                      color: context.colors.primary.withOpacity(0.15),
                      offset: const Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Constrói apenas o texto do logo sem a borda
  Widget _buildTextOnlyLogo(BuildContext context) {
    final fontSize = context.responsive<double>(
      xs: small ? 24 : 32,
      sm: small ? 28 : 36,
      md: small ? 32 : 42,
      lg: small ? 34 : 46,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Central Island',
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: context.colors.primary,
            letterSpacing: 0.5,
            height: 1.2,
            shadows: [
              Shadow(
                color: context.colors.primary.withOpacity(0.15),
                offset: const Offset(2, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Floors',
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: context.colors.primary,
            letterSpacing: 0.5,
            height: 1.2,
            shadows: [
              Shadow(
                color: context.colors.primary.withOpacity(0.15),
                offset: const Offset(2, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Constrói a versão monograma do logo (apenas iniciais)
  Widget _buildMonogramLogo(BuildContext context) {
    final size = context.responsive<double>(
      xs: small ? 40 : 50,
      sm: small ? 50 : 60,
      md: small ? 60 : 70,
      lg: small ? 70 : 80,
    );
    
    final fontSize = context.responsive<double>(
      xs: small ? 20 : 25,
      sm: small ? 24 : 30,
      md: small ? 30 : 36,
      lg: small ? 34 : 40,
    );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colors.primary,
            context.colors.primary.withOpacity(0.7),
          ],
          stops: const [0.2, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: context.colors.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                context.colors.surface,
                context.colors.surface.withOpacity(0.95),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              'CIF',
              style: GoogleFonts.poppins(
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                color: context.colors.primary,
                letterSpacing: 0.5,
                shadows: [
                  Shadow(
                    color: context.colors.primary.withOpacity(0.15),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}