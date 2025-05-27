// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$expenseRepositoryHash() => r'd02fdca3aaf4b7106eaab683591de0ad3a7b7357';

/// Provider que fornece o repositório de despesas
///
/// Copied from [expenseRepository].
@ProviderFor(expenseRepository)
final expenseRepositoryProvider =
    AutoDisposeProvider<ExpenseRepository>.internal(
      expenseRepository,
      name: r'expenseRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$expenseRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExpenseRepositoryRef = AutoDisposeProviderRef<ExpenseRepository>;
String _$expensesHash() => r'b78707bbf67b97d27e8b92a4479bfd0368386672';

/// Provider para obter todas as despesas
///
/// Copied from [expenses].
@ProviderFor(expenses)
final expensesProvider = AutoDisposeFutureProvider<List<ExpenseModel>>.internal(
  expenses,
  name: r'expensesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$expensesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExpensesRef = AutoDisposeFutureProviderRef<List<ExpenseModel>>;
String _$expensesStreamHash() => r'12b1d48f4ef2ee425ca649ca2f90847fc3415363';

/// Provider para observar todas as despesas em tempo real
///
/// Copied from [expensesStream].
@ProviderFor(expensesStream)
final expensesStreamProvider =
    AutoDisposeStreamProvider<List<ExpenseModel>>.internal(
      expensesStream,
      name: r'expensesStreamProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$expensesStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExpensesStreamRef = AutoDisposeStreamProviderRef<List<ExpenseModel>>;
String _$expenseHash() => r'04f5f9e23e03bd8fb8f5466617d9c4bac25e27ba';

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

/// Provider para obter uma despesa específica por ID
///
/// Copied from [expense].
@ProviderFor(expense)
const expenseProvider = ExpenseFamily();

/// Provider para obter uma despesa específica por ID
///
/// Copied from [expense].
class ExpenseFamily extends Family<AsyncValue<ExpenseModel?>> {
  /// Provider para obter uma despesa específica por ID
  ///
  /// Copied from [expense].
  const ExpenseFamily();

  /// Provider para obter uma despesa específica por ID
  ///
  /// Copied from [expense].
  ExpenseProvider call(String id) {
    return ExpenseProvider(id);
  }

  @override
  ExpenseProvider getProviderOverride(covariant ExpenseProvider provider) {
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
  String? get name => r'expenseProvider';
}

/// Provider para obter uma despesa específica por ID
///
/// Copied from [expense].
class ExpenseProvider extends AutoDisposeFutureProvider<ExpenseModel?> {
  /// Provider para obter uma despesa específica por ID
  ///
  /// Copied from [expense].
  ExpenseProvider(String id)
    : this._internal(
        (ref) => expense(ref as ExpenseRef, id),
        from: expenseProvider,
        name: r'expenseProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$expenseHash,
        dependencies: ExpenseFamily._dependencies,
        allTransitiveDependencies: ExpenseFamily._allTransitiveDependencies,
        id: id,
      );

  ExpenseProvider._internal(
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
    FutureOr<ExpenseModel?> Function(ExpenseRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExpenseProvider._internal(
        (ref) => create(ref as ExpenseRef),
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
  AutoDisposeFutureProviderElement<ExpenseModel?> createElement() {
    return _ExpenseProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpenseProvider && other.id == id;
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
mixin ExpenseRef on AutoDisposeFutureProviderRef<ExpenseModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ExpenseProviderElement
    extends AutoDisposeFutureProviderElement<ExpenseModel?>
    with ExpenseRef {
  _ExpenseProviderElement(super.provider);

  @override
  String get id => (origin as ExpenseProvider).id;
}

String _$expenseStreamHash() => r'0896e8b483ec59a55bcfc9ce98d1cdc7235232cc';

/// Provider para observar uma despesa específica em tempo real
///
/// Copied from [expenseStream].
@ProviderFor(expenseStream)
const expenseStreamProvider = ExpenseStreamFamily();

/// Provider para observar uma despesa específica em tempo real
///
/// Copied from [expenseStream].
class ExpenseStreamFamily extends Family<AsyncValue<ExpenseModel?>> {
  /// Provider para observar uma despesa específica em tempo real
  ///
  /// Copied from [expenseStream].
  const ExpenseStreamFamily();

  /// Provider para observar uma despesa específica em tempo real
  ///
  /// Copied from [expenseStream].
  ExpenseStreamProvider call(String id) {
    return ExpenseStreamProvider(id);
  }

  @override
  ExpenseStreamProvider getProviderOverride(
    covariant ExpenseStreamProvider provider,
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
  String? get name => r'expenseStreamProvider';
}

/// Provider para observar uma despesa específica em tempo real
///
/// Copied from [expenseStream].
class ExpenseStreamProvider extends AutoDisposeStreamProvider<ExpenseModel?> {
  /// Provider para observar uma despesa específica em tempo real
  ///
  /// Copied from [expenseStream].
  ExpenseStreamProvider(String id)
    : this._internal(
        (ref) => expenseStream(ref as ExpenseStreamRef, id),
        from: expenseStreamProvider,
        name: r'expenseStreamProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$expenseStreamHash,
        dependencies: ExpenseStreamFamily._dependencies,
        allTransitiveDependencies:
            ExpenseStreamFamily._allTransitiveDependencies,
        id: id,
      );

  ExpenseStreamProvider._internal(
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
    Stream<ExpenseModel?> Function(ExpenseStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExpenseStreamProvider._internal(
        (ref) => create(ref as ExpenseStreamRef),
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
  AutoDisposeStreamProviderElement<ExpenseModel?> createElement() {
    return _ExpenseStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpenseStreamProvider && other.id == id;
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
mixin ExpenseStreamRef on AutoDisposeStreamProviderRef<ExpenseModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ExpenseStreamProviderElement
    extends AutoDisposeStreamProviderElement<ExpenseModel?>
    with ExpenseStreamRef {
  _ExpenseStreamProviderElement(super.provider);

  @override
  String get id => (origin as ExpenseStreamProvider).id;
}

String _$expenseByIdStreamHash() => r'791830cdff6e07cb9656925bf1337ac6639ad823';

/// Provider para observar uma despesa específica em tempo real (alternativo para telas)
///
/// Copied from [expenseByIdStream].
@ProviderFor(expenseByIdStream)
const expenseByIdStreamProvider = ExpenseByIdStreamFamily();

/// Provider para observar uma despesa específica em tempo real (alternativo para telas)
///
/// Copied from [expenseByIdStream].
class ExpenseByIdStreamFamily extends Family<AsyncValue<ExpenseModel?>> {
  /// Provider para observar uma despesa específica em tempo real (alternativo para telas)
  ///
  /// Copied from [expenseByIdStream].
  const ExpenseByIdStreamFamily();

  /// Provider para observar uma despesa específica em tempo real (alternativo para telas)
  ///
  /// Copied from [expenseByIdStream].
  ExpenseByIdStreamProvider call(String id) {
    return ExpenseByIdStreamProvider(id);
  }

  @override
  ExpenseByIdStreamProvider getProviderOverride(
    covariant ExpenseByIdStreamProvider provider,
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
  String? get name => r'expenseByIdStreamProvider';
}

/// Provider para observar uma despesa específica em tempo real (alternativo para telas)
///
/// Copied from [expenseByIdStream].
class ExpenseByIdStreamProvider
    extends AutoDisposeStreamProvider<ExpenseModel?> {
  /// Provider para observar uma despesa específica em tempo real (alternativo para telas)
  ///
  /// Copied from [expenseByIdStream].
  ExpenseByIdStreamProvider(String id)
    : this._internal(
        (ref) => expenseByIdStream(ref as ExpenseByIdStreamRef, id),
        from: expenseByIdStreamProvider,
        name: r'expenseByIdStreamProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$expenseByIdStreamHash,
        dependencies: ExpenseByIdStreamFamily._dependencies,
        allTransitiveDependencies:
            ExpenseByIdStreamFamily._allTransitiveDependencies,
        id: id,
      );

  ExpenseByIdStreamProvider._internal(
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
    Stream<ExpenseModel?> Function(ExpenseByIdStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExpenseByIdStreamProvider._internal(
        (ref) => create(ref as ExpenseByIdStreamRef),
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
  AutoDisposeStreamProviderElement<ExpenseModel?> createElement() {
    return _ExpenseByIdStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpenseByIdStreamProvider && other.id == id;
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
mixin ExpenseByIdStreamRef on AutoDisposeStreamProviderRef<ExpenseModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ExpenseByIdStreamProviderElement
    extends AutoDisposeStreamProviderElement<ExpenseModel?>
    with ExpenseByIdStreamRef {
  _ExpenseByIdStreamProviderElement(super.provider);

  @override
  String get id => (origin as ExpenseByIdStreamProvider).id;
}

String _$expensesByStatusHash() => r'cfa47ad4f531473d60b42f4f69f33ee75179b863';

/// Provider para obter despesas por status
///
/// Copied from [expensesByStatus].
@ProviderFor(expensesByStatus)
const expensesByStatusProvider = ExpensesByStatusFamily();

/// Provider para obter despesas por status
///
/// Copied from [expensesByStatus].
class ExpensesByStatusFamily extends Family<AsyncValue<List<ExpenseModel>>> {
  /// Provider para obter despesas por status
  ///
  /// Copied from [expensesByStatus].
  const ExpensesByStatusFamily();

  /// Provider para obter despesas por status
  ///
  /// Copied from [expensesByStatus].
  ExpensesByStatusProvider call(ExpenseStatus status) {
    return ExpensesByStatusProvider(status);
  }

  @override
  ExpensesByStatusProvider getProviderOverride(
    covariant ExpensesByStatusProvider provider,
  ) {
    return call(provider.status);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'expensesByStatusProvider';
}

/// Provider para obter despesas por status
///
/// Copied from [expensesByStatus].
class ExpensesByStatusProvider
    extends AutoDisposeFutureProvider<List<ExpenseModel>> {
  /// Provider para obter despesas por status
  ///
  /// Copied from [expensesByStatus].
  ExpensesByStatusProvider(ExpenseStatus status)
    : this._internal(
        (ref) => expensesByStatus(ref as ExpensesByStatusRef, status),
        from: expensesByStatusProvider,
        name: r'expensesByStatusProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$expensesByStatusHash,
        dependencies: ExpensesByStatusFamily._dependencies,
        allTransitiveDependencies:
            ExpensesByStatusFamily._allTransitiveDependencies,
        status: status,
      );

  ExpensesByStatusProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
  }) : super.internal();

  final ExpenseStatus status;

  @override
  Override overrideWith(
    FutureOr<List<ExpenseModel>> Function(ExpensesByStatusRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExpensesByStatusProvider._internal(
        (ref) => create(ref as ExpensesByStatusRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ExpenseModel>> createElement() {
    return _ExpensesByStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpensesByStatusProvider && other.status == status;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExpensesByStatusRef on AutoDisposeFutureProviderRef<List<ExpenseModel>> {
  /// The parameter `status` of this provider.
  ExpenseStatus get status;
}

class _ExpensesByStatusProviderElement
    extends AutoDisposeFutureProviderElement<List<ExpenseModel>>
    with ExpensesByStatusRef {
  _ExpensesByStatusProviderElement(super.provider);

  @override
  ExpenseStatus get status => (origin as ExpensesByStatusProvider).status;
}

String _$expensesByStatusStreamHash() =>
    r'0170674d5551d0a809042dfc32c59c517313c5a1';

/// Provider para observar despesas por status em tempo real
///
/// Copied from [expensesByStatusStream].
@ProviderFor(expensesByStatusStream)
const expensesByStatusStreamProvider = ExpensesByStatusStreamFamily();

/// Provider para observar despesas por status em tempo real
///
/// Copied from [expensesByStatusStream].
class ExpensesByStatusStreamFamily
    extends Family<AsyncValue<List<ExpenseModel>>> {
  /// Provider para observar despesas por status em tempo real
  ///
  /// Copied from [expensesByStatusStream].
  const ExpensesByStatusStreamFamily();

  /// Provider para observar despesas por status em tempo real
  ///
  /// Copied from [expensesByStatusStream].
  ExpensesByStatusStreamProvider call(ExpenseStatus status) {
    return ExpensesByStatusStreamProvider(status);
  }

  @override
  ExpensesByStatusStreamProvider getProviderOverride(
    covariant ExpensesByStatusStreamProvider provider,
  ) {
    return call(provider.status);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'expensesByStatusStreamProvider';
}

/// Provider para observar despesas por status em tempo real
///
/// Copied from [expensesByStatusStream].
class ExpensesByStatusStreamProvider
    extends AutoDisposeStreamProvider<List<ExpenseModel>> {
  /// Provider para observar despesas por status em tempo real
  ///
  /// Copied from [expensesByStatusStream].
  ExpensesByStatusStreamProvider(ExpenseStatus status)
    : this._internal(
        (ref) =>
            expensesByStatusStream(ref as ExpensesByStatusStreamRef, status),
        from: expensesByStatusStreamProvider,
        name: r'expensesByStatusStreamProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$expensesByStatusStreamHash,
        dependencies: ExpensesByStatusStreamFamily._dependencies,
        allTransitiveDependencies:
            ExpensesByStatusStreamFamily._allTransitiveDependencies,
        status: status,
      );

  ExpensesByStatusStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
  }) : super.internal();

  final ExpenseStatus status;

  @override
  Override overrideWith(
    Stream<List<ExpenseModel>> Function(ExpensesByStatusStreamRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExpensesByStatusStreamProvider._internal(
        (ref) => create(ref as ExpensesByStatusStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<ExpenseModel>> createElement() {
    return _ExpensesByStatusStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpensesByStatusStreamProvider && other.status == status;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExpensesByStatusStreamRef
    on AutoDisposeStreamProviderRef<List<ExpenseModel>> {
  /// The parameter `status` of this provider.
  ExpenseStatus get status;
}

class _ExpensesByStatusStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<ExpenseModel>>
    with ExpensesByStatusStreamRef {
  _ExpensesByStatusStreamProviderElement(super.provider);

  @override
  ExpenseStatus get status => (origin as ExpensesByStatusStreamProvider).status;
}

String _$pendingExpensesHash() => r'66119a08e8c8c372f2c62d09147dd64d4d6eb441';

/// Provider para obter despesas pendentes
///
/// Copied from [pendingExpenses].
@ProviderFor(pendingExpenses)
final pendingExpensesProvider =
    AutoDisposeFutureProvider<List<ExpenseModel>>.internal(
      pendingExpenses,
      name: r'pendingExpensesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$pendingExpensesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingExpensesRef = AutoDisposeFutureProviderRef<List<ExpenseModel>>;
String _$pendingExpensesStreamHash() =>
    r'2bdd337589365e519f7c80e4fca48cb3d73e2a98';

/// Provider para observar despesas pendentes em tempo real
///
/// Copied from [pendingExpensesStream].
@ProviderFor(pendingExpensesStream)
final pendingExpensesStreamProvider =
    AutoDisposeStreamProvider<List<ExpenseModel>>.internal(
      pendingExpensesStream,
      name: r'pendingExpensesStreamProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$pendingExpensesStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingExpensesStreamRef =
    AutoDisposeStreamProviderRef<List<ExpenseModel>>;
String _$expensesByUserHash() => r'3cdf0cb57d2919cce6fa95c0b687d6b9110b90e1';

/// Provider para obter despesas por usuário
///
/// Copied from [expensesByUser].
@ProviderFor(expensesByUser)
const expensesByUserProvider = ExpensesByUserFamily();

/// Provider para obter despesas por usuário
///
/// Copied from [expensesByUser].
class ExpensesByUserFamily extends Family<AsyncValue<List<ExpenseModel>>> {
  /// Provider para obter despesas por usuário
  ///
  /// Copied from [expensesByUser].
  const ExpensesByUserFamily();

  /// Provider para obter despesas por usuário
  ///
  /// Copied from [expensesByUser].
  ExpensesByUserProvider call(String userId) {
    return ExpensesByUserProvider(userId);
  }

  @override
  ExpensesByUserProvider getProviderOverride(
    covariant ExpensesByUserProvider provider,
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
  String? get name => r'expensesByUserProvider';
}

/// Provider para obter despesas por usuário
///
/// Copied from [expensesByUser].
class ExpensesByUserProvider
    extends AutoDisposeFutureProvider<List<ExpenseModel>> {
  /// Provider para obter despesas por usuário
  ///
  /// Copied from [expensesByUser].
  ExpensesByUserProvider(String userId)
    : this._internal(
        (ref) => expensesByUser(ref as ExpensesByUserRef, userId),
        from: expensesByUserProvider,
        name: r'expensesByUserProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$expensesByUserHash,
        dependencies: ExpensesByUserFamily._dependencies,
        allTransitiveDependencies:
            ExpensesByUserFamily._allTransitiveDependencies,
        userId: userId,
      );

  ExpensesByUserProvider._internal(
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
    FutureOr<List<ExpenseModel>> Function(ExpensesByUserRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExpensesByUserProvider._internal(
        (ref) => create(ref as ExpensesByUserRef),
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
  AutoDisposeFutureProviderElement<List<ExpenseModel>> createElement() {
    return _ExpensesByUserProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpensesByUserProvider && other.userId == userId;
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
mixin ExpensesByUserRef on AutoDisposeFutureProviderRef<List<ExpenseModel>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _ExpensesByUserProviderElement
    extends AutoDisposeFutureProviderElement<List<ExpenseModel>>
    with ExpensesByUserRef {
  _ExpensesByUserProviderElement(super.provider);

  @override
  String get userId => (origin as ExpensesByUserProvider).userId;
}

String _$expensesByUserStreamHash() =>
    r'bfde045462ab0fbad3de33a474091f3380f97dff';

/// Provider para observar despesas por usuário em tempo real
///
/// Copied from [expensesByUserStream].
@ProviderFor(expensesByUserStream)
const expensesByUserStreamProvider = ExpensesByUserStreamFamily();

/// Provider para observar despesas por usuário em tempo real
///
/// Copied from [expensesByUserStream].
class ExpensesByUserStreamFamily
    extends Family<AsyncValue<List<ExpenseModel>>> {
  /// Provider para observar despesas por usuário em tempo real
  ///
  /// Copied from [expensesByUserStream].
  const ExpensesByUserStreamFamily();

  /// Provider para observar despesas por usuário em tempo real
  ///
  /// Copied from [expensesByUserStream].
  ExpensesByUserStreamProvider call(String userId) {
    return ExpensesByUserStreamProvider(userId);
  }

  @override
  ExpensesByUserStreamProvider getProviderOverride(
    covariant ExpensesByUserStreamProvider provider,
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
  String? get name => r'expensesByUserStreamProvider';
}

/// Provider para observar despesas por usuário em tempo real
///
/// Copied from [expensesByUserStream].
class ExpensesByUserStreamProvider
    extends AutoDisposeStreamProvider<List<ExpenseModel>> {
  /// Provider para observar despesas por usuário em tempo real
  ///
  /// Copied from [expensesByUserStream].
  ExpensesByUserStreamProvider(String userId)
    : this._internal(
        (ref) => expensesByUserStream(ref as ExpensesByUserStreamRef, userId),
        from: expensesByUserStreamProvider,
        name: r'expensesByUserStreamProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$expensesByUserStreamHash,
        dependencies: ExpensesByUserStreamFamily._dependencies,
        allTransitiveDependencies:
            ExpensesByUserStreamFamily._allTransitiveDependencies,
        userId: userId,
      );

  ExpensesByUserStreamProvider._internal(
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
    Stream<List<ExpenseModel>> Function(ExpensesByUserStreamRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExpensesByUserStreamProvider._internal(
        (ref) => create(ref as ExpensesByUserStreamRef),
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
  AutoDisposeStreamProviderElement<List<ExpenseModel>> createElement() {
    return _ExpensesByUserStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpensesByUserStreamProvider && other.userId == userId;
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
mixin ExpensesByUserStreamRef
    on AutoDisposeStreamProviderRef<List<ExpenseModel>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _ExpensesByUserStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<ExpenseModel>>
    with ExpensesByUserStreamRef {
  _ExpensesByUserStreamProviderElement(super.provider);

  @override
  String get userId => (origin as ExpensesByUserStreamProvider).userId;
}

String _$expensesByCardHash() => r'91c5446950440018f2058f93fd890572c8a3e15a';

/// Provider para obter despesas por cartão
///
/// Copied from [expensesByCard].
@ProviderFor(expensesByCard)
const expensesByCardProvider = ExpensesByCardFamily();

/// Provider para obter despesas por cartão
///
/// Copied from [expensesByCard].
class ExpensesByCardFamily extends Family<AsyncValue<List<ExpenseModel>>> {
  /// Provider para obter despesas por cartão
  ///
  /// Copied from [expensesByCard].
  const ExpensesByCardFamily();

  /// Provider para obter despesas por cartão
  ///
  /// Copied from [expensesByCard].
  ExpensesByCardProvider call(String cardId) {
    return ExpensesByCardProvider(cardId);
  }

  @override
  ExpensesByCardProvider getProviderOverride(
    covariant ExpensesByCardProvider provider,
  ) {
    return call(provider.cardId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'expensesByCardProvider';
}

/// Provider para obter despesas por cartão
///
/// Copied from [expensesByCard].
class ExpensesByCardProvider
    extends AutoDisposeFutureProvider<List<ExpenseModel>> {
  /// Provider para obter despesas por cartão
  ///
  /// Copied from [expensesByCard].
  ExpensesByCardProvider(String cardId)
    : this._internal(
        (ref) => expensesByCard(ref as ExpensesByCardRef, cardId),
        from: expensesByCardProvider,
        name: r'expensesByCardProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$expensesByCardHash,
        dependencies: ExpensesByCardFamily._dependencies,
        allTransitiveDependencies:
            ExpensesByCardFamily._allTransitiveDependencies,
        cardId: cardId,
      );

  ExpensesByCardProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cardId,
  }) : super.internal();

  final String cardId;

  @override
  Override overrideWith(
    FutureOr<List<ExpenseModel>> Function(ExpensesByCardRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExpensesByCardProvider._internal(
        (ref) => create(ref as ExpensesByCardRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cardId: cardId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ExpenseModel>> createElement() {
    return _ExpensesByCardProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpensesByCardProvider && other.cardId == cardId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cardId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExpensesByCardRef on AutoDisposeFutureProviderRef<List<ExpenseModel>> {
  /// The parameter `cardId` of this provider.
  String get cardId;
}

class _ExpensesByCardProviderElement
    extends AutoDisposeFutureProviderElement<List<ExpenseModel>>
    with ExpensesByCardRef {
  _ExpensesByCardProviderElement(super.provider);

  @override
  String get cardId => (origin as ExpensesByCardProvider).cardId;
}

String _$expenseStateHash() => r'eddb015055a01ea689e5c3c6e47d0511fd9baa90';

abstract class _$ExpenseState
    extends BuildlessAutoDisposeAsyncNotifier<ExpenseModel?> {
  late final String id;

  FutureOr<ExpenseModel?> build(String id);
}

/// Provider para gerenciar o estado de uma despesa
///
/// Copied from [ExpenseState].
@ProviderFor(ExpenseState)
const expenseStateProvider = ExpenseStateFamily();

/// Provider para gerenciar o estado de uma despesa
///
/// Copied from [ExpenseState].
class ExpenseStateFamily extends Family<AsyncValue<ExpenseModel?>> {
  /// Provider para gerenciar o estado de uma despesa
  ///
  /// Copied from [ExpenseState].
  const ExpenseStateFamily();

  /// Provider para gerenciar o estado de uma despesa
  ///
  /// Copied from [ExpenseState].
  ExpenseStateProvider call(String id) {
    return ExpenseStateProvider(id);
  }

  @override
  ExpenseStateProvider getProviderOverride(
    covariant ExpenseStateProvider provider,
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
  String? get name => r'expenseStateProvider';
}

/// Provider para gerenciar o estado de uma despesa
///
/// Copied from [ExpenseState].
class ExpenseStateProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ExpenseState, ExpenseModel?> {
  /// Provider para gerenciar o estado de uma despesa
  ///
  /// Copied from [ExpenseState].
  ExpenseStateProvider(String id)
    : this._internal(
        () => ExpenseState()..id = id,
        from: expenseStateProvider,
        name: r'expenseStateProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$expenseStateHash,
        dependencies: ExpenseStateFamily._dependencies,
        allTransitiveDependencies:
            ExpenseStateFamily._allTransitiveDependencies,
        id: id,
      );

  ExpenseStateProvider._internal(
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
  FutureOr<ExpenseModel?> runNotifierBuild(covariant ExpenseState notifier) {
    return notifier.build(id);
  }

  @override
  Override overrideWith(ExpenseState Function() create) {
    return ProviderOverride(
      origin: this,
      override: ExpenseStateProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<ExpenseState, ExpenseModel?>
  createElement() {
    return _ExpenseStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpenseStateProvider && other.id == id;
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
mixin ExpenseStateRef on AutoDisposeAsyncNotifierProviderRef<ExpenseModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ExpenseStateProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ExpenseState, ExpenseModel?>
    with ExpenseStateRef {
  _ExpenseStateProviderElement(super.provider);

  @override
  String get id => (origin as ExpenseStateProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
