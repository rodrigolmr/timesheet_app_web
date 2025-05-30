// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cachedExpensesHash() => r'0f0da158185560d1c5f8b01ab2edcfccfec5076d';

/// Provider para armazenar todas as despesas em cache
///
/// Copied from [cachedExpenses].
@ProviderFor(cachedExpenses)
final cachedExpensesProvider = StreamProvider<List<ExpenseModel>>.internal(
  cachedExpenses,
  name: r'cachedExpensesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$cachedExpensesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CachedExpensesRef = StreamProviderRef<List<ExpenseModel>>;
String _$searchExpensesHash() => r'c621a54190e052e5584550f5e0e687f7a8ea4d51';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider para pesquisar despesas
///
/// Copied from [searchExpenses].
@ProviderFor(searchExpenses)
const searchExpensesProvider = SearchExpensesFamily();

/// Provider para pesquisar despesas
///
/// Copied from [searchExpenses].
class SearchExpensesFamily extends Family<List<ExpenseModel>> {
  /// Provider para pesquisar despesas
  ///
  /// Copied from [searchExpenses].
  const SearchExpensesFamily();

  /// Provider para pesquisar despesas
  ///
  /// Copied from [searchExpenses].
  SearchExpensesProvider call({
    required String query,
    String? userId,
    String? cardId,
    InvalidType status,
    ExpenseSortOption? sortOption,
  }) {
    return SearchExpensesProvider(
      query: query,
      userId: userId,
      cardId: cardId,
      status: status,
      sortOption: sortOption,
    );
  }

  @override
  SearchExpensesProvider getProviderOverride(
    covariant SearchExpensesProvider provider,
  ) {
    return call(
      query: provider.query,
      userId: provider.userId,
      cardId: provider.cardId,
      status: provider.status,
      sortOption: provider.sortOption,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchExpensesProvider';
}

/// Provider para pesquisar despesas
///
/// Copied from [searchExpenses].
class SearchExpensesProvider extends AutoDisposeProvider<List<ExpenseModel>> {
  /// Provider para pesquisar despesas
  ///
  /// Copied from [searchExpenses].
  SearchExpensesProvider({
    required String query,
    String? userId,
    String? cardId,
    InvalidType status,
    ExpenseSortOption? sortOption,
  }) : this._internal(
         (ref) => searchExpenses(
           ref as SearchExpensesRef,
           query: query,
           userId: userId,
           cardId: cardId,
           status: status,
           sortOption: sortOption,
         ),
         from: searchExpensesProvider,
         name: r'searchExpensesProvider',
         debugGetCreateSourceHash:
             const bool.fromEnvironment('dart.vm.product')
                 ? null
                 : _$searchExpensesHash,
         dependencies: SearchExpensesFamily._dependencies,
         allTransitiveDependencies:
             SearchExpensesFamily._allTransitiveDependencies,
         query: query,
         userId: userId,
         cardId: cardId,
         status: status,
         sortOption: sortOption,
       );

  SearchExpensesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
    required this.userId,
    required this.cardId,
    required this.status,
    required this.sortOption,
  }) : super.internal();

  final String query;
  final String? userId;
  final String? cardId;
  final InvalidType status;
  final ExpenseSortOption? sortOption;

  @override
  Override overrideWith(
    List<ExpenseModel> Function(SearchExpensesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchExpensesProvider._internal(
        (ref) => create(ref as SearchExpensesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
        userId: userId,
        cardId: cardId,
        status: status,
        sortOption: sortOption,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<ExpenseModel>> createElement() {
    return _SearchExpensesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchExpensesProvider &&
        other.query == query &&
        other.userId == userId &&
        other.cardId == cardId &&
        other.status == status &&
        other.sortOption == sortOption;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, cardId.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);
    hash = _SystemHash.combine(hash, sortOption.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchExpensesRef on AutoDisposeProviderRef<List<ExpenseModel>> {
  /// The parameter `query` of this provider.
  String get query;

  /// The parameter `userId` of this provider.
  String? get userId;

  /// The parameter `cardId` of this provider.
  String? get cardId;

  /// The parameter `status` of this provider.
  InvalidType get status;

  /// The parameter `sortOption` of this provider.
  ExpenseSortOption? get sortOption;
}

class _SearchExpensesProviderElement
    extends AutoDisposeProviderElement<List<ExpenseModel>>
    with SearchExpensesRef {
  _SearchExpensesProviderElement(super.provider);

  @override
  String get query => (origin as SearchExpensesProvider).query;
  @override
  String? get userId => (origin as SearchExpensesProvider).userId;
  @override
  String? get cardId => (origin as SearchExpensesProvider).cardId;
  @override
  InvalidType get status => (origin as SearchExpensesProvider).status;
  @override
  ExpenseSortOption? get sortOption =>
      (origin as SearchExpensesProvider).sortOption;
}

String _$expenseSearchResultsHash() =>
    r'b78e69636254195150cb12e3472485a08a9754a6';

/// Provider que combina a consulta e os filtros para fornecer resultados de pesquisa
///
/// Copied from [expenseSearchResults].
@ProviderFor(expenseSearchResults)
final expenseSearchResultsProvider =
    AutoDisposeProvider<List<ExpenseModel>>.internal(
      expenseSearchResults,
      name: r'expenseSearchResultsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$expenseSearchResultsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExpenseSearchResultsRef = AutoDisposeProviderRef<List<ExpenseModel>>;
String _$expenseSearchQueryHash() =>
    r'924853cf0e91343701ae6b6968b9895ae1c9a0ab';

/// Provider para o estado da consulta de pesquisa
///
/// Copied from [ExpenseSearchQuery].
@ProviderFor(ExpenseSearchQuery)
final expenseSearchQueryProvider =
    AutoDisposeNotifierProvider<ExpenseSearchQuery, String>.internal(
      ExpenseSearchQuery.new,
      name: r'expenseSearchQueryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$expenseSearchQueryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ExpenseSearchQuery = AutoDisposeNotifier<String>;
String _$expenseSearchFiltersHash() =>
    r'ab3fb3ccfda18dbcdbc41e4ed1dfddeaa67c07d1';

/// Provider para o estado dos filtros de pesquisa de despesas
///
/// Copied from [ExpenseSearchFilters].
@ProviderFor(ExpenseSearchFilters)
final expenseSearchFiltersProvider = AutoDisposeNotifierProvider<
  ExpenseSearchFilters,
  ({
    String? userId,
    String? cardId,
    ExpenseStatus? status,
    ExpenseSortOption sortOption,
  })
>.internal(
  ExpenseSearchFilters.new,
  name: r'expenseSearchFiltersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$expenseSearchFiltersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExpenseSearchFilters =
    AutoDisposeNotifier<
      ({
        String? userId,
        String? cardId,
        ExpenseStatus? status,
        ExpenseSortOption sortOption,
      })
    >;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
