import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timesheet_app_web/src/core/services/search_service.dart';
import 'package:timesheet_app_web/src/features/expense/data/models/expense_model.dart';
import 'package:timesheet_app_web/src/features/expense/presentation/providers/expense_providers.dart';

part 'expense_search_providers.g.dart';

/// Provider para armazenar todas as despesas em cache
@Riverpod(keepAlive: true)
Stream<List<ExpenseModel>> cachedExpenses(CachedExpensesRef ref) {
  // Usamos o stream existente que já está com persistência
  return ref.watch(expensesStreamProvider);
}

/// Enumeração para ordenação de despesas
enum ExpenseSortOption {
  dateDesc,
  dateAsc,
  amountDesc,
  amountAsc,
}

/// Provider para o estado da consulta de pesquisa
@riverpod
class ExpenseSearchQuery extends _$ExpenseSearchQuery {
  @override
  String build() {
    return '';
  }

  void updateQuery(String query) {
    state = query;
  }
}

/// Provider para o estado dos filtros de pesquisa de despesas
@riverpod
class ExpenseSearchFilters extends _$ExpenseSearchFilters {
  @override
  ({String? userId, String? cardId, ExpenseStatus? status, ExpenseSortOption sortOption}) build() {
    return (
      userId: null,
      cardId: null,
      status: null,
      sortOption: ExpenseSortOption.dateDesc,
    );
  }

  void updateUserId(String? userId) {
    state = (
      userId: userId,
      cardId: state.cardId,
      status: state.status,
      sortOption: state.sortOption,
    );
  }

  void updateCardId(String? cardId) {
    state = (
      userId: state.userId,
      cardId: cardId,
      status: state.status,
      sortOption: state.sortOption,
    );
  }

  void updateStatus(ExpenseStatus? status) {
    state = (
      userId: state.userId,
      cardId: state.cardId,
      status: status,
      sortOption: state.sortOption,
    );
  }

  void updateSortOption(ExpenseSortOption sortOption) {
    state = (
      userId: state.userId,
      cardId: state.cardId,
      status: state.status,
      sortOption: sortOption,
    );
  }

  void resetFilters() {
    state = (
      userId: null,
      cardId: null,
      status: null,
      sortOption: ExpenseSortOption.dateDesc,
    );
  }
}

/// Provider para pesquisar despesas
@riverpod
List<ExpenseModel> searchExpenses(
  SearchExpensesRef ref, {
  required String query,
  String? userId,
  String? cardId,
  ExpenseStatus? status,
  ExpenseSortOption? sortOption,
}) {
  final searchService = ref.watch(searchServiceProvider);
  final expensesAsyncValue = ref.watch(cachedExpensesProvider);
  
  return expensesAsyncValue.when(
    data: (expenses) {
      // Criar funções de filtro com base nos parâmetros
      final List<bool Function(ExpenseModel)> filters = [];
      
      if (userId != null && userId.isNotEmpty) {
        filters.add((expense) => expense.userId == userId);
      }
      
      if (cardId != null && cardId.isNotEmpty) {
        filters.add((expense) => expense.cardId == cardId);
      }
      
      if (status != null) {
        filters.add((expense) => expense.status == status);
      }
      
      // Definir a função de ordenação
      int Function(ExpenseModel, ExpenseModel)? sortBy;
      
      switch (sortOption ?? ExpenseSortOption.dateDesc) {
        case ExpenseSortOption.dateDesc:
          sortBy = (a, b) => searchService.sortByDate(a, b, (expense) => expense.date);
        case ExpenseSortOption.dateAsc:
          sortBy = (a, b) => searchService.sortByDate(a, b, (expense) => expense.date, descending: false);
        case ExpenseSortOption.amountDesc:
          sortBy = (a, b) => b.amount.compareTo(a.amount);
        case ExpenseSortOption.amountAsc:
          sortBy = (a, b) => a.amount.compareTo(b.amount);
      }
      
      // Usar o serviço de pesquisa
      return searchService.search<ExpenseModel>(
        items: expenses,
        query: query,
        searchFields: (expense) => [
          expense.description,
          expense.amount.toString(),
          expense.date.toString().split(' ')[0], // Data formatada como YYYY-MM-DD
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
List<ExpenseModel> expenseSearchResults(ExpenseSearchResultsRef ref) {
  final query = ref.watch(expenseSearchQueryProvider);
  final filters = ref.watch(expenseSearchFiltersProvider);
  
  return ref.watch(searchExpensesProvider(
    query: query,
    userId: filters.userId,
    cardId: filters.cardId,
    status: filters.status,
    sortOption: filters.sortOption,
  ));
}