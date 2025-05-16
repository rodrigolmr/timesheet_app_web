/// Exceção personalizada para erros de autenticação
class AuthException implements Exception {
  final String code;
  final String message;

  AuthException({required this.code, required this.message});

  @override
  String toString() => 'AuthException: [$code] $message';

  /// Factory para criar exceções a partir de códigos de erro do Firebase Auth
  factory AuthException.fromFirebaseAuthError(String code) {
    switch (code) {
      case 'invalid-email':
        return AuthException(
          code: code,
          message: 'O endereço de email está formatado incorretamente.',
        );
      case 'user-disabled':
        return AuthException(
          code: code,
          message: 'Este usuário foi desativado.',
        );
      case 'user-not-found':
        return AuthException(
          code: code,
          message: 'Não há nenhum usuário com este email.',
        );
      case 'wrong-password':
        return AuthException(
          code: code,
          message: 'A senha está incorreta.',
        );
      case 'email-already-in-use':
        return AuthException(
          code: code,
          message: 'Este email já está sendo usado por outra conta.',
        );
      case 'operation-not-allowed':
        return AuthException(
          code: code,
          message: 'O login com email e senha não está habilitado.',
        );
      case 'weak-password':
        return AuthException(
          code: code,
          message: 'A senha é muito fraca.',
        );
      case 'too-many-requests':
        return AuthException(
          code: code,
          message: 'Muitas tentativas inválidas. Tente novamente mais tarde.',
        );
      case 'network-request-failed':
        return AuthException(
          code: code,
          message: 'Erro de conexão. Verifique sua internet.',
        );
      default:
        return AuthException(
          code: code,
          message: 'Ocorreu um erro na autenticação.',
        );
    }
  }
}