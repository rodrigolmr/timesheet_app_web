// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$employeeRepositoryHash() =>
    r'861926ac151cd7dda00c98fc6eb84c66ca5f8e0d';

/// Provider que fornece o repositório de funcionários
///
/// Copied from [employeeRepository].
@ProviderFor(employeeRepository)
final employeeRepositoryProvider =
    AutoDisposeProvider<EmployeeRepository>.internal(
      employeeRepository,
      name: r'employeeRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$employeeRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EmployeeRepositoryRef = AutoDisposeProviderRef<EmployeeRepository>;
String _$employeesHash() => r'34ffce5c302f8bf41979a74fe64e8f82cdd534c6';

/// Provider para obter todos os funcionários
///
/// Copied from [employees].
@ProviderFor(employees)
final employeesProvider =
    AutoDisposeFutureProvider<List<EmployeeModel>>.internal(
      employees,
      name: r'employeesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$employeesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EmployeesRef = AutoDisposeFutureProviderRef<List<EmployeeModel>>;
String _$employeesStreamHash() => r'8ffa76a4375df09d31ba29ad4181880e22420510';

/// Provider para observar todos os funcionários em tempo real
///
/// Copied from [employeesStream].
@ProviderFor(employeesStream)
final employeesStreamProvider =
    AutoDisposeStreamProvider<List<EmployeeModel>>.internal(
      employeesStream,
      name: r'employeesStreamProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$employeesStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EmployeesStreamRef = AutoDisposeStreamProviderRef<List<EmployeeModel>>;
String _$employeeHash() => r'217947aa463fb7e94dd53f65abd8471488748182';

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

/// Provider para obter um funcionário específico por ID
///
/// Copied from [employee].
@ProviderFor(employee)
const employeeProvider = EmployeeFamily();

/// Provider para obter um funcionário específico por ID
///
/// Copied from [employee].
class EmployeeFamily extends Family<AsyncValue<EmployeeModel?>> {
  /// Provider para obter um funcionário específico por ID
  ///
  /// Copied from [employee].
  const EmployeeFamily();

  /// Provider para obter um funcionário específico por ID
  ///
  /// Copied from [employee].
  EmployeeProvider call(String id) {
    return EmployeeProvider(id);
  }

  @override
  EmployeeProvider getProviderOverride(covariant EmployeeProvider provider) {
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
  String? get name => r'employeeProvider';
}

/// Provider para obter um funcionário específico por ID
///
/// Copied from [employee].
class EmployeeProvider extends AutoDisposeFutureProvider<EmployeeModel?> {
  /// Provider para obter um funcionário específico por ID
  ///
  /// Copied from [employee].
  EmployeeProvider(String id)
    : this._internal(
        (ref) => employee(ref as EmployeeRef, id),
        from: employeeProvider,
        name: r'employeeProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$employeeHash,
        dependencies: EmployeeFamily._dependencies,
        allTransitiveDependencies: EmployeeFamily._allTransitiveDependencies,
        id: id,
      );

  EmployeeProvider._internal(
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
    FutureOr<EmployeeModel?> Function(EmployeeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EmployeeProvider._internal(
        (ref) => create(ref as EmployeeRef),
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
  AutoDisposeFutureProviderElement<EmployeeModel?> createElement() {
    return _EmployeeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EmployeeProvider && other.id == id;
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
mixin EmployeeRef on AutoDisposeFutureProviderRef<EmployeeModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _EmployeeProviderElement
    extends AutoDisposeFutureProviderElement<EmployeeModel?>
    with EmployeeRef {
  _EmployeeProviderElement(super.provider);

  @override
  String get id => (origin as EmployeeProvider).id;
}

String _$employeeStreamHash() => r'b4d3bae8aa716d3d2030a207bf2d356ed45d1123';

/// Provider para observar um funcionário específico em tempo real
///
/// Copied from [employeeStream].
@ProviderFor(employeeStream)
const employeeStreamProvider = EmployeeStreamFamily();

/// Provider para observar um funcionário específico em tempo real
///
/// Copied from [employeeStream].
class EmployeeStreamFamily extends Family<AsyncValue<EmployeeModel?>> {
  /// Provider para observar um funcionário específico em tempo real
  ///
  /// Copied from [employeeStream].
  const EmployeeStreamFamily();

  /// Provider para observar um funcionário específico em tempo real
  ///
  /// Copied from [employeeStream].
  EmployeeStreamProvider call(String id) {
    return EmployeeStreamProvider(id);
  }

  @override
  EmployeeStreamProvider getProviderOverride(
    covariant EmployeeStreamProvider provider,
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
  String? get name => r'employeeStreamProvider';
}

/// Provider para observar um funcionário específico em tempo real
///
/// Copied from [employeeStream].
class EmployeeStreamProvider extends AutoDisposeStreamProvider<EmployeeModel?> {
  /// Provider para observar um funcionário específico em tempo real
  ///
  /// Copied from [employeeStream].
  EmployeeStreamProvider(String id)
    : this._internal(
        (ref) => employeeStream(ref as EmployeeStreamRef, id),
        from: employeeStreamProvider,
        name: r'employeeStreamProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$employeeStreamHash,
        dependencies: EmployeeStreamFamily._dependencies,
        allTransitiveDependencies:
            EmployeeStreamFamily._allTransitiveDependencies,
        id: id,
      );

  EmployeeStreamProvider._internal(
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
    Stream<EmployeeModel?> Function(EmployeeStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EmployeeStreamProvider._internal(
        (ref) => create(ref as EmployeeStreamRef),
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
  AutoDisposeStreamProviderElement<EmployeeModel?> createElement() {
    return _EmployeeStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EmployeeStreamProvider && other.id == id;
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
mixin EmployeeStreamRef on AutoDisposeStreamProviderRef<EmployeeModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _EmployeeStreamProviderElement
    extends AutoDisposeStreamProviderElement<EmployeeModel?>
    with EmployeeStreamRef {
  _EmployeeStreamProviderElement(super.provider);

  @override
  String get id => (origin as EmployeeStreamProvider).id;
}

String _$activeEmployeesHash() => r'a7d2b587f69ad75b847ba480f36e1c31ff4e6122';

/// Provider para obter funcionários ativos
///
/// Copied from [activeEmployees].
@ProviderFor(activeEmployees)
final activeEmployeesProvider =
    AutoDisposeFutureProvider<List<EmployeeModel>>.internal(
      activeEmployees,
      name: r'activeEmployeesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$activeEmployeesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveEmployeesRef = AutoDisposeFutureProviderRef<List<EmployeeModel>>;
String _$activeEmployeesStreamHash() =>
    r'06596db739025b8f413e576b0b422f4ac58b016e';

/// Provider para observar funcionários ativos em tempo real
///
/// Copied from [activeEmployeesStream].
@ProviderFor(activeEmployeesStream)
final activeEmployeesStreamProvider =
    AutoDisposeStreamProvider<List<EmployeeModel>>.internal(
      activeEmployeesStream,
      name: r'activeEmployeesStreamProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$activeEmployeesStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveEmployeesStreamRef =
    AutoDisposeStreamProviderRef<List<EmployeeModel>>;
String _$employeeStateHash() => r'fc994c758aa003f08b2d022052d09522b9914c34';

abstract class _$EmployeeState
    extends BuildlessAutoDisposeAsyncNotifier<EmployeeModel?> {
  late final String id;

  FutureOr<EmployeeModel?> build(String id);
}

/// Provider para gerenciar o estado de um funcionário
///
/// Copied from [EmployeeState].
@ProviderFor(EmployeeState)
const employeeStateProvider = EmployeeStateFamily();

/// Provider para gerenciar o estado de um funcionário
///
/// Copied from [EmployeeState].
class EmployeeStateFamily extends Family<AsyncValue<EmployeeModel?>> {
  /// Provider para gerenciar o estado de um funcionário
  ///
  /// Copied from [EmployeeState].
  const EmployeeStateFamily();

  /// Provider para gerenciar o estado de um funcionário
  ///
  /// Copied from [EmployeeState].
  EmployeeStateProvider call(String id) {
    return EmployeeStateProvider(id);
  }

  @override
  EmployeeStateProvider getProviderOverride(
    covariant EmployeeStateProvider provider,
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
  String? get name => r'employeeStateProvider';
}

/// Provider para gerenciar o estado de um funcionário
///
/// Copied from [EmployeeState].
class EmployeeStateProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<EmployeeState, EmployeeModel?> {
  /// Provider para gerenciar o estado de um funcionário
  ///
  /// Copied from [EmployeeState].
  EmployeeStateProvider(String id)
    : this._internal(
        () => EmployeeState()..id = id,
        from: employeeStateProvider,
        name: r'employeeStateProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$employeeStateHash,
        dependencies: EmployeeStateFamily._dependencies,
        allTransitiveDependencies:
            EmployeeStateFamily._allTransitiveDependencies,
        id: id,
      );

  EmployeeStateProvider._internal(
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
  FutureOr<EmployeeModel?> runNotifierBuild(covariant EmployeeState notifier) {
    return notifier.build(id);
  }

  @override
  Override overrideWith(EmployeeState Function() create) {
    return ProviderOverride(
      origin: this,
      override: EmployeeStateProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<EmployeeState, EmployeeModel?>
  createElement() {
    return _EmployeeStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EmployeeStateProvider && other.id == id;
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
mixin EmployeeStateRef on AutoDisposeAsyncNotifierProviderRef<EmployeeModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _EmployeeStateProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<EmployeeState, EmployeeModel?>
    with EmployeeStateRef {
  _EmployeeStateProviderElement(super.provider);

  @override
  String get id => (origin as EmployeeStateProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
