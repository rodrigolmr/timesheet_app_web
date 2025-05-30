// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_record_search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cachedJobRecordsHash() => r'363dbe8edb4f12065b3d57979ac883d8e4fdc61d';

/// Provider para armazenar todos os registros de trabalho em cache
///
/// Copied from [cachedJobRecords].
@ProviderFor(cachedJobRecords)
final cachedJobRecordsProvider = StreamProvider<List<JobRecordModel>>.internal(
  cachedJobRecords,
  name: r'cachedJobRecordsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$cachedJobRecordsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CachedJobRecordsRef = StreamProviderRef<List<JobRecordModel>>;
String _$searchJobRecordsHash() => r'b776ff3adb44054e6b8064964d67ba2c0466b690';

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

/// Provider para pesquisar registros de trabalho
///
/// Copied from [searchJobRecords].
@ProviderFor(searchJobRecords)
const searchJobRecordsProvider = SearchJobRecordsFamily();

/// Provider para pesquisar registros de trabalho
///
/// Copied from [searchJobRecords].
class SearchJobRecordsFamily extends Family<List<JobRecordModel>> {
  /// Provider para pesquisar registros de trabalho
  ///
  /// Copied from [searchJobRecords].
  const SearchJobRecordsFamily();

  /// Provider para pesquisar registros de trabalho
  ///
  /// Copied from [searchJobRecords].
  SearchJobRecordsProvider call({
    required String query,
    String? userId,
    String? location,
    JobRecordSortOption? sortOption,
  }) {
    return SearchJobRecordsProvider(
      query: query,
      userId: userId,
      location: location,
      sortOption: sortOption,
    );
  }

  @override
  SearchJobRecordsProvider getProviderOverride(
    covariant SearchJobRecordsProvider provider,
  ) {
    return call(
      query: provider.query,
      userId: provider.userId,
      location: provider.location,
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
  String? get name => r'searchJobRecordsProvider';
}

/// Provider para pesquisar registros de trabalho
///
/// Copied from [searchJobRecords].
class SearchJobRecordsProvider
    extends AutoDisposeProvider<List<JobRecordModel>> {
  /// Provider para pesquisar registros de trabalho
  ///
  /// Copied from [searchJobRecords].
  SearchJobRecordsProvider({
    required String query,
    String? userId,
    String? location,
    JobRecordSortOption? sortOption,
  }) : this._internal(
         (ref) => searchJobRecords(
           ref as SearchJobRecordsRef,
           query: query,
           userId: userId,
           location: location,
           sortOption: sortOption,
         ),
         from: searchJobRecordsProvider,
         name: r'searchJobRecordsProvider',
         debugGetCreateSourceHash:
             const bool.fromEnvironment('dart.vm.product')
                 ? null
                 : _$searchJobRecordsHash,
         dependencies: SearchJobRecordsFamily._dependencies,
         allTransitiveDependencies:
             SearchJobRecordsFamily._allTransitiveDependencies,
         query: query,
         userId: userId,
         location: location,
         sortOption: sortOption,
       );

  SearchJobRecordsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
    required this.userId,
    required this.location,
    required this.sortOption,
  }) : super.internal();

  final String query;
  final String? userId;
  final String? location;
  final JobRecordSortOption? sortOption;

  @override
  Override overrideWith(
    List<JobRecordModel> Function(SearchJobRecordsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchJobRecordsProvider._internal(
        (ref) => create(ref as SearchJobRecordsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
        userId: userId,
        location: location,
        sortOption: sortOption,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<JobRecordModel>> createElement() {
    return _SearchJobRecordsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchJobRecordsProvider &&
        other.query == query &&
        other.userId == userId &&
        other.location == location &&
        other.sortOption == sortOption;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, location.hashCode);
    hash = _SystemHash.combine(hash, sortOption.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchJobRecordsRef on AutoDisposeProviderRef<List<JobRecordModel>> {
  /// The parameter `query` of this provider.
  String get query;

  /// The parameter `userId` of this provider.
  String? get userId;

  /// The parameter `location` of this provider.
  String? get location;

  /// The parameter `sortOption` of this provider.
  JobRecordSortOption? get sortOption;
}

class _SearchJobRecordsProviderElement
    extends AutoDisposeProviderElement<List<JobRecordModel>>
    with SearchJobRecordsRef {
  _SearchJobRecordsProviderElement(super.provider);

  @override
  String get query => (origin as SearchJobRecordsProvider).query;
  @override
  String? get userId => (origin as SearchJobRecordsProvider).userId;
  @override
  String? get location => (origin as SearchJobRecordsProvider).location;
  @override
  JobRecordSortOption? get sortOption =>
      (origin as SearchJobRecordsProvider).sortOption;
}

String _$jobRecordSearchResultsHash() =>
    r'195a5b04b07d94835ab1f89022743b6fb5f7366f';

/// Provider que combina a consulta e os filtros para fornecer resultados de pesquisa
///
/// Copied from [jobRecordSearchResults].
@ProviderFor(jobRecordSearchResults)
final jobRecordSearchResultsProvider =
    AutoDisposeProvider<List<JobRecordModel>>.internal(
      jobRecordSearchResults,
      name: r'jobRecordSearchResultsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$jobRecordSearchResultsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JobRecordSearchResultsRef =
    AutoDisposeProviderRef<List<JobRecordModel>>;
String _$jobRecordSearchQueryHash() =>
    r'32be0e05eb837002722c08e5c70b3ee03e190459';

/// Provider para o estado da consulta de pesquisa
///
/// Copied from [JobRecordSearchQuery].
@ProviderFor(JobRecordSearchQuery)
final jobRecordSearchQueryProvider =
    AutoDisposeNotifierProvider<JobRecordSearchQuery, String>.internal(
      JobRecordSearchQuery.new,
      name: r'jobRecordSearchQueryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$jobRecordSearchQueryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$JobRecordSearchQuery = AutoDisposeNotifier<String>;
String _$jobRecordSearchFiltersHash() =>
    r'876a3b78504ea2f154b0f4a34fb9a81fb51316d7';

/// Provider para o estado dos filtros de pesquisa de registros de trabalho
///
/// Copied from [JobRecordSearchFilters].
@ProviderFor(JobRecordSearchFilters)
final jobRecordSearchFiltersProvider = AutoDisposeNotifierProvider<
  JobRecordSearchFilters,
  ({String? userId, String? location, JobRecordSortOption sortOption})
>.internal(
  JobRecordSearchFilters.new,
  name: r'jobRecordSearchFiltersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$jobRecordSearchFiltersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$JobRecordSearchFilters =
    AutoDisposeNotifier<
      ({String? userId, String? location, JobRecordSortOption sortOption})
    >;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
