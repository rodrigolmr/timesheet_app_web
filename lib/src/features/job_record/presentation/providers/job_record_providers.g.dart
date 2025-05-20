// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_record_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$jobRecordRepositoryHash() =>
    r'19810d1dde792e06dfeea96bd7c8e17830c766ed';

/// Provider que fornece o repositório de registros de trabalho
///
/// Copied from [jobRecordRepository].
@ProviderFor(jobRecordRepository)
final jobRecordRepositoryProvider =
    AutoDisposeProvider<JobRecordRepository>.internal(
      jobRecordRepository,
      name: r'jobRecordRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$jobRecordRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JobRecordRepositoryRef = AutoDisposeProviderRef<JobRecordRepository>;
String _$jobRecordsHash() => r'6658e757216a5bdea9b4cbf1185b0cf1ae0b58d3';

/// Provider para obter todos os registros
///
/// Copied from [jobRecords].
@ProviderFor(jobRecords)
final jobRecordsProvider =
    AutoDisposeFutureProvider<List<JobRecordModel>>.internal(
      jobRecords,
      name: r'jobRecordsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$jobRecordsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JobRecordsRef = AutoDisposeFutureProviderRef<List<JobRecordModel>>;
String _$jobRecordsStreamHash() => r'af8ce693247ef94255727bd938e054120e52cda8';

/// Provider para observar todos os registros em tempo real
///
/// Copied from [jobRecordsStream].
@ProviderFor(jobRecordsStream)
final jobRecordsStreamProvider =
    AutoDisposeStreamProvider<List<JobRecordModel>>.internal(
      jobRecordsStream,
      name: r'jobRecordsStreamProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$jobRecordsStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JobRecordsStreamRef =
    AutoDisposeStreamProviderRef<List<JobRecordModel>>;
String _$jobRecordHash() => r'df5a778e89642f56ae36df24e0745736babffa95';

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

/// Provider para obter um registro específico por ID
///
/// Copied from [jobRecord].
@ProviderFor(jobRecord)
const jobRecordProvider = JobRecordFamily();

/// Provider para obter um registro específico por ID
///
/// Copied from [jobRecord].
class JobRecordFamily extends Family<AsyncValue<JobRecordModel?>> {
  /// Provider para obter um registro específico por ID
  ///
  /// Copied from [jobRecord].
  const JobRecordFamily();

  /// Provider para obter um registro específico por ID
  ///
  /// Copied from [jobRecord].
  JobRecordProvider call(String id) {
    return JobRecordProvider(id);
  }

  @override
  JobRecordProvider getProviderOverride(covariant JobRecordProvider provider) {
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
  String? get name => r'jobRecordProvider';
}

/// Provider para obter um registro específico por ID
///
/// Copied from [jobRecord].
class JobRecordProvider extends AutoDisposeFutureProvider<JobRecordModel?> {
  /// Provider para obter um registro específico por ID
  ///
  /// Copied from [jobRecord].
  JobRecordProvider(String id)
    : this._internal(
        (ref) => jobRecord(ref as JobRecordRef, id),
        from: jobRecordProvider,
        name: r'jobRecordProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$jobRecordHash,
        dependencies: JobRecordFamily._dependencies,
        allTransitiveDependencies: JobRecordFamily._allTransitiveDependencies,
        id: id,
      );

  JobRecordProvider._internal(
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
    FutureOr<JobRecordModel?> Function(JobRecordRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JobRecordProvider._internal(
        (ref) => create(ref as JobRecordRef),
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
  AutoDisposeFutureProviderElement<JobRecordModel?> createElement() {
    return _JobRecordProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JobRecordProvider && other.id == id;
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
mixin JobRecordRef on AutoDisposeFutureProviderRef<JobRecordModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _JobRecordProviderElement
    extends AutoDisposeFutureProviderElement<JobRecordModel?>
    with JobRecordRef {
  _JobRecordProviderElement(super.provider);

  @override
  String get id => (origin as JobRecordProvider).id;
}

String _$jobRecordStreamHash() => r'28724d48d627ced519f1bf2f01d56d44fbc9deeb';

/// Provider para observar um registro específico em tempo real
///
/// Copied from [jobRecordStream].
@ProviderFor(jobRecordStream)
const jobRecordStreamProvider = JobRecordStreamFamily();

/// Provider para observar um registro específico em tempo real
///
/// Copied from [jobRecordStream].
class JobRecordStreamFamily extends Family<AsyncValue<JobRecordModel?>> {
  /// Provider para observar um registro específico em tempo real
  ///
  /// Copied from [jobRecordStream].
  const JobRecordStreamFamily();

  /// Provider para observar um registro específico em tempo real
  ///
  /// Copied from [jobRecordStream].
  JobRecordStreamProvider call(String id) {
    return JobRecordStreamProvider(id);
  }

  @override
  JobRecordStreamProvider getProviderOverride(
    covariant JobRecordStreamProvider provider,
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
  String? get name => r'jobRecordStreamProvider';
}

/// Provider para observar um registro específico em tempo real
///
/// Copied from [jobRecordStream].
class JobRecordStreamProvider
    extends AutoDisposeStreamProvider<JobRecordModel?> {
  /// Provider para observar um registro específico em tempo real
  ///
  /// Copied from [jobRecordStream].
  JobRecordStreamProvider(String id)
    : this._internal(
        (ref) => jobRecordStream(ref as JobRecordStreamRef, id),
        from: jobRecordStreamProvider,
        name: r'jobRecordStreamProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$jobRecordStreamHash,
        dependencies: JobRecordStreamFamily._dependencies,
        allTransitiveDependencies:
            JobRecordStreamFamily._allTransitiveDependencies,
        id: id,
      );

  JobRecordStreamProvider._internal(
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
    Stream<JobRecordModel?> Function(JobRecordStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JobRecordStreamProvider._internal(
        (ref) => create(ref as JobRecordStreamRef),
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
  AutoDisposeStreamProviderElement<JobRecordModel?> createElement() {
    return _JobRecordStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JobRecordStreamProvider && other.id == id;
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
mixin JobRecordStreamRef on AutoDisposeStreamProviderRef<JobRecordModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _JobRecordStreamProviderElement
    extends AutoDisposeStreamProviderElement<JobRecordModel?>
    with JobRecordStreamRef {
  _JobRecordStreamProviderElement(super.provider);

  @override
  String get id => (origin as JobRecordStreamProvider).id;
}

String _$jobRecordsByUserHash() => r'9ed4c890cbfb71ff87086b767151240d43fb1f67';

/// Provider para obter registros por usuário
///
/// Copied from [jobRecordsByUser].
@ProviderFor(jobRecordsByUser)
const jobRecordsByUserProvider = JobRecordsByUserFamily();

/// Provider para obter registros por usuário
///
/// Copied from [jobRecordsByUser].
class JobRecordsByUserFamily extends Family<AsyncValue<List<JobRecordModel>>> {
  /// Provider para obter registros por usuário
  ///
  /// Copied from [jobRecordsByUser].
  const JobRecordsByUserFamily();

  /// Provider para obter registros por usuário
  ///
  /// Copied from [jobRecordsByUser].
  JobRecordsByUserProvider call(String userId) {
    return JobRecordsByUserProvider(userId);
  }

  @override
  JobRecordsByUserProvider getProviderOverride(
    covariant JobRecordsByUserProvider provider,
  ) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'jobRecordsByUserProvider';
}

/// Provider para obter registros por usuário
///
/// Copied from [jobRecordsByUser].
class JobRecordsByUserProvider
    extends AutoDisposeFutureProvider<List<JobRecordModel>> {
  /// Provider para obter registros por usuário
  ///
  /// Copied from [jobRecordsByUser].
  JobRecordsByUserProvider(String userId)
    : this._internal(
        (ref) => jobRecordsByUser(ref as JobRecordsByUserRef, userId),
        from: jobRecordsByUserProvider,
        name: r'jobRecordsByUserProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$jobRecordsByUserHash,
        dependencies: JobRecordsByUserFamily._dependencies,
        allTransitiveDependencies:
            JobRecordsByUserFamily._allTransitiveDependencies,
        userId: userId,
      );

  JobRecordsByUserProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<List<JobRecordModel>> Function(JobRecordsByUserRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JobRecordsByUserProvider._internal(
        (ref) => create(ref as JobRecordsByUserRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<JobRecordModel>> createElement() {
    return _JobRecordsByUserProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JobRecordsByUserProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin JobRecordsByUserRef
    on AutoDisposeFutureProviderRef<List<JobRecordModel>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _JobRecordsByUserProviderElement
    extends AutoDisposeFutureProviderElement<List<JobRecordModel>>
    with JobRecordsByUserRef {
  _JobRecordsByUserProviderElement(super.provider);

  @override
  String get userId => (origin as JobRecordsByUserProvider).userId;
}

String _$jobRecordsByUserStreamHash() =>
    r'aa27b4ec61f01fb3be0314ea811dd0715dc289c5';

/// Provider para observar registros por usuário em tempo real
///
/// Copied from [jobRecordsByUserStream].
@ProviderFor(jobRecordsByUserStream)
const jobRecordsByUserStreamProvider = JobRecordsByUserStreamFamily();

/// Provider para observar registros por usuário em tempo real
///
/// Copied from [jobRecordsByUserStream].
class JobRecordsByUserStreamFamily
    extends Family<AsyncValue<List<JobRecordModel>>> {
  /// Provider para observar registros por usuário em tempo real
  ///
  /// Copied from [jobRecordsByUserStream].
  const JobRecordsByUserStreamFamily();

  /// Provider para observar registros por usuário em tempo real
  ///
  /// Copied from [jobRecordsByUserStream].
  JobRecordsByUserStreamProvider call(String userId) {
    return JobRecordsByUserStreamProvider(userId);
  }

  @override
  JobRecordsByUserStreamProvider getProviderOverride(
    covariant JobRecordsByUserStreamProvider provider,
  ) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'jobRecordsByUserStreamProvider';
}

/// Provider para observar registros por usuário em tempo real
///
/// Copied from [jobRecordsByUserStream].
class JobRecordsByUserStreamProvider
    extends AutoDisposeStreamProvider<List<JobRecordModel>> {
  /// Provider para observar registros por usuário em tempo real
  ///
  /// Copied from [jobRecordsByUserStream].
  JobRecordsByUserStreamProvider(String userId)
    : this._internal(
        (ref) =>
            jobRecordsByUserStream(ref as JobRecordsByUserStreamRef, userId),
        from: jobRecordsByUserStreamProvider,
        name: r'jobRecordsByUserStreamProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$jobRecordsByUserStreamHash,
        dependencies: JobRecordsByUserStreamFamily._dependencies,
        allTransitiveDependencies:
            JobRecordsByUserStreamFamily._allTransitiveDependencies,
        userId: userId,
      );

  JobRecordsByUserStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    Stream<List<JobRecordModel>> Function(JobRecordsByUserStreamRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JobRecordsByUserStreamProvider._internal(
        (ref) => create(ref as JobRecordsByUserStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<JobRecordModel>> createElement() {
    return _JobRecordsByUserStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JobRecordsByUserStreamProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin JobRecordsByUserStreamRef
    on AutoDisposeStreamProviderRef<List<JobRecordModel>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _JobRecordsByUserStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<JobRecordModel>>
    with JobRecordsByUserStreamRef {
  _JobRecordsByUserStreamProviderElement(super.provider);

  @override
  String get userId => (origin as JobRecordsByUserStreamProvider).userId;
}

String _$jobRecordsByEmployeeHash() =>
    r'b80a5b38ba39302d4bbe70ffd672865779ce7f65';

/// Provider para obter registros por funcionário
///
/// Copied from [jobRecordsByEmployee].
@ProviderFor(jobRecordsByEmployee)
const jobRecordsByEmployeeProvider = JobRecordsByEmployeeFamily();

/// Provider para obter registros por funcionário
///
/// Copied from [jobRecordsByEmployee].
class JobRecordsByEmployeeFamily
    extends Family<AsyncValue<List<JobRecordModel>>> {
  /// Provider para obter registros por funcionário
  ///
  /// Copied from [jobRecordsByEmployee].
  const JobRecordsByEmployeeFamily();

  /// Provider para obter registros por funcionário
  ///
  /// Copied from [jobRecordsByEmployee].
  JobRecordsByEmployeeProvider call(String employeeId) {
    return JobRecordsByEmployeeProvider(employeeId);
  }

  @override
  JobRecordsByEmployeeProvider getProviderOverride(
    covariant JobRecordsByEmployeeProvider provider,
  ) {
    return call(provider.employeeId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'jobRecordsByEmployeeProvider';
}

/// Provider para obter registros por funcionário
///
/// Copied from [jobRecordsByEmployee].
class JobRecordsByEmployeeProvider
    extends AutoDisposeFutureProvider<List<JobRecordModel>> {
  /// Provider para obter registros por funcionário
  ///
  /// Copied from [jobRecordsByEmployee].
  JobRecordsByEmployeeProvider(String employeeId)
    : this._internal(
        (ref) =>
            jobRecordsByEmployee(ref as JobRecordsByEmployeeRef, employeeId),
        from: jobRecordsByEmployeeProvider,
        name: r'jobRecordsByEmployeeProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$jobRecordsByEmployeeHash,
        dependencies: JobRecordsByEmployeeFamily._dependencies,
        allTransitiveDependencies:
            JobRecordsByEmployeeFamily._allTransitiveDependencies,
        employeeId: employeeId,
      );

  JobRecordsByEmployeeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.employeeId,
  }) : super.internal();

  final String employeeId;

  @override
  Override overrideWith(
    FutureOr<List<JobRecordModel>> Function(JobRecordsByEmployeeRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JobRecordsByEmployeeProvider._internal(
        (ref) => create(ref as JobRecordsByEmployeeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        employeeId: employeeId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<JobRecordModel>> createElement() {
    return _JobRecordsByEmployeeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JobRecordsByEmployeeProvider &&
        other.employeeId == employeeId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, employeeId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin JobRecordsByEmployeeRef
    on AutoDisposeFutureProviderRef<List<JobRecordModel>> {
  /// The parameter `employeeId` of this provider.
  String get employeeId;
}

class _JobRecordsByEmployeeProviderElement
    extends AutoDisposeFutureProviderElement<List<JobRecordModel>>
    with JobRecordsByEmployeeRef {
  _JobRecordsByEmployeeProviderElement(super.provider);

  @override
  String get employeeId => (origin as JobRecordsByEmployeeProvider).employeeId;
}

String _$jobRecordsByEmployeeStreamHash() =>
    r'285308a9af800449fc6aa48a7c69c4309ca92616';

/// Provider para observar registros por funcionário em tempo real
///
/// Copied from [jobRecordsByEmployeeStream].
@ProviderFor(jobRecordsByEmployeeStream)
const jobRecordsByEmployeeStreamProvider = JobRecordsByEmployeeStreamFamily();

/// Provider para observar registros por funcionário em tempo real
///
/// Copied from [jobRecordsByEmployeeStream].
class JobRecordsByEmployeeStreamFamily
    extends Family<AsyncValue<List<JobRecordModel>>> {
  /// Provider para observar registros por funcionário em tempo real
  ///
  /// Copied from [jobRecordsByEmployeeStream].
  const JobRecordsByEmployeeStreamFamily();

  /// Provider para observar registros por funcionário em tempo real
  ///
  /// Copied from [jobRecordsByEmployeeStream].
  JobRecordsByEmployeeStreamProvider call(String employeeId) {
    return JobRecordsByEmployeeStreamProvider(employeeId);
  }

  @override
  JobRecordsByEmployeeStreamProvider getProviderOverride(
    covariant JobRecordsByEmployeeStreamProvider provider,
  ) {
    return call(provider.employeeId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'jobRecordsByEmployeeStreamProvider';
}

/// Provider para observar registros por funcionário em tempo real
///
/// Copied from [jobRecordsByEmployeeStream].
class JobRecordsByEmployeeStreamProvider
    extends AutoDisposeStreamProvider<List<JobRecordModel>> {
  /// Provider para observar registros por funcionário em tempo real
  ///
  /// Copied from [jobRecordsByEmployeeStream].
  JobRecordsByEmployeeStreamProvider(String employeeId)
    : this._internal(
        (ref) => jobRecordsByEmployeeStream(
          ref as JobRecordsByEmployeeStreamRef,
          employeeId,
        ),
        from: jobRecordsByEmployeeStreamProvider,
        name: r'jobRecordsByEmployeeStreamProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$jobRecordsByEmployeeStreamHash,
        dependencies: JobRecordsByEmployeeStreamFamily._dependencies,
        allTransitiveDependencies:
            JobRecordsByEmployeeStreamFamily._allTransitiveDependencies,
        employeeId: employeeId,
      );

  JobRecordsByEmployeeStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.employeeId,
  }) : super.internal();

  final String employeeId;

  @override
  Override overrideWith(
    Stream<List<JobRecordModel>> Function(
      JobRecordsByEmployeeStreamRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JobRecordsByEmployeeStreamProvider._internal(
        (ref) => create(ref as JobRecordsByEmployeeStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        employeeId: employeeId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<JobRecordModel>> createElement() {
    return _JobRecordsByEmployeeStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JobRecordsByEmployeeStreamProvider &&
        other.employeeId == employeeId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, employeeId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin JobRecordsByEmployeeStreamRef
    on AutoDisposeStreamProviderRef<List<JobRecordModel>> {
  /// The parameter `employeeId` of this provider.
  String get employeeId;
}

class _JobRecordsByEmployeeStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<JobRecordModel>>
    with JobRecordsByEmployeeStreamRef {
  _JobRecordsByEmployeeStreamProviderElement(super.provider);

  @override
  String get employeeId =>
      (origin as JobRecordsByEmployeeStreamProvider).employeeId;
}

String _$jobRecordStateHash() => r'48b228befd9ade7d0683b25bb9799c55d5c77e5b';

abstract class _$JobRecordState
    extends BuildlessAutoDisposeAsyncNotifier<JobRecordModel?> {
  late final String id;

  FutureOr<JobRecordModel?> build(String id);
}

/// Provider para gerenciar o estado de um registro
///
/// Copied from [JobRecordState].
@ProviderFor(JobRecordState)
const jobRecordStateProvider = JobRecordStateFamily();

/// Provider para gerenciar o estado de um registro
///
/// Copied from [JobRecordState].
class JobRecordStateFamily extends Family<AsyncValue<JobRecordModel?>> {
  /// Provider para gerenciar o estado de um registro
  ///
  /// Copied from [JobRecordState].
  const JobRecordStateFamily();

  /// Provider para gerenciar o estado de um registro
  ///
  /// Copied from [JobRecordState].
  JobRecordStateProvider call(String id) {
    return JobRecordStateProvider(id);
  }

  @override
  JobRecordStateProvider getProviderOverride(
    covariant JobRecordStateProvider provider,
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
  String? get name => r'jobRecordStateProvider';
}

/// Provider para gerenciar o estado de um registro
///
/// Copied from [JobRecordState].
class JobRecordStateProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<JobRecordState, JobRecordModel?> {
  /// Provider para gerenciar o estado de um registro
  ///
  /// Copied from [JobRecordState].
  JobRecordStateProvider(String id)
    : this._internal(
        () => JobRecordState()..id = id,
        from: jobRecordStateProvider,
        name: r'jobRecordStateProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$jobRecordStateHash,
        dependencies: JobRecordStateFamily._dependencies,
        allTransitiveDependencies:
            JobRecordStateFamily._allTransitiveDependencies,
        id: id,
      );

  JobRecordStateProvider._internal(
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
  FutureOr<JobRecordModel?> runNotifierBuild(
    covariant JobRecordState notifier,
  ) {
    return notifier.build(id);
  }

  @override
  Override overrideWith(JobRecordState Function() create) {
    return ProviderOverride(
      origin: this,
      override: JobRecordStateProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<JobRecordState, JobRecordModel?>
  createElement() {
    return _JobRecordStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JobRecordStateProvider && other.id == id;
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
mixin JobRecordStateRef
    on AutoDisposeAsyncNotifierProviderRef<JobRecordModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _JobRecordStateProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<JobRecordState, JobRecordModel?>
    with JobRecordStateRef {
  _JobRecordStateProviderElement(super.provider);

  @override
  String get id => (origin as JobRecordStateProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
