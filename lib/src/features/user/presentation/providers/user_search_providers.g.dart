// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cachedUsersHash() => r'2b5e443c03b99ad8f7279b4711c8ec03d33ba131';

/// Provider para armazenar todos os usuários em cache
///
/// Copied from [cachedUsers].
@ProviderFor(cachedUsers)
final cachedUsersProvider = StreamProvider<List<UserModel>>.internal(
  cachedUsers,
  name: r'cachedUsersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$cachedUsersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CachedUsersRef = StreamProviderRef<List<UserModel>>;
String _$searchUsersHash() => r'a5ac19a7fa8a08ce08952cb9b34696a2904994f0';

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

/// Provider para pesquisar usuários
///
/// Copied from [searchUsers].
@ProviderFor(searchUsers)
const searchUsersProvider = SearchUsersFamily();

/// Provider para pesquisar usuários
///
/// Copied from [searchUsers].
class SearchUsersFamily extends Family<List<UserModel>> {
  /// Provider para pesquisar usuários
  ///
  /// Copied from [searchUsers].
  const SearchUsersFamily();

  /// Provider para pesquisar usuários
  ///
  /// Copied from [searchUsers].
  SearchUsersProvider call({
    required String query,
    String? role,
    bool? isActive,
    UserSortOption? sortOption,
  }) {
    return SearchUsersProvider(
      query: query,
      role: role,
      isActive: isActive,
      sortOption: sortOption,
    );
  }

  @override
  SearchUsersProvider getProviderOverride(
    covariant SearchUsersProvider provider,
  ) {
    return call(
      query: provider.query,
      role: provider.role,
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
  String? get name => r'searchUsersProvider';
}

/// Provider para pesquisar usuários
///
/// Copied from [searchUsers].
class SearchUsersProvider extends AutoDisposeProvider<List<UserModel>> {
  /// Provider para pesquisar usuários
  ///
  /// Copied from [searchUsers].
  SearchUsersProvider({
    required String query,
    String? role,
    bool? isActive,
    UserSortOption? sortOption,
  }) : this._internal(
         (ref) => searchUsers(
           ref as SearchUsersRef,
           query: query,
           role: role,
           isActive: isActive,
           sortOption: sortOption,
         ),
         from: searchUsersProvider,
         name: r'searchUsersProvider',
         debugGetCreateSourceHash:
             const bool.fromEnvironment('dart.vm.product')
                 ? null
                 : _$searchUsersHash,
         dependencies: SearchUsersFamily._dependencies,
         allTransitiveDependencies:
             SearchUsersFamily._allTransitiveDependencies,
         query: query,
         role: role,
         isActive: isActive,
         sortOption: sortOption,
       );

  SearchUsersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
    required this.role,
    required this.isActive,
    required this.sortOption,
  }) : super.internal();

  final String query;
  final String? role;
  final bool? isActive;
  final UserSortOption? sortOption;

  @override
  Override overrideWith(
    List<UserModel> Function(SearchUsersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchUsersProvider._internal(
        (ref) => create(ref as SearchUsersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
        role: role,
        isActive: isActive,
        sortOption: sortOption,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<UserModel>> createElement() {
    return _SearchUsersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchUsersProvider &&
        other.query == query &&
        other.role == role &&
        other.isActive == isActive &&
        other.sortOption == sortOption;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);
    hash = _SystemHash.combine(hash, role.hashCode);
    hash = _SystemHash.combine(hash, isActive.hashCode);
    hash = _SystemHash.combine(hash, sortOption.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchUsersRef on AutoDisposeProviderRef<List<UserModel>> {
  /// The parameter `query` of this provider.
  String get query;

  /// The parameter `role` of this provider.
  String? get role;

  /// The parameter `isActive` of this provider.
  bool? get isActive;

  /// The parameter `sortOption` of this provider.
  UserSortOption? get sortOption;
}

class _SearchUsersProviderElement
    extends AutoDisposeProviderElement<List<UserModel>>
    with SearchUsersRef {
  _SearchUsersProviderElement(super.provider);

  @override
  String get query => (origin as SearchUsersProvider).query;
  @override
  String? get role => (origin as SearchUsersProvider).role;
  @override
  bool? get isActive => (origin as SearchUsersProvider).isActive;
  @override
  UserSortOption? get sortOption => (origin as SearchUsersProvider).sortOption;
}

String _$userSearchResultsHash() => r'b04089706fba450a9b2501ac16e49b9de6f60d36';

/// Provider que combina a consulta e os filtros para fornecer resultados de pesquisa
///
/// Copied from [userSearchResults].
@ProviderFor(userSearchResults)
final userSearchResultsProvider = AutoDisposeProvider<List<UserModel>>.internal(
  userSearchResults,
  name: r'userSearchResultsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userSearchResultsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserSearchResultsRef = AutoDisposeProviderRef<List<UserModel>>;
String _$userSearchQueryHash() => r'c1437efb44d58b4a919ceccc92d05c38bb11e25b';

/// Provider para o estado da consulta de pesquisa
///
/// Copied from [UserSearchQuery].
@ProviderFor(UserSearchQuery)
final userSearchQueryProvider =
    AutoDisposeNotifierProvider<UserSearchQuery, String>.internal(
      UserSearchQuery.new,
      name: r'userSearchQueryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$userSearchQueryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UserSearchQuery = AutoDisposeNotifier<String>;
String _$userSearchFiltersHash() => r'68235f48c87220821332d33c6472cae7b169322c';

/// Provider para o estado dos filtros de pesquisa de usuários
///
/// Copied from [UserSearchFilters].
@ProviderFor(UserSearchFilters)
final userSearchFiltersProvider = AutoDisposeNotifierProvider<
  UserSearchFilters,
  ({String? role, bool? isActive, UserSortOption sortOption})
>.internal(
  UserSearchFilters.new,
  name: r'userSearchFiltersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userSearchFiltersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserSearchFilters =
    AutoDisposeNotifier<
      ({String? role, bool? isActive, UserSortOption sortOption})
    >;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
