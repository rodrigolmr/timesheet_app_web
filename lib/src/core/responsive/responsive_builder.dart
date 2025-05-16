import 'package:flutter/material.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';

/// A widget builder that provides constraints based on the current screen size
/// 
/// This is useful for widgets that need to adapt their layout based on the
/// available width, without having to create entirely different layouts.
/// 
/// Example usage:
/// ```dart
/// ResponsiveBuilder(
///   builder: (context, constraints, screenSize) {
///     final columns = screenSize == ScreenSize.xs || screenSize == ScreenSize.sm ? 2 : 3;
///     return GridView.builder(
///       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
///         crossAxisCount: columns,
///         childAspectRatio: 1.0,
///       ),
///       itemCount: items.length,
///       itemBuilder: (context, index) => ItemCard(item: items[index]),
///     );
///   },
/// )
/// ```
class ResponsiveBuilder extends StatelessWidget {
  /// Builder function that provides constraints and screen size
  final Widget Function(
    BuildContext context, 
    BoxConstraints constraints,
    ScreenSize screenSize,
  ) builder;

  /// Constructor
  const ResponsiveBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = _getScreenSize(context);
        return builder(context, constraints, screenSize);
      },
    );
  }

  ScreenSize _getScreenSize(BuildContext context) {
    final width = context.screenWidth;
    
    if (width < Breakpoints.sm) return ScreenSize.xs;
    if (width < Breakpoints.md) return ScreenSize.sm;
    if (width < Breakpoints.lg) return ScreenSize.md;
    if (width < Breakpoints.xl) return ScreenSize.lg;
    return ScreenSize.xl;
  }
}

/// Enum representing the current screen size category
enum ScreenSize {
  /// Extra small screens (<400px)
  xs,
  
  /// Small screens (400px-599px)
  sm,
  
  /// Medium screens (600px-839px)
  md,
  
  /// Large screens (840px-1199px)
  lg,
  
  /// Extra large screens (≥1200px)
  xl,
}