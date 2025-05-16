import 'package:firebase_auth/firebase_auth.dart';
import 'package:timesheet_app_web/src/core/errors/auth_exceptions.dart';
import 'package:timesheet_app_web/src/features/auth/domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthRepository({FirebaseAuth? firebaseAuth}) 
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseAuthError(e.code);
    } catch (e) {
      throw AuthException(
        code: 'unknown',
        message: 'Ocorreu um erro desconhecido: ${e.toString()}',
      );
    }
  }

  @override
  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseAuthError(e.code);
    } catch (e) {
      throw AuthException(
        code: 'unknown',
        message: 'Ocorreu um erro desconhecido: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseAuthError(e.code);
    } catch (e) {
      throw AuthException(
        code: 'unknown',
        message: 'Ocorreu um erro desconhecido: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AuthException(
        code: 'signout-failed',
        message: 'Erro ao fazer logout: ${e.toString()}',
      );
    }
  }
}