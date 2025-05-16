// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cachedEmployeesHash() => r'4f46c60ebe40882baafe99bcf1e96a73c92e43fb';

/// Provider para armazenar todos os funcionários em cache
///
/// Copied from [cachedEmployees].
@ProviderFor(cachedEmployees)
final cachedEmployeesProvider = StreamProvider<List<EmployeeModel>>.internal(
  cachedEmployees,
  name: r'cachedEmployeesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$cachedEmployeesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CachedEmployeesRef = StreamProviderRef<List<EmployeeModel>>;
String _$searchEmployeesHash() => r'a0c4a5064b748d1593f3ea311d53df7baafbcf41';

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

/// Provider para pesquisar funcionários
///
/// Copied from [searchEmployees].
@ProviderFor(searchEmployees)
const searchEmployeesProvider = SearchEmployeesFamily();

/// Provider para pesquisar funcionários
///
/// Copied from [searchEmployees].
class SearchEmployeesFamily extends Family<List<EmployeeModel>> {
  /// Provider para pesquisar funcionários
  ///
  /// Copied from [searchEmployees].
  const SearchEmployeesFamily();

  /// Provider para pesquisar funcionários
  ///
  /// Copied from [searchEmployees].
  SearchEmployeesProvider call({
    required String query,
    bool? isActive,
    EmployeeSortOption? sortOption,
  }) {
    return SearchEmployeesProvider(
      query: query,
      isActive: isActive,
      sortOption: sortOption,
    );
  }

  @override
  SearchEmployeesProvider getProviderOverride(
    covariant SearchEmployeesProvider provider,
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
  String? get name => r'searchEmployeesProvider';
}

/// Provider para pesquisar funcionários
///
/// Copied from [searchEmployees].
class SearchEmployeesProvider extends AutoDisposeProvider<List<EmployeeModel>> {
  /// Provider para pesquisar funcionários
  ///
  /// Copied from [searchEmployees].
  SearchEmployeesProvider({
    required String query,
    bool? isActive,
    EmployeeSortOption? sortOption,
  }) : this._internal(
         (ref) => searchEmployees(
           ref as SearchEmployeesRef,
           query: query,
           isActive: isActive,
           sortOption: sortOption,
         ),
         from: searchEmployeesProvider,
         name: r'searchEmployeesProvider',
         debugGetCreateSourceHash:
             const bool.fromEnvironment('dart.vm.product')
                 ? null
                 : _$searchEmployeesHash,
         dependencies: SearchEmployeesFamily._dependencies,
         allTransitiveDependencies:
             SearchEmployeesFamily._allTransitiveDependencies,
         query: query,
         isActive: isActive,
         sortOption: sortOption,
       );

  SearchEmployeesProvider._internal(
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
  final EmployeeSortOption? sortOption;

  @override
  Override overrideWith(
    List<EmployeeModel> Function(SearchEmployeesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchEmployeesProvider._internal(
        (ref) => create(ref as SearchEmployeesRef),
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
  AutoDisposeProviderElement<List<EmployeeModel>> createElement() {
    return _SearchEmployeesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchEmployeesProvider &&
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
mixin SearchEmployeesRef on AutoDisposeProviderRef<List<EmployeeModel>> {
  /// The parameter `query` of this provider.
  String get query;

  /// The parameter `isActive` of this provider.
  bool? get isActive;

  /// The parameter `sortOption` of this provider.
  EmployeeSortOption? get sortOption;
}

class _SearchEmployeesProviderElement
    extends AutoDisposeProviderElement<List<EmployeeModel>>
    with SearchEmployeesRef {
  _SearchEmployeesProviderElement(super.provider);

  @override
  String get query => (origin as SearchEmployeesProvider).query;
  @override
  bool? get isActive => (origin as SearchEmployeesProvider).isActive;
  @override
  EmployeeSortOption? get sortOption =>
      (origin as SearchEmployeesProvider).sortOption;
}

String _$employeeSearchResultsHash() =>
    r'8aae146ee27b8f35f6307731136fe8675419e318';

/// Provider que combina a consulta e os filtros para fornecer resultados de pesquisa
///
/// Copied from [employeeSearchResults].
@ProviderFor(employeeSearchResults)
final employeeSearchResultsProvider =
    AutoDisposeProvider<List<EmployeeModel>>.internal(
      employeeSearchResults,
      name: r'employeeSearchResultsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$employeeSearchResultsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EmployeeSearchResultsRef = AutoDisposeProviderRef<List<EmployeeModel>>;
String _$employeeSearchQueryHash() =>
    r'946a010afec79cec0f9b5e99f1da2509ae755207';

/// Provider para o estado da consulta de pesquisa
///
/// Copied from [EmployeeSearchQuery].
@ProviderFor(EmployeeSearchQuery)
final employeeSearchQueryProvider =
    AutoDisposeNotifierProvider<EmployeeSearchQuery, String>.internal(
      EmployeeSearchQuery.new,
      name: r'employeeSearchQueryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$employeeSearchQueryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$EmployeeSearchQuery = AutoDisposeNotifier<String>;
String _$employeeSearchFiltersHash() =>
    r'0a476d9de9cbc90ac5f7b308fd7a1b3d6c9cceb4';

/// Provider para o estado dos filtros de pesquisa de funcionários
///
/// Copied from [EmployeeSearchFilters].
@ProviderFor(EmployeeSearchFilters)
final employeeSearchFiltersProvider = AutoDisposeNotifierProvider<
  EmployeeSearchFilters,
  ({bool? isActive, EmployeeSortOption sortOption})
>.internal(
  EmployeeSearchFilters.new,
  name: r'employeeSearchFiltersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$employeeSearchFiltersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EmployeeSearchFilters =
    AutoDisposeNotifier<({bool? isActive, EmployeeSortOption sortOption})>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
