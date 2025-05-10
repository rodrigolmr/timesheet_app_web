// lib/widgets/title_box.dart

import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class TitleBox extends StatelessWidget {
  final String title;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final double height;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final TextAlign textAlign;
  final VoidCallback? onTap;

  const TitleBox({
    Key? key,
    required this.title,
    this.backgroundColor,
    this.textStyle,
    this.height = AppTheme.titleBoxHeight,
    this.borderRadius = const BorderRadius.all(Radius.circular(10.0)), // Usando valor direto em vez de AppTheme.largeRadius para constante
    this.margin = const EdgeInsets.symmetric(horizontal: AppTheme.defaultSpacing),
    this.padding = EdgeInsets.zero,
    this.textAlign = TextAlign.center,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? Theme.of(context).colorScheme.primary;
    final style = textStyle ?? Theme.of(context).textTheme.titleLarge?.copyWith(
      color: AppTheme.textLightColor,
      fontWeight: FontWeight.bold,
    );

    Widget innerContent = Container(
      width: double.infinity,
      height: height,
      padding: padding,
      decoration: AppTheme.titleBoxDecoration(bg),
      alignment: Alignment.center,
      child: Text(title, textAlign: textAlign, style: style),
    );

    if (onTap != null) {
      innerContent = Semantics(
        header: true,
        button: true,
        label: title,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: innerContent,
        ),
      );
    } else {
      innerContent = Semantics(header: true, child: innerContent);
    }

    // Wrap with Center and ConstrainedBox
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppTheme.maxContainerWidth),
        child: Container(
          margin: margin,
          child: innerContent,
        ),
      ),
    );
  }
}