// lib/core/responsive/responsive_layout.dart

import 'package:flutter/material.dart';
import 'responsive_breakpoints.dart';
import 'responsive_sizing.dart';

/// Widget que permite renderizar diferentes layouts baseados no tamanho da tela.
///
/// Simplifica a criação de interfaces responsivas exibindo diferentes widgets
/// de acordo com o breakpoint atingido.
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile; // Layout para dispositivos móveis (< 768px)
  final Widget? mobileLarge; // Layout para dispositivos móveis grandes (>= 428px)
  final Widget? tablet; // Layout para tablets (>= 768px)
  final Widget? desktop; // Layout para desktops (>= 1280px)

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    this.mobileLarge,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        
        // Layout para desktop
        if (ResponsiveBreakpoints.isDesktop(width)) {
          return desktop ?? tablet ?? mobileLarge ?? mobile;
        }
        
        // Layout para tablet
        if (ResponsiveBreakpoints.isTablet(width) || 
            ResponsiveBreakpoints.isTabletLarge(width)) {
          return tablet ?? mobileLarge ?? mobile;
        }
        
        // Layout para mobile grande
        if (ResponsiveBreakpoints.isMobileLarge(width)) {
          return mobileLarge ?? mobile;
        }
        
        // Layout para mobile padrão
        return mobile;
      },
    );
  }
}

/// Widget que ajusta o tamanho máximo e centraliza o conteúdo com base no dispositivo.
///
/// Útil para formulários, cards e containers que precisam ter largura limitada
/// em telas maiores, mas ocupar todo o espaço em telas menores.
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? mobileMaxWidth;
  final double? tabletMaxWidth;
  final double? desktopMaxWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool center;
  final Color? backgroundColor;
  final BoxDecoration? decoration;
  final BoxConstraints? additionalConstraints;
  final double? minHeight;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;
  final List<BoxShadow>? boxShadow;
  final BorderRadius? borderRadius;
  final Border? border;
  final double? childSpacing; // Espaço entre elementos filho quando child é uma Column/Row

  /// Cria um container responsivo com larguras máximas diferentes para cada breakpoint.
  ///
  /// O [child] é o widget a ser exibido dentro do container.
  /// [mobileMaxWidth], [tabletMaxWidth] e [desktopMaxWidth] definem a largura máxima para cada tipo de dispositivo.
  /// [padding] é o espaçamento interno aplicado ao conteúdo.
  /// [margin] é o espaçamento externo aplicado ao container.
  /// [center] determina se o conteúdo deve ser centralizado na tela.
  /// [backgroundColor] define a cor de fundo do container.
  /// [decoration] permite uma personalização completa do container (substitui backgroundColor, borderRadius, etc).
  /// [additionalConstraints] permite definir restrições adicionais além da largura máxima.
  /// [minHeight] define uma altura mínima para o container.
  /// [crossAxisAlignment] e [mainAxisAlignment] definem o alinhamento quando o child é um Column ou Row.
  /// [boxShadow] aplica sombras ao container.
  /// [borderRadius] define o arredondamento das bordas.
  /// [border] define as bordas do container.
  /// [childSpacing] define o espaçamento entre elementos quando o child é uma Column ou Row.
  const ResponsiveContainer({
    Key? key,
    required this.child,
    this.mobileMaxWidth,
    this.tabletMaxWidth,
    this.desktopMaxWidth,
    this.padding,
    this.margin,
    this.center = true,
    this.backgroundColor,
    this.decoration,
    this.additionalConstraints,
    this.minHeight,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.boxShadow,
    this.borderRadius,
    this.border,
    this.childSpacing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveSizing(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // Determina a largura máxima com base no tamanho da tela
        double? maxWidth;
        if (ResponsiveBreakpoints.isDesktop(width) && desktopMaxWidth != null) {
          maxWidth = desktopMaxWidth;
        } else if ((ResponsiveBreakpoints.isTablet(width) ||
                   ResponsiveBreakpoints.isTabletLarge(width)) &&
                   tabletMaxWidth != null) {
          maxWidth = tabletMaxWidth;
        } else if (mobileMaxWidth != null) {
          maxWidth = mobileMaxWidth;
        }

        // Cria constraints combinando maxWidth e additionalConstraints
        BoxConstraints containerConstraints = additionalConstraints ?? const BoxConstraints();
        if (maxWidth != null) {
          containerConstraints = containerConstraints.copyWith(maxWidth: maxWidth);
        }
        if (minHeight != null) {
          containerConstraints = containerConstraints.copyWith(minHeight: minHeight);
        }

        // Cria decoration do container
        BoxDecoration? containerDecoration;
        if (decoration != null) {
          containerDecoration = decoration;
        } else if (backgroundColor != null || boxShadow != null || borderRadius != null || border != null) {
          containerDecoration = BoxDecoration(
            color: backgroundColor,
            boxShadow: boxShadow,
            borderRadius: borderRadius,
            border: border,
          );
        }

        // Prepara o conteúdo filho, aplicando Column/Row se necessário
        Widget content = child;

        // Identifica se o child já é uma Column e aplica o espaçamento automático
        if (child is Column && childSpacing != null) {
          // Se o child já é uma Column, ajustamos o espaçamento entre seus elementos
          final Column column = child as Column;
          // Adiciona SizedBox entre os elementos da Column
          final List<Widget> childrenWithSpacing = [];
          for (int i = 0; i < column.children.length; i++) {
            childrenWithSpacing.add(column.children[i]);
            // Adiciona espaçamento entre os elementos, exceto após o último
            if (i < column.children.length - 1) {
              childrenWithSpacing.add(SizedBox(height: childSpacing));
            }
          }

          // Cria uma nova Column com os mesmos parâmetros da original, mas com espaçamento
          content = Column(
            mainAxisAlignment: column.mainAxisAlignment,
            mainAxisSize: MainAxisSize.min, // Usamos min para não esticar
            crossAxisAlignment: column.crossAxisAlignment,
            textDirection: column.textDirection,
            verticalDirection: column.verticalDirection,
            textBaseline: column.textBaseline,
            children: childrenWithSpacing,
          );
        } else if (crossAxisAlignment != null || mainAxisAlignment != null) {
          // Se não for uma Column mas tiver parâmetros de alinhamento, criar uma Column
          content = Column(
            crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
            mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [child],
          );
        }

        // Aplica constraints
        if (containerConstraints != const BoxConstraints()) {
          content = ConstrainedBox(
            constraints: containerConstraints,
            child: content,
          );
        }

        // Aplica decoration
        if (containerDecoration != null) {
          content = Container(
            decoration: containerDecoration,
            child: content,
          );
        }

        // Aplica padding se fornecido
        if (padding != null) {
          content = Padding(padding: padding!, child: content);
        }

        // Aplica margin se fornecido
        if (margin != null) {
          content = Padding(padding: margin!, child: content);
        }

        // Centraliza o conteúdo se solicitado
        if (center) {
          content = Align(
            alignment: Alignment.topCenter,
            child: content,
          );
        }

        return content;
      },
    );
  }
}

/// Extension para adicionar métodos de adaptação responsiva ao BuildContext
extension ResponsiveExtension on BuildContext {
  // Verifica tamanhos de tela
  bool get isMobile => MediaQuery.of(this).size.width < ResponsiveBreakpoints.tablet;
  bool get isTablet => 
      MediaQuery.of(this).size.width >= ResponsiveBreakpoints.tablet && 
      MediaQuery.of(this).size.width < ResponsiveBreakpoints.desktopSmall;
  bool get isDesktop => MediaQuery.of(this).size.width >= ResponsiveBreakpoints.desktopSmall;
  
  // Obtém orientação
  bool get isPortrait => MediaQuery.of(this).orientation == Orientation.portrait;
  bool get isLandscape => MediaQuery.of(this).orientation == Orientation.landscape;
  
  // Retorna um valor com base no tamanho da tela atual
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop && desktop != null) {
      return desktop;
    }
    if (isTablet && tablet != null) {
      return tablet;
    }
    return mobile;
  }
  
  // Calcula padding responsivo
  EdgeInsets get responsivePadding => responsive<EdgeInsets>(
    mobile: const EdgeInsets.all(16.0),
    tablet: const EdgeInsets.all(24.0),
    desktop: const EdgeInsets.all(32.0),
  );
  
  // Calcula espaçamento responsivo
  double get responsiveSpacing => responsive<double>(
    mobile: 16.0,
    tablet: 24.0,
    desktop: 32.0,
  );
}