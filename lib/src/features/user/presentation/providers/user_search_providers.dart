import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timesheet_app_web/src/core/services/search_service.dart';
import 'package:timesheet_app_web/src/features/user/data/models/user_model.dart';
import 'package:timesheet_app_web/src/features/user/presentation/providers/user_providers.dart';

part 'user_search_providers.g.dart';

/// Provider para armazenar todos os usuários em cache
@Riverpod(keepAlive: true)
Stream<List<UserModel>> cachedUsers(CachedUsersRef ref) {
  // Usamos o stream existente com a persistência do Firestore
  return ref.read(usersStreamProvider.stream);
}

/// Enumeração para ordenação de usuários
enum UserSortOption {
  nameAsc,
  nameDesc,
  dateCreatedDesc,
  dateCreatedAsc,
}

/// Provider para o estado da consulta de pesquisa
@riverpod
class UserSearchQuery extends _$UserSearchQuery {
  @override
  String build() {
    return '';
  }

  void updateQuery(String query) {
    state = query;
  }
}

/// Provider para o estado dos filtros de pesquisa de usuários
@riverpod
class UserSearchFilters extends _$UserSearchFilters {
  @override
  ({String? role, bool? isActive, UserSortOption sortOption}) build() {
    return (
      role: null,
      isActive: null,
      sortOption: UserSortOption.nameAsc,
    );
  }

  void updateRole(String? role) {
    state = (
      role: role,
      isActive: state.isActive,
      sortOption: state.sortOption,
    );
  }

  void updateActiveStatus(bool? isActive) {
    state = (
      role: state.role,
      isActive: isActive,
      sortOption: state.sortOption,
    );
  }

  void updateSortOption(UserSortOption sortOption) {
    state = (
      role: state.role,
      isActive: state.isActive,
      sortOption: sortOption,
    );
  }

  void resetFilters() {
    state = (
      role: null,
      isActive: null,
      sortOption: UserSortOption.nameAsc,
    );
  }
}

/// Provider para pesquisar usuários
@riverpod
List<UserModel> searchUsers(
  SearchUsersRef ref, {
  required String query,
  String? role,
  bool? isActive,
  UserSortOption? sortOption,
}) {
  final searchService = ref.watch(searchServiceProvider);
  final usersAsyncValue = ref.watch(cachedUsersProvider);
  
  return usersAsyncValue.when(
    data: (users) {
      // Criar funções de filtro com base nos parâmetros
      final List<bool Function(UserModel)> filters = [];
      
      if (role != null) {
        filters.add((user) => user.role == role);
      }
      
      if (isActive != null) {
        filters.add((user) => user.isActive == isActive);
      }
      
      // Definir a função de ordenação
      int Function(UserModel, UserModel)? sortBy;
      
      switch (sortOption ?? UserSortOption.nameAsc) {
        case UserSortOption.nameAsc:
          sortBy = (a, b) => searchService.sortByString(a, b, (user) => '${user.firstName} ${user.lastName}');
        case UserSortOption.nameDesc:
          sortBy = (a, b) => searchService.sortByString(a, b, (user) => '${user.firstName} ${user.lastName}', descending: true);
        case UserSortOption.dateCreatedDesc:
          sortBy = (a, b) => searchService.sortByDate(a, b, (user) => user.createdAt);
        case UserSortOption.dateCreatedAsc:
          sortBy = (a, b) => searchService.sortByDate(a, b, (user) => user.createdAt, descending: false);
      }
      
      // Usar o serviço de pesquisa
      return searchService.search<UserModel>(
        items: users,
        query: query,
        searchFields: (user) => [
          user.firstName,
          user.lastName,
          user.email,
          user.role,
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
List<UserModel> userSearchResults(UserSearchResultsRef ref) {
  final query = ref.watch(userSearchQueryProvider);
  final filters = ref.watch(userSearchFiltersProvider);
  
  return ref.watch(searchUsersProvider(
    query: query,
    role: filters.role,
    isActive: filters.isActive,
    sortOption: filters.sortOption,
  ));
}