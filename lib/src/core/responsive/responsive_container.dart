import 'package:flutter/material.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';

/// Container responsivo que limita a largura máxima do conteúdo baseado no tamanho da tela
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  
  /// Largura máxima para telas extra pequenas (mobile)
  final double? xsMaxWidth;
  
  /// Largura máxima para telas pequenas
  final double? smMaxWidth;
  
  /// Largura máxima para telas médias (tablets)
  final double? mdMaxWidth;
  
  /// Largura máxima para telas grandes
  final double? lgMaxWidth;
  
  /// Largura máxima para telas extra grandes (desktop)
  final double? xlMaxWidth;

  const ResponsiveContainer({
    Key? key,
    required this.child,
    this.xsMaxWidth,
    this.smMaxWidth,
    this.mdMaxWidth,
    this.lgMaxWidth,
    this.xlMaxWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxWidth = context.responsive<double>(
      xs: xsMaxWidth ?? double.infinity,
      sm: smMaxWidth ?? 600,
      md: mdMaxWidth ?? 800,
      lg: lgMaxWidth ?? 1000,
      xl: xlMaxWidth ?? 1200,
    );

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}