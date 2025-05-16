import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timesheet_app_web/src/core/services/search_service.dart';
import 'package:timesheet_app_web/src/features/company_card/data/models/company_card_model.dart';
import 'package:timesheet_app_web/src/features/company_card/presentation/providers/company_card_providers.dart';

part 'company_card_search_providers.g.dart';

/// Provider para armazenar todos os cartões corporativos em cache
@Riverpod(keepAlive: true)
Stream<List<CompanyCardModel>> cachedCompanyCards(CachedCompanyCardsRef ref) {
  // Usamos o stream existente que já está com persistência
  return ref.watch(companyCardsStreamProvider);
}

/// Enumeração para ordenação de cartões corporativos
enum CompanyCardSortOption {
  holderNameAsc,
  holderNameDesc,
  dateCreatedDesc,
  dateCreatedAsc,
}

/// Provider para o estado da consulta de pesquisa
@riverpod
class CompanyCardSearchQuery extends _$CompanyCardSearchQuery {
  @override
  String build() {
    return '';
  }

  void updateQuery(String query) {
    state = query;
  }
}

/// Provider para o estado dos filtros de pesquisa de cartões corporativos
@riverpod
class CompanyCardSearchFilters extends _$CompanyCardSearchFilters {
  @override
  ({bool? isActive, CompanyCardSortOption sortOption}) build() {
    return (
      isActive: null,
      sortOption: CompanyCardSortOption.holderNameAsc,
    );
  }

  void updateActiveStatus(bool? isActive) {
    state = (
      isActive: isActive,
      sortOption: state.sortOption,
    );
  }

  void updateSortOption(CompanyCardSortOption sortOption) {
    state = (
      isActive: state.isActive,
      sortOption: sortOption,
    );
  }

  void resetFilters() {
    state = (
      isActive: null,
      sortOption: CompanyCardSortOption.holderNameAsc,
    );
  }
}

/// Provider para pesquisar cartões corporativos
@riverpod
List<CompanyCardModel> searchCompanyCards(
  SearchCompanyCardsRef ref, {
  required String query,
  bool? isActive,
  CompanyCardSortOption? sortOption,
}) {
  final searchService = ref.watch(searchServiceProvider);
  final cardsAsyncValue = ref.watch(cachedCompanyCardsProvider);
  
  return cardsAsyncValue.when(
    data: (cards) {
      // Criar funções de filtro com base nos parâmetros
      final List<bool Function(CompanyCardModel)> filters = [];
      
      if (isActive != null) {
        filters.add((card) => card.isActive == isActive);
      }
      
      // Definir a função de ordenação
      int Function(CompanyCardModel, CompanyCardModel)? sortBy;
      
      switch (sortOption ?? CompanyCardSortOption.holderNameAsc) {
        case CompanyCardSortOption.holderNameAsc:
          sortBy = (a, b) => searchService.sortByString(a, b, (card) => card.holderName);
        case CompanyCardSortOption.holderNameDesc:
          sortBy = (a, b) => searchService.sortByString(a, b, (card) => card.holderName, descending: true);
        case CompanyCardSortOption.dateCreatedDesc:
          sortBy = (a, b) => searchService.sortByDate(a, b, (card) => card.createdAt);
        case CompanyCardSortOption.dateCreatedAsc:
          sortBy = (a, b) => searchService.sortByDate(a, b, (card) => card.createdAt, descending: false);
      }
      
      // Usar o serviço de pesquisa
      return searchService.search<CompanyCardModel>(
        items: cards,
        query: query,
        searchFields: (card) => [
          card.holderName,
          card.lastFourDigits,
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
List<CompanyCardModel> companyCardSearchResults(CompanyCardSearchResultsRef ref) {
  final query = ref.watch(companyCardSearchQueryProvider);
  final filters = ref.watch(companyCardSearchFiltersProvider);
  
  return ref.watch(searchCompanyCardsProvider(
    query: query,
    isActive: filters.isActive,
    sortOption: filters.sortOption,
  ));
}