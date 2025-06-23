// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hours_management_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hoursManagementRepositoryHash() =>
    r'6921fd2cb3016142448d631a674555367a10983a';

/// See also [hoursManagementRepository].
@ProviderFor(hoursManagementRepository)
final hoursManagementRepositoryProvider =
    AutoDisposeProvider<HoursManagementRepository>.internal(
      hoursManagementRepository,
      name: r'hoursManagementRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$hoursManagementRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HoursManagementRepositoryRef =
    AutoDisposeProviderRef<HoursManagementRepository>;
String _$userDailyHoursHash() => r'd72310c168383a55c0df5d54714ff7e9e2256917';

/// See also [userDailyHours].
@ProviderFor(userDailyHours)
final userDailyHoursProvider =
    AutoDisposeFutureProvider<List<UserHoursModel>>.internal(
      userDailyHours,
      name: r'userDailyHoursProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$userDailyHoursHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserDailyHoursRef = AutoDisposeFutureProviderRef<List<UserHoursModel>>;
String _$userHoursSummaryHash() => r'f7622e20f0276f4f9ab9ed0663031a3c0bc3001a';

/// See also [userHoursSummary].
@ProviderFor(userHoursSummary)
final userHoursSummaryProvider =
    AutoDisposeFutureProvider<Map<String, double>>.internal(
      userHoursSummary,
      name: r'userHoursSummaryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$userHoursSummaryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserHoursSummaryRef = AutoDisposeFutureProviderRef<Map<String, double>>;
String _$employeeDailyHoursHash() =>
    r'58d655704059644038f1ec2cc951e2b298b6bb48';

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

/// See also [employeeDailyHours].
@ProviderFor(employeeDailyHours)
const employeeDailyHoursProvider = EmployeeDailyHoursFamily();

/// See also [employeeDailyHours].
class EmployeeDailyHoursFamily
    extends Family<AsyncValue<List<DailyHoursModel>>> {
  /// See also [employeeDailyHours].
  const EmployeeDailyHoursFamily();

  /// See also [employeeDailyHours].
  EmployeeDailyHoursProvider call({required String employeeId}) {
    return EmployeeDailyHoursProvider(employeeId: employeeId);
  }

  @override
  EmployeeDailyHoursProvider getProviderOverride(
    covariant EmployeeDailyHoursProvider provider,
  ) {
    return call(employeeId: provider.employeeId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'employeeDailyHoursProvider';
}

/// See also [employeeDailyHours].
class EmployeeDailyHoursProvider
    extends AutoDisposeFutureProvider<List<DailyHoursModel>> {
  /// See also [employeeDailyHours].
  EmployeeDailyHoursProvider({required String employeeId})
    : this._internal(
        (ref) => employeeDailyHours(
          ref as EmployeeDailyHoursRef,
          employeeId: employeeId,
        ),
        from: employeeDailyHoursProvider,
        name: r'employeeDailyHoursProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$employeeDailyHoursHash,
        dependencies: EmployeeDailyHoursFamily._dependencies,
        allTransitiveDependencies:
            EmployeeDailyHoursFamily._allTransitiveDependencies,
        employeeId: employeeId,
      );

  EmployeeDailyHoursProvider._internal(
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
    FutureOr<List<DailyHoursModel>> Function(EmployeeDailyHoursRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EmployeeDailyHoursProvider._internal(
        (ref) => create(ref as EmployeeDailyHoursRef),
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
  AutoDisposeFutureProviderElement<List<DailyHoursModel>> createElement() {
    return _EmployeeDailyHoursProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EmployeeDailyHoursProvider &&
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
mixin EmployeeDailyHoursRef
    on AutoDisposeFutureProviderRef<List<DailyHoursModel>> {
  /// The parameter `employeeId` of this provider.
  String get employeeId;
}

class _EmployeeDailyHoursProviderElement
    extends AutoDisposeFutureProviderElement<List<DailyHoursModel>>
    with EmployeeDailyHoursRef {
  _EmployeeDailyHoursProviderElement(super.provider);

  @override
  String get employeeId => (origin as EmployeeDailyHoursProvider).employeeId;
}

String _$employeeHoursSummaryHash() =>
    r'c05c2b2d7286e1ef8140a83ff9e29f913aab2e26';

/// See also [employeeHoursSummary].
@ProviderFor(employeeHoursSummary)
const employeeHoursSummaryProvider = EmployeeHoursSummaryFamily();

/// See also [employeeHoursSummary].
class EmployeeHoursSummaryFamily
    extends Family<AsyncValue<Map<String, double>>> {
  /// See also [employeeHoursSummary].
  const EmployeeHoursSummaryFamily();

  /// See also [employeeHoursSummary].
  EmployeeHoursSummaryProvider call({required String employeeId}) {
    return EmployeeHoursSummaryProvider(employeeId: employeeId);
  }

  @override
  EmployeeHoursSummaryProvider getProviderOverride(
    covariant EmployeeHoursSummaryProvider provider,
  ) {
    return call(employeeId: provider.employeeId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'employeeHoursSummaryProvider';
}

/// See also [employeeHoursSummary].
class EmployeeHoursSummaryProvider
    extends AutoDisposeFutureProvider<Map<String, double>> {
  /// See also [employeeHoursSummary].
  EmployeeHoursSummaryProvider({required String employeeId})
    : this._internal(
        (ref) => employeeHoursSummary(
          ref as EmployeeHoursSummaryRef,
          employeeId: employeeId,
        ),
        from: employeeHoursSummaryProvider,
        name: r'employeeHoursSummaryProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$employeeHoursSummaryHash,
        dependencies: EmployeeHoursSummaryFamily._dependencies,
        allTransitiveDependencies:
            EmployeeHoursSummaryFamily._allTransitiveDependencies,
        employeeId: employeeId,
      );

  EmployeeHoursSummaryProvider._internal(
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
    FutureOr<Map<String, double>> Function(EmployeeHoursSummaryRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EmployeeHoursSummaryProvider._internal(
        (ref) => create(ref as EmployeeHoursSummaryRef),
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
  AutoDisposeFutureProviderElement<Map<String, double>> createElement() {
    return _EmployeeHoursSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EmployeeHoursSummaryProvider &&
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
mixin EmployeeHoursSummaryRef
    on AutoDisposeFutureProviderRef<Map<String, double>> {
  /// The parameter `employeeId` of this provider.
  String get employeeId;
}

class _EmployeeHoursSummaryProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, double>>
    with EmployeeHoursSummaryRef {
  _EmployeeHoursSummaryProviderElement(super.provider);

  @override
  String get employeeId => (origin as EmployeeHoursSummaryProvider).employeeId;
}

String _$canViewOtherEmployeesHash() =>
    r'96733edabb78a9889c9a81c797fffbfc8c718f48';

/// See also [canViewOtherEmployees].
@ProviderFor(canViewOtherEmployees)
final canViewOtherEmployeesProvider = AutoDisposeFutureProvider<bool>.internal(
  canViewOtherEmployees,
  name: r'canViewOtherEmployeesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$canViewOtherEmployeesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CanViewOtherEmployeesRef = AutoDisposeFutureProviderRef<bool>;
String _$viewingEmployeeHoursHash() =>
    r'c71613f430ec00ae2c3146ae8a7b0122d1d303ff';

/// See also [viewingEmployeeHours].
@ProviderFor(viewingEmployeeHours)
final viewingEmployeeHoursProvider =
    AutoDisposeFutureProvider<List<UserHoursModel>>.internal(
      viewingEmployeeHours,
      name: r'viewingEmployeeHoursProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$viewingEmployeeHoursHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ViewingEmployeeHoursRef =
    AutoDisposeFutureProviderRef<List<UserHoursModel>>;
String _$viewingEmployeeHoursSummaryHash() =>
    r'd43e1ec52c7638a37afa26831d4bd8491e0f486e';

/// See also [viewingEmployeeHoursSummary].
@ProviderFor(viewingEmployeeHoursSummary)
final viewingEmployeeHoursSummaryProvider =
    AutoDisposeFutureProvider<Map<String, double>>.internal(
      viewingEmployeeHoursSummary,
      name: r'viewingEmployeeHoursSummaryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$viewingEmployeeHoursSummaryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ViewingEmployeeHoursSummaryRef =
    AutoDisposeFutureProviderRef<Map<String, double>>;
String _$dateRangeSelectionHash() =>
    r'e938bb8e2388b7eb276e1e5a73865414ee910233';

/// See also [DateRangeSelection].
@ProviderFor(DateRangeSelection)
final dateRangeSelectionProvider = AutoDisposeNotifierProvider<
  DateRangeSelection,
  ({DateTime? startDate, DateTime? endDate})
>.internal(
  DateRangeSelection.new,
  name: r'dateRangeSelectionProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dateRangeSelectionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DateRangeSelection =
    AutoDisposeNotifier<({DateTime? startDate, DateTime? endDate})>;
String _$selectedEmployeeHash() => r'995c33de06ad18c3cff40f7acde6ecf1d3f872da';

/// See also [SelectedEmployee].
@ProviderFor(SelectedEmployee)
final selectedEmployeeProvider =
    AutoDisposeNotifierProvider<SelectedEmployee, String?>.internal(
      SelectedEmployee.new,
      name: r'selectedEmployeeProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedEmployeeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedEmployee = AutoDisposeNotifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
