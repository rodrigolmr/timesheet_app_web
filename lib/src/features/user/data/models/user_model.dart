import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timesheet_app_web/src/core/theme/theme_variant.dart';
import 'package:timesheet_app_web/src/features/user/domain/enums/user_role.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const UserModel._();
  
  const factory UserModel({
    // Campos do sistema (não visíveis ao usuário final)
    required String id,
    required String authUid,
    
    // Campos visíveis ao usuário
    required String email,
    required String firstName,
    required String lastName,
    required String role,
    required bool isActive,
    String? themePreference,
    bool? forcedTheme,
    
    // Campos de controle (sistema)
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserModel(
      id: doc.id,
      authUid: data['auth_uid'] as String,
      email: data['email'] as String,
      firstName: data['first_name'] as String,
      lastName: data['last_name'] as String,
      role: data['role'] as String,
      isActive: data['is_active'] as bool,
      themePreference: data['theme_preference'] as String?,
      forcedTheme: data['forced_theme'] as bool?,
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'auth_uid': authUid,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
      'is_active': isActive,
      'theme_preference': themePreference,
      'forced_theme': forcedTheme,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }

  /// Converte a string themePreference para o enum ThemeVariant
  ThemeVariant? get themeVariant {
    if (themePreference == null) return null;
    
    switch (themePreference) {
      case 'light':
        return ThemeVariant.light;
      case 'dark':
        return ThemeVariant.dark;
      case 'feminine':
        return ThemeVariant.feminine;
      case 'green':
        return ThemeVariant.green;
      default:
        return null;
    }
  }
  
  /// Verifica se o usuário pode alterar seu tema
  bool get canChangeTheme => forcedTheme != true;
  
  /// Retorna o UserRole enum baseado na string role
  UserRole get userRole => UserRole.fromString(role);
  
  /// Verifica se o usuário é admin
  bool get isAdmin => userRole == UserRole.admin;
  
  /// Verifica se o usuário é manager
  bool get isManager => userRole == UserRole.manager;
  
  /// Verifica se o usuário é user regular
  bool get isRegularUser => userRole == UserRole.user;
}