import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timesheet_app_web/src/core/providers/firebase_providers.dart';
import 'package:timesheet_app_web/src/features/employee/data/models/employee_model.dart';
import 'package:timesheet_app_web/src/features/employee/data/repositories/firestore_employee_repository.dart';
import 'package:timesheet_app_web/src/features/employee/domain/repositories/employee_repository.dart';

part 'employee_providers.g.dart';

/// Provider que fornece o repositório de funcionários
@riverpod
EmployeeRepository employeeRepository(EmployeeRepositoryRef ref) {
  return FirestoreEmployeeRepository(
    firestore: ref.watch(firestoreProvider),
  );
}

/// Provider para obter todos os funcionários
@riverpod
Future<List<EmployeeModel>> employees(EmployeesRef ref) {
  return ref.watch(employeeRepositoryProvider).getAll();
}

/// Provider para observar todos os funcionários em tempo real
@riverpod
Stream<List<EmployeeModel>> employeesStream(EmployeesStreamRef ref) {
  return ref.watch(employeeRepositoryProvider).watchAll();
}

/// Provider para obter um funcionário específico por ID
@riverpod
Future<EmployeeModel?> employee(EmployeeRef ref, String id) {
  return ref.watch(employeeRepositoryProvider).getById(id);
}

/// Provider para observar um funcionário específico em tempo real
@riverpod
Stream<EmployeeModel?> employeeStream(EmployeeStreamRef ref, String id) {
  return ref.watch(employeeRepositoryProvider).watchById(id);
}

/// Provider para obter funcionários ativos
@riverpod
Future<List<EmployeeModel>> activeEmployees(ActiveEmployeesRef ref) {
  return ref.watch(employeeRepositoryProvider).getActiveEmployees();
}

/// Provider para observar funcionários ativos em tempo real
@riverpod
Stream<List<EmployeeModel>> activeEmployeesStream(ActiveEmployeesStreamRef ref) {
  return ref.watch(employeeRepositoryProvider).watchActiveEmployees();
}

/// Provider para gerenciar o estado de um funcionário
@riverpod
class EmployeeState extends _$EmployeeState {
  @override
  FutureOr<EmployeeModel?> build(String id) async {
    return id.isEmpty ? null : await ref.watch(employeeProvider(id).future);
  }

  /// Ativa ou desativa um funcionário
  Future<void> toggleActive(bool isActive) async {
    if (state.value == null) return;
    
    state = const AsyncLoading();
    try {
      await ref.read(employeeRepositoryProvider).toggleEmployeeActive(
        state.value!.id,
        isActive,
      );
      state = AsyncData(
        state.value!.copyWith(isActive: isActive),
      );
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  /// Atualiza um funcionário
  Future<EmployeeModel?> updateEmployee(EmployeeModel employee) async {
    state = const AsyncLoading();
    try {
      await ref.read(employeeRepositoryProvider).update(
        employee.id,
        employee,
      );
      state = AsyncData(employee);
      return employee;
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return null;
    }
  }

  /// Cria um novo funcionário
  Future<String> create(EmployeeModel employee) async {
    try {
      return await ref.read(employeeRepositoryProvider).create(employee);
    } catch (e) {
      rethrow;
    }
  }

  /// Exclui um funcionário
  Future<void> delete(String id) async {
    try {
      await ref.read(employeeRepositoryProvider).delete(id);
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}