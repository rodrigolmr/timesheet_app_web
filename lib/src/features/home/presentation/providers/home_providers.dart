import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:timesheet_app_web/src/core/navigation/routes.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/permission_providers.dart';

part 'home_providers.g.dart';

/// Model for navigation cards on home screen
class HomeNavigationItem {
  final String title;
  final String description;
  final IconData icon;
  final String route;
  final String categoryName;
  final bool isActive;

  const HomeNavigationItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
    required this.categoryName,
    required this.isActive,
  });
}

/// Provider for home navigation items
@riverpod
List<HomeNavigationItem> homeNavigationItems(HomeNavigationItemsRef ref) {
  return [
    HomeNavigationItem(
      title: 'Job Records',
      description: 'View and manage all job records',
      icon: Icons.view_list,
      route: AppRoute.jobRecords.path,
      categoryName: 'timesheet',
      isActive: true,
    ),
    HomeNavigationItem(
      title: 'Expenses',
      description: 'Manage and submit expense reports',
      icon: Icons.receipt_long,
      route: AppRoute.expenses.path,
      categoryName: 'receipt',
      isActive: true,
    ),
    HomeNavigationItem(
      title: 'Company Cards',
      description: 'View and manage company credit cards',
      icon: Icons.credit_card,
      route: AppRoute.companyCards.path,
      categoryName: 'card',
      isActive: true,
    ),
    HomeNavigationItem(
      title: 'Employees',
      description: 'Manage employee information',
      icon: Icons.people,
      route: AppRoute.employees.path,
      categoryName: 'worker',
      isActive: true,
    ),
    HomeNavigationItem(
      title: 'Users',
      description: 'Manage system users',
      icon: Icons.manage_accounts,
      route: AppRoute.users.path,
      categoryName: 'user',
      isActive: true,
    ),
    HomeNavigationItem(
      title: 'Reports',
      description: 'Generate and view reports',
      icon: Icons.bar_chart,
      route: '/reports', // TODO: Update with AppRoute.reports.path when route is added
      categoryName: 'pdf',
      isActive: false,
    ),
    HomeNavigationItem(
      title: 'Settings',
      description: 'Configure app preferences',
      icon: Icons.settings,
      route: AppRoute.settings.path,
      categoryName: 'settings',
      isActive: true,
    ),
  ];
}

/// Provider for filtered home navigation items based on user permissions
@riverpod
Future<List<HomeNavigationItem>> filteredHomeNavigationItems(
  FilteredHomeNavigationItemsRef ref,
) async {
  final allItems = ref.watch(homeNavigationItemsProvider);
  final allowedRoutes = await ref.watch(allowedRoutesProvider.future);
  
  // Filter items based on allowed routes
  return allItems.where((item) {
    // Skip inactive items
    if (!item.isActive) return false;
    
    // Find matching AppRoute
    final matchingRoute = AppRoute.values.where((route) => route.path == item.route).firstOrNull;
    
    // If no matching route found or route not allowed, hide the item
    if (matchingRoute == null) return false;
    
    return allowedRoutes.contains(matchingRoute);
  }).toList();
}