// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userRepositoryHash() => r'e3eb41e2cc78bb42f35518b72aca6fffdb122b6d';

/// Provider que fornece o repositório de usuários
///
/// Copied from [userRepository].
@ProviderFor(userRepository)
final userRepositoryProvider = AutoDisposeProvider<UserRepository>.internal(
  userRepository,
  name: r'userRepositoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserRepositoryRef = AutoDisposeProviderRef<UserRepository>;
String _$usersHash() => r'187535d8146696b81f8362cfe63e753622cfe63c';

/// Provider para obter todos os usuários
///
/// Copied from [users].
@ProviderFor(users)
final usersProvider = AutoDisposeFutureProvider<List<UserModel>>.internal(
  users,
  name: r'usersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$usersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UsersRef = AutoDisposeFutureProviderRef<List<UserModel>>;
String _$usersStreamHash() => r'b3a0728dd6cb51ec2e418693efd3f6ddb9786141';

/// Provider para observar todos os usuários em tempo real
///
/// Copied from [usersStream].
@ProviderFor(usersStream)
final usersStreamProvider = AutoDisposeStreamProvider<List<UserModel>>.internal(
  usersStream,
  name: r'usersStreamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$usersStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UsersStreamRef = AutoDisposeStreamProviderRef<List<UserModel>>;
String _$userHash() => r'5d0600a4378e0bc4e346de3c711a2825d5a30907';

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

/// Provider para obter um usuário específico por ID
///
/// Copied from [user].
@ProviderFor(user)
const userProvider = UserFamily();

/// Provider para obter um usuário específico por ID
///
/// Copied from [user].
class UserFamily extends Family<AsyncValue<UserModel?>> {
  /// Provider para obter um usuário específico por ID
  ///
  /// Copied from [user].
  const UserFamily();

  /// Provider para obter um usuário específico por ID
  ///
  /// Copied from [user].
  UserProvider call(String id) {
    return UserProvider(id);
  }

  @override
  UserProvider getProviderOverride(covariant UserProvider provider) {
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
  String? get name => r'userProvider';
}

/// Provider para obter um usuário específico por ID
///
/// Copied from [user].
class UserProvider extends AutoDisposeFutureProvider<UserModel?> {
  /// Provider para obter um usuário específico por ID
  ///
  /// Copied from [user].
  UserProvider(String id)
    : this._internal(
        (ref) => user(ref as UserRef, id),
        from: userProvider,
        name: r'userProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product') ? null : _$userHash,
        dependencies: UserFamily._dependencies,
        allTransitiveDependencies: UserFamily._allTransitiveDependencies,
        id: id,
      );

  UserProvider._internal(
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
    FutureOr<UserModel?> Function(UserRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserProvider._internal(
        (ref) => create(ref as UserRef),
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
  AutoDisposeFutureProviderElement<UserModel?> createElement() {
    return _UserProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserProvider && other.id == id;
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
mixin UserRef on AutoDisposeFutureProviderRef<UserModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _UserProviderElement extends AutoDisposeFutureProviderElement<UserModel?>
    with UserRef {
  _UserProviderElement(super.provider);

  @override
  String get id => (origin as UserProvider).id;
}

String _$userStreamHash() => r'179febb226e3f8d73491890cf92f4ec65b072d0c';

/// Provider para observar um usuário específico em tempo real
///
/// Copied from [userStream].
@ProviderFor(userStream)
const userStreamProvider = UserStreamFamily();

/// Provider para observar um usuário específico em tempo real
///
/// Copied from [userStream].
class UserStreamFamily extends Family<AsyncValue<UserModel?>> {
  /// Provider para observar um usuário específico em tempo real
  ///
  /// Copied from [userStream].
  const UserStreamFamily();

  /// Provider para observar um usuário específico em tempo real
  ///
  /// Copied from [userStream].
  UserStreamProvider call(String id) {
    return UserStreamProvider(id);
  }

  @override
  UserStreamProvider getProviderOverride(
    covariant UserStreamProvider provider,
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
  String? get name => r'userStreamProvider';
}

/// Provider para observar um usuário específico em tempo real
///
/// Copied from [userStream].
class UserStreamProvider extends AutoDisposeStreamProvider<UserModel?> {
  /// Provider para observar um usuário específico em tempo real
  ///
  /// Copied from [userStream].
  UserStreamProvider(String id)
    : this._internal(
        (ref) => userStream(ref as UserStreamRef, id),
        from: userStreamProvider,
        name: r'userStreamProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$userStreamHash,
        dependencies: UserStreamFamily._dependencies,
        allTransitiveDependencies: UserStreamFamily._allTransitiveDependencies,
        id: id,
      );

  UserStreamProvider._internal(
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
    Stream<UserModel?> Function(UserStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserStreamProvider._internal(
        (ref) => create(ref as UserStreamRef),
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
  AutoDisposeStreamProviderElement<UserModel?> createElement() {
    return _UserStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserStreamProvider && other.id == id;
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
mixin UserStreamRef on AutoDisposeStreamProviderRef<UserModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _UserStreamProviderElement
    extends AutoDisposeStreamProviderElement<UserModel?>
    with UserStreamRef {
  _UserStreamProviderElement(super.provider);

  @override
  String get id => (origin as UserStreamProvider).id;
}

String _$userByIdStreamHash() => r'6211c87a60835dfe0c1e26421d44561cea260b59';

/// Provider para observar um usuário específico em tempo real (alternativo para telas)
///
/// Copied from [userByIdStream].
@ProviderFor(userByIdStream)
const userByIdStreamProvider = UserByIdStreamFamily();

/// Provider para observar um usuário específico em tempo real (alternativo para telas)
///
/// Copied from [userByIdStream].
class UserByIdStreamFamily extends Family<AsyncValue<UserModel?>> {
  /// Provider para observar um usuário específico em tempo real (alternativo para telas)
  ///
  /// Copied from [userByIdStream].
  const UserByIdStreamFamily();

  /// Provider para observar um usuário específico em tempo real (alternativo para telas)
  ///
  /// Copied from [userByIdStream].
  UserByIdStreamProvider call(String id) {
    return UserByIdStreamProvider(id);
  }

  @override
  UserByIdStreamProvider getProviderOverride(
    covariant UserByIdStreamProvider provider,
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
  String? get name => r'userByIdStreamProvider';
}

/// Provider para observar um usuário específico em tempo real (alternativo para telas)
///
/// Copied from [userByIdStream].
class UserByIdStreamProvider extends AutoDisposeStreamProvider<UserModel?> {
  /// Provider para observar um usuário específico em tempo real (alternativo para telas)
  ///
  /// Copied from [userByIdStream].
  UserByIdStreamProvider(String id)
    : this._internal(
        (ref) => userByIdStream(ref as UserByIdStreamRef, id),
        from: userByIdStreamProvider,
        name: r'userByIdStreamProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$userByIdStreamHash,
        dependencies: UserByIdStreamFamily._dependencies,
        allTransitiveDependencies:
            UserByIdStreamFamily._allTransitiveDependencies,
        id: id,
      );

  UserByIdStreamProvider._internal(
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
    Stream<UserModel?> Function(UserByIdStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserByIdStreamProvider._internal(
        (ref) => create(ref as UserByIdStreamRef),
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
  AutoDisposeStreamProviderElement<UserModel?> createElement() {
    return _UserByIdStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserByIdStreamProvider && other.id == id;
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
mixin UserByIdStreamRef on AutoDisposeStreamProviderRef<UserModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _UserByIdStreamProviderElement
    extends AutoDisposeStreamProviderElement<UserModel?>
    with UserByIdStreamRef {
  _UserByIdStreamProviderElement(super.provider);

  @override
  String get id => (origin as UserByIdStreamProvider).id;
}

String _$usersByRoleHash() => r'8d4a11860e1ec1d38fe7fb37348118c3e69850e4';

/// Provider para obter usuários por cargo
///
/// Copied from [usersByRole].
@ProviderFor(usersByRole)
const usersByRoleProvider = UsersByRoleFamily();

/// Provider para obter usuários por cargo
///
/// Copied from [usersByRole].
class UsersByRoleFamily extends Family<AsyncValue<List<UserModel>>> {
  /// Provider para obter usuários por cargo
  ///
  /// Copied from [usersByRole].
  const UsersByRoleFamily();

  /// Provider para obter usuários por cargo
  ///
  /// Copied from [usersByRole].
  UsersByRoleProvider call(String role) {
    return UsersByRoleProvider(role);
  }

  @override
  UsersByRoleProvider getProviderOverride(
    covariant UsersByRoleProvider provider,
  ) {
    return call(provider.role);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'usersByRoleProvider';
}

/// Provider para obter usuários por cargo
///
/// Copied from [usersByRole].
class UsersByRoleProvider extends AutoDisposeFutureProvider<List<UserModel>> {
  /// Provider para obter usuários por cargo
  ///
  /// Copied from [usersByRole].
  UsersByRoleProvider(String role)
    : this._internal(
        (ref) => usersByRole(ref as UsersByRoleRef, role),
        from: usersByRoleProvider,
        name: r'usersByRoleProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$usersByRoleHash,
        dependencies: UsersByRoleFamily._dependencies,
        allTransitiveDependencies: UsersByRoleFamily._allTransitiveDependencies,
        role: role,
      );

  UsersByRoleProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.role,
  }) : super.internal();

  final String role;

  @override
  Override overrideWith(
    FutureOr<List<UserModel>> Function(UsersByRoleRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UsersByRoleProvider._internal(
        (ref) => create(ref as UsersByRoleRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        role: role,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<UserModel>> createElement() {
    return _UsersByRoleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UsersByRoleProvider && other.role == role;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, role.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UsersByRoleRef on AutoDisposeFutureProviderRef<List<UserModel>> {
  /// The parameter `role` of this provider.
  String get role;
}

class _UsersByRoleProviderElement
    extends AutoDisposeFutureProviderElement<List<UserModel>>
    with UsersByRoleRef {
  _UsersByRoleProviderElement(super.provider);

  @override
  String get role => (origin as UsersByRoleProvider).role;
}

String _$userByAuthUidHash() => r'4cf7ba0fd327f1a1f24c36508859dbc448d576da';

/// Provider para obter um usuário por auth UID
///
/// Copied from [userByAuthUid].
@ProviderFor(userByAuthUid)
const userByAuthUidProvider = UserByAuthUidFamily();

/// Provider para obter um usuário por auth UID
///
/// Copied from [userByAuthUid].
class UserByAuthUidFamily extends Family<AsyncValue<UserModel?>> {
  /// Provider para obter um usuário por auth UID
  ///
  /// Copied from [userByAuthUid].
  const UserByAuthUidFamily();

  /// Provider para obter um usuário por auth UID
  ///
  /// Copied from [userByAuthUid].
  UserByAuthUidProvider call(String authUid) {
    return UserByAuthUidProvider(authUid);
  }

  @override
  UserByAuthUidProvider getProviderOverride(
    covariant UserByAuthUidProvider provider,
  ) {
    return call(provider.authUid);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userByAuthUidProvider';
}

/// Provider para obter um usuário por auth UID
///
/// Copied from [userByAuthUid].
class UserByAuthUidProvider extends AutoDisposeFutureProvider<UserModel?> {
  /// Provider para obter um usuário por auth UID
  ///
  /// Copied from [userByAuthUid].
  UserByAuthUidProvider(String authUid)
    : this._internal(
        (ref) => userByAuthUid(ref as UserByAuthUidRef, authUid),
        from: userByAuthUidProvider,
        name: r'userByAuthUidProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$userByAuthUidHash,
        dependencies: UserByAuthUidFamily._dependencies,
        allTransitiveDependencies:
            UserByAuthUidFamily._allTransitiveDependencies,
        authUid: authUid,
      );

  UserByAuthUidProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.authUid,
  }) : super.internal();

  final String authUid;

  @override
  Override overrideWith(
    FutureOr<UserModel?> Function(UserByAuthUidRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserByAuthUidProvider._internal(
        (ref) => create(ref as UserByAuthUidRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        authUid: authUid,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<UserModel?> createElement() {
    return _UserByAuthUidProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserByAuthUidProvider && other.authUid == authUid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, authUid.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserByAuthUidRef on AutoDisposeFutureProviderRef<UserModel?> {
  /// The parameter `authUid` of this provider.
  String get authUid;
}

class _UserByAuthUidProviderElement
    extends AutoDisposeFutureProviderElement<UserModel?>
    with UserByAuthUidRef {
  _UserByAuthUidProviderElement(super.provider);

  @override
  String get authUid => (origin as UserByAuthUidProvider).authUid;
}

String _$activeUsersHash() => r'd3ec54c0589e6809b6fd173c7e6f596cee14b466';

/// Provider para obter usuários ativos
///
/// Copied from [activeUsers].
@ProviderFor(activeUsers)
final activeUsersProvider = AutoDisposeFutureProvider<List<UserModel>>.internal(
  activeUsers,
  name: r'activeUsersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$activeUsersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveUsersRef = AutoDisposeFutureProviderRef<List<UserModel>>;
String _$currentUserProfileHash() =>
    r'1f90757909cdf2121dc1dac5c91fceee468f11fc';

/// Provider para obter o usuário atual autenticado
///
/// Copied from [currentUserProfile].
@ProviderFor(currentUserProfile)
final currentUserProfileProvider =
    AutoDisposeFutureProvider<UserModel?>.internal(
      currentUserProfile,
      name: r'currentUserProfileProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$currentUserProfileHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserProfileRef = AutoDisposeFutureProviderRef<UserModel?>;
String _$currentUserProfileStreamHash() =>
    r'70a886b060f656137fd8f5a7e7f1ce179b779698';

/// Provider para observar o perfil do usuário atual em tempo real
///
/// Copied from [currentUserProfileStream].
@ProviderFor(currentUserProfileStream)
final currentUserProfileStreamProvider =
    AutoDisposeStreamProvider<UserModel?>.internal(
      currentUserProfileStream,
      name: r'currentUserProfileStreamProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$currentUserProfileStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserProfileStreamRef = AutoDisposeStreamProviderRef<UserModel?>;
String _$userPreferredThemeHash() =>
    r'03c6ee3f1ae1a9beb0f9dde9363f8d7a0609edcc';

/// Provider que fornece o tema preferido do usuário atual
///
/// Copied from [userPreferredTheme].
@ProviderFor(userPreferredTheme)
final userPreferredThemeProvider =
    AutoDisposeFutureProvider<ThemeVariant?>.internal(
      userPreferredTheme,
      name: r'userPreferredThemeProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$userPreferredThemeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserPreferredThemeRef = AutoDisposeFutureProviderRef<ThemeVariant?>;
String _$canUserChangeThemeHash() =>
    r'f46bd5b7d9165aa72ae1ab0e02bddd63e4d6332c';

/// Provider que fornece se o usuário atual pode alterar seu tema
///
/// Copied from [canUserChangeTheme].
@ProviderFor(canUserChangeTheme)
final canUserChangeThemeProvider = AutoDisposeFutureProvider<bool>.internal(
  canUserChangeTheme,
  name: r'canUserChangeThemeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$canUserChangeThemeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CanUserChangeThemeRef = AutoDisposeFutureProviderRef<bool>;
String _$updateCurrentUserThemeHash() =>
    r'2f8ddc56b68174e8207805ebffad077c99fdebd6';

/// Atualiza o tema do usuário atual
///
/// Copied from [updateCurrentUserTheme].
@ProviderFor(updateCurrentUserTheme)
const updateCurrentUserThemeProvider = UpdateCurrentUserThemeFamily();

/// Atualiza o tema do usuário atual
///
/// Copied from [updateCurrentUserTheme].
class UpdateCurrentUserThemeFamily extends Family<AsyncValue<void>> {
  /// Atualiza o tema do usuário atual
  ///
  /// Copied from [updateCurrentUserTheme].
  const UpdateCurrentUserThemeFamily();

  /// Atualiza o tema do usuário atual
  ///
  /// Copied from [updateCurrentUserTheme].
  UpdateCurrentUserThemeProvider call(String themePreference) {
    return UpdateCurrentUserThemeProvider(themePreference);
  }

  @override
  UpdateCurrentUserThemeProvider getProviderOverride(
    covariant UpdateCurrentUserThemeProvider provider,
  ) {
    return call(provider.themePreference);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'updateCurrentUserThemeProvider';
}

/// Atualiza o tema do usuário atual
///
/// Copied from [updateCurrentUserTheme].
class UpdateCurrentUserThemeProvider extends AutoDisposeFutureProvider<void> {
  /// Atualiza o tema do usuário atual
  ///
  /// Copied from [updateCurrentUserTheme].
  UpdateCurrentUserThemeProvider(String themePreference)
    : this._internal(
        (ref) => updateCurrentUserTheme(
          ref as UpdateCurrentUserThemeRef,
          themePreference,
        ),
        from: updateCurrentUserThemeProvider,
        name: r'updateCurrentUserThemeProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$updateCurrentUserThemeHash,
        dependencies: UpdateCurrentUserThemeFamily._dependencies,
        allTransitiveDependencies:
            UpdateCurrentUserThemeFamily._allTransitiveDependencies,
        themePreference: themePreference,
      );

  UpdateCurrentUserThemeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.themePreference,
  }) : super.internal();

  final String themePreference;

  @override
  Override overrideWith(
    FutureOr<void> Function(UpdateCurrentUserThemeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateCurrentUserThemeProvider._internal(
        (ref) => create(ref as UpdateCurrentUserThemeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        themePreference: themePreference,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _UpdateCurrentUserThemeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateCurrentUserThemeProvider &&
        other.themePreference == themePreference;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, themePreference.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UpdateCurrentUserThemeRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `themePreference` of this provider.
  String get themePreference;
}

class _UpdateCurrentUserThemeProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with UpdateCurrentUserThemeRef {
  _UpdateCurrentUserThemeProviderElement(super.provider);

  @override
  String get themePreference =>
      (origin as UpdateCurrentUserThemeProvider).themePreference;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
