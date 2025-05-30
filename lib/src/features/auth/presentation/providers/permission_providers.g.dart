// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$canAccessRouteHash() => r'3d7b519115f38141deb413332a4a6af72ee4dc5c';

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

/// See also [canAccessRoute].
@ProviderFor(canAccessRoute)
const canAccessRouteProvider = CanAccessRouteFamily();

/// See also [canAccessRoute].
class CanAccessRouteFamily extends Family<AsyncValue<bool>> {
  /// See also [canAccessRoute].
  const CanAccessRouteFamily();

  /// See also [canAccessRoute].
  CanAccessRouteProvider call(AppRoute route) {
    return CanAccessRouteProvider(route);
  }

  @override
  CanAccessRouteProvider getProviderOverride(
    covariant CanAccessRouteProvider provider,
  ) {
    return call(provider.route);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'canAccessRouteProvider';
}

/// See also [canAccessRoute].
class CanAccessRouteProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [canAccessRoute].
  CanAccessRouteProvider(AppRoute route)
    : this._internal(
        (ref) => canAccessRoute(ref as CanAccessRouteRef, route),
        from: canAccessRouteProvider,
        name: r'canAccessRouteProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$canAccessRouteHash,
        dependencies: CanAccessRouteFamily._dependencies,
        allTransitiveDependencies:
            CanAccessRouteFamily._allTransitiveDependencies,
        route: route,
      );

  CanAccessRouteProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.route,
  }) : super.internal();

  final AppRoute route;

  @override
  Override overrideWith(
    FutureOr<bool> Function(CanAccessRouteRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CanAccessRouteProvider._internal(
        (ref) => create(ref as CanAccessRouteRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        route: route,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _CanAccessRouteProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CanAccessRouteProvider && other.route == route;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, route.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CanAccessRouteRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `route` of this provider.
  AppRoute get route;
}

class _CanAccessRouteProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with CanAccessRouteRef {
  _CanAccessRouteProviderElement(super.provider);

  @override
  AppRoute get route => (origin as CanAccessRouteProvider).route;
}

String _$currentUserRoleHash() => r'1eb60929f215becf52c27591f44256111b520ec3';

/// See also [currentUserRole].
@ProviderFor(currentUserRole)
final currentUserRoleProvider = AutoDisposeFutureProvider<UserRole?>.internal(
  currentUserRole,
  name: r'currentUserRoleProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentUserRoleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserRoleRef = AutoDisposeFutureProviderRef<UserRole?>;
String _$currentUserRoleStreamHash() =>
    r'33c361531e9377924850deaf6e73c8918501d2a0';

/// See also [currentUserRoleStream].
@ProviderFor(currentUserRoleStream)
final currentUserRoleStreamProvider =
    AutoDisposeStreamProvider<UserRole?>.internal(
      currentUserRoleStream,
      name: r'currentUserRoleStreamProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$currentUserRoleStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserRoleStreamRef = AutoDisposeStreamProviderRef<UserRole?>;
String _$canViewAllJobRecordsHash() =>
    r'a164dbc404d2fa031ab3f2a0b30dc0d8bf354e96';

/// See also [canViewAllJobRecords].
@ProviderFor(canViewAllJobRecords)
final canViewAllJobRecordsProvider = AutoDisposeFutureProvider<bool>.internal(
  canViewAllJobRecords,
  name: r'canViewAllJobRecordsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$canViewAllJobRecordsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CanViewAllJobRecordsRef = AutoDisposeFutureProviderRef<bool>;
String _$canEditJobRecordHash() => r'01b5069f7bd8ed08a9403fa8cb0445d295c8aa19';

/// See also [canEditJobRecord].
@ProviderFor(canEditJobRecord)
const canEditJobRecordProvider = CanEditJobRecordFamily();

/// See also [canEditJobRecord].
class CanEditJobRecordFamily extends Family<AsyncValue<bool>> {
  /// See also [canEditJobRecord].
  const CanEditJobRecordFamily();

  /// See also [canEditJobRecord].
  CanEditJobRecordProvider call(String recordCreatorId) {
    return CanEditJobRecordProvider(recordCreatorId);
  }

  @override
  CanEditJobRecordProvider getProviderOverride(
    covariant CanEditJobRecordProvider provider,
  ) {
    return call(provider.recordCreatorId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'canEditJobRecordProvider';
}

/// See also [canEditJobRecord].
class CanEditJobRecordProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [canEditJobRecord].
  CanEditJobRecordProvider(String recordCreatorId)
    : this._internal(
        (ref) => canEditJobRecord(ref as CanEditJobRecordRef, recordCreatorId),
        from: canEditJobRecordProvider,
        name: r'canEditJobRecordProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$canEditJobRecordHash,
        dependencies: CanEditJobRecordFamily._dependencies,
        allTransitiveDependencies:
            CanEditJobRecordFamily._allTransitiveDependencies,
        recordCreatorId: recordCreatorId,
      );

  CanEditJobRecordProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.recordCreatorId,
  }) : super.internal();

  final String recordCreatorId;

  @override
  Override overrideWith(
    FutureOr<bool> Function(CanEditJobRecordRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CanEditJobRecordProvider._internal(
        (ref) => create(ref as CanEditJobRecordRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        recordCreatorId: recordCreatorId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _CanEditJobRecordProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CanEditJobRecordProvider &&
        other.recordCreatorId == recordCreatorId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, recordCreatorId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CanEditJobRecordRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `recordCreatorId` of this provider.
  String get recordCreatorId;
}

class _CanEditJobRecordProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with CanEditJobRecordRef {
  _CanEditJobRecordProviderElement(super.provider);

  @override
  String get recordCreatorId =>
      (origin as CanEditJobRecordProvider).recordCreatorId;
}

String _$canDeleteJobRecordHash() =>
    r'ee674499e09232c5095413dbcf1bb59713c79912';

/// See also [canDeleteJobRecord].
@ProviderFor(canDeleteJobRecord)
final canDeleteJobRecordProvider = AutoDisposeFutureProvider<bool>.internal(
  canDeleteJobRecord,
  name: r'canDeleteJobRecordProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$canDeleteJobRecordHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CanDeleteJobRecordRef = AutoDisposeFutureProviderRef<bool>;
String _$canViewAllExpensesHash() =>
    r'06344bbeeca9bd7eb81b5930c195ae46d6669eab';

/// See also [canViewAllExpenses].
@ProviderFor(canViewAllExpenses)
final canViewAllExpensesProvider = AutoDisposeFutureProvider<bool>.internal(
  canViewAllExpenses,
  name: r'canViewAllExpensesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$canViewAllExpensesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CanViewAllExpensesRef = AutoDisposeFutureProviderRef<bool>;
String _$canEditExpenseHash() => r'f7fe47aa78f4bdfe73bf39b3eb707ba45ac99ddb';

/// See also [canEditExpense].
@ProviderFor(canEditExpense)
const canEditExpenseProvider = CanEditExpenseFamily();

/// See also [canEditExpense].
class CanEditExpenseFamily extends Family<AsyncValue<bool>> {
  /// See also [canEditExpense].
  const CanEditExpenseFamily();

  /// See also [canEditExpense].
  CanEditExpenseProvider call(String expenseCreatorId) {
    return CanEditExpenseProvider(expenseCreatorId);
  }

  @override
  CanEditExpenseProvider getProviderOverride(
    covariant CanEditExpenseProvider provider,
  ) {
    return call(provider.expenseCreatorId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'canEditExpenseProvider';
}

/// See also [canEditExpense].
class CanEditExpenseProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [canEditExpense].
  CanEditExpenseProvider(String expenseCreatorId)
    : this._internal(
        (ref) => canEditExpense(ref as CanEditExpenseRef, expenseCreatorId),
        from: canEditExpenseProvider,
        name: r'canEditExpenseProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$canEditExpenseHash,
        dependencies: CanEditExpenseFamily._dependencies,
        allTransitiveDependencies:
            CanEditExpenseFamily._allTransitiveDependencies,
        expenseCreatorId: expenseCreatorId,
      );

  CanEditExpenseProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.expenseCreatorId,
  }) : super.internal();

  final String expenseCreatorId;

  @override
  Override overrideWith(
    FutureOr<bool> Function(CanEditExpenseRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CanEditExpenseProvider._internal(
        (ref) => create(ref as CanEditExpenseRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        expenseCreatorId: expenseCreatorId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _CanEditExpenseProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CanEditExpenseProvider &&
        other.expenseCreatorId == expenseCreatorId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, expenseCreatorId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CanEditExpenseRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `expenseCreatorId` of this provider.
  String get expenseCreatorId;
}

class _CanEditExpenseProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with CanEditExpenseRef {
  _CanEditExpenseProviderElement(super.provider);

  @override
  String get expenseCreatorId =>
      (origin as CanEditExpenseProvider).expenseCreatorId;
}

String _$canDeleteExpenseHash() => r'10db6af7b4183480079f14d3bd846b922dda91f5';

/// See also [canDeleteExpense].
@ProviderFor(canDeleteExpense)
final canDeleteExpenseProvider = AutoDisposeFutureProvider<bool>.internal(
  canDeleteExpense,
  name: r'canDeleteExpenseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$canDeleteExpenseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CanDeleteExpenseRef = AutoDisposeFutureProviderRef<bool>;
String _$canManageEmployeesHash() =>
    r'44b5229f1865080979c62bd6174dd9921076b32d';

/// See also [canManageEmployees].
@ProviderFor(canManageEmployees)
final canManageEmployeesProvider = AutoDisposeFutureProvider<bool>.internal(
  canManageEmployees,
  name: r'canManageEmployeesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$canManageEmployeesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CanManageEmployeesRef = AutoDisposeFutureProviderRef<bool>;
String _$canManageUsersHash() => r'31a272c8cb7f5aac7733d2d376522f8954af5310';

/// See also [canManageUsers].
@ProviderFor(canManageUsers)
final canManageUsersProvider = AutoDisposeFutureProvider<bool>.internal(
  canManageUsers,
  name: r'canManageUsersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$canManageUsersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CanManageUsersRef = AutoDisposeFutureProviderRef<bool>;
String _$canManageCompanyCardsHash() =>
    r'f122877a536a8296475c7347d036769a6e2f635f';

/// See also [canManageCompanyCards].
@ProviderFor(canManageCompanyCards)
final canManageCompanyCardsProvider = AutoDisposeFutureProvider<bool>.internal(
  canManageCompanyCards,
  name: r'canManageCompanyCardsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$canManageCompanyCardsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CanManageCompanyCardsRef = AutoDisposeFutureProviderRef<bool>;
String _$canAccessDatabaseHash() => r'd01220fc1174f03f34e8fbe4fdbb437a91185dcc';

/// See also [canAccessDatabase].
@ProviderFor(canAccessDatabase)
final canAccessDatabaseProvider = AutoDisposeFutureProvider<bool>.internal(
  canAccessDatabase,
  name: r'canAccessDatabaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$canAccessDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CanAccessDatabaseRef = AutoDisposeFutureProviderRef<bool>;
String _$allowedRoutesHash() => r'89b973ef59674e58ffaeba796c348a1778569cd2';

/// See also [allowedRoutes].
@ProviderFor(allowedRoutes)
final allowedRoutesProvider = AutoDisposeFutureProvider<Set<AppRoute>>.internal(
  allowedRoutes,
  name: r'allowedRoutesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$allowedRoutesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllowedRoutesRef = AutoDisposeFutureProviderRef<Set<AppRoute>>;
String _$canGenerateTimesheetHash() =>
    r'd267cbc49eceb7c8c3450d1f3d48466e7001c9f3';

/// See also [canGenerateTimesheet].
@ProviderFor(canGenerateTimesheet)
final canGenerateTimesheetProvider = AutoDisposeFutureProvider<bool>.internal(
  canGenerateTimesheet,
  name: r'canGenerateTimesheetProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$canGenerateTimesheetHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CanGenerateTimesheetRef = AutoDisposeFutureProviderRef<bool>;
String _$canPrintJobRecordsHash() =>
    r'41a499c2b6d5927b19dcfb7fd389ce794725c9c2';

/// See also [canPrintJobRecords].
@ProviderFor(canPrintJobRecords)
final canPrintJobRecordsProvider = AutoDisposeFutureProvider<bool>.internal(
  canPrintJobRecords,
  name: r'canPrintJobRecordsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$canPrintJobRecordsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CanPrintJobRecordsRef = AutoDisposeFutureProviderRef<bool>;
String _$canPrintExpensesHash() => r'c41cbcff927ea7899f8c9564725741fb1f813fb3';

/// See also [canPrintExpenses].
@ProviderFor(canPrintExpenses)
final canPrintExpensesProvider = AutoDisposeFutureProvider<bool>.internal(
  canPrintExpenses,
  name: r'canPrintExpensesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$canPrintExpensesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CanPrintExpensesRef = AutoDisposeFutureProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
