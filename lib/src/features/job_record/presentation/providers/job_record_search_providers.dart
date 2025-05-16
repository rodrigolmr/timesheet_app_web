import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timesheet_app_web/src/core/services/search_service.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/job_record_providers.dart';

part 'job_record_search_providers.g.dart';

/// Provider para armazenar todos os registros de trabalho em cache
@Riverpod(keepAlive: true)
Stream<List<JobRecordModel>> cachedJobRecords(CachedJobRecordsRef ref) {
  // Usamos o stream existente que já está com persistência
  return ref.watch(jobRecordsStreamProvider);
}

/// Enumeração para ordenação de registros de trabalho
enum JobRecordSortOption {
  dateDesc,
  dateAsc,
  hoursDesc,
  hoursAsc,
  projectNameAsc,
  projectNameDesc,
}

/// Provider para o estado da consulta de pesquisa
@riverpod
class JobRecordSearchQuery extends _$JobRecordSearchQuery {
  @override
  String build() {
    return '';
  }

  void updateQuery(String query) {
    state = query;
  }
}

/// Provider para o estado dos filtros de pesquisa de registros de trabalho
@riverpod
class JobRecordSearchFilters extends _$JobRecordSearchFilters {
  @override
  ({String? userId, String? workerId, JobStatus? status, String? location, JobRecordSortOption sortOption}) build() {
    return (
      userId: null,
      workerId: null,
      status: null,
      location: null,
      sortOption: JobRecordSortOption.dateDesc,
    );
  }

  void updateUserId(String? userId) {
    state = (
      userId: userId,
      workerId: state.workerId,
      status: state.status,
      location: state.location,
      sortOption: state.sortOption,
    );
  }

  void updateWorkerId(String? workerId) {
    state = (
      userId: state.userId,
      workerId: workerId,
      status: state.status,
      location: state.location,
      sortOption: state.sortOption,
    );
  }

  void updateStatus(JobStatus? status) {
    state = (
      userId: state.userId,
      workerId: state.workerId,
      status: status,
      location: state.location,
      sortOption: state.sortOption,
    );
  }

  void updateLocation(String? location) {
    state = (
      userId: state.userId,
      workerId: state.workerId,
      status: state.status,
      location: location,
      sortOption: state.sortOption,
    );
  }

  void updateSortOption(JobRecordSortOption sortOption) {
    state = (
      userId: state.userId,
      workerId: state.workerId,
      status: state.status,
      location: state.location,
      sortOption: sortOption,
    );
  }

  void resetFilters() {
    state = (
      userId: null,
      workerId: null,
      status: null,
      location: null,
      sortOption: JobRecordSortOption.dateDesc,
    );
  }
}

/// Provider para pesquisar registros de trabalho
@riverpod
List<JobRecordModel> searchJobRecords(
  SearchJobRecordsRef ref, {
  required String query,
  String? userId,
  String? workerId,
  JobStatus? status,
  String? location,
  JobRecordSortOption? sortOption,
}) {
  final searchService = ref.watch(searchServiceProvider);
  final recordsAsyncValue = ref.watch(cachedJobRecordsProvider);
  
  return recordsAsyncValue.when(
    data: (records) {
      // Criar funções de filtro com base nos parâmetros
      final List<bool Function(JobRecordModel)> filters = [];
      
      if (userId != null && userId.isNotEmpty) {
        filters.add((record) => record.userId == userId);
      }
      
      if (workerId != null && workerId.isNotEmpty) {
        filters.add((record) => record.workerId == workerId);
      }
      
      if (status != null) {
        filters.add((record) => record.status == status);
      }
      
      if (location != null && location.isNotEmpty) {
        filters.add((record) => record.location.toLowerCase().contains(location.toLowerCase()));
      }
      
      // Definir a função de ordenação
      int Function(JobRecordModel, JobRecordModel)? sortBy;
      
      switch (sortOption ?? JobRecordSortOption.dateDesc) {
        case JobRecordSortOption.dateDesc:
          sortBy = (a, b) => searchService.sortByDate(a, b, (record) => record.date);
        case JobRecordSortOption.dateAsc:
          sortBy = (a, b) => searchService.sortByDate(a, b, (record) => record.date, descending: false);
        case JobRecordSortOption.hoursDesc:
          sortBy = (a, b) => (b.hours + b.travelHours).compareTo(a.hours + a.travelHours);
        case JobRecordSortOption.hoursAsc:
          sortBy = (a, b) => (a.hours + a.travelHours).compareTo(b.hours + b.travelHours);
        case JobRecordSortOption.projectNameAsc:
          sortBy = (a, b) => searchService.sortByString(a, b, (record) => record.projectName);
        case JobRecordSortOption.projectNameDesc:
          sortBy = (a, b) => searchService.sortByString(a, b, (record) => record.projectName, descending: true);
      }
      
      // Usar o serviço de pesquisa
      return searchService.search<JobRecordModel>(
        items: records,
        query: query,
        searchFields: (record) => [
          record.projectName,
          record.workDescription,
          record.location,
          record.workerName,
          record.date.toString().split(' ')[0], // Data formatada como YYYY-MM-DD
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
List<JobRecordModel> jobRecordSearchResults(JobRecordSearchResultsRef ref) {
  final query = ref.watch(jobRecordSearchQueryProvider);
  final filters = ref.watch(jobRecordSearchFiltersProvider);
  
  return ref.watch(searchJobRecordsProvider(
    query: query,
    userId: filters.userId,
    workerId: filters.workerId,
    status: filters.status,
    location: filters.location,
    sortOption: filters.sortOption,
  ));
}