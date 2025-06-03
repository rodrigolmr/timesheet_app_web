// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_admin_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allNotificationsStreamHash() =>
    r'689bd1d857c63fc13c3c16b1b2effb7c79cad8f6';

/// See also [allNotificationsStream].
@ProviderFor(allNotificationsStream)
final allNotificationsStreamProvider =
    AutoDisposeStreamProvider<List<NotificationModel>>.internal(
      allNotificationsStream,
      name: r'allNotificationsStreamProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$allNotificationsStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllNotificationsStreamRef =
    AutoDisposeStreamProviderRef<List<NotificationModel>>;
String _$userNotificationPreferencesByIdHash() =>
    r'96304131ae1b59c06402066586214b6c8849abb6';

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

/// See also [userNotificationPreferencesById].
@ProviderFor(userNotificationPreferencesById)
const userNotificationPreferencesByIdProvider =
    UserNotificationPreferencesByIdFamily();

/// See also [userNotificationPreferencesById].
class UserNotificationPreferencesByIdFamily
    extends Family<AsyncValue<NotificationPreferencesModel?>> {
  /// See also [userNotificationPreferencesById].
  const UserNotificationPreferencesByIdFamily();

  /// See also [userNotificationPreferencesById].
  UserNotificationPreferencesByIdProvider call(String userId) {
    return UserNotificationPreferencesByIdProvider(userId);
  }

  @override
  UserNotificationPreferencesByIdProvider getProviderOverride(
    covariant UserNotificationPreferencesByIdProvider provider,
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
  String? get name => r'userNotificationPreferencesByIdProvider';
}

/// See also [userNotificationPreferencesById].
class UserNotificationPreferencesByIdProvider
    extends AutoDisposeStreamProvider<NotificationPreferencesModel?> {
  /// See also [userNotificationPreferencesById].
  UserNotificationPreferencesByIdProvider(String userId)
    : this._internal(
        (ref) => userNotificationPreferencesById(
          ref as UserNotificationPreferencesByIdRef,
          userId,
        ),
        from: userNotificationPreferencesByIdProvider,
        name: r'userNotificationPreferencesByIdProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$userNotificationPreferencesByIdHash,
        dependencies: UserNotificationPreferencesByIdFamily._dependencies,
        allTransitiveDependencies:
            UserNotificationPreferencesByIdFamily._allTransitiveDependencies,
        userId: userId,
      );

  UserNotificationPreferencesByIdProvider._internal(
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
    Stream<NotificationPreferencesModel?> Function(
      UserNotificationPreferencesByIdRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserNotificationPreferencesByIdProvider._internal(
        (ref) => create(ref as UserNotificationPreferencesByIdRef),
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
  AutoDisposeStreamProviderElement<NotificationPreferencesModel?>
  createElement() {
    return _UserNotificationPreferencesByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserNotificationPreferencesByIdProvider &&
        other.userId == userId;
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
mixin UserNotificationPreferencesByIdRef
    on AutoDisposeStreamProviderRef<NotificationPreferencesModel?> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserNotificationPreferencesByIdProviderElement
    extends AutoDisposeStreamProviderElement<NotificationPreferencesModel?>
    with UserNotificationPreferencesByIdRef {
  _UserNotificationPreferencesByIdProviderElement(super.provider);

  @override
  String get userId =>
      (origin as UserNotificationPreferencesByIdProvider).userId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
