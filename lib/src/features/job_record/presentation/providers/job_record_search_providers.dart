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
  ({String? userId, String? location, JobRecordSortOption sortOption}) build() {
    return (
      userId: null,
      location: null,
      sortOption: JobRecordSortOption.dateDesc,
    );
  }

  void updateUserId(String? userId) {
    state = (
      userId: userId,
      location: state.location,
      sortOption: state.sortOption,
    );
  }

  void updateLocation(String? location) {
    state = (
      userId: state.userId,
      location: location,
      sortOption: state.sortOption,
    );
  }

  void updateSortOption(JobRecordSortOption sortOption) {
    state = (
      userId: state.userId,
      location: state.location,
      sortOption: sortOption,
    );
  }

  void resetFilters() {
    state = (
      userId: null,
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
      
      if (location != null && location.isNotEmpty) {
        filters.add((record) => record.location != null && record.location.toLowerCase().contains(location.toLowerCase()));
      }
      
      // Definir a função de ordenação
      int Function(JobRecordModel, JobRecordModel)? sortBy;
      
      switch (sortOption ?? JobRecordSortOption.dateDesc) {
        case JobRecordSortOption.dateDesc:
          sortBy = (a, b) => searchService.sortByDate(a, b, (record) => record.date);
        case JobRecordSortOption.dateAsc:
          sortBy = (a, b) => searchService.sortByDate(a, b, (record) => record.date, descending: false);
        case JobRecordSortOption.projectNameAsc:
          sortBy = (a, b) => searchService.sortByString(a, b, (record) => record.jobName);
        case JobRecordSortOption.projectNameDesc:
          sortBy = (a, b) => searchService.sortByString(a, b, (record) => record.jobName, descending: true);
      }
      
      // Usar o serviço de pesquisa
      return searchService.search<JobRecordModel>(
        items: records,
        query: query,
        searchFields: (record) => [
          record.jobName,
          record.jobDescription,
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
    location: filters.location,
    sortOption: filters.sortOption,
  ));
}