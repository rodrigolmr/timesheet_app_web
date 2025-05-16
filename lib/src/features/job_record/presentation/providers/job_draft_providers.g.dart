// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_draft_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$jobDraftRepositoryHash() =>
    r'835ea40cdbba7cb697179cbc0e8abc2c8fc46a3d';

/// Provider que fornece o repositório de rascunhos de trabalho
///
/// Copied from [jobDraftRepository].
@ProviderFor(jobDraftRepository)
final jobDraftRepositoryProvider =
    AutoDisposeProvider<JobDraftRepository>.internal(
      jobDraftRepository,
      name: r'jobDraftRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$jobDraftRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JobDraftRepositoryRef = AutoDisposeProviderRef<JobDraftRepository>;
String _$jobDraftsHash() => r'f3d60de8c91a8609b1e0d79fec9e633a8a992ca0';

/// Provider para obter todos os rascunhos
///
/// Copied from [jobDrafts].
@ProviderFor(jobDrafts)
final jobDraftsProvider =
    AutoDisposeFutureProvider<List<JobDraftModel>>.internal(
      jobDrafts,
      name: r'jobDraftsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$jobDraftsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JobDraftsRef = AutoDisposeFutureProviderRef<List<JobDraftModel>>;
String _$jobDraftsStreamHash() => r'f3e5f605e749e7d4a0cd6747705c61ce368ae68f';

/// Provider para observar todos os rascunhos em tempo real
///
/// Copied from [jobDraftsStream].
@ProviderFor(jobDraftsStream)
final jobDraftsStreamProvider =
    AutoDisposeStreamProvider<List<JobDraftModel>>.internal(
      jobDraftsStream,
      name: r'jobDraftsStreamProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$jobDraftsStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JobDraftsStreamRef = AutoDisposeStreamProviderRef<List<JobDraftModel>>;
String _$jobDraftHash() => r'fb9088728cb5881842e02be391af638bbfe39cbd';

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

/// Provider para obter um rascunho específico por ID
///
/// Copied from [jobDraft].
@ProviderFor(jobDraft)
const jobDraftProvider = JobDraftFamily();

/// Provider para obter um rascunho específico por ID
///
/// Copied from [jobDraft].
class JobDraftFamily extends Family<AsyncValue<JobDraftModel?>> {
  /// Provider para obter um rascunho específico por ID
  ///
  /// Copied from [jobDraft].
  const JobDraftFamily();

  /// Provider para obter um rascunho específico por ID
  ///
  /// Copied from [jobDraft].
  JobDraftProvider call(String id) {
    return JobDraftProvider(id);
  }

  @override
  JobDraftProvider getProviderOverride(covariant JobDraftProvider provider) {
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
  String? get name => r'jobDraftProvider';
}

/// Provider para obter um rascunho específico por ID
///
/// Copied from [jobDraft].
class JobDraftProvider extends AutoDisposeFutureProvider<JobDraftModel?> {
  /// Provider para obter um rascunho específico por ID
  ///
  /// Copied from [jobDraft].
  JobDraftProvider(String id)
    : this._internal(
        (ref) => jobDraft(ref as JobDraftRef, id),
        from: jobDraftProvider,
        name: r'jobDraftProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$jobDraftHash,
        dependencies: JobDraftFamily._dependencies,
        allTransitiveDependencies: JobDraftFamily._allTransitiveDependencies,
        id: id,
      );

  JobDraftProvider._internal(
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
    FutureOr<JobDraftModel?> Function(JobDraftRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JobDraftProvider._internal(
        (ref) => create(ref as JobDraftRef),
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
  AutoDisposeFutureProviderElement<JobDraftModel?> createElement() {
    return _JobDraftProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JobDraftProvider && other.id == id;
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
mixin JobDraftRef on AutoDisposeFutureProviderRef<JobDraftModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _JobDraftProviderElement
    extends AutoDisposeFutureProviderElement<JobDraftModel?>
    with JobDraftRef {
  _JobDraftProviderElement(super.provider);

  @override
  String get id => (origin as JobDraftProvider).id;
}

String _$jobDraftStreamHash() => r'116726cc817365b6d5f6a9530ed9080b37358abc';

/// Provider para observar um rascunho específico em tempo real
///
/// Copied from [jobDraftStream].
@ProviderFor(jobDraftStream)
const jobDraftStreamProvider = JobDraftStreamFamily();

/// Provider para observar um rascunho específico em tempo real
///
/// Copied from [jobDraftStream].
class JobDraftStreamFamily extends Family<AsyncValue<JobDraftModel?>> {
  /// Provider para observar um rascunho específico em tempo real
  ///
  /// Copied from [jobDraftStream].
  const JobDraftStreamFamily();

  /// Provider para observar um rascunho específico em tempo real
  ///
  /// Copied from [jobDraftStream].
  JobDraftStreamProvider call(String id) {
    return JobDraftStreamProvider(id);
  }

  @override
  JobDraftStreamProvider getProviderOverride(
    covariant JobDraftStreamProvider provider,
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
  String? get name => r'jobDraftStreamProvider';
}

/// Provider para observar um rascunho específico em tempo real
///
/// Copied from [jobDraftStream].
class JobDraftStreamProvider extends AutoDisposeStreamProvider<JobDraftModel?> {
  /// Provider para observar um rascunho específico em tempo real
  ///
  /// Copied from [jobDraftStream].
  JobDraftStreamProvider(String id)
    : this._internal(
        (ref) => jobDraftStream(ref as JobDraftStreamRef, id),
        from: jobDraftStreamProvider,
        name: r'jobDraftStreamProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$jobDraftStreamHash,
        dependencies: JobDraftStreamFamily._dependencies,
        allTransitiveDependencies:
            JobDraftStreamFamily._allTransitiveDependencies,
        id: id,
      );

  JobDraftStreamProvider._internal(
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
    Stream<JobDraftModel?> Function(JobDraftStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JobDraftStreamProvider._internal(
        (ref) => create(ref as JobDraftStreamRef),
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
  AutoDisposeStreamProviderElement<JobDraftModel?> createElement() {
    return _JobDraftStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JobDraftStreamProvider && other.id == id;
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
mixin JobDraftStreamRef on AutoDisposeStreamProviderRef<JobDraftModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _JobDraftStreamProviderElement
    extends AutoDisposeStreamProviderElement<JobDraftModel?>
    with JobDraftStreamRef {
  _JobDraftStreamProviderElement(super.provider);

  @override
  String get id => (origin as JobDraftStreamProvider).id;
}

String _$jobDraftsByUserHash() => r'692b0e44d27dad97b7754ae4d9d2d91a0087a977';

/// Provider para obter rascunhos por usuário
///
/// Copied from [jobDraftsByUser].
@ProviderFor(jobDraftsByUser)
const jobDraftsByUserProvider = JobDraftsByUserFamily();

/// Provider para obter rascunhos por usuário
///
/// Copied from [jobDraftsByUser].
class JobDraftsByUserFamily extends Family<AsyncValue<List<JobDraftModel>>> {
  /// Provider para obter rascunhos por usuário
  ///
  /// Copied from [jobDraftsByUser].
  const JobDraftsByUserFamily();

  /// Provider para obter rascunhos por usuário
  ///
  /// Copied from [jobDraftsByUser].
  JobDraftsByUserProvider call(String userId) {
    return JobDraftsByUserProvider(userId);
  }

  @override
  JobDraftsByUserProvider getProviderOverride(
    covariant JobDraftsByUserProvider provider,
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
  String? get name => r'jobDraftsByUserProvider';
}

/// Provider para obter rascunhos por usuário
///
/// Copied from [jobDraftsByUser].
class JobDraftsByUserProvider
    extends AutoDisposeFutureProvider<List<JobDraftModel>> {
  /// Provider para obter rascunhos por usuário
  ///
  /// Copied from [jobDraftsByUser].
  JobDraftsByUserProvider(String userId)
    : this._internal(
        (ref) => jobDraftsByUser(ref as JobDraftsByUserRef, userId),
        from: jobDraftsByUserProvider,
        name: r'jobDraftsByUserProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$jobDraftsByUserHash,
        dependencies: JobDraftsByUserFamily._dependencies,
        allTransitiveDependencies:
            JobDraftsByUserFamily._allTransitiveDependencies,
        userId: userId,
      );

  JobDraftsByUserProvider._internal(
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
    FutureOr<List<JobDraftModel>> Function(JobDraftsByUserRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JobDraftsByUserProvider._internal(
        (ref) => create(ref as JobDraftsByUserRef),
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
  AutoDisposeFutureProviderElement<List<JobDraftModel>> createElement() {
    return _JobDraftsByUserProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JobDraftsByUserProvider && other.userId == userId;
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
mixin JobDraftsByUserRef on AutoDisposeFutureProviderRef<List<JobDraftModel>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _JobDraftsByUserProviderElement
    extends AutoDisposeFutureProviderElement<List<JobDraftModel>>
    with JobDraftsByUserRef {
  _JobDraftsByUserProviderElement(super.provider);

  @override
  String get userId => (origin as JobDraftsByUserProvider).userId;
}

String _$jobDraftsByUserStreamHash() =>
    r'c84b7f5374c417c40283ecf4b056c841a3911a49';

/// Provider para observar rascunhos por usuário em tempo real
///
/// Copied from [jobDraftsByUserStream].
@ProviderFor(jobDraftsByUserStream)
const jobDraftsByUserStreamProvider = JobDraftsByUserStreamFamily();

/// Provider para observar rascunhos por usuário em tempo real
///
/// Copied from [jobDraftsByUserStream].
class JobDraftsByUserStreamFamily
    extends Family<AsyncValue<List<JobDraftModel>>> {
  /// Provider para observar rascunhos por usuário em tempo real
  ///
  /// Copied from [jobDraftsByUserStream].
  const JobDraftsByUserStreamFamily();

  /// Provider para observar rascunhos por usuário em tempo real
  ///
  /// Copied from [jobDraftsByUserStream].
  JobDraftsByUserStreamProvider call(String userId) {
    return JobDraftsByUserStreamProvider(userId);
  }

  @override
  JobDraftsByUserStreamProvider getProviderOverride(
    covariant JobDraftsByUserStreamProvider provider,
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
  String? get name => r'jobDraftsByUserStreamProvider';
}

/// Provider para observar rascunhos por usuário em tempo real
///
/// Copied from [jobDraftsByUserStream].
class JobDraftsByUserStreamProvider
    extends AutoDisposeStreamProvider<List<JobDraftModel>> {
  /// Provider para observar rascunhos por usuário em tempo real
  ///
  /// Copied from [jobDraftsByUserStream].
  JobDraftsByUserStreamProvider(String userId)
    : this._internal(
        (ref) => jobDraftsByUserStream(ref as JobDraftsByUserStreamRef, userId),
        from: jobDraftsByUserStreamProvider,
        name: r'jobDraftsByUserStreamProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$jobDraftsByUserStreamHash,
        dependencies: JobDraftsByUserStreamFamily._dependencies,
        allTransitiveDependencies:
            JobDraftsByUserStreamFamily._allTransitiveDependencies,
        userId: userId,
      );

  JobDraftsByUserStreamProvider._internal(
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
    Stream<List<JobDraftModel>> Function(JobDraftsByUserStreamRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JobDraftsByUserStreamProvider._internal(
        (ref) => create(ref as JobDraftsByUserStreamRef),
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
  AutoDisposeStreamProviderElement<List<JobDraftModel>> createElement() {
    return _JobDraftsByUserStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JobDraftsByUserStreamProvider && other.userId == userId;
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
mixin JobDraftsByUserStreamRef
    on AutoDisposeStreamProviderRef<List<JobDraftModel>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _JobDraftsByUserStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<JobDraftModel>>
    with JobDraftsByUserStreamRef {
  _JobDraftsByUserStreamProviderElement(super.provider);

  @override
  String get userId => (origin as JobDraftsByUserStreamProvider).userId;
}

String _$jobDraftsByWorkerHash() => r'1b469d6a6b8005d95a8f7309d191c58935643714';

/// Provider para obter rascunhos por funcionário
///
/// Copied from [jobDraftsByWorker].
@ProviderFor(jobDraftsByWorker)
const jobDraftsByWorkerProvider = JobDraftsByWorkerFamily();

/// Provider para obter rascunhos por funcionário
///
/// Copied from [jobDraftsByWorker].
class JobDraftsByWorkerFamily extends Family<AsyncValue<List<JobDraftModel>>> {
  /// Provider para obter rascunhos por funcionário
  ///
  /// Copied from [jobDraftsByWorker].
  const JobDraftsByWorkerFamily();

  /// Provider para obter rascunhos por funcionário
  ///
  /// Copied from [jobDraftsByWorker].
  JobDraftsByWorkerProvider call(String workerId) {
    return JobDraftsByWorkerProvider(workerId);
  }

  @override
  JobDraftsByWorkerProvider getProviderOverride(
    covariant JobDraftsByWorkerProvider provider,
  ) {
    return call(provider.workerId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'jobDraftsByWorkerProvider';
}

/// Provider para obter rascunhos por funcionário
///
/// Copied from [jobDraftsByWorker].
class JobDraftsByWorkerProvider
    extends AutoDisposeFutureProvider<List<JobDraftModel>> {
  /// Provider para obter rascunhos por funcionário
  ///
  /// Copied from [jobDraftsByWorker].
  JobDraftsByWorkerProvider(String workerId)
    : this._internal(
        (ref) => jobDraftsByWorker(ref as JobDraftsByWorkerRef, workerId),
        from: jobDraftsByWorkerProvider,
        name: r'jobDraftsByWorkerProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$jobDraftsByWorkerHash,
        dependencies: JobDraftsByWorkerFamily._dependencies,
        allTransitiveDependencies:
            JobDraftsByWorkerFamily._allTransitiveDependencies,
        workerId: workerId,
      );

  JobDraftsByWorkerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.workerId,
  }) : super.internal();

  final String workerId;

  @override
  Override overrideWith(
    FutureOr<List<JobDraftModel>> Function(JobDraftsByWorkerRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JobDraftsByWorkerProvider._internal(
        (ref) => create(ref as JobDraftsByWorkerRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        workerId: workerId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<JobDraftModel>> createElement() {
    return _JobDraftsByWorkerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JobDraftsByWorkerProvider && other.workerId == workerId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, workerId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin JobDraftsByWorkerRef
    on AutoDisposeFutureProviderRef<List<JobDraftModel>> {
  /// The parameter `workerId` of this provider.
  String get workerId;
}

class _JobDraftsByWorkerProviderElement
    extends AutoDisposeFutureProviderElement<List<JobDraftModel>>
    with JobDraftsByWorkerRef {
  _JobDraftsByWorkerProviderElement(super.provider);

  @override
  String get workerId => (origin as JobDraftsByWorkerProvider).workerId;
}

String _$jobDraftStateHash() => r'4cbb4309a020a79838b4757b2753043801650c11';

abstract class _$JobDraftState
    extends BuildlessAutoDisposeAsyncNotifier<JobDraftModel?> {
  late final String id;

  FutureOr<JobDraftModel?> build(String id);
}

/// Provider para gerenciar o estado de um rascunho
///
/// Copied from [JobDraftState].
@ProviderFor(JobDraftState)
const jobDraftStateProvider = JobDraftStateFamily();

/// Provider para gerenciar o estado de um rascunho
///
/// Copied from [JobDraftState].
class JobDraftStateFamily extends Family<AsyncValue<JobDraftModel?>> {
  /// Provider para gerenciar o estado de um rascunho
  ///
  /// Copied from [JobDraftState].
  const JobDraftStateFamily();

  /// Provider para gerenciar o estado de um rascunho
  ///
  /// Copied from [JobDraftState].
  JobDraftStateProvider call(String id) {
    return JobDraftStateProvider(id);
  }

  @override
  JobDraftStateProvider getProviderOverride(
    covariant JobDraftStateProvider provider,
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
  String? get name => r'jobDraftStateProvider';
}

/// Provider para gerenciar o estado de um rascunho
///
/// Copied from [JobDraftState].
class JobDraftStateProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<JobDraftState, JobDraftModel?> {
  /// Provider para gerenciar o estado de um rascunho
  ///
  /// Copied from [JobDraftState].
  JobDraftStateProvider(String id)
    : this._internal(
        () => JobDraftState()..id = id,
        from: jobDraftStateProvider,
        name: r'jobDraftStateProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$jobDraftStateHash,
        dependencies: JobDraftStateFamily._dependencies,
        allTransitiveDependencies:
            JobDraftStateFamily._allTransitiveDependencies,
        id: id,
      );

  JobDraftStateProvider._internal(
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
  FutureOr<JobDraftModel?> runNotifierBuild(covariant JobDraftState notifier) {
    return notifier.build(id);
  }

  @override
  Override overrideWith(JobDraftState Function() create) {
    return ProviderOverride(
      origin: this,
      override: JobDraftStateProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<JobDraftState, JobDraftModel?>
  createElement() {
    return _JobDraftStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JobDraftStateProvider && other.id == id;
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
mixin JobDraftStateRef on AutoDisposeAsyncNotifierProviderRef<JobDraftModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _JobDraftStateProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<JobDraftState, JobDraftModel?>
    with JobDraftStateRef {
  _JobDraftStateProviderElement(super.provider);

  @override
  String get id => (origin as JobDraftStateProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
