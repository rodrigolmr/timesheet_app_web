import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timesheet_app_web/src/core/navigation/routes.dart';
import 'package:timesheet_app_web/src/features/auth/domain/models/role_permissions.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:timesheet_app_web/src/features/user/domain/enums/user_role.dart';
import 'package:timesheet_app_web/src/features/user/presentation/providers/user_providers.dart';

part 'permission_providers.g.dart';

@riverpod
Future<bool> canAccessRoute(CanAccessRouteRef ref, AppRoute route) async {
  final userProfile = await ref.watch(currentUserProfileProvider.future);
  if (userProfile == null) return false;
  
  final role = UserRole.fromString(userProfile.role);
  return RolePermissions.canAccessRoute(role, route);
}

@riverpod
Future<UserRole?> currentUserRole(CurrentUserRoleRef ref) async {
  final userProfile = await ref.watch(currentUserProfileProvider.future);
  return userProfile != null ? UserRole.fromString(userProfile.role) : null;
}

@riverpod
Stream<UserRole?> currentUserRoleStream(CurrentUserRoleStreamRef ref) {
  final authState = ref.watch(authStateChangesProvider);
  
  return authState.when(
    data: (authUser) {
      if (authUser == null) {
        return Stream.value(null);
      }
      
      return ref.read(userRepositoryProvider)
          .watchUserByAuthUid(authUser.uid)
          .map((userProfile) {
        return userProfile != null ? UserRole.fromString(userProfile.role) : null;
      });
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
}

@riverpod
Future<bool> canViewAllJobRecords(CanViewAllJobRecordsRef ref) async {
  final role = await ref.watch(currentUserRoleProvider.future);
  return role != null ? RolePermissions.canViewAllJobRecords(role) : false;
}

@riverpod
Future<bool> canEditJobRecord(
  CanEditJobRecordRef ref,
  String recordCreatorId,
) async {
  final userProfile = await ref.watch(currentUserProfileProvider.future);
  if (userProfile == null) return false;
  
  final role = UserRole.fromString(userProfile.role);
  return RolePermissions.canEditJobRecord(role, recordCreatorId, userProfile.authUid);
}

@riverpod
Future<bool> canDeleteJobRecord(CanDeleteJobRecordRef ref) async {
  final role = await ref.watch(currentUserRoleProvider.future);
  return role != null ? RolePermissions.canDeleteJobRecord(role) : false;
}

@riverpod
Future<bool> canViewAllExpenses(CanViewAllExpensesRef ref) async {
  final role = await ref.watch(currentUserRoleProvider.future);
  return role != null ? RolePermissions.canViewAllExpenses(role) : false;
}

@riverpod
Future<bool> canEditExpense(
  CanEditExpenseRef ref,
  String expenseCreatorId,
) async {
  final userProfile = await ref.watch(currentUserProfileProvider.future);
  if (userProfile == null) return false;
  
  final role = UserRole.fromString(userProfile.role);
  return RolePermissions.canEditExpense(role, expenseCreatorId, userProfile.authUid);
}

@riverpod
Future<bool> canDeleteExpense(CanDeleteExpenseRef ref) async {
  final role = await ref.watch(currentUserRoleProvider.future);
  return role != null ? RolePermissions.canDeleteExpense(role) : false;
}

@riverpod
Future<bool> canManageEmployees(CanManageEmployeesRef ref) async {
  final role = await ref.watch(currentUserRoleProvider.future);
  return role != null ? RolePermissions.canManageEmployees(role) : false;
}

@riverpod
Future<bool> canManageUsers(CanManageUsersRef ref) async {
  final role = await ref.watch(currentUserRoleProvider.future);
  return role != null ? RolePermissions.canManageUsers(role) : false;
}

@riverpod
Future<bool> canManageCompanyCards(CanManageCompanyCardsRef ref) async {
  final role = await ref.watch(currentUserRoleProvider.future);
  return role != null ? RolePermissions.canManageCompanyCards(role) : false;
}

@riverpod
Future<bool> canAccessDatabase(CanAccessDatabaseRef ref) async {
  final role = await ref.watch(currentUserRoleProvider.future);
  return role != null ? RolePermissions.canAccessDatabase(role) : false;
}

@riverpod
Future<Set<AppRoute>> allowedRoutes(AllowedRoutesRef ref) async {
  final role = await ref.watch(currentUserRoleProvider.future);
  return role != null ? RolePermissions.getAllowedRoutes(role) : {};
}

@riverpod
Future<bool> canGenerateTimesheet(CanGenerateTimesheetRef ref) async {
  final role = await ref.watch(currentUserRoleProvider.future);
  return role != null ? RolePermissions.canGenerateTimesheet(role) : false;
}

@riverpod
Future<bool> canPrintJobRecords(CanPrintJobRecordsRef ref) async {
  final role = await ref.watch(currentUserRoleProvider.future);
  return role != null ? RolePermissions.canPrintJobRecords(role) : false;
}

@riverpod
Future<bool> canPrintExpenses(CanPrintExpensesRef ref) async {
  final role = await ref.watch(currentUserRoleProvider.future);
  return role != null ? RolePermissions.canPrintExpenses(role) : false;
}

@riverpod
Future<bool> canDeleteOwnExpense(
  CanDeleteOwnExpenseRef ref,
  String expenseCreatorId,
) async {
  final userProfile = await ref.watch(currentUserProfileProvider.future);
  if (userProfile == null) return false;
  
  final role = UserRole.fromString(userProfile.role);
  return RolePermissions.canDeleteOwnExpense(role, expenseCreatorId, userProfile.authUid);
}