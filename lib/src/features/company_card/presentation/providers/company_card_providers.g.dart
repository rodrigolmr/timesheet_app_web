// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_card_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$companyCardRepositoryHash() =>
    r'52511b161c2bbbb8e99fb2344b6d2852bdda1410';

/// Provider que fornece o repositório de cartões corporativos
///
/// Copied from [companyCardRepository].
@ProviderFor(companyCardRepository)
final companyCardRepositoryProvider =
    AutoDisposeProvider<CompanyCardRepository>.internal(
      companyCardRepository,
      name: r'companyCardRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$companyCardRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompanyCardRepositoryRef =
    AutoDisposeProviderRef<CompanyCardRepository>;
String _$companyCardsHash() => r'124b10c818a286a4aed99565c425eaf8768bb075';

/// Provider para obter todos os cartões
///
/// Copied from [companyCards].
@ProviderFor(companyCards)
final companyCardsProvider =
    AutoDisposeFutureProvider<List<CompanyCardModel>>.internal(
      companyCards,
      name: r'companyCardsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$companyCardsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompanyCardsRef = AutoDisposeFutureProviderRef<List<CompanyCardModel>>;
String _$companyCardsStreamHash() =>
    r'c2ff2473588c9cca8face987c69fc7e10ddea2c3';

/// Provider para observar todos os cartões em tempo real
///
/// Copied from [companyCardsStream].
@ProviderFor(companyCardsStream)
final companyCardsStreamProvider =
    AutoDisposeStreamProvider<List<CompanyCardModel>>.internal(
      companyCardsStream,
      name: r'companyCardsStreamProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$companyCardsStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompanyCardsStreamRef =
    AutoDisposeStreamProviderRef<List<CompanyCardModel>>;
String _$companyCardHash() => r'a01fb01473ff0d142fc4feb41f503661d428966c';

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

/// Provider para obter um cartão específico por ID
///
/// Copied from [companyCard].
@ProviderFor(companyCard)
const companyCardProvider = CompanyCardFamily();

/// Provider para obter um cartão específico por ID
///
/// Copied from [companyCard].
class CompanyCardFamily extends Family<AsyncValue<CompanyCardModel?>> {
  /// Provider para obter um cartão específico por ID
  ///
  /// Copied from [companyCard].
  const CompanyCardFamily();

  /// Provider para obter um cartão específico por ID
  ///
  /// Copied from [companyCard].
  CompanyCardProvider call(String id) {
    return CompanyCardProvider(id);
  }

  @override
  CompanyCardProvider getProviderOverride(
    covariant CompanyCardProvider provider,
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
  String? get name => r'companyCardProvider';
}

/// Provider para obter um cartão específico por ID
///
/// Copied from [companyCard].
class CompanyCardProvider extends AutoDisposeFutureProvider<CompanyCardModel?> {
  /// Provider para obter um cartão específico por ID
  ///
  /// Copied from [companyCard].
  CompanyCardProvider(String id)
    : this._internal(
        (ref) => companyCard(ref as CompanyCardRef, id),
        from: companyCardProvider,
        name: r'companyCardProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$companyCardHash,
        dependencies: CompanyCardFamily._dependencies,
        allTransitiveDependencies: CompanyCardFamily._allTransitiveDependencies,
        id: id,
      );

  CompanyCardProvider._internal(
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
    FutureOr<CompanyCardModel?> Function(CompanyCardRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CompanyCardProvider._internal(
        (ref) => create(ref as CompanyCardRef),
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
  AutoDisposeFutureProviderElement<CompanyCardModel?> createElement() {
    return _CompanyCardProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CompanyCardProvider && other.id == id;
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
mixin CompanyCardRef on AutoDisposeFutureProviderRef<CompanyCardModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _CompanyCardProviderElement
    extends AutoDisposeFutureProviderElement<CompanyCardModel?>
    with CompanyCardRef {
  _CompanyCardProviderElement(super.provider);

  @override
  String get id => (origin as CompanyCardProvider).id;
}

String _$companyCardStreamHash() => r'a2ab04b52d76fda995f90a5e3c8331759a011b38';

/// Provider para observar um cartão específico em tempo real
///
/// Copied from [companyCardStream].
@ProviderFor(companyCardStream)
const companyCardStreamProvider = CompanyCardStreamFamily();

/// Provider para observar um cartão específico em tempo real
///
/// Copied from [companyCardStream].
class CompanyCardStreamFamily extends Family<AsyncValue<CompanyCardModel?>> {
  /// Provider para observar um cartão específico em tempo real
  ///
  /// Copied from [companyCardStream].
  const CompanyCardStreamFamily();

  /// Provider para observar um cartão específico em tempo real
  ///
  /// Copied from [companyCardStream].
  CompanyCardStreamProvider call(String id) {
    return CompanyCardStreamProvider(id);
  }

  @override
  CompanyCardStreamProvider getProviderOverride(
    covariant CompanyCardStreamProvider provider,
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
  String? get name => r'companyCardStreamProvider';
}

/// Provider para observar um cartão específico em tempo real
///
/// Copied from [companyCardStream].
class CompanyCardStreamProvider
    extends AutoDisposeStreamProvider<CompanyCardModel?> {
  /// Provider para observar um cartão específico em tempo real
  ///
  /// Copied from [companyCardStream].
  CompanyCardStreamProvider(String id)
    : this._internal(
        (ref) => companyCardStream(ref as CompanyCardStreamRef, id),
        from: companyCardStreamProvider,
        name: r'companyCardStreamProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$companyCardStreamHash,
        dependencies: CompanyCardStreamFamily._dependencies,
        allTransitiveDependencies:
            CompanyCardStreamFamily._allTransitiveDependencies,
        id: id,
      );

  CompanyCardStreamProvider._internal(
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
    Stream<CompanyCardModel?> Function(CompanyCardStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CompanyCardStreamProvider._internal(
        (ref) => create(ref as CompanyCardStreamRef),
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
  AutoDisposeStreamProviderElement<CompanyCardModel?> createElement() {
    return _CompanyCardStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CompanyCardStreamProvider && other.id == id;
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
mixin CompanyCardStreamRef on AutoDisposeStreamProviderRef<CompanyCardModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _CompanyCardStreamProviderElement
    extends AutoDisposeStreamProviderElement<CompanyCardModel?>
    with CompanyCardStreamRef {
  _CompanyCardStreamProviderElement(super.provider);

  @override
  String get id => (origin as CompanyCardStreamProvider).id;
}

String _$companyCardByIdStreamHash() =>
    r'defaae113309ea9b2d7fd8d921bd04da96738475';

/// Provider para observar um cartão específico em tempo real (alternativo para telas)
///
/// Copied from [companyCardByIdStream].
@ProviderFor(companyCardByIdStream)
const companyCardByIdStreamProvider = CompanyCardByIdStreamFamily();

/// Provider para observar um cartão específico em tempo real (alternativo para telas)
///
/// Copied from [companyCardByIdStream].
class CompanyCardByIdStreamFamily
    extends Family<AsyncValue<CompanyCardModel?>> {
  /// Provider para observar um cartão específico em tempo real (alternativo para telas)
  ///
  /// Copied from [companyCardByIdStream].
  const CompanyCardByIdStreamFamily();

  /// Provider para observar um cartão específico em tempo real (alternativo para telas)
  ///
  /// Copied from [companyCardByIdStream].
  CompanyCardByIdStreamProvider call(String id) {
    return CompanyCardByIdStreamProvider(id);
  }

  @override
  CompanyCardByIdStreamProvider getProviderOverride(
    covariant CompanyCardByIdStreamProvider provider,
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
  String? get name => r'companyCardByIdStreamProvider';
}

/// Provider para observar um cartão específico em tempo real (alternativo para telas)
///
/// Copied from [companyCardByIdStream].
class CompanyCardByIdStreamProvider
    extends AutoDisposeStreamProvider<CompanyCardModel?> {
  /// Provider para observar um cartão específico em tempo real (alternativo para telas)
  ///
  /// Copied from [companyCardByIdStream].
  CompanyCardByIdStreamProvider(String id)
    : this._internal(
        (ref) => companyCardByIdStream(ref as CompanyCardByIdStreamRef, id),
        from: companyCardByIdStreamProvider,
        name: r'companyCardByIdStreamProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$companyCardByIdStreamHash,
        dependencies: CompanyCardByIdStreamFamily._dependencies,
        allTransitiveDependencies:
            CompanyCardByIdStreamFamily._allTransitiveDependencies,
        id: id,
      );

  CompanyCardByIdStreamProvider._internal(
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
    Stream<CompanyCardModel?> Function(CompanyCardByIdStreamRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CompanyCardByIdStreamProvider._internal(
        (ref) => create(ref as CompanyCardByIdStreamRef),
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
  AutoDisposeStreamProviderElement<CompanyCardModel?> createElement() {
    return _CompanyCardByIdStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CompanyCardByIdStreamProvider && other.id == id;
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
mixin CompanyCardByIdStreamRef
    on AutoDisposeStreamProviderRef<CompanyCardModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _CompanyCardByIdStreamProviderElement
    extends AutoDisposeStreamProviderElement<CompanyCardModel?>
    with CompanyCardByIdStreamRef {
  _CompanyCardByIdStreamProviderElement(super.provider);

  @override
  String get id => (origin as CompanyCardByIdStreamProvider).id;
}

String _$activeCompanyCardsHash() =>
    r'd25534e8c91eb979852ae18c2149ae25ff52471b';

/// Provider para obter cartões ativos
///
/// Copied from [activeCompanyCards].
@ProviderFor(activeCompanyCards)
final activeCompanyCardsProvider =
    AutoDisposeFutureProvider<List<CompanyCardModel>>.internal(
      activeCompanyCards,
      name: r'activeCompanyCardsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$activeCompanyCardsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveCompanyCardsRef =
    AutoDisposeFutureProviderRef<List<CompanyCardModel>>;
String _$activeCompanyCardsStreamHash() =>
    r'7fe58364c98cf3cd21faa3ec6e8cb751f756a51e';

/// Provider para observar cartões ativos em tempo real
///
/// Copied from [activeCompanyCardsStream].
@ProviderFor(activeCompanyCardsStream)
final activeCompanyCardsStreamProvider =
    AutoDisposeStreamProvider<List<CompanyCardModel>>.internal(
      activeCompanyCardsStream,
      name: r'activeCompanyCardsStreamProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$activeCompanyCardsStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveCompanyCardsStreamRef =
    AutoDisposeStreamProviderRef<List<CompanyCardModel>>;
String _$companyCardStateHash() => r'b4136b41575b09cbcadfef7920edc0c51cd69871';

abstract class _$CompanyCardState
    extends BuildlessAutoDisposeAsyncNotifier<CompanyCardModel?> {
  late final String id;

  FutureOr<CompanyCardModel?> build(String id);
}

/// Provider para gerenciar o estado de um cartão
///
/// Copied from [CompanyCardState].
@ProviderFor(CompanyCardState)
const companyCardStateProvider = CompanyCardStateFamily();

/// Provider para gerenciar o estado de um cartão
///
/// Copied from [CompanyCardState].
class CompanyCardStateFamily extends Family<AsyncValue<CompanyCardModel?>> {
  /// Provider para gerenciar o estado de um cartão
  ///
  /// Copied from [CompanyCardState].
  const CompanyCardStateFamily();

  /// Provider para gerenciar o estado de um cartão
  ///
  /// Copied from [CompanyCardState].
  CompanyCardStateProvider call(String id) {
    return CompanyCardStateProvider(id);
  }

  @override
  CompanyCardStateProvider getProviderOverride(
    covariant CompanyCardStateProvider provider,
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
  String? get name => r'companyCardStateProvider';
}

/// Provider para gerenciar o estado de um cartão
///
/// Copied from [CompanyCardState].
class CompanyCardStateProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          CompanyCardState,
          CompanyCardModel?
        > {
  /// Provider para gerenciar o estado de um cartão
  ///
  /// Copied from [CompanyCardState].
  CompanyCardStateProvider(String id)
    : this._internal(
        () => CompanyCardState()..id = id,
        from: companyCardStateProvider,
        name: r'companyCardStateProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$companyCardStateHash,
        dependencies: CompanyCardStateFamily._dependencies,
        allTransitiveDependencies:
            CompanyCardStateFamily._allTransitiveDependencies,
        id: id,
      );

  CompanyCardStateProvider._internal(
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
  FutureOr<CompanyCardModel?> runNotifierBuild(
    covariant CompanyCardState notifier,
  ) {
    return notifier.build(id);
  }

  @override
  Override overrideWith(CompanyCardState Function() create) {
    return ProviderOverride(
      origin: this,
      override: CompanyCardStateProvider._internal(
        () => create()..id = id,
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
  AutoDisposeAsyncNotifierProviderElement<CompanyCardState, CompanyCardModel?>
  createElement() {
    return _CompanyCardStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CompanyCardStateProvider && other.id == id;
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
mixin CompanyCardStateRef
    on AutoDisposeAsyncNotifierProviderRef<CompanyCardModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _CompanyCardStateProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          CompanyCardState,
          CompanyCardModel?
        >
    with CompanyCardStateRef {
  _CompanyCardStateProviderElement(super.provider);

  @override
  String get id => (origin as CompanyCardStateProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
