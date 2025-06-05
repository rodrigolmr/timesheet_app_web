import 'package:timesheet_app_web/src/core/interfaces/base_repository.dart';
import 'package:timesheet_app_web/src/features/user/data/models/user_model.dart';

abstract class UserRepository implements BaseRepository<UserModel> {
  /// Busca um usuário pelo UID de autenticação do Firebase
  Future<UserModel?> getUserByAuthUid(String authUid);
  
  /// Stream de um usuário pelo UID de autenticação
  Stream<UserModel?> watchUserByAuthUid(String authUid);
  
  /// Busca todos os usuários por cargo
  Future<List<UserModel>> getUsersByRole(String role);
  
  /// Ativa ou desativa um usuário
  Future<void> toggleUserActive(String id, bool isActive);
  
  /// Atualiza a preferência de tema de um usuário
  Future<void> updateUserTheme(String id, String themePreference, {bool? forcedTheme});
  
  /// Cria um usuário com autenticação (sem employee)
  Future<String> createUserWithAuth(UserModel user, String password);
  
  /// Cria um usuário e um novo employee associado
  Future<String> createUserWithNewEmployee(UserModel user, String password);
  
  /// Cria um usuário e associa a um employee existente
  Future<String> createUserWithExistingEmployee(UserModel user, String password, String employeeId);
  
  /// Associa um usuário existente a um employee existente
  Future<void> associateUserWithEmployee(String userId, String employeeId);
}