// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_card_search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cachedCompanyCardsHash() =>
    r'e7acc93accb28339239cd78b952d1c12205042ba';

/// Provider para armazenar todos os cartões corporativos em cache
///
/// Copied from [cachedCompanyCards].
@ProviderFor(cachedCompanyCards)
final cachedCompanyCardsProvider =
    StreamProvider<List<CompanyCardModel>>.internal(
      cachedCompanyCards,
      name: r'cachedCompanyCardsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$cachedCompanyCardsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CachedCompanyCardsRef = StreamProviderRef<List<CompanyCardModel>>;
String _$searchCompanyCardsHash() =>
    r'dc7721ad6674a0e3d5428aaacb6ac4474b3b6706';

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

/// Provider para pesquisar cartões corporativos
///
/// Copied from [searchCompanyCards].
@ProviderFor(searchCompanyCards)
const searchCompanyCardsProvider = SearchCompanyCardsFamily();

/// Provider para pesquisar cartões corporativos
///
/// Copied from [searchCompanyCards].
class SearchCompanyCardsFamily extends Family<List<CompanyCardModel>> {
  /// Provider para pesquisar cartões corporativos
  ///
  /// Copied from [searchCompanyCards].
  const SearchCompanyCardsFamily();

  /// Provider para pesquisar cartões corporativos
  ///
  /// Copied from [searchCompanyCards].
  SearchCompanyCardsProvider call({
    required String query,
    bool? isActive,
    CompanyCardSortOption? sortOption,
  }) {
    return SearchCompanyCardsProvider(
      query: query,
      isActive: isActive,
      sortOption: sortOption,
    );
  }

  @override
  SearchCompanyCardsProvider getProviderOverride(
    covariant SearchCompanyCardsProvider provider,
  ) {
    return call(
      query: provider.query,
      isActive: provider.isActive,
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
  String? get name => r'searchCompanyCardsProvider';
}

/// Provider para pesquisar cartões corporativos
///
/// Copied from [searchCompanyCards].
class SearchCompanyCardsProvider
    extends AutoDisposeProvider<List<CompanyCardModel>> {
  /// Provider para pesquisar cartões corporativos
  ///
  /// Copied from [searchCompanyCards].
  SearchCompanyCardsProvider({
    required String query,
    bool? isActive,
    CompanyCardSortOption? sortOption,
  }) : this._internal(
         (ref) => searchCompanyCards(
           ref as SearchCompanyCardsRef,
           query: query,
           isActive: isActive,
           sortOption: sortOption,
         ),
         from: searchCompanyCardsProvider,
         name: r'searchCompanyCardsProvider',
         debugGetCreateSourceHash:
             const bool.fromEnvironment('dart.vm.product')
                 ? null
                 : _$searchCompanyCardsHash,
         dependencies: SearchCompanyCardsFamily._dependencies,
         allTransitiveDependencies:
             SearchCompanyCardsFamily._allTransitiveDependencies,
         query: query,
         isActive: isActive,
         sortOption: sortOption,
       );

  SearchCompanyCardsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
    required this.isActive,
    required this.sortOption,
  }) : super.internal();

  final String query;
  final bool? isActive;
  final CompanyCardSortOption? sortOption;

  @override
  Override overrideWith(
    List<CompanyCardModel> Function(SearchCompanyCardsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchCompanyCardsProvider._internal(
        (ref) => create(ref as SearchCompanyCardsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
        isActive: isActive,
        sortOption: sortOption,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<CompanyCardModel>> createElement() {
    return _SearchCompanyCardsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchCompanyCardsProvider &&
        other.query == query &&
        other.isActive == isActive &&
        other.sortOption == sortOption;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);
    hash = _SystemHash.combine(hash, isActive.hashCode);
    hash = _SystemHash.combine(hash, sortOption.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchCompanyCardsRef on AutoDisposeProviderRef<List<CompanyCardModel>> {
  /// The parameter `query` of this provider.
  String get query;

  /// The parameter `isActive` of this provider.
  bool? get isActive;

  /// The parameter `sortOption` of this provider.
  CompanyCardSortOption? get sortOption;
}

class _SearchCompanyCardsProviderElement
    extends AutoDisposeProviderElement<List<CompanyCardModel>>
    with SearchCompanyCardsRef {
  _SearchCompanyCardsProviderElement(super.provider);

  @override
  String get query => (origin as SearchCompanyCardsProvider).query;
  @override
  bool? get isActive => (origin as SearchCompanyCardsProvider).isActive;
  @override
  CompanyCardSortOption? get sortOption =>
      (origin as SearchCompanyCardsProvider).sortOption;
}

String _$companyCardSearchResultsHash() =>
    r'7449405dc99159a1d5933c0d047f6fdf26f19925';

/// Provider que combina a consulta e os filtros para fornecer resultados de pesquisa
///
/// Copied from [companyCardSearchResults].
@ProviderFor(companyCardSearchResults)
final companyCardSearchResultsProvider =
    AutoDisposeProvider<List<CompanyCardModel>>.internal(
      companyCardSearchResults,
      name: r'companyCardSearchResultsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$companyCardSearchResultsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompanyCardSearchResultsRef =
    AutoDisposeProviderRef<List<CompanyCardModel>>;
String _$companyCardSearchQueryHash() =>
    r'30b4d4d84bac54087eebae26bbc690735742fea3';

/// Provider para o estado da consulta de pesquisa
///
/// Copied from [CompanyCardSearchQuery].
@ProviderFor(CompanyCardSearchQuery)
final companyCardSearchQueryProvider =
    AutoDisposeNotifierProvider<CompanyCardSearchQuery, String>.internal(
      CompanyCardSearchQuery.new,
      name: r'companyCardSearchQueryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$companyCardSearchQueryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CompanyCardSearchQuery = AutoDisposeNotifier<String>;
String _$companyCardSearchFiltersHash() =>
    r'c6a69478709943075e9badcc9a151ff7f2d01ed6';

/// Provider para o estado dos filtros de pesquisa de cartões corporativos
///
/// Copied from [CompanyCardSearchFilters].
@ProviderFor(CompanyCardSearchFilters)
final companyCardSearchFiltersProvider = AutoDisposeNotifierProvider<
  CompanyCardSearchFilters,
  ({bool? isActive, CompanyCardSortOption sortOption})
>.internal(
  CompanyCardSearchFilters.new,
  name: r'companyCardSearchFiltersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$companyCardSearchFiltersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CompanyCardSearchFilters =
    AutoDisposeNotifier<({bool? isActive, CompanyCardSortOption sortOption})>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
