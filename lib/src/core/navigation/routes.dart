import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/screens/login_screen.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:timesheet_app_web/src/features/home/presentation/screens/home_screen.dart';
import 'package:timesheet_app_web/src/features/employee/presentation/screens/employees_screen.dart';
import 'package:timesheet_app_web/src/features/employee/presentation/screens/employee_details_screen.dart';
import 'package:timesheet_app_web/src/features/settings/presentation/screens/theme_settings_screen.dart';
import 'package:timesheet_app_web/src/features/settings/presentation/screens/theme_selector_screen.dart';
import 'package:timesheet_app_web/src/features/settings/presentation/screens/settings_screen.dart';
import 'package:timesheet_app_web/src/features/database/presentation/screens/database_screen.dart';
import 'package:timesheet_app_web/src/features/timesheet_create/presentation/screens/timesheet_create_screen.dart';

part 'routes.g.dart';

enum AppRoute {
  login('/login'),
  home('/'),
  employees('/employees'),
  employeeDetails('/employees/:id'),
  settings('/settings'),
  themeSettings('/settings/theme'),
  themeSelector('/settings/theme-selector'),
  database('/settings/database'),
  timesheetCreate('/timesheet/create');

  const AppRoute(this.path);
  final String path;
}

class AuthNotifier extends ChangeNotifier {
  AuthNotifier(this.ref) {
    ref.listen(authStateProvider, (_, state) {
      notifyListeners();
    });
  }

  final Ref ref;
}

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  final authNotifier = AuthNotifier(ref);
  
  return GoRouter(
    initialLocation: AppRoute.home.path,
    debugLogDiagnostics: true,
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final isLoggingIn = state.matchedLocation == AppRoute.login.path;
      
      return authState.when(
        data: (user) {
          if (user == null) {
            // No user authenticated
            return isLoggingIn ? null : AppRoute.login.path;
          }
          
          // User is authenticated
          if (isLoggingIn) {
            return AppRoute.home.path;
          }
          
          return null;
        },
        loading: () => null,
        error: (_, __) => isLoggingIn ? null : AppRoute.login.path,
      );
    },
    routes: [
      GoRoute(
        path: AppRoute.login.path,
        name: AppRoute.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoute.home.path,
        name: AppRoute.home.name,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoute.employees.path,
        name: AppRoute.employees.name,
        builder: (context, state) => const EmployeesScreen(),
      ),
      GoRoute(
        path: AppRoute.employeeDetails.path,
        name: AppRoute.employeeDetails.name,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return EmployeeDetailsScreen(employeeId: id);
        },
      ),
      GoRoute(
        path: AppRoute.settings.path,
        name: AppRoute.settings.name,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoute.themeSettings.path,
        name: AppRoute.themeSettings.name,
        builder: (context, state) => const ThemeSettingsScreen(),
      ),
      GoRoute(
        path: AppRoute.themeSelector.path,
        name: AppRoute.themeSelector.name,
        builder: (context, state) => const ThemeSelectorScreen(),
      ),
      GoRoute(
        path: AppRoute.database.path,
        name: AppRoute.database.name,
        builder: (context, state) => const DatabaseScreen(),
      ),
      GoRoute(
        path: AppRoute.timesheetCreate.path,
        name: AppRoute.timesheetCreate.name,
        builder: (context, state) => const TimesheetCreateScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}