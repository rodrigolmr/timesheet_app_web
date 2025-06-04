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
import 'package:timesheet_app_web/src/features/auth/presentation/providers/permission_providers.dart';
import 'package:timesheet_app_web/src/features/user/domain/enums/user_role.dart';
import 'package:timesheet_app_web/src/core/widgets/dialogs/dialogs.dart';
import 'package:timesheet_app_web/src/features/settings/presentation/widgets/about_dialog.dart';

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
      child: _buildFeatureCards(context, ref),
    );
  }

  Widget _buildTabletLayout(BuildContext context, WidgetRef ref, dynamic currentUser) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: context.dimensions.spacingL,
        vertical: context.dimensions.spacingXL,
      ),
      child: _buildFeatureCards(context, ref),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, WidgetRef ref, dynamic currentUser) {
    return ResponsiveContainer(
      maxWidthXl: 1200,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.dimensions.spacingXL),
        child: _buildFeatureCards(context, ref),
      ),
    );
  }

  Widget _buildFeatureCards(BuildContext context, WidgetRef ref) {
    final userRoleAsync = ref.watch(currentUserRoleProvider);
    
    return userRoleAsync.when(
      data: (role) {
        final isAdmin = role == UserRole.admin;
        final isManager = role == UserRole.manager;
        final isManagerOrAdmin = isAdmin || isManager;
        
        // Cards ativos organizados na ordem solicitada
        final activeCards = <Widget>[];
        
        // 1. Profile (para todos)
        activeCards.add(
          NavigationCard(
            title: 'Profile',
            description: 'Your info',
            icon: Icons.person_outline,
            route: '/settings/profile',
            color: context.categoryColorByName('worker'),
            isActive: true,
            onTap: () => _showProfileDialog(context, ref),
          ),
        );
        
        // 2. Users (para managers e admins)
        if (isManagerOrAdmin) {
          activeCards.add(
            NavigationCard(
              title: 'Users',
              description: 'Manage system users',
              icon: Icons.manage_accounts,
              route: AppRoute.users.path,
              color: context.categoryColorByName('user'),
              isActive: true,
            ),
          );
        }
        
        // 3. Employees (para managers e admins)
        if (isManagerOrAdmin) {
          activeCards.add(
            NavigationCard(
              title: 'Employees',
              description: 'Manage employee information',
              icon: Icons.people,
              route: AppRoute.employees.path,
              color: context.categoryColorByName('worker'),
              isActive: true,
            ),
          );
        }
        
        // 4. Company Cards (para managers e admins)
        if (isManagerOrAdmin) {
          activeCards.add(
            NavigationCard(
              title: 'Company Cards',
              description: 'View and manage company credit cards',
              icon: Icons.credit_card,
              route: AppRoute.companyCards.path,
              color: context.categoryColorByName('card'),
              isActive: true,
            ),
          );
        }
        
        // 5. Themes (para todos)
        activeCards.add(
          NavigationCard(
            title: 'Themes',
            description: 'Choose theme',
            icon: Icons.palette,
            route: AppRoute.themeSelector.path,
            color: context.colors.primary,
            isActive: true,
          ),
        );
        
        // 6. About (para todos)
        activeCards.add(
          NavigationCard(
            title: 'About',
            description: 'App info',
            icon: Icons.help_outline,
            route: '/settings/about',
            color: context.colors.primary,
            isActive: true,
            onTap: () => _showAboutDialog(context),
          ),
        );
        
        // 7. Database (apenas para admin)
        if (isAdmin) {
          activeCards.add(
            NavigationCard(
              title: 'Database',
              description: 'View data',
              icon: Icons.storage,
              route: AppRoute.database.path,
              color: context.categoryColorByName('timesheet'),
              isActive: true,
            ),
          );
        }
        
        // Cards inativos (soon) - disponíveis para todos
        final inactiveCards = <Widget>[
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
        ];
        
        // Cards inativos exclusivos para admin
        if (isAdmin) {
          inactiveCards.addAll([
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
          ]);
        }
        
        // Combinar cards: ativos primeiro, depois inativos
        final allCards = [...activeCards, ...inactiveCards];

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
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'Error loading user role: $error',
          style: context.textStyles.body.copyWith(
            color: context.colors.error,
          ),
        ),
      ),
    );
  }

  void _showProfileDialog(BuildContext context, WidgetRef ref) {
    final currentUserProfileAsync = ref.read(currentUserProfileProvider);
    
    currentUserProfileAsync.when(
      data: (userProfile) {
        if (userProfile != null) {
          showAppDetailsDialog(
            context: context,
            title: 'Profile Information',
            icon: Icons.person,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildUserInfoRow(
                  context,
                  label: 'Name',
                  value: '${userProfile.firstName} ${userProfile.lastName}',
                  icon: Icons.person,
                ),
                const SizedBox(height: 16.0), // spacingM = 16
                _buildUserInfoRow(
                  context,
                  label: 'Email',
                  value: userProfile.email,
                  icon: Icons.email,
                ),
                const SizedBox(height: 16.0), // spacingM = 16
                _buildUserInfoRow(
                  context,
                  label: 'Role',
                  value: _formatRole(userProfile.role),
                  icon: Icons.work_outline,
                ),
                const SizedBox(height: 16.0), // spacingM = 16
                _buildUserInfoRow(
                  context,
                  label: 'Status',
                  value: userProfile.isActive ? 'Active' : 'Inactive',
                  icon: Icons.circle,
                  statusColor: userProfile.isActive ? context.colors.success : context.colors.error,
                ),
              ],
            ),
          );
        }
      },
      loading: () {},
      error: (error, _) {
        showErrorDialog(
          context: context,
          title: 'Error',
          message: 'Failed to load profile information',
        );
      },
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

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AboutAppDialog(),
    );
  }
}