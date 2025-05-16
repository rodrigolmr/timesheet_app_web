import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timesheet_app_web/src/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:timesheet_app_web/src/features/auth/domain/repositories/auth_repository.dart';

part 'auth_providers.g.dart';

/// Provider que fornece a instância do FirebaseAuth
@riverpod
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}

/// Provider que fornece o repositório de autenticação
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return FirebaseAuthRepository(firebaseAuth: ref.watch(firebaseAuthProvider));
}

/// Provider que fornece o usuário autenticado atualmente
@riverpod
User? currentUser(CurrentUserRef ref) {
  return ref.watch(authRepositoryProvider).currentUser;
}

/// Provider que fornece o ID do usuário autenticado atualmente
@riverpod
AsyncValue<String?> currentUserId(CurrentUserIdRef ref) {
  final user = ref.watch(currentUserProvider);
  return AsyncData(user?.uid);
}

/// Provider que fornece um stream do estado de autenticação
@riverpod
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
}

/// Provider para verificar se o usuário está autenticado
@riverpod
Future<bool> isUserAuthenticated(IsUserAuthenticatedRef ref) async {
  final user = ref.watch(currentUserProvider);
  return user != null;
}

/// Provider para gerenciar o estado de carregamento da autenticação
@riverpod
class AuthState extends _$AuthState {
  @override
  AsyncValue<User?> build() {
    // Observa o stream de mudanças no estado de autenticação
    ref.listen(authStateChangesProvider, (previous, next) {
      next.when(
        data: (user) => state = AsyncData(user),
        error: (error, stackTrace) => state = AsyncError(error, stackTrace),
        loading: () => state = const AsyncLoading(),
      );
    });
    
    // Retorna o estado inicial com o usuário atual
    final currentUser = ref.watch(currentUserProvider);
    return currentUser != null ? AsyncData(currentUser) : const AsyncData(null);
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    try {
      final user = await ref
          .read(authRepositoryProvider)
          .signInWithEmailAndPassword(email, password);
      state = AsyncData(user);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncLoading();
    try {
      final user = await ref
          .read(authRepositoryProvider)
          .createUserWithEmailAndPassword(email, password);
      state = AsyncData(user);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> resetPassword(String email) async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).sendPasswordResetEmail(email);
      state = AsyncData(ref.read(currentUserProvider));
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).signOut();
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}