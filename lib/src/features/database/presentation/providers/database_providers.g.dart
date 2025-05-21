// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$databaseRepositoryHash() =>
    r'eb5b5ab46e859a0a4b9edf06db230a85265b4412';

/// See also [databaseRepository].
@ProviderFor(databaseRepository)
final databaseRepositoryProvider =
    AutoDisposeProvider<DatabaseRepository>.internal(
      databaseRepository,
      name: r'databaseRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$databaseRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DatabaseRepositoryRef = AutoDisposeProviderRef<DatabaseRepository>;
String _$databaseStatsHash() => r'e9b4c8c0414cdf642dcc932020d6c134d56823f2';

/// See also [databaseStats].
@ProviderFor(databaseStats)
final databaseStatsProvider =
    AutoDisposeFutureProvider<List<DatabaseStatsModel>>.internal(
      databaseStats,
      name: r'databaseStatsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$databaseStatsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DatabaseStatsRef =
    AutoDisposeFutureProviderRef<List<DatabaseStatsModel>>;
String _$collectionDetailsHash() => r'84f4339d33562e18fe8b37dc541707b9346d56fd';

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

/// See also [collectionDetails].
@ProviderFor(collectionDetails)
const collectionDetailsProvider = CollectionDetailsFamily();

/// See also [collectionDetails].
class CollectionDetailsFamily
    extends Family<AsyncValue<DatabaseCollectionModel>> {
  /// See also [collectionDetails].
  const CollectionDetailsFamily();

  /// See also [collectionDetails].
  CollectionDetailsProvider call(String collectionName) {
    return CollectionDetailsProvider(collectionName);
  }

  @override
  CollectionDetailsProvider getProviderOverride(
    covariant CollectionDetailsProvider provider,
  ) {
    return call(provider.collectionName);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'collectionDetailsProvider';
}

/// See also [collectionDetails].
class CollectionDetailsProvider
    extends AutoDisposeFutureProvider<DatabaseCollectionModel> {
  /// See also [collectionDetails].
  CollectionDetailsProvider(String collectionName)
    : this._internal(
        (ref) => collectionDetails(ref as CollectionDetailsRef, collectionName),
        from: collectionDetailsProvider,
        name: r'collectionDetailsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$collectionDetailsHash,
        dependencies: CollectionDetailsFamily._dependencies,
        allTransitiveDependencies:
            CollectionDetailsFamily._allTransitiveDependencies,
        collectionName: collectionName,
      );

  CollectionDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.collectionName,
  }) : super.internal();

  final String collectionName;

  @override
  Override overrideWith(
    FutureOr<DatabaseCollectionModel> Function(CollectionDetailsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CollectionDetailsProvider._internal(
        (ref) => create(ref as CollectionDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        collectionName: collectionName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<DatabaseCollectionModel> createElement() {
    return _CollectionDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CollectionDetailsProvider &&
        other.collectionName == collectionName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, collectionName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CollectionDetailsRef
    on AutoDisposeFutureProviderRef<DatabaseCollectionModel> {
  /// The parameter `collectionName` of this provider.
  String get collectionName;
}

class _CollectionDetailsProviderElement
    extends AutoDisposeFutureProviderElement<DatabaseCollectionModel>
    with CollectionDetailsRef {
  _CollectionDetailsProviderElement(super.provider);

  @override
  String get collectionName =>
      (origin as CollectionDetailsProvider).collectionName;
}

String _$sampleDocumentHash() => r'4e45185a052639619beade7f92a4f138f57542c0';

/// See also [sampleDocument].
@ProviderFor(sampleDocument)
const sampleDocumentProvider = SampleDocumentFamily();

/// See also [sampleDocument].
class SampleDocumentFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [sampleDocument].
  const SampleDocumentFamily();

  /// See also [sampleDocument].
  SampleDocumentProvider call(String collectionName) {
    return SampleDocumentProvider(collectionName);
  }

  @override
  SampleDocumentProvider getProviderOverride(
    covariant SampleDocumentProvider provider,
  ) {
    return call(provider.collectionName);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'sampleDocumentProvider';
}

/// See also [sampleDocument].
class SampleDocumentProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [sampleDocument].
  SampleDocumentProvider(String collectionName)
    : this._internal(
        (ref) => sampleDocument(ref as SampleDocumentRef, collectionName),
        from: sampleDocumentProvider,
        name: r'sampleDocumentProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$sampleDocumentHash,
        dependencies: SampleDocumentFamily._dependencies,
        allTransitiveDependencies:
            SampleDocumentFamily._allTransitiveDependencies,
        collectionName: collectionName,
      );

  SampleDocumentProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.collectionName,
  }) : super.internal();

  final String collectionName;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(SampleDocumentRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SampleDocumentProvider._internal(
        (ref) => create(ref as SampleDocumentRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        collectionName: collectionName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _SampleDocumentProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SampleDocumentProvider &&
        other.collectionName == collectionName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, collectionName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SampleDocumentRef on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `collectionName` of this provider.
  String get collectionName;
}

class _SampleDocumentProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with SampleDocumentRef {
  _SampleDocumentProviderElement(super.provider);

  @override
  String get collectionName =>
      (origin as SampleDocumentProvider).collectionName;
}

String _$collectionDocumentsHash() =>
    r'60ef56177f63f521abdb80ecc7745d81de0f675d';

/// See also [collectionDocuments].
@ProviderFor(collectionDocuments)
const collectionDocumentsProvider = CollectionDocumentsFamily();

/// See also [collectionDocuments].
class CollectionDocumentsFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [collectionDocuments].
  const CollectionDocumentsFamily();

  /// See also [collectionDocuments].
  CollectionDocumentsProvider call(String collectionName, {int limit = 20}) {
    return CollectionDocumentsProvider(collectionName, limit: limit);
  }

  @override
  CollectionDocumentsProvider getProviderOverride(
    covariant CollectionDocumentsProvider provider,
  ) {
    return call(provider.collectionName, limit: provider.limit);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'collectionDocumentsProvider';
}

/// See also [collectionDocuments].
class CollectionDocumentsProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// See also [collectionDocuments].
  CollectionDocumentsProvider(String collectionName, {int limit = 20})
    : this._internal(
        (ref) => collectionDocuments(
          ref as CollectionDocumentsRef,
          collectionName,
          limit: limit,
        ),
        from: collectionDocumentsProvider,
        name: r'collectionDocumentsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$collectionDocumentsHash,
        dependencies: CollectionDocumentsFamily._dependencies,
        allTransitiveDependencies:
            CollectionDocumentsFamily._allTransitiveDependencies,
        collectionName: collectionName,
        limit: limit,
      );

  CollectionDocumentsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.collectionName,
    required this.limit,
  }) : super.internal();

  final String collectionName;
  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<Map<String, dynamic>>> Function(
      CollectionDocumentsRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CollectionDocumentsProvider._internal(
        (ref) => create(ref as CollectionDocumentsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        collectionName: collectionName,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Map<String, dynamic>>> createElement() {
    return _CollectionDocumentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CollectionDocumentsProvider &&
        other.collectionName == collectionName &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, collectionName.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CollectionDocumentsRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `collectionName` of this provider.
  String get collectionName;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _CollectionDocumentsProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with CollectionDocumentsRef {
  _CollectionDocumentsProviderElement(super.provider);

  @override
  String get collectionName =>
      (origin as CollectionDocumentsProvider).collectionName;
  @override
  int get limit => (origin as CollectionDocumentsProvider).limit;
}

String _$documentDetailsHash() => r'5288eb478e497b9643c044f2b355c25d2e15d0b9';

/// See also [documentDetails].
@ProviderFor(documentDetails)
const documentDetailsProvider = DocumentDetailsFamily();

/// See also [documentDetails].
class DocumentDetailsFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [documentDetails].
  const DocumentDetailsFamily();

  /// See also [documentDetails].
  DocumentDetailsProvider call(String collectionName, String documentId) {
    return DocumentDetailsProvider(collectionName, documentId);
  }

  @override
  DocumentDetailsProvider getProviderOverride(
    covariant DocumentDetailsProvider provider,
  ) {
    return call(provider.collectionName, provider.documentId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'documentDetailsProvider';
}

/// See also [documentDetails].
class DocumentDetailsProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [documentDetails].
  DocumentDetailsProvider(String collectionName, String documentId)
    : this._internal(
        (ref) => documentDetails(
          ref as DocumentDetailsRef,
          collectionName,
          documentId,
        ),
        from: documentDetailsProvider,
        name: r'documentDetailsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$documentDetailsHash,
        dependencies: DocumentDetailsFamily._dependencies,
        allTransitiveDependencies:
            DocumentDetailsFamily._allTransitiveDependencies,
        collectionName: collectionName,
        documentId: documentId,
      );

  DocumentDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.collectionName,
    required this.documentId,
  }) : super.internal();

  final String collectionName;
  final String documentId;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(DocumentDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DocumentDetailsProvider._internal(
        (ref) => create(ref as DocumentDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        collectionName: collectionName,
        documentId: documentId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _DocumentDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DocumentDetailsProvider &&
        other.collectionName == collectionName &&
        other.documentId == documentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, collectionName.hashCode);
    hash = _SystemHash.combine(hash, documentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DocumentDetailsRef on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `collectionName` of this provider.
  String get collectionName;

  /// The parameter `documentId` of this provider.
  String get documentId;
}

class _DocumentDetailsProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with DocumentDetailsRef {
  _DocumentDetailsProviderElement(super.provider);

  @override
  String get collectionName =>
      (origin as DocumentDetailsProvider).collectionName;
  @override
  String get documentId => (origin as DocumentDetailsProvider).documentId;
}

String _$databaseOperationsHash() =>
    r'bdeae86dddf7f9327672bcb9fa8c8664c7b01d7b';

/// See also [DatabaseOperations].
@ProviderFor(DatabaseOperations)
final databaseOperationsProvider = AutoDisposeNotifierProvider<
  DatabaseOperations,
  AsyncValue<String?>
>.internal(
  DatabaseOperations.new,
  name: r'databaseOperationsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$databaseOperationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DatabaseOperations = AutoDisposeNotifier<AsyncValue<String?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
