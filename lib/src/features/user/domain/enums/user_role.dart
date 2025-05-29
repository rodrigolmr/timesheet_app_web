enum UserRole {
  admin('admin'),
  manager('manager'),
  user('user');

  final String value;
  const UserRole(this.value);

  static UserRole fromString(String role) {
    // Normalizar para lowercase para evitar problemas de case
    final normalizedRole = role.toLowerCase().trim();
    return UserRole.values.firstWhere(
      (e) => e.value == normalizedRole,
      orElse: () => UserRole.user,
    );
  }

  bool get isAdmin => this == UserRole.admin;
  bool get isManager => this == UserRole.manager;
  bool get isUser => this == UserRole.user;

  bool get canManageUsers => isAdmin;
  bool get canManageEmployees => isAdmin || isManager;
  bool get canViewAllRecords => isAdmin || isManager;
  bool get canAccessDatabase => isAdmin;
  bool get canManageCompanyCards => isAdmin || isManager;
}