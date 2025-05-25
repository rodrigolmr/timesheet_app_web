import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive_grid.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/app_header.dart';
import 'package:timesheet_app_web/src/core/widgets/navigation/navigation.dart';
import 'package:timesheet_app_web/src/core/navigation/routes.dart';
import 'package:timesheet_app_web/src/features/user/presentation/providers/user_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserProfileAsync = ref.watch(currentUserProfileProvider);
    
    return Scaffold(
      appBar: AppHeader(
        title: 'Settings',
        showBackButton: false,
        showNavigationMenu: true,
      ),
      body: currentUserProfileAsync.when(
        data: (userProfile) => ResponsiveLayout(
          mobile: _buildMobileLayout(context, ref, userProfile),
          tablet: _buildTabletLayout(context, ref, userProfile),
          desktop: _buildDesktopLayout(context, ref, userProfile),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error loading user data: $error',
            style: context.textStyles.body.copyWith(
              color: context.colors.error,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, WidgetRef ref, dynamic currentUser) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: context.dimensions.spacingM,
        vertical: context.dimensions.spacingL,
      ),
      child: Column(
        children: [
          _buildUserInfoSection(context, ref, currentUser),
          const SizedBox(height: 32.0), // spacingXL = 32
          _buildFeatureCards(context, ref),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, WidgetRef ref, dynamic currentUser) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: context.dimensions.spacingL,
        vertical: context.dimensions.spacingXL,
      ),
      child: Column(
        children: [
          _buildUserInfoSection(context, ref, currentUser),
          const SizedBox(height: 32.0), // spacingXL = 32
          _buildFeatureCards(context, ref),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, WidgetRef ref, dynamic currentUser) {
    return ResponsiveContainer(
      maxWidthXl: 1200,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.dimensions.spacingXL),
        child: Column(
          children: [
            _buildUserInfoSection(context, ref, currentUser),
            const SizedBox(height: 48.0), // spacingXL * 1.5 = 48
            _buildFeatureCards(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCards(BuildContext context, WidgetRef ref) {
    final allCards = [
      // Quick Actions
      NavigationCard(
        title: 'Themes',
        description: 'Choose theme',
        icon: Icons.palette,
        route: AppRoute.themeSelector.path,
        color: context.colors.primary,
        isActive: true,
      ),
      NavigationCard(
        title: 'Profile',
        description: 'Your info',
        icon: Icons.person_outline,
        route: '/settings/profile',
        color: context.categoryColorByName('worker'),
        isActive: false,
      ),
      NavigationCard(
        title: 'Notifications',
        description: 'Preferences',
        icon: Icons.notifications_outlined,
        route: '/settings/notifications',
        color: context.categoryColorByName('card'),
        isActive: false,
      ),
      NavigationCard(
        title: 'Security',
        description: 'Password',
        icon: Icons.security,
        route: '/settings/security',
        color: context.colors.warning,
        isActive: false,
      ),
      // Management
      NavigationCard(
        title: 'Database',
        description: 'View data',
        icon: Icons.storage,
        route: AppRoute.database.path,
        color: context.categoryColorByName('timesheet'),
        isActive: true,
      ),
      NavigationCard(
        title: 'Users',
        description: 'Manage users',
        icon: Icons.group,
        route: '/settings/users',
        color: context.categoryColorByName('receipt'),
        isActive: false,
      ),
      NavigationCard(
        title: 'Reports',
        description: 'Generate',
        icon: Icons.assessment,
        route: '/settings/reports',
        color: context.colors.secondary,
        isActive: false,
      ),
      NavigationCard(
        title: 'Backup',
        description: 'Backup data',
        icon: Icons.backup,
        route: '/settings/backup',
        color: context.colors.success,
        isActive: false,
      ),
      // Advanced
      NavigationCard(
        title: 'Image Processing',
        description: 'Debug info',
        icon: Icons.image_search,
        route: '/settings/image-processing-debug',
        color: context.colors.primary,
        isActive: true,
      ),
      NavigationCard(
        title: 'Debug',
        description: 'Dev tools',
        icon: Icons.bug_report,
        route: '/settings/debug',
        color: context.colors.error,
        isActive: false,
      ),
      NavigationCard(
        title: 'System',
        description: 'View info',
        icon: Icons.info_outline,
        route: '/settings/system',
        color: context.colors.textSecondary,
        isActive: false,
      ),
      NavigationCard(
        title: 'Logs',
        description: 'View logs',
        icon: Icons.article_outlined,
        route: '/settings/logs',
        color: context.categoryColorByName('receipt'),
        isActive: false,
      ),
      NavigationCard(
        title: 'About',
        description: 'App info',
        icon: Icons.help_outline,
        route: '/settings/about',
        color: context.colors.primary,
        isActive: false,
      ),
    ];

    return ResponsiveGrid(
      spacing: context.responsive<double>(
        xs: context.dimensions.spacingS,
        sm: context.dimensions.spacingM,
        md: context.dimensions.spacingL,
      ),
      xsColumns: 2,
      smColumns: 3,
      mdColumns: 4,
      lgColumns: 5,
      xlColumns: 6,
      children: allCards,
    );
  }

  Widget _buildUserInfoSection(
    BuildContext context,
    WidgetRef ref,
    dynamic currentUser,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(context.dimensions.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your information',
              style: context.textStyles.headline,
            ),
            const SizedBox(height: 16.0), // spacingM = 16
            if (currentUser == null)
              Text(
                'No user logged in',
                style: context.textStyles.body.copyWith(
                  color: context.colors.textSecondary,
                ),
              )
            else
              Column(
                children: [
                  _buildUserInfoRow(
                    context,
                    label: 'Name',
                    value: '${currentUser.firstName} ${currentUser.lastName}',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16.0), // spacingM = 16
                  _buildUserInfoRow(
                    context,
                    label: 'Email',
                    value: currentUser.email,
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 16.0), // spacingM = 16
                  _buildUserInfoRow(
                    context,
                    label: 'Role',
                    value: _formatRole(currentUser.role),
                    icon: Icons.work_outline,
                  ),
                  const SizedBox(height: 16.0), // spacingM = 16
                  _buildUserInfoRow(
                    context,
                    label: 'Status',
                    value: currentUser.isActive ? 'Active' : 'Inactive',
                    icon: Icons.circle,
                    statusColor: currentUser.isActive ? context.colors.success : context.colors.error,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoRow(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    Color? statusColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: context.dimensions.iconSizeM,
          color: statusColor ?? context.colors.primary,
        ),
        const SizedBox(width: 16.0), // spacingM = 16
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textStyles.caption.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              Text(
                value,
                style: context.textStyles.body,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatRole(String role) {
    return role.replaceAll('_', ' ').split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }
}