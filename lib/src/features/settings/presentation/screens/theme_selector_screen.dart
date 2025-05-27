import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timesheet_app_web/src/core/theme/theme.dart';
import 'package:timesheet_app_web/src/core/widgets/app_header.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';

/// Theme selector screen for the application
class ThemeSelectorScreen extends ConsumerWidget {
  const ThemeSelectorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get current theme
    final currentTheme = ref.watch(themeControllerProvider);
    
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppHeader(
        title: 'Theme Selection',
        subtitle: 'Choose your preferred theme',
        showBackButton: true,
        showNavigationMenu: false,
        onBackPressed: () => context.go('/settings'),
      ),
      body: SingleChildScrollView(
        child: ResponsiveContainer(
          maxWidthXl: 800,
          child: Padding(
            padding: EdgeInsets.all(
              context.isMobile
                ? context.dimensions.spacingM
                : context.dimensions.spacingL,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // No header text needed since it's in AppHeader
            
                // Blue Theme (Light)
                _buildThemeCard(
                  context,
                  ref,
                  title: 'Corporate Blue',
                  description: 'Default theme with corporate blue tones',
                  variant: ThemeVariant.light,
                  isSelected: currentTheme.variant == ThemeVariant.light,
                ),
                
                // Dark Theme
                _buildThemeCard(
                  context,
                  ref,
                  title: 'Dark Theme',
                  description: 'Dark theme for low-light environments',
                  variant: ThemeVariant.dark,
                  isSelected: currentTheme.variant == ThemeVariant.dark,
                ),
                
                // Pink Theme (Feminine)
                _buildThemeCard(
                  context,
                  ref,
                  title: 'Pink Theme',
                  description: 'Modern and vibrant theme with pink tones',
                  variant: ThemeVariant.feminine,
                  isSelected: currentTheme.variant == ThemeVariant.feminine,
                ),
                
                // Green Theme
                _buildThemeCard(
                  context,
                  ref,
                  title: 'Green Theme',
                  description: 'Calming theme with green tones',
                  variant: ThemeVariant.green,
                  isSelected: currentTheme.variant == ThemeVariant.green,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  /// Selects a theme and shows confirmation feedback
  void _selectTheme(BuildContext context, WidgetRef ref, ThemeVariant variant) {
    ref.read(themeControllerProvider.notifier).setTheme(variant);
    
    // Get theme name for feedback
    String themeName;
    switch (variant) {
      case ThemeVariant.light:
        themeName = 'Corporate Blue';
        break;
      case ThemeVariant.dark:
        themeName = 'Dark Theme';
        break;
      case ThemeVariant.feminine:
        themeName = 'Pink Theme';
        break;
      case ThemeVariant.green:
        themeName = 'Green Theme';
        break;
    }
    
    // Show SnackBar with selected theme
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$themeName applied successfully',
          style: context.textStyles.body.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: _getColorForVariant(variant),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
        ),
      ),
    );
  }
  
  /// Builds a card for each theme option
  Widget _buildThemeCard(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String description,
    required ThemeVariant variant,
    required bool isSelected,
  }) {
    // Define colors based on variant
    final Color primaryColor = _getColorForVariant(variant);
    final Color backgroundColor = isSelected 
      ? primaryColor.withValues(alpha: 0.1) 
      : context.colors.surface;
    
    return Card(
      margin: EdgeInsets.only(
        bottom: context.isMobile
          ? context.dimensions.spacingM
          : context.dimensions.spacingL,
      ),
      elevation: isSelected ? 2 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
        side: BorderSide(
          color: isSelected ? primaryColor : context.colors.outline.withValues(alpha: 0.3),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Semantics(
        label: '$title theme',
        hint: 'Select $title theme. $description',
        button: true,
        checked: isSelected,
        enabled: true,
        child: InkWell(
          onTap: () => _selectTheme(context, ref, variant),
          borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
          child: Container(
            padding: EdgeInsets.all(
              context.isMobile
                ? context.dimensions.spacingM
                : context.dimensions.spacingL,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Color circle representing the theme
                    Container(
                      width: context.isMobile ? 36 : 44,
                      height: context.isMobile ? 36 : 44,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getIconForVariant(variant),
                        color: Colors.white,
                        size: context.isMobile ? 20 : 24,
                      ),
                    ),
                    SizedBox(width: context.dimensions.spacingM),
                    
                    // Title and description
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: context.textStyles.subtitle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: context.dimensions.spacingXS),
                          Text(
                            description,
                            style: context.textStyles.body.copyWith(
                              color: context.colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Selection icon
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: primaryColor,
                        size: context.isMobile ? 24 : 28,
                      ),
                  ],
                ),
                
                SizedBox(height: context.dimensions.spacingM),
                
                // Theme color samples
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildColorSample(
                      context,
                      color: primaryColor,
                      label: 'Primary',
                    ),
                    _buildColorSample(
                      context,
                      color: _getLighterColorForVariant(variant),
                      label: 'Secondary',
                    ),
                    _buildColorSample(
                      context,
                      color: _getSuccessColorForVariant(variant),
                      label: 'Success',
                    ),
                    _buildColorSample(
                      context,
                      color: _getWarningColorForVariant(variant),
                      label: 'Warning',
                    ),
                    _buildColorSample(
                      context,
                      color: _getErrorColorForVariant(variant),
                      label: 'Error',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  /// Builds a color sample for the theme
  Widget _buildColorSample(
    BuildContext context, {
    required Color color,
    required String label,
  }) {
    return Semantics(
      label: '$label color sample',
      hint: '$label color in selected theme',
      child: Column(
        children: [
          Container(
            width: context.isMobile ? 28 : 32,
            height: context.isMobile ? 28 : 32,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: context.colors.outline.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
          ),
          SizedBox(height: context.dimensions.spacingXS),
          Text(
            label,
            style: context.textStyles.caption.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Returns the icon for the theme variant
  IconData _getIconForVariant(ThemeVariant variant) {
    switch (variant) {
      case ThemeVariant.light:
        return Icons.wb_sunny;
      case ThemeVariant.dark:
        return Icons.nightlight_round;
      case ThemeVariant.feminine:
        return Icons.spa;
      case ThemeVariant.green:
        return Icons.forest;
    }
  }
  
  /// Returns the primary color for a theme variant
  Color _getColorForVariant(ThemeVariant variant) {
    // Use exact colors from defined palettes
    switch (variant) {
      case ThemeVariant.light:
        return const Color(0xFF1565C0); // Azul Corporativo da Palette4CorporateAmber
      case ThemeVariant.dark:
        return const Color(0xFF0D47A1); // Azul escuro para dark mode
      case ThemeVariant.feminine:
        return const Color(0xFFE91E63); // Rosa principal da Palette5PinkSoft
      case ThemeVariant.green:
        return const Color(0xFF00897B); // Verde teal da Palette6GreenFresh
    }
  }
  
  /// Returns the secondary color for a theme variant
  Color _getLighterColorForVariant(ThemeVariant variant) {
    switch (variant) {
      case ThemeVariant.light:
        return const Color(0xFF1E88E5); // primaryLight da Palette4CorporateAmber
      case ThemeVariant.dark:
        return const Color(0xFF1976D2); // Secondary para dark mode
      case ThemeVariant.feminine:
        return const Color(0xFFF06292); // primaryLight da Palette5PinkSoft
      case ThemeVariant.green:
        return const Color(0xFF4DB6AC); // primaryLight da Palette6GreenFresh
    }
  }
  
  /// Returns the success color for a theme variant
  Color _getSuccessColorForVariant(ThemeVariant variant) {
    switch (variant) {
      case ThemeVariant.light:
        return const Color(0xFF388E3C); // success da Palette4CorporateAmber
      case ThemeVariant.dark:
        return const Color(0xFF2E7D32); // success para dark mode
      case ThemeVariant.feminine:
        return const Color(0xFF4CAF50); // success da Palette5PinkSoft
      case ThemeVariant.green:
        return const Color(0xFF4CAF50); // success da Palette6GreenFresh
    }
  }
  
  /// Returns the warning color for a theme variant
  Color _getWarningColorForVariant(ThemeVariant variant) {
    switch (variant) {
      case ThemeVariant.light:
        return const Color(0xFFFFA000); // warning da Palette4CorporateAmber
      case ThemeVariant.dark:
        return const Color(0xFFFF8F00); // warning para dark mode
      case ThemeVariant.feminine:
        return const Color(0xFFFF9800); // warning da Palette5PinkSoft
      case ThemeVariant.green:
        return const Color(0xFFFFB300); // warning da Palette6GreenFresh
    }
  }
  
  /// Returns the error color for a theme variant
  Color _getErrorColorForVariant(ThemeVariant variant) {
    switch (variant) {
      case ThemeVariant.light:
        return const Color(0xFFD32F2F); // error da Palette4CorporateAmber
      case ThemeVariant.dark:
        return const Color(0xFFC62828); // error para dark mode
      case ThemeVariant.feminine:
        return const Color(0xFFF44336); // error da Palette5PinkSoft
      case ThemeVariant.green:
        return const Color(0xFFE53935); // error da Palette6GreenFresh
    }
  }
}