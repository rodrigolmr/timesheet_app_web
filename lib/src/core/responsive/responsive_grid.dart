import 'package:flutter/material.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';

/// A responsive grid layout that adapts the number of columns based on screen size
///
/// This widget is useful for creating grid layouts that adjust the number of columns
/// based on the available width, such as for dashboards, card layouts, etc.
///
/// Example usage:
/// ```dart
/// ResponsiveGrid(
///   children: [
///     for (var item in items)
///       ItemCard(item: item),
///   ],
/// )
/// ```
class ResponsiveGrid extends StatelessWidget {
  /// Children to display in the grid
  final List<Widget> children;
  
  /// Spacing between grid items
  final double? spacing;
  
  /// Number of columns for extra small screens
  final int xsColumns;
  
  /// Number of columns for small screens
  final int? smColumns;
  
  /// Number of columns for medium screens
  final int? mdColumns;
  
  /// Number of columns for large screens
  final int? lgColumns;
  
  /// Number of columns for extra large screens
  final int? xlColumns;
  
  /// Constructor
  const ResponsiveGrid({
    Key? key,
    required this.children,
    this.spacing,
    this.xsColumns = 1,
    this.smColumns,
    this.mdColumns,
    this.lgColumns,
    this.xlColumns,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final finalSpacing = spacing ?? context.spacing;
    
    // Determine number of columns based on screen width
    final columns = context.responsive<int>(
      xs: xsColumns,
      sm: smColumns ?? xsColumns,
      md: mdColumns ?? (smColumns ?? xsColumns),
      lg: lgColumns ?? (mdColumns ?? (smColumns ?? xsColumns)),
      xl: xlColumns ?? (lgColumns ?? (mdColumns ?? (smColumns ?? xsColumns))),
    );
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use the available width from constraints
        final availableWidth = constraints.maxWidth;
        
        // Calculate the width for each item
        final itemWidth = (availableWidth - (finalSpacing * (columns - 1))) / columns;
        
        // Constrain width to remain positive
        final constrainedWidth = itemWidth > 0 ? itemWidth : 50;
        
        return Wrap(
          spacing: finalSpacing,
          runSpacing: finalSpacing,
          children: children.map((child) {
            return SizedBox(
              width: constrainedWidth.toDouble(),
              child: child,
            );
          }).toList(),
        );
      },
    );
  }
}

/// A responsive grid that creates tiles that respect a specific aspect ratio
class ResponsiveGridTile extends StatelessWidget {
  /// Children to display in the grid
  final List<Widget> children;
  
  /// Spacing between grid items
  final double? spacing;
  
  /// Number of columns for extra small screens
  final int xsColumns;
  
  /// Number of columns for small screens
  final int? smColumns;
  
  /// Number of columns for medium screens
  final int? mdColumns;
  
  /// Number of columns for large screens
  final int? lgColumns;
  
  /// Number of columns for extra large screens
  final int? xlColumns;
  
  /// Aspect ratio of each tile (width / height)
  final double aspectRatio;

  /// Constructor
  const ResponsiveGridTile({
    Key? key,
    required this.children,
    this.spacing,
    this.xsColumns = 1,
    this.smColumns,
    this.mdColumns,
    this.lgColumns,
    this.xlColumns,
    this.aspectRatio = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final finalSpacing = spacing ?? context.spacing;
        
        // Determine number of columns based on screen width
        final columns = context.responsive<int>(
          xs: xsColumns,
          sm: smColumns ?? xsColumns,
          md: mdColumns ?? (smColumns ?? xsColumns),
          lg: lgColumns ?? (mdColumns ?? (smColumns ?? xsColumns)),
          xl: xlColumns ?? (lgColumns ?? (mdColumns ?? (smColumns ?? xsColumns))),
        );
        
        // Calculate available width
        final availableWidth = constraints.maxWidth;
        
        // Calculate item width
        final itemWidth = (availableWidth - (finalSpacing * (columns - 1))) / columns;
        final itemHeight = itemWidth / aspectRatio;
        
        return Wrap(
          spacing: finalSpacing,
          runSpacing: finalSpacing,
          children: children.map((child) {
            return SizedBox(
              width: itemWidth,
              height: itemHeight,
              child: child,
            );
          }).toList(),
        );
      },
    );
  }
}