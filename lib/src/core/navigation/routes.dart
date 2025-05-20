import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/screens/login_screen.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:timesheet_app_web/src/features/home/presentation/screens/home_screen.dart';
import 'package:timesheet_app_web/src/features/employee/presentation/screens/employees_placeholder.dart';
import 'package:timesheet_app_web/src/features/settings/presentation/screens/theme_settings_screen.dart';
import 'package:timesheet_app_web/src/features/settings/presentation/screens/theme_selector_screen.dart';
import 'package:timesheet_app_web/src/features/settings/presentation/screens/settings_screen.dart';
import 'package:timesheet_app_web/src/features/database/presentation/screens/database_screen.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/screens/job_record_create_screen.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/screens/job_records_screen.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/screens/job_record_details_screen.dart';
import 'package:timesheet_app_web/src/demo/week_grouping_demo.dart';

part 'routes.g.dart';

enum AppRoute {
  login('/login'),
  home('/'),
  // Rotas de funcionários foram removidas
  employees('/employees'),
  employeeDetails('/employees/:id'),
  settings('/settings'),
  themeSettings('/settings/theme'),
  themeSelector('/settings/theme-selector'),
  database('/settings/database'),
  jobRecordCreate('/job-record-create'),
  jobRecords('/job-records'),
  timesheetList('/timesheets'),
  jobRecordDetails('/job-records/:id'),
  weekGroupingDemo('/demo/week-grouping');

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
        builder: (context, state) => const EmployeesPlaceholder(),
      ),
      GoRoute(
        path: AppRoute.employeeDetails.path,
        name: AppRoute.employeeDetails.name,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return EmployeeDetailsPlaceholder(employeeId: id);
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
        path: AppRoute.jobRecordCreate.path,
        name: AppRoute.jobRecordCreate.name,
        builder: (context, state) => const JobRecordCreateScreen(),
      ),
      GoRoute(
        path: AppRoute.jobRecords.path,
        name: AppRoute.jobRecords.name,
        builder: (context, state) => const JobRecordsScreen(),
      ),
      GoRoute(
        path: AppRoute.timesheetList.path,
        name: AppRoute.timesheetList.name,
        builder: (context, state) => const JobRecordsScreen(),
      ),
      GoRoute(
        path: AppRoute.jobRecordDetails.path,
        name: AppRoute.jobRecordDetails.name,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return JobRecordDetailsScreen(recordId: id);
        },
      ),
      GoRoute(
        path: AppRoute.weekGroupingDemo.path,
        name: AppRoute.weekGroupingDemo.name,
        builder: (context, state) => const WeekGroupingDemo(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}