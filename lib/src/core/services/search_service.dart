import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_service.g.dart';

/// Serviço genérico para pesquisa local em coleções
/// 
/// Este serviço fornece métodos para pesquisar em coleções de dados
/// que foram carregadas na memória a partir do Firebase.
/// 
/// Uso típico:
/// ```dart
/// // Criar um provider que utiliza o SearchService para pesquisar em uma coleção
/// @riverpod
/// List<UserModel> searchUsers(SearchUsersRef ref, {required String query}) {
///   final searchService = ref.watch(searchServiceProvider);
///   final usersAsyncValue = ref.watch(usersProvider);
///   
///   return usersAsyncValue.when(
///     data: (users) => searchService.search<UserModel>(
///       items: users,
///       query: query,
///       searchFields: (user) => [
///         user.firstName,
///         user.lastName,
///         user.email,
///       ],
///     ),
///     loading: () => [],
///     error: (_, __) => [],
///   );
/// }
/// ```
class SearchService {
  /// Pesquisa itens em uma coleção com base em uma consulta
  /// 
  /// [items]: A lista de itens a serem pesquisados
  /// [query]: O texto a ser pesquisado
  /// [searchFields]: Função que retorna uma lista de campos a serem incluídos na pesquisa
  /// [filters]: Lista opcional de funções para filtrar os resultados
  /// [sortBy]: Função opcional para ordenar os resultados
  /// 
  /// Retorna uma lista dos itens que correspondem à consulta.
  List<T> search<T>({
    required List<T> items,
    required String query,
    required List<String?> Function(T item) searchFields,
    List<bool Function(T item)>? filters,
    int Function(T a, T b)? sortBy,
  }) {
    if (items.isEmpty) return [];
    
    // Aplicar filtros, se fornecidos
    var filteredItems = items;
    if (filters != null && filters.isNotEmpty) {
      filteredItems = items.where((item) {
        // Um item deve passar por todos os filtros para ser incluído
        return filters.every((filter) => filter(item));
      }).toList();
    }
    
    // Se a consulta estiver vazia, retorna os itens apenas com os filtros aplicados
    if (query.isEmpty) {
      // Ordenar resultados, se solicitado
      if (sortBy != null) {
        filteredItems.sort(sortBy);
      }
      return filteredItems;
    }
    
    // Normalizar a consulta para pesquisa
    final normalizedQuery = query.toLowerCase().trim();
    
    // Pesquisar nos campos fornecidos
    final results = filteredItems.where((item) {
      final fields = searchFields(item);
      
      // Um campo deve conter a consulta para o item ser incluído
      return fields.any((field) => 
        field != null && field.toLowerCase().contains(normalizedQuery)
      );
    }).toList();
    
    // Ordenar resultados, se solicitado
    if (sortBy != null) {
      results.sort(sortBy);
    }
    
    return results;
  }
  
  /// Função auxiliar para ordenar itens por data
  /// 
  /// [dateExtractor] deve retornar a data a ser usada para ordenação
  /// [descending] controla a direção da ordenação (padrão: decrescente/mais recente primeiro)
  int sortByDate<T>(T a, T b, DateTime? Function(T item) dateExtractor, {bool descending = true}) {
    final dateA = dateExtractor(a);
    final dateB = dateExtractor(b);
    
    // Tratar valores nulos
    if (dateA == null && dateB == null) return 0;
    if (dateA == null) return descending ? 1 : -1;
    if (dateB == null) return descending ? -1 : 1;
    
    // Comparar datas
    return descending 
        ? dateB.compareTo(dateA) 
        : dateA.compareTo(dateB);
  }
  
  /// Função auxiliar para ordenar itens por string
  /// 
  /// [stringExtractor] deve retornar a string a ser usada para ordenação
  /// [descending] controla a direção da ordenação (padrão: crescente/alfabético)
  int sortByString<T>(T a, T b, String? Function(T item) stringExtractor, {bool descending = false}) {
    final stringA = stringExtractor(a);
    final stringB = stringExtractor(b);
    
    // Tratar valores nulos
    if (stringA == null && stringB == null) return 0;
    if (stringA == null) return descending ? -1 : 1;
    if (stringB == null) return descending ? 1 : -1;
    
    // Comparar strings
    return descending 
        ? stringB.compareTo(stringA) 
        : stringA.compareTo(stringB);
  }
}

/// Provider global para o serviço de pesquisa
@riverpod
SearchService searchService(SearchServiceRef ref) {
  return SearchService();
}