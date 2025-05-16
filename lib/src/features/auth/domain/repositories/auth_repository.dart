import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  /// Retorna o usuário atual ou null se não estiver autenticado
  User? get currentUser;

  /// Stream que emite o usuário atual ou null quando desconecta
  Stream<User?> get authStateChanges;

  /// Realiza login com email e senha
  Future<User?> signInWithEmailAndPassword(String email, String password);

  /// Cria uma nova conta com email e senha
  Future<User?> createUserWithEmailAndPassword(String email, String password);

  /// Envia email de redefinição de senha
  Future<void> sendPasswordResetEmail(String email);

  /// Realiza o logout
  Future<void> signOut();
}