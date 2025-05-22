import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/responsive/responsive.dart';

class NavigationCard extends ConsumerWidget {
  final String title;
  final String description;
  final IconData icon;
  final String route;
  final Color? color;
  final bool isActive;
  final VoidCallback? onTap;

  const NavigationCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
    this.color,
    this.isActive = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardColor = color ?? context.colors.primary;
    final isEnabled = isActive;

    // Usar valores responsivos para dimensões do card mais compactos
    final cardWidth = context.responsive<double>(
      xs: 90.0,   // Bem menor para telas pequenas
      sm: 110.0,  // Menor sem descrição
      md: 130.0,  // Compacto
      lg: 150.0,  // Compacto
    );
    
    final cardHeight = context.responsive<double>(
      xs: 90.0,   // Quadrado pequeno
      sm: 110.0,  // Quadrado
      md: 130.0,  // Quadrado
      lg: 150.0,  // Quadrado
    );

    return Container(
      width: cardWidth,
      height: cardHeight,
      child: Card(
        color: context.colors.surface,
        elevation: 8.0, // Aumentar elevação para maior destaque
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
          side: BorderSide(color: cardColor.withOpacity(0.2), width: 1.5),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled
                ? (onTap ?? () => context.go(route))
                : null,
            splashColor: cardColor.withOpacity(0.1),
            highlightColor: cardColor.withOpacity(0.05),
            hoverColor: cardColor.withOpacity(0.03),
            child: Stack(
              children: [
                // Elementos decorativos de fundo
                Positioned(
                  right: -20,
                  top: -20,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: cardColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  left: -20,
                  bottom: -20,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: cardColor.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                
                // Badge "Coming Soon" posicionado no canto superior direito
                if (!isEnabled)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.dimensions.spacingXS,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: context.colors.textSecondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(context.dimensions.borderRadiusL),
                      ),
                      child: Text(
                        'Soon',
                        style: TextStyle(
                          color: context.colors.textSecondary,
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                
                // Conteúdo principal centralizado
                Semantics(
                  button: true,
                  label: '$title: $description',
                  enabled: isEnabled,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: context.responsive<double>(
                        xs: context.dimensions.spacingS,
                        sm: context.dimensions.spacingM,
                      ),
                      right: context.responsive<double>(
                        xs: context.dimensions.spacingS,
                        sm: context.dimensions.spacingM,
                      ),
                      top: context.responsive<double>(
                        xs: context.dimensions.spacingS,
                        sm: context.dimensions.spacingM,
                      ),
                      bottom: context.responsive<double>(
                        xs: 6.0, // Padding ainda menor na parte inferior para telas pequenas
                        sm: context.dimensions.spacingS,
                        md: context.dimensions.spacingM,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Ícone centralizado
                        Icon(
                          icon,
                          color: isEnabled ? cardColor : context.colors.textSecondary,
                          size: context.responsive<double>(
                            xs: 24.0, // Ícone menor
                            sm: 28.0,
                            md: 32.0,
                            lg: 36.0,
                          ),
                        ),
                        SizedBox(height: context.responsive<double>(
                          xs: 6.0,
                          sm: 8.0,
                        )),
                        
                        // Título centralizado
                        Text(
                          title,
                          style: context.textStyles.caption.copyWith(
                            color: isEnabled ? context.colors.textPrimary : context.colors.textSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: context.responsive<double>(
                              xs: 10.0, // Fonte menor
                              sm: 11.0,
                              md: 12.0,
                              lg: 13.0,
                            ),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}