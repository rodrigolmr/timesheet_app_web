import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timesheet_app_web/src/core/services/search_service.dart';
import 'package:timesheet_app_web/src/features/employee/data/models/employee_model.dart';
import 'package:timesheet_app_web/src/features/employee/presentation/providers/employee_providers.dart';

part 'employee_search_providers.g.dart';

/// Provider para armazenar todos os funcionários em cache
@Riverpod(keepAlive: true)
Stream<List<EmployeeModel>> cachedEmployees(CachedEmployeesRef ref) {
  // Usamos o stream existente que já está com persistência
  return ref.watch(employeesStreamProvider.stream);
}

/// Enumeração para ordenação de funcionários
enum EmployeeSortOption {
  nameAsc,
  nameDesc,
  dateCreatedDesc,
  dateCreatedAsc,
}

/// Provider para o estado da consulta de pesquisa
@riverpod
class EmployeeSearchQuery extends _$EmployeeSearchQuery {
  @override
  String build() {
    return '';
  }

  void updateQuery(String query) {
    state = query;
  }
}

/// Provider para o estado dos filtros de pesquisa de funcionários
@riverpod
class EmployeeSearchFilters extends _$EmployeeSearchFilters {
  @override
  ({bool? isActive, EmployeeSortOption sortOption}) build() {
    return (
      isActive: null,
      sortOption: EmployeeSortOption.nameAsc,
    );
  }

  void updateActiveStatus(bool? isActive) {
    state = (
      isActive: isActive,
      sortOption: state.sortOption,
    );
  }

  void updateSortOption(EmployeeSortOption sortOption) {
    state = (
      isActive: state.isActive,
      sortOption: sortOption,
    );
  }

  void resetFilters() {
    state = (
      isActive: null,
      sortOption: EmployeeSortOption.nameAsc,
    );
  }
}

/// Provider para pesquisar funcionários
@riverpod
List<EmployeeModel> searchEmployees(
  SearchEmployeesRef ref, {
  required String query,
  bool? isActive,
  EmployeeSortOption? sortOption,
}) {
  final searchService = ref.watch(searchServiceProvider);
  final employeesAsyncValue = ref.watch(cachedEmployeesProvider);
  
  return employeesAsyncValue.when(
    data: (employees) {
      // Criar funções de filtro com base nos parâmetros
      final List<bool Function(EmployeeModel)> filters = [];
      
      if (isActive != null) {
        filters.add((employee) => employee.isActive == isActive);
      }
      
      // Definir a função de ordenação
      int Function(EmployeeModel, EmployeeModel)? sortBy;
      
      switch (sortOption ?? EmployeeSortOption.nameAsc) {
        case EmployeeSortOption.nameAsc:
          sortBy = (a, b) => searchService.sortByString(a, b, (employee) => '${employee.firstName} ${employee.lastName}');
        case EmployeeSortOption.nameDesc:
          sortBy = (a, b) => searchService.sortByString(a, b, (employee) => '${employee.firstName} ${employee.lastName}', descending: true);
        case EmployeeSortOption.dateCreatedDesc:
          sortBy = (a, b) => searchService.sortByDate(a, b, (employee) => employee.createdAt);
        case EmployeeSortOption.dateCreatedAsc:
          sortBy = (a, b) => searchService.sortByDate(a, b, (employee) => employee.createdAt, descending: false);
      }
      
      // Usar o serviço de pesquisa
      return searchService.search<EmployeeModel>(
        items: employees,
        query: query,
        searchFields: (employee) => [
          employee.firstName,
          employee.lastName,
          '${employee.firstName} ${employee.lastName}',
        ],
        filters: filters.isEmpty ? null : filters,
        sortBy: sortBy,
      );
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

/// Provider que combina a consulta e os filtros para fornecer resultados de pesquisa
@riverpod
List<EmployeeModel> employeeSearchResults(EmployeeSearchResultsRef ref) {
  final query = ref.watch(employeeSearchQueryProvider);
  final filters = ref.watch(employeeSearchFiltersProvider);
  
  return ref.watch(searchEmployeesProvider(
    query: query,
    isActive: filters.isActive,
    sortOption: filters.sortOption,
  ));
}