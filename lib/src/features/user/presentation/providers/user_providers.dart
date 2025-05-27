import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timesheet_app_web/src/core/providers/firebase_providers.dart';
import 'package:timesheet_app_web/src/core/theme/theme_variant.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:timesheet_app_web/src/features/user/data/models/user_model.dart';
import 'package:timesheet_app_web/src/features/user/data/repositories/firestore_user_repository.dart';
import 'package:timesheet_app_web/src/features/user/domain/repositories/user_repository.dart';

part 'user_providers.g.dart';

/// Provider que fornece o repositório de usuários
@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  return FirestoreUserRepository(
    firestore: ref.watch(firestoreProvider),
  );
}

/// Provider para obter todos os usuários
@riverpod
Future<List<UserModel>> users(UsersRef ref) {
  return ref.watch(userRepositoryProvider).getAll();
}

/// Provider para observar todos os usuários em tempo real
@riverpod
Stream<List<UserModel>> usersStream(UsersStreamRef ref) {
  return ref.watch(userRepositoryProvider).watchAll();
}

/// Provider para obter um usuário específico por ID
@riverpod
Future<UserModel?> user(UserRef ref, String id) {
  return ref.watch(userRepositoryProvider).getById(id);
}

/// Provider para observar um usuário específico em tempo real
@riverpod
Stream<UserModel?> userStream(UserStreamRef ref, String id) {
  return ref.watch(userRepositoryProvider).watchById(id);
}

/// Provider para observar um usuário específico em tempo real (alternativo para telas)
@riverpod
Stream<UserModel?> userByIdStream(UserByIdStreamRef ref, String id) {
  return ref.watch(userRepositoryProvider).watchById(id);
}

/// Provider para obter usuários por cargo
@riverpod
Future<List<UserModel>> usersByRole(UsersByRoleRef ref, String role) {
  return ref.watch(userRepositoryProvider).getUsersByRole(role);
}

/// Provider para obter um usuário por auth UID
@riverpod
Future<UserModel?> userByAuthUid(UserByAuthUidRef ref, String authUid) {
  return ref.watch(userRepositoryProvider).getUserByAuthUid(authUid);
}

/// Provider para obter usuários ativos
@riverpod
Future<List<UserModel>> activeUsers(ActiveUsersRef ref) async {
  final users = await ref.watch(usersProvider.future);
  return users.where((user) => user.isActive).toList();
}

/// Provider para obter o usuário atual autenticado
@riverpod
Future<UserModel?> currentUserProfile(CurrentUserProfileRef ref) async {
  // Observe as mudanças de autenticação diretamente, não apenas o currentUserProvider
  final authStateChanges = ref.watch(authStateChangesProvider);
  
  return authStateChanges.when(
    data: (authUser) async {
      if (authUser == null) {
        return null;
      }
      
      final userProfile = await ref.read(userRepositoryProvider).getUserByAuthUid(authUser.uid);
      
      return userProfile;
    },
    loading: () {
      return null;
    },
    error: (error, stackTrace) {
      return null;
    },
  );
}

/// Provider para observar o perfil do usuário atual em tempo real
@riverpod
Stream<UserModel?> currentUserProfileStream(CurrentUserProfileStreamRef ref) {
  // Use o stream de auth diretamente ao invés de currentUserProvider
  return ref.watch(authStateChangesProvider).when(
    data: (authUser) {
      if (authUser == null) {
        return Stream.value(null);
      }
      
      final stream = ref.read(userRepositoryProvider).watchUserByAuthUid(authUser.uid);
      
      // Transformar o stream para adicionar logs
      return stream.map((userProfile) {
        return userProfile;
      });
    },
    loading: () {
      return Stream.value(null);
    },
    error: (error, stackTrace) {
      return Stream.value(null);
    },
  );
}

/// Provider que fornece o tema preferido do usuário atual
@riverpod
Future<ThemeVariant?> userPreferredTheme(UserPreferredThemeRef ref) async {
  final userProfile = await ref.watch(currentUserProfileProvider.future);
  return userProfile?.themeVariant;
}

/// Provider que fornece se o usuário atual pode alterar seu tema
@riverpod
Future<bool> canUserChangeTheme(CanUserChangeThemeRef ref) async {
  final userProfile = await ref.watch(currentUserProfileProvider.future);
  return userProfile?.canChangeTheme ?? true; // Se não há perfil, permite por padrão
}

/// Atualiza o tema do usuário atual
@riverpod
Future<void> updateCurrentUserTheme(
  UpdateCurrentUserThemeRef ref,
  String themePreference,
) async {
  final userProfile = await ref.watch(currentUserProfileProvider.future);
  
  if (userProfile != null) {
    await ref.read(userRepositoryProvider).updateUserTheme(
      userProfile.id,
      themePreference,
    );
  }
}