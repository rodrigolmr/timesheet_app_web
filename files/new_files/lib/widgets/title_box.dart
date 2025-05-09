// lib/widgets/title_box.dart

import 'package:flutter/material.dart';

class TitleBox extends StatelessWidget {
  static const double defaultHeight = 70.0;
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
    this.height = defaultHeight,
    this.borderRadius = const BorderRadius.all(Radius.circular(10.0)),
    this.margin = const EdgeInsets.symmetric(horizontal: 16.0),
    this.padding = EdgeInsets.zero,
    this.textAlign = TextAlign.center,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? Theme.of(context).colorScheme.primary;
    final style =
        textStyle ??
        Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        );

    Widget innerContent = Container(
      width: double.infinity, // Container still fills the ConstrainedBox
      height: height,
      padding: padding,
      decoration: BoxDecoration(color: bg, borderRadius: borderRadius),
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
        constraints: const BoxConstraints(maxWidth: 600),
        child: Container(
          margin: margin, // Apply margin to the ConstrainedBox container
          child: innerContent,
        ),
      ),
    );
  }
}
