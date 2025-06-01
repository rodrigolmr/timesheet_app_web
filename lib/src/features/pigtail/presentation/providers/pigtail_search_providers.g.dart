// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pigtail_search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchPigtailsHash() => r'1d09b94984b45b81821e63e859c8910e2986bf72';

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

/// See also [searchPigtails].
@ProviderFor(searchPigtails)
const searchPigtailsProvider = SearchPigtailsFamily();

/// See also [searchPigtails].
class SearchPigtailsFamily extends Family<List<PigtailModel>> {
  /// See also [searchPigtails].
  const SearchPigtailsFamily();

  /// See also [searchPigtails].
  SearchPigtailsProvider call({
    required String query,
    String? status,
    String? type,
  }) {
    return SearchPigtailsProvider(query: query, status: status, type: type);
  }

  @override
  SearchPigtailsProvider getProviderOverride(
    covariant SearchPigtailsProvider provider,
  ) {
    return call(
      query: provider.query,
      status: provider.status,
      type: provider.type,
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
  String? get name => r'searchPigtailsProvider';
}

/// See also [searchPigtails].
class SearchPigtailsProvider extends AutoDisposeProvider<List<PigtailModel>> {
  /// See also [searchPigtails].
  SearchPigtailsProvider({required String query, String? status, String? type})
    : this._internal(
        (ref) => searchPigtails(
          ref as SearchPigtailsRef,
          query: query,
          status: status,
          type: type,
        ),
        from: searchPigtailsProvider,
        name: r'searchPigtailsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$searchPigtailsHash,
        dependencies: SearchPigtailsFamily._dependencies,
        allTransitiveDependencies:
            SearchPigtailsFamily._allTransitiveDependencies,
        query: query,
        status: status,
        type: type,
      );

  SearchPigtailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
    required this.status,
    required this.type,
  }) : super.internal();

  final String query;
  final String? status;
  final String? type;

  @override
  Override overrideWith(
    List<PigtailModel> Function(SearchPigtailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchPigtailsProvider._internal(
        (ref) => create(ref as SearchPigtailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
        status: status,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<PigtailModel>> createElement() {
    return _SearchPigtailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchPigtailsProvider &&
        other.query == query &&
        other.status == status &&
        other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchPigtailsRef on AutoDisposeProviderRef<List<PigtailModel>> {
  /// The parameter `query` of this provider.
  String get query;

  /// The parameter `status` of this provider.
  String? get status;

  /// The parameter `type` of this provider.
  String? get type;
}

class _SearchPigtailsProviderElement
    extends AutoDisposeProviderElement<List<PigtailModel>>
    with SearchPigtailsRef {
  _SearchPigtailsProviderElement(super.provider);

  @override
  String get query => (origin as SearchPigtailsProvider).query;
  @override
  String? get status => (origin as SearchPigtailsProvider).status;
  @override
  String? get type => (origin as SearchPigtailsProvider).type;
}

String _$pigtailSearchResultsHash() =>
    r'5cc13396dbbb6b12d5d9b1453ec66695d9297d04';

/// See also [pigtailSearchResults].
@ProviderFor(pigtailSearchResults)
final pigtailSearchResultsProvider =
    AutoDisposeProvider<List<PigtailModel>>.internal(
      pigtailSearchResults,
      name: r'pigtailSearchResultsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$pigtailSearchResultsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PigtailSearchResultsRef = AutoDisposeProviderRef<List<PigtailModel>>;
String _$availablePigtailTypesHash() =>
    r'43333319fa8ef0c18bc558852b806bfedd217927';

/// See also [availablePigtailTypes].
@ProviderFor(availablePigtailTypes)
final availablePigtailTypesProvider =
    AutoDisposeProvider<List<String>>.internal(
      availablePigtailTypes,
      name: r'availablePigtailTypesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$availablePigtailTypesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailablePigtailTypesRef = AutoDisposeProviderRef<List<String>>;
String _$pigtailSearchQueryHash() =>
    r'bf4df6c9961300cc5d244719318c9a8ee5cee1f2';

/// See also [PigtailSearchQuery].
@ProviderFor(PigtailSearchQuery)
final pigtailSearchQueryProvider =
    AutoDisposeNotifierProvider<PigtailSearchQuery, String>.internal(
      PigtailSearchQuery.new,
      name: r'pigtailSearchQueryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$pigtailSearchQueryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PigtailSearchQuery = AutoDisposeNotifier<String>;
String _$pigtailSearchFiltersHash() =>
    r'ee77819797752d100a4b9f7c367ffa5705bb47ef';

/// See also [PigtailSearchFilters].
@ProviderFor(PigtailSearchFilters)
final pigtailSearchFiltersProvider = AutoDisposeNotifierProvider<
  PigtailSearchFilters,
  ({String? status, String? type})
>.internal(
  PigtailSearchFilters.new,
  name: r'pigtailSearchFiltersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pigtailSearchFiltersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PigtailSearchFilters =
    AutoDisposeNotifier<({String? status, String? type})>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
