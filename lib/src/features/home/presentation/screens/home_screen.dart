import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive_grid.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/app_header.dart';
import 'package:timesheet_app_web/src/core/widgets/navigation/navigation.dart';
import 'package:timesheet_app_web/src/core/widgets/logo/logo.dart';
import 'package:timesheet_app_web/src/core/navigation/routes.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:timesheet_app_web/src/features/user/presentation/providers/user_providers.dart';
import 'package:timesheet_app_web/src/features/home/presentation/providers/home_providers.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/notification_providers.dart';
import 'package:timesheet_app_web/src/features/job_record/domain/enums/job_record_status.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppHeader(
        title: '',
        elevation: 4.0,
        showNavigationMenu: true,
        showBackButton: false,
      ),
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(context, ref),
        tablet: _buildTabletLayout(context, ref),
        desktop: _buildDesktopLayout(context, ref),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: context.dimensions.spacingM,
        vertical: context.dimensions.spacingL,
      ),
      child: Column(
        children: [
          _buildNotificationBanner(context, ref),
          _buildWelcomeSection(context, ref),
          SizedBox(height: context.dimensions.spacingXL),
          _buildFeatureCards(context, ref, columns: 2),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: context.dimensions.spacingL,
        vertical: context.dimensions.spacingXL,
      ),
      child: Column(
        children: [
          _buildNotificationBanner(context, ref),
          _buildWelcomeSection(context, ref),
          SizedBox(height: context.dimensions.spacingXL),
          _buildFeatureCards(context, ref, columns: 3),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, WidgetRef ref) {
    return ResponsiveContainer(
      maxWidthXl: 1200,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.dimensions.spacingXL),
        child: Column(
          children: [
            _buildNotificationBanner(context, ref),
            _buildWelcomeSection(context, ref),
            SizedBox(height: context.dimensions.spacingXL * 1.5),
            _buildFeatureCards(context, ref, columns: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProfileProvider);
    
    return Column(
      children: [
        // Logo
        Container(
          constraints: BoxConstraints(
            maxWidth: context.responsive<double>(
              xs: 250,
              sm: 300,
              md: 350,
              lg: 400,
            ),
          ),
          child: AppLogo(
            displayMode: LogoDisplayMode.vertical,
            small: false,
            centered: true,
          ),
        ),
        
        SizedBox(height: context.dimensions.spacingL),
        
        // Welcome message
        currentUserAsync.when(
          data: (user) => Text(
            user != null 
              ? 'Welcome back, ${user.firstName} ${user.lastName}!'
              : 'Welcome!',
            style: context.responsive<TextStyle>(
              xs: context.textStyles.title,
              sm: context.textStyles.subtitle,
              md: context.textStyles.headline,
            ),
            textAlign: TextAlign.center,
          ),
          loading: () => const CircularProgressIndicator(),
          error: (error, stackTrace) {
            debugPrint('Error loading user profile: $error');
            return Text(
              'Welcome!',
              style: context.textStyles.headline,
              textAlign: TextAlign.center,
            );
          },
        ),
      ],
    );
  }

  Widget _buildFeatureCards(BuildContext context, WidgetRef ref, {required int columns}) {
    return ResponsiveGrid(
      spacing: context.responsive<double>(
        xs: context.dimensions.spacingS,
        sm: context.dimensions.spacingM,
        md: context.dimensions.spacingL,
      ),
      xsColumns: 2,  // Sempre 2 colunas em telas pequenas
      smColumns: 2,  // Manter 2 colunas mesmo em sm
      mdColumns: columns,
      lgColumns: columns,
      xlColumns: columns > 4 ? 6 : columns,
      children: _getFeatureCards(context, ref),
    );
  }

  List<Widget> _getFeatureCards(BuildContext context, WidgetRef ref) {
    final navigationItemsAsync = ref.watch(filteredHomeNavigationItemsProvider);
    
    return navigationItemsAsync.when(
      data: (items) => items.map((item) => NavigationCard(
        title: item.title,
        description: item.description,
        icon: item.icon,
        route: item.route,
        color: context.categoryColorByName(item.categoryName),
        isActive: item.isActive,
      )).toList(),
      loading: () => [
        const Center(child: CircularProgressIndicator()),
      ],
      error: (error, _) {
        debugPrint('Error loading navigation items: $error');
        return [];
      },
    );
  }

  Widget _buildNotificationBanner(BuildContext context, WidgetRef ref) {
    final pendingCount = ref.watch(pendingJobRecordsCountProvider);
    
    // Only show banner for managers/admins with pending approvals
    if (pendingCount == 0) {
      return const SizedBox.shrink();
    }
    
    return Container(
      margin: EdgeInsets.only(bottom: context.dimensions.spacingL),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
        child: InkWell(
          onTap: () {
            // Navigate to job records with pending filter
            context.go('/job-records');
          },
          borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
          child: Container(
            padding: EdgeInsets.all(context.dimensions.spacingM),
            decoration: BoxDecoration(
              color: context.colors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
              border: Border.all(
                color: context.colors.warning.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(context.dimensions.spacingS),
                  decoration: BoxDecoration(
                    color: context.colors.warning.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(context.dimensions.borderRadiusS),
                  ),
                  child: Icon(
                    Icons.pending_actions,
                    color: context.colors.warning,
                    size: context.responsive<double>(
                      xs: 24,
                      sm: 28,
                      md: 32,
                    ),
                  ),
                ),
                SizedBox(width: context.dimensions.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pending Approvals',
                        style: context.textStyles.subtitle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colors.warning,
                        ),
                      ),
                      SizedBox(height: context.dimensions.spacingXS),
                      Text(
                        'You have $pendingCount job record${pendingCount > 1 ? 's' : ''} waiting for approval',
                        style: context.textStyles.body.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: context.colors.warning,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}