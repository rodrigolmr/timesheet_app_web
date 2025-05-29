import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/permission_providers.dart';
import 'package:timesheet_app_web/src/features/user/domain/enums/user_role.dart';

class PermissionGuard extends ConsumerWidget {
  final UserRole requiredRole;
  final Widget child;
  final Widget? fallback;
  
  const PermissionGuard({
    required this.requiredRole,
    required this.child,
    this.fallback,
    super.key,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRoleAsync = ref.watch(currentUserRoleProvider);
    
    return userRoleAsync.when(
      data: (role) {
        if (role != null && _hasPermission(role, requiredRole)) {
          return child;
        }
        return fallback ?? const SizedBox.shrink();
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => fallback ?? const SizedBox.shrink(),
    );
  }
  
  bool _hasPermission(UserRole userRole, UserRole requiredRole) {
    // Admin has all permissions
    if (userRole == UserRole.admin) return true;
    // Manager has permissions of manager and user
    if (userRole == UserRole.manager && requiredRole == UserRole.user) return true;
    // Exact role check
    return userRole == requiredRole;
  }
}

class PermissionGuardAsync extends ConsumerWidget {
  final Future<bool> Function(WidgetRef ref) permissionCheck;
  final Widget child;
  final Widget? fallback;
  
  const PermissionGuardAsync({
    required this.permissionCheck,
    required this.child,
    this.fallback,
    super.key,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<bool>(
      future: permissionCheck(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasData && snapshot.data == true) {
          return child;
        }
        
        return fallback ?? const SizedBox.shrink();
      },
    );
  }
}