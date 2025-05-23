import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:timesheet_app_web/src/core/navigation/routes.dart';

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
      title: 'Create Job Record',
      description: 'Create new job records',
      icon: Icons.add_chart,
      route: AppRoute.jobRecordCreate.path,
      categoryName: 'timesheet',
      isActive: true,
    ),
    HomeNavigationItem(
      title: 'Job Records',
      description: 'View and manage all job records',
      icon: Icons.view_list,
      route: AppRoute.jobRecords.path,
      categoryName: 'timesheet',
      isActive: true,
    ),
    HomeNavigationItem(
      title: 'Document Scanner',
      description: 'Scan documents and receipts',
      icon: Icons.document_scanner,
      route: AppRoute.documentScanner.path,
      categoryName: 'scanner',
      isActive: true,
    ),
    HomeNavigationItem(
      title: 'Expenses',
      description: 'Manage and submit expense reports',
      icon: Icons.receipt_long,
      route: '/expenses', // TODO: Update with AppRoute.expenses.path when route is added
      categoryName: 'receipt',
      isActive: false,
    ),
    HomeNavigationItem(
      title: 'Company Cards',
      description: 'View and manage company credit cards',
      icon: Icons.credit_card,
      route: '/company-cards', // TODO: Update with AppRoute.companyCards.path when route is added
      categoryName: 'card',
      isActive: false,
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