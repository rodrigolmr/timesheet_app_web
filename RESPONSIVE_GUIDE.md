# Responsive Design Guide

This document provides guidelines for implementing responsive design in the Timesheet App. It explains the centralized responsive system, how to use it, and examples of implementation in different components.

## Table of Contents

1. [Introduction](#introduction)
2. [Responsive System Overview](#responsive-system-overview)
3. [Using the Responsive System](#using-the-responsive-system)
   - [Responsive Values](#responsive-values)
   - [Responsive Layout](#responsive-layout)
   - [Predefined Helpers](#predefined-helpers)
4. [Implementation Examples](#implementation-examples)
   - [Adapting Existing Widgets](#adapting-existing-widgets)
   - [Creating New Responsive Screens](#creating-new-responsive-screens)
5. [Best Practices](#best-practices)

## Introduction

The Timesheet App needs to support a wide range of screen sizes, from mobile devices (320px width) to desktop browsers. Our responsive design system provides a centralized way to manage breakpoints, spacing, font sizes, and other UI elements to ensure consistency across the entire application.

All responsive logic is contained in `lib/src/core/responsive/responsive.dart`, which provides extensions and widgets to make implementing responsive design simple and consistent.

## Responsive System Overview

The system is built around these key components:

1. **Breakpoints**: Defined screen width thresholds
   - xs: 320px (small mobile)
   - sm: 400px (regular mobile)
   - md: 600px (small tablet)
   - lg: 840px (large tablet/small desktop)
   - xl: 1200px (desktop)

2. **ResponsiveContext**: Extension on BuildContext providing:
   - Screen size detection methods
   - Responsive value selection based on screen size
   - Predefined responsive values for common UI elements

3. **ResponsiveLayout**: Widget to display different layouts based on screen size

4. **ResponsiveContainer**: Widget to constrain content width based on screen size

## Using the Responsive System

### Responsive Values

The most powerful feature is the `responsive()` method, which allows you to define different values for different screen sizes:

```dart
// Setting a font size that changes with screen size
final fontSize = context.responsive<double>(
  xs: 14,  // Extra small screens (<400px)
  sm: 16,  // Small screens (400px-599px)
  md: 18,  // Medium screens (600px-839px)
  lg: 20,  // Large screens (840px-1199px)
  xl: 22,  // Extra large screens (≥1200px)
);

// Using it in a Text widget
Text(
  'Hello World',
  style: TextStyle(fontSize: fontSize),
)
```

Only the `xs` value is required; others are optional. If a size is not specified, it falls back to the next smaller defined size.

### Responsive Layout

For screens that need completely different layouts across devices:

```dart
ResponsiveLayout(
  // Mobile layout (required)
  mobile: SingleChildScrollView(
    child: Column(
      children: [
        // Mobile layout widgets
      ],
    ),
  ),
  
  // Tablet layout (optional, falls back to mobile)
  tablet: Row(
    children: [
      // Tablet layout widgets
    ],
  ),
  
  // Desktop layout (optional, falls back to tablet or mobile)
  desktop: Row(
    children: [
      // Desktop layout with sidebar
      Expanded(
        flex: 1,
        child: SidebarMenu(),
      ),
      Expanded(
        flex: 3,
        child: MainContent(),
      ),
    ],
  ),
)
```

### Predefined Helpers

The system includes many predefined values:

```dart
// Screen size checks
if (context.isMobile) {
  // Do something for mobile
}

// Font sizes
Text(
  'Title',
  style: TextStyle(
    fontSize: context.fontSizeTitle,
    fontWeight: FontWeight.bold,
  ),
)

// Spacing and padding
Container(
  padding: context.padding,
  // or
  padding: EdgeInsets.all(context.spacing),
  
  // Specific horizontal padding
  padding: context.horizontalPadding,
)

// Button and icon sizes
Icon(
  Icons.home,
  size: context.iconSizeMedium,
)

// Border radius
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(context.borderRadiusMedium),
  ),
)
```

## Implementation Examples

### Adapting Existing Widgets

#### BaseLayout Widget:

```dart
class BaseLayout extends StatelessWidget {
  final Widget child;
  final String title;

  const BaseLayout({
    Key? key,
    required this.child,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Responsive header
          SafeArea(
            bottom: false,
            child: Container(
              height: context.responsive(xs: 50.0, md: 60.0, xl: 70.0),
              padding: context.horizontalPadding,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                )],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Menu icon with responsive size
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.menu,
                      color: const Color(0xFF0205D3),
                      size: context.iconSizeLarge,
                    ),
                    // Menu items...
                  ),

                  // Title with responsive font size
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                      fontSize: context.fontSizeHeadline,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0205D3),
                    ),
                  ),

                  // Spacer
                  SizedBox(width: context.iconSizeLarge),
                ],
              ),
            ),
          ),
          
          // Content
          Expanded(child: child),
        ],
      ),
    );
  }
}
```

#### CustomInputField Widget:

```dart
class CustomInputField extends StatelessWidget {
  // Properties...

  @override
  Widget build(BuildContext context) {
    const Color appBlueColor = Color(0xFF0205D3);
    const Color appYellowColor = Color(0xFFFFFDD0);
    
    // Use responsive width instead of fixed calculation
    final double fieldWidth = context.screenWidth - context.spacing * 2.5;

    return Container(
      width: fieldWidth < 0 ? 0 : fieldWidth,
      height: context.responsive(xs: 36.0, sm: 40.0, md: 46.0, lg: 50.0),
      // Rest of the widget...
      child: TextField(
        // TextField properties...
        style: TextStyle(
          fontSize: context.fontSizeBody,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: context.fontSizeBody,
            color: Colors.black,
          ),
          floatingLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: context.fontSizeCaption,
            color: appBlueColor,
          ),
          // Rest of decoration...
        ),
      ),
    );
  }
}
```

#### CustomButton Widget:

```dart
@override
Widget build(BuildContext context) {
  final config = _getButtonConfig();
  
  // Use responsive button size
  final buttonSize = context.responsive<double>(
    xs: 50.0,
    sm: 60.0,
    md: 70.0,
    lg: 80.0,
    xl: 90.0,
  );
  
  // Responsive icon and text sizes
  final iconSize = context.responsive<double>(
    xs: 20.0,
    sm: 24.0,
    md: 28.0,
    lg: 32.0,
    xl: 36.0,
  );
  
  final fontSize = context.responsive<double>(
    xs: 10.0,
    sm: 12.0,
    md: 14.0,
    lg: 16.0,
    xl: 18.0,
  );
  
  return SizedBox(
    width: buttonSize,
    height: buttonSize,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: config['backgroundColor'],
        side: BorderSide(
          color: config['borderColor'],
          width: context.responsive(xs: 2.0, md: 3.0, lg: 4.0),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.borderRadiusSmall),
        ),
        padding: EdgeInsets.zero,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (config['hasIcon']) ...[
            FaIcon(
              config['faIcon'],
              size: iconSize,
              color: config['iconColor'],
            ),
            SizedBox(height: context.responsive(xs: 2.0, md: 4.0, lg: 6.0)),
          ],
          Text(
            config['label'],
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: config['textColor'],
              height: config['lineHeight'],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
```

### Creating New Responsive Screens

```dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: "Timesheet",
      child: ResponsiveLayout(
        // Mobile layout (portrait phones)
        mobile: _buildMobileLayout(context),
        
        // Tablet layout
        tablet: _buildTabletLayout(context),
        
        // Desktop layout
        desktop: _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: context.spacing * 4),
          const LogoText(),
          SizedBox(height: context.spacing * 3),
          _buildButtonGrid(context, columns: 2),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: context.spacing * 4),
          const LogoText(),
          SizedBox(height: context.spacing * 3),
          _buildButtonGrid(context, columns: 3),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // Sidebar (30% width)
        Container(
          width: context.screenWidth * 0.3,
          color: Colors.grey.shade100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LogoText(),
              SizedBox(height: context.spacing * 2),
              Text(
                "Welcome to Timesheet App",
                style: TextStyle(
                  fontSize: context.fontSizeSubtitle,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        
        // Main content (70% width)
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: context.spacing * 4),
                _buildButtonGrid(context, columns: 4),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonGrid(BuildContext context, {required int columns}) {
    // Calculate spacing between buttons
    final spacing = context.responsive(
      xs: 10.0,
      md: 15.0,
      lg: 20.0,
      xl: 25.0,
    );
    
    return Padding(
      padding: context.horizontalPadding,
      child: Wrap(
        spacing: spacing,
        runSpacing: spacing * 1.5,
        alignment: WrapAlignment.center,
        children: [
          CustomButton(
            type: ButtonType.sheetsButton,
            onPressed: () {
              Navigator.pushNamed(context, '/timesheets');
            },
          ),
          // More buttons...
        ],
      ),
    );
  }
}
```

## Best Practices

1. **Always use the responsive system** for dimensions, font sizes, and spacing, rather than hard-coded values.

2. **Keep layouts simple** for mobile devices, and progressively enhance for larger screens.

3. **Test all breakpoints** to ensure your UI looks good at all sizes. Test the following widths at minimum:
   - 320px (small mobile)
   - 400px (mobile)
   - 600px (small tablet)
   - 840px (large tablet)
   - 1200px (desktop)

4. **Don't nest ResponsiveLayout widgets** - it makes the code hard to follow. Instead, create methods that return different layouts.

5. **Use predefined responsive helpers** whenever possible for consistency.

6. **Avoid fixed pixel dimensions** that don't adapt to screen size.

7. **Consider orientation changes** for tablet devices - sometimes a different layout works better in landscape mode.

8. **Make text readable at all sizes** - ensure font sizes are never too small on mobile or too large on desktop.

9. **Use constraints** for maximum width on large screens to prevent content from being too stretched out.

10. **Be mindful of touch targets** on mobile - buttons and interactive elements should be at least 44x44 pts.

By following these guidelines and using the responsive system, you can ensure your app provides a great user experience across all devices from mobile to desktop, while maintaining a centralized approach to responsive design.