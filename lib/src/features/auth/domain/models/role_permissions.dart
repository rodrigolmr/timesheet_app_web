import 'package:timesheet_app_web/src/core/navigation/routes.dart';
import 'package:timesheet_app_web/src/features/user/domain/enums/user_role.dart';

class RolePermissions {
  static const Map<UserRole, Set<AppRoute>> routePermissions = {
    UserRole.admin: {
      // Admin has access to everything
      ...AppRoute.values,
    },
    UserRole.manager: {
      // Manager cannot access database only
      AppRoute.login,
      AppRoute.home,
      AppRoute.accessDenied,
      AppRoute.jobRecords,
      AppRoute.jobRecordCreate,
      AppRoute.jobRecordEdit,
      AppRoute.jobRecordDetails,
      AppRoute.timesheetList,
      AppRoute.expenses,
      AppRoute.expenseDetails,
      AppRoute.employees,
      AppRoute.users,
      AppRoute.companyCards,
      AppRoute.settings,
      AppRoute.themeSettings,
      AppRoute.themeSelector,
      AppRoute.documentScanner,
      AppRoute.pigtails,
    },
    UserRole.user: {
      // User has limited access
      AppRoute.login,
      AppRoute.home,
      AppRoute.accessDenied,
      AppRoute.jobRecords,
      AppRoute.jobRecordCreate,
      AppRoute.jobRecordEdit,
      AppRoute.jobRecordDetails,
      AppRoute.timesheetList,
      AppRoute.expenses,
      AppRoute.expenseDetails,
      AppRoute.documentScanner,
      AppRoute.settings,
      AppRoute.themeSettings,
      AppRoute.themeSelector,
    },
  };

  static bool canAccessRoute(UserRole role, AppRoute route) {
    return routePermissions[role]?.contains(route) ?? false;
  }

  static Set<AppRoute> getAllowedRoutes(UserRole role) {
    return routePermissions[role] ?? {};
  }

  static bool canCreateJobRecord(UserRole role) {
    return true; // All roles can create job records
  }

  static bool canEditJobRecord(UserRole role, String creatorId, String currentUserId) {
    // Admin and Manager can edit all records
    if (role == UserRole.admin || role == UserRole.manager) {
      return true;
    }
    // Regular users can only edit their own records
    return role == UserRole.user && (creatorId == currentUserId || creatorId.isEmpty);
  }

  static bool canDeleteJobRecord(UserRole role) {
    // Only Admin and Manager can delete job records (controls selection mode)
    return role == UserRole.admin || role == UserRole.manager;
  }

  static bool canDeleteOwnJobRecord(UserRole role, String creatorId, String currentUserId) {
    // Admin and Manager can delete any record
    if (role == UserRole.admin || role == UserRole.manager) {
      return true;
    }
    // Regular users can delete their own records
    return role == UserRole.user && (creatorId == currentUserId || creatorId.isEmpty);
  }

  static bool canViewAllJobRecords(UserRole role) {
    // Only Admin and Manager can view all job records
    // Regular users can only view their own
    return role == UserRole.admin || role == UserRole.manager;
  }

  static bool canCreateExpense(UserRole role) {
    return true; // All roles can create expenses
  }

  static bool canEditExpense(UserRole role, String creatorId, String currentUserId) {
    // Admin and Manager can edit all expenses
    if (role == UserRole.admin || role == UserRole.manager) {
      return true;
    }
    // Regular users can only edit their own expenses
    return role == UserRole.user && (creatorId == currentUserId || creatorId.isEmpty);
  }

  static bool canDeleteExpense(UserRole role) {
    // Only Admin and Manager can delete expenses (controls selection mode)
    return role == UserRole.admin || role == UserRole.manager;
  }

  static bool canDeleteOwnExpense(UserRole role, String creatorId, String currentUserId) {
    // Admin and Manager can delete any expense
    if (role == UserRole.admin || role == UserRole.manager) {
      return true;
    }
    // Regular users can delete their own expenses
    return role == UserRole.user && (creatorId == currentUserId || creatorId.isEmpty);
  }

  static bool canViewAllExpenses(UserRole role) {
    // Only Admin and Manager can view all expenses
    // Regular users can only view their own
    return role == UserRole.admin || role == UserRole.manager;
  }

  static bool canManageEmployees(UserRole role) {
    return role == UserRole.admin || role == UserRole.manager;
  }

  static bool canManageUsers(UserRole role) {
    return role == UserRole.admin || role == UserRole.manager;
  }

  static bool canManageCompanyCards(UserRole role) {
    return role == UserRole.admin || role == UserRole.manager;
  }

  static bool canAccessDatabase(UserRole role) {
    return role == UserRole.admin;
  }

  static bool canGenerateTimesheet(UserRole role) {
    return role == UserRole.admin || role == UserRole.manager;
  }

  static bool canPrintJobRecords(UserRole role) {
    return role == UserRole.admin || role == UserRole.manager;
  }

  static bool canPrintExpenses(UserRole role) {
    return role == UserRole.admin || role == UserRole.manager;
  }
}