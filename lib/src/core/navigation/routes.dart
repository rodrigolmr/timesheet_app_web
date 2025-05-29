import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:typed_data';
import 'package:timesheet_app_web/src/features/auth/presentation/screens/login_screen.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/permission_providers.dart';
import 'package:timesheet_app_web/src/features/home/presentation/screens/home_screen.dart';
import 'package:timesheet_app_web/src/features/employee/presentation/screens/employees_screen.dart';
import 'package:timesheet_app_web/src/features/settings/presentation/screens/theme_settings_screen.dart';
import 'package:timesheet_app_web/src/features/settings/presentation/screens/theme_selector_screen.dart';
import 'package:timesheet_app_web/src/features/settings/presentation/screens/settings_screen.dart';
// import 'package:timesheet_app_web/src/features/settings/presentation/screens/image_processing_debug_screen.dart';
import 'package:timesheet_app_web/src/features/database/presentation/screens/database_screen.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/screens/job_record_create_screen.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/screens/job_records_screen.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/screens/job_record_details_screen.dart';
import 'package:timesheet_app_web/src/features/expense/presentation/screens/expenses_screen.dart';
import 'package:timesheet_app_web/src/features/expense/presentation/screens/expense_details_screen.dart';
import 'package:timesheet_app_web/src/features/document_scanner/presentation/screens/document_scanner_screen.dart';
import 'package:timesheet_app_web/src/features/document_scanner/presentation/screens/document_crop_screen.dart';
import 'package:timesheet_app_web/src/features/document_scanner/presentation/screens/document_filter_screen.dart';
import 'package:timesheet_app_web/src/features/document_scanner/presentation/screens/expense_info_screen.dart';
import 'package:timesheet_app_web/src/features/user/presentation/screens/users_screen.dart';
import 'package:timesheet_app_web/src/features/company_card/presentation/screens/company_cards_screen.dart';
import 'package:timesheet_app_web/src/features/database/presentation/screens/data_import_screen.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/screens/access_denied_screen.dart';

part 'routes.g.dart';

enum AppRoute {
  login('/login'),
  home('/'),
  accessDenied('/access-denied'),
  // Rotas de funcionários
  employees('/employees'),
  users('/users'),
  companyCards('/company-cards'),
  settings('/settings'),
  themeSettings('/settings/theme'),
  themeSelector('/settings/theme-selector'),
  imageProcessingDebug('/settings/image-processing-debug'),
  database('/settings/database'),
  dataImport('/settings/database/import'),
  jobRecordCreate('/job-record-create'),
  jobRecordEdit('/job-records/edit/:id'),
  jobRecords('/job-records'),
  timesheetList('/timesheets'),
  jobRecordDetails('/job-records/:id'),
  expenses('/expenses'),
  expenseDetails('/expenses/:id'),
  documentScanner('/document-scanner'),
  documentCrop('/document-scanner/crop'),
  documentFilter('/document-scanner/filter'),
  expenseInfo('/document-scanner/expense-info'),
;

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
    redirect: (context, state) async {
      final authState = ref.read(authStateProvider);
      final isLoggingIn = state.matchedLocation == AppRoute.login.path;
      final isAccessDenied = state.matchedLocation == AppRoute.accessDenied.path;
      
      return authState.when(
        data: (user) async {
          if (user == null) {
            // No user authenticated
            return isLoggingIn ? null : AppRoute.login.path;
          }
          
          // User is authenticated
          if (isLoggingIn) {
            return AppRoute.home.path;
          }
          
          // Check route permissions
          final currentRoute = AppRoute.values.firstWhere(
            (r) => state.matchedLocation == r.path || 
                   state.matchedLocation.startsWith(r.path + '/') ||
                   (r.path.contains(':') && _matchesParameterizedRoute(state.matchedLocation, r.path)),
            orElse: () => AppRoute.home,
          );
          
          // Skip permission check for certain routes
          final publicRoutes = [AppRoute.login, AppRoute.home, AppRoute.accessDenied];
          if (publicRoutes.contains(currentRoute)) {
            return null;
          }
          
          // Check if user has permission to access the route
          final hasPermission = await ref.read(canAccessRouteProvider(currentRoute).future);
          
          if (!hasPermission && !isAccessDenied) {
            return AppRoute.accessDenied.path;
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
        path: AppRoute.accessDenied.path,
        name: AppRoute.accessDenied.name,
        builder: (context, state) => const AccessDeniedScreen(),
      ),
      GoRoute(
        path: AppRoute.employees.path,
        name: AppRoute.employees.name,
        builder: (context, state) => const EmployeesScreen(),
      ),
      GoRoute(
        path: AppRoute.users.path,
        name: AppRoute.users.name,
        builder: (context, state) => const UsersScreen(),
      ),
      GoRoute(
        path: AppRoute.companyCards.path,
        name: AppRoute.companyCards.name,
        builder: (context, state) => const CompanyCardsScreen(),
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
      // GoRoute(
      //   path: AppRoute.imageProcessingDebug.path,
      //   name: AppRoute.imageProcessingDebug.name,
      //   builder: (context, state) => const ImageProcessingDebugScreen(),
      // ),
      GoRoute(
        path: AppRoute.database.path,
        name: AppRoute.database.name,
        builder: (context, state) => const DatabaseScreen(),
      ),
      GoRoute(
        path: AppRoute.dataImport.path,
        name: AppRoute.dataImport.name,
        builder: (context, state) => const DataImportScreen(),
      ),
      GoRoute(
        path: AppRoute.jobRecordCreate.path,
        name: AppRoute.jobRecordCreate.name,
        builder: (context, state) => const JobRecordCreateScreen(),
      ),
      GoRoute(
        path: AppRoute.jobRecordEdit.path,
        name: AppRoute.jobRecordEdit.name,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return JobRecordCreateScreen(editRecordId: id);
        },
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
        path: AppRoute.expenses.path,
        name: AppRoute.expenses.name,
        builder: (context, state) => const ExpensesScreen(),
      ),
      GoRoute(
        path: AppRoute.expenseDetails.path,
        name: AppRoute.expenseDetails.name,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ExpenseDetailsScreen(expenseId: id);
        },
      ),
      GoRoute(
        path: AppRoute.documentScanner.path,
        name: AppRoute.documentScanner.name,
        builder: (context, state) => DocumentScannerScreen(
          extra: state.extra as Map<String, dynamic>?,
        ),
      ),
      GoRoute(
        path: AppRoute.documentCrop.path,
        name: AppRoute.documentCrop.name,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return DocumentCropScreen(
            imageData: extra['imageData'] as Uint8List,
          );
        },
      ),
      GoRoute(
        path: AppRoute.documentFilter.path,
        name: AppRoute.documentFilter.name,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return DocumentFilterScreen(
            imageData: extra['imageData'] as Uint8List,
          );
        },
      ),
      GoRoute(
        path: AppRoute.expenseInfo.path,
        name: AppRoute.expenseInfo.name,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ExpenseInfoScreen(
            imageData: extra['imageData'] as Uint8List,
            isPdf: extra['isPdf'] as bool? ?? false,
            fileName: extra['fileName'] as String?,
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}

// Helper function to match parameterized routes
bool _matchesParameterizedRoute(String path, String routePattern) {
  // Convert route pattern to regex
  final regexPattern = routePattern.replaceAllMapped(
    RegExp(r':(\w+)'),
    (match) => r'[^/]+',
  );
  
  final regex = RegExp('^$regexPattern\$');
  return regex.hasMatch(path);
}