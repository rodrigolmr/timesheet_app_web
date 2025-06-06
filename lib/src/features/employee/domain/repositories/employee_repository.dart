import 'package:timesheet_app_web/src/core/interfaces/base_repository.dart';
import 'package:timesheet_app_web/src/features/employee/data/models/employee_model.dart';

abstract class EmployeeRepository implements BaseRepository<EmployeeModel> {
  /// Retorna todos os funcionários ativos
  Future<List<EmployeeModel>> getActiveEmployees();
  
  /// Stream de todos os funcionários ativos
  Stream<List<EmployeeModel>> watchActiveEmployees();
  
  /// Ativa ou desativa um funcionário
  Future<void> toggleEmployeeActive(String id, bool isActive);
  
  /// Associa um employee a um user
  Future<void> associateWithUser(String employeeId, String userId);
  
  /// Remove a associação de um employee com um user
  Future<void> dissociateFromUser(String employeeId);
}