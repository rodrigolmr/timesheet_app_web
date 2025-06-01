// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pigtail_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pigtailRepositoryHash() => r'18aaef54a30438fadad4e2ecdb464cf1539df1e9';

/// See also [pigtailRepository].
@ProviderFor(pigtailRepository)
final pigtailRepositoryProvider =
    AutoDisposeProvider<PigtailRepository>.internal(
      pigtailRepository,
      name: r'pigtailRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$pigtailRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PigtailRepositoryRef = AutoDisposeProviderRef<PigtailRepository>;
String _$pigtailsHash() => r'e4c33611b434892ac686f3eb4ff93a50f244d427';

/// See also [pigtails].
@ProviderFor(pigtails)
final pigtailsProvider = AutoDisposeFutureProvider<List<PigtailModel>>.internal(
  pigtails,
  name: r'pigtailsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$pigtailsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PigtailsRef = AutoDisposeFutureProviderRef<List<PigtailModel>>;
String _$pigtailsStreamHash() => r'e11359b146b7417fdf6cacf33a7af29a388693ad';

/// See also [pigtailsStream].
@ProviderFor(pigtailsStream)
final pigtailsStreamProvider =
    AutoDisposeStreamProvider<List<PigtailModel>>.internal(
      pigtailsStream,
      name: r'pigtailsStreamProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$pigtailsStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PigtailsStreamRef = AutoDisposeStreamProviderRef<List<PigtailModel>>;
String _$pigtailByIdHash() => r'99aeabf52b265033d187823afe4360ca026a9e40';

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

/// See also [pigtailById].
@ProviderFor(pigtailById)
const pigtailByIdProvider = PigtailByIdFamily();

/// See also [pigtailById].
class PigtailByIdFamily extends Family<AsyncValue<PigtailModel?>> {
  /// See also [pigtailById].
  const PigtailByIdFamily();

  /// See also [pigtailById].
  PigtailByIdProvider call(String id) {
    return PigtailByIdProvider(id);
  }

  @override
  PigtailByIdProvider getProviderOverride(
    covariant PigtailByIdProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'pigtailByIdProvider';
}

/// See also [pigtailById].
class PigtailByIdProvider extends AutoDisposeStreamProvider<PigtailModel?> {
  /// See also [pigtailById].
  PigtailByIdProvider(String id)
    : this._internal(
        (ref) => pigtailById(ref as PigtailByIdRef, id),
        from: pigtailByIdProvider,
        name: r'pigtailByIdProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$pigtailByIdHash,
        dependencies: PigtailByIdFamily._dependencies,
        allTransitiveDependencies: PigtailByIdFamily._allTransitiveDependencies,
        id: id,
      );

  PigtailByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    Stream<PigtailModel?> Function(PigtailByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PigtailByIdProvider._internal(
        (ref) => create(ref as PigtailByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<PigtailModel?> createElement() {
    return _PigtailByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PigtailByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PigtailByIdRef on AutoDisposeStreamProviderRef<PigtailModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _PigtailByIdProviderElement
    extends AutoDisposeStreamProviderElement<PigtailModel?>
    with PigtailByIdRef {
  _PigtailByIdProviderElement(super.provider);

  @override
  String get id => (origin as PigtailByIdProvider).id;
}

String _$cachedPigtailsHash() => r'de058ca0c3749b4da314fcbaa54d264d92fbe4de';

/// See also [cachedPigtails].
@ProviderFor(cachedPigtails)
final cachedPigtailsProvider = StreamProvider<List<PigtailModel>>.internal(
  cachedPigtails,
  name: r'cachedPigtailsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$cachedPigtailsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CachedPigtailsRef = StreamProviderRef<List<PigtailModel>>;
String _$canEditPigtailHash() => r'87f9317f992426f9303ea2e21712ea26c6e1e5cd';

/// See also [canEditPigtail].
@ProviderFor(canEditPigtail)
const canEditPigtailProvider = CanEditPigtailFamily();

/// See also [canEditPigtail].
class CanEditPigtailFamily extends Family<AsyncValue<bool>> {
  /// See also [canEditPigtail].
  const CanEditPigtailFamily();

  /// See also [canEditPigtail].
  CanEditPigtailProvider call(String pigtailCreatorId) {
    return CanEditPigtailProvider(pigtailCreatorId);
  }

  @override
  CanEditPigtailProvider getProviderOverride(
    covariant CanEditPigtailProvider provider,
  ) {
    return call(provider.pigtailCreatorId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'canEditPigtailProvider';
}

/// See also [canEditPigtail].
class CanEditPigtailProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [canEditPigtail].
  CanEditPigtailProvider(String pigtailCreatorId)
    : this._internal(
        (ref) => canEditPigtail(ref as CanEditPigtailRef, pigtailCreatorId),
        from: canEditPigtailProvider,
        name: r'canEditPigtailProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$canEditPigtailHash,
        dependencies: CanEditPigtailFamily._dependencies,
        allTransitiveDependencies:
            CanEditPigtailFamily._allTransitiveDependencies,
        pigtailCreatorId: pigtailCreatorId,
      );

  CanEditPigtailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pigtailCreatorId,
  }) : super.internal();

  final String pigtailCreatorId;

  @override
  Override overrideWith(
    FutureOr<bool> Function(CanEditPigtailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CanEditPigtailProvider._internal(
        (ref) => create(ref as CanEditPigtailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pigtailCreatorId: pigtailCreatorId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _CanEditPigtailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CanEditPigtailProvider &&
        other.pigtailCreatorId == pigtailCreatorId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pigtailCreatorId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CanEditPigtailRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `pigtailCreatorId` of this provider.
  String get pigtailCreatorId;
}

class _CanEditPigtailProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with CanEditPigtailRef {
  _CanEditPigtailProviderElement(super.provider);

  @override
  String get pigtailCreatorId =>
      (origin as CanEditPigtailProvider).pigtailCreatorId;
}

String _$canDeletePigtailHash() => r'c89c8bd0fa516d228bf0e2af991f111a1cf25fd2';

/// See also [canDeletePigtail].
@ProviderFor(canDeletePigtail)
final canDeletePigtailProvider = AutoDisposeFutureProvider<bool>.internal(
  canDeletePigtail,
  name: r'canDeletePigtailProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$canDeletePigtailHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CanDeletePigtailRef = AutoDisposeFutureProviderRef<bool>;
String _$uniquePigtailAddressesHash() =>
    r'f50c73df4ad805e8a1a14a6d0dba3d700e5b1013';

/// See also [uniquePigtailAddresses].
@ProviderFor(uniquePigtailAddresses)
final uniquePigtailAddressesProvider =
    AutoDisposeFutureProvider<List<String>>.internal(
      uniquePigtailAddresses,
      name: r'uniquePigtailAddressesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$uniquePigtailAddressesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UniquePigtailAddressesRef = AutoDisposeFutureProviderRef<List<String>>;
String _$pigtailStateHash() => r'6d8f19cc0fa18b2dba3af8b83cb610bd5631bdef';

/// See also [PigtailState].
@ProviderFor(PigtailState)
final pigtailStateProvider = AutoDisposeNotifierProvider<
  PigtailState,
  AsyncValue<PigtailModel?>
>.internal(
  PigtailState.new,
  name: r'pigtailStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$pigtailStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PigtailState = AutoDisposeNotifier<AsyncValue<PigtailModel?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
