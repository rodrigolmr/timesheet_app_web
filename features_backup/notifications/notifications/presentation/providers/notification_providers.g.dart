// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationRepositoryHash() =>
    r'2bd81c09c33c14531aa1cedd04c1d8156d91a951';

/// See also [notificationRepository].
@ProviderFor(notificationRepository)
final notificationRepositoryProvider =
    AutoDisposeProvider<NotificationRepository>.internal(
      notificationRepository,
      name: r'notificationRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$notificationRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationRepositoryRef =
    AutoDisposeProviderRef<NotificationRepository>;
String _$notificationServiceHash() =>
    r'6db295591da0ebe2efdebffe326d89912af46b5a';

/// See also [notificationService].
@ProviderFor(notificationService)
final notificationServiceProvider =
    AutoDisposeProvider<NotificationService>.internal(
      notificationService,
      name: r'notificationServiceProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$notificationServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationServiceRef = AutoDisposeProviderRef<NotificationService>;
String _$notificationHelperHash() =>
    r'3ab42f8397c3e34cf3703109d10afe4df4d19953';

/// See also [notificationHelper].
@ProviderFor(notificationHelper)
final notificationHelperProvider =
    AutoDisposeProvider<NotificationHelper>.internal(
      notificationHelper,
      name: r'notificationHelperProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$notificationHelperHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationHelperRef = AutoDisposeProviderRef<NotificationHelper>;
String _$userNotificationsHash() => r'9433b8994fcf4f1daa78e4c885cb9eef11da4ec4';

/// See also [userNotifications].
@ProviderFor(userNotifications)
final userNotificationsProvider =
    AutoDisposeStreamProvider<List<NotificationModel>>.internal(
      userNotifications,
      name: r'userNotificationsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$userNotificationsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserNotificationsRef =
    AutoDisposeStreamProviderRef<List<NotificationModel>>;
String _$unreadNotificationCountHash() =>
    r'61e04a4ffe863d6fa46789967582f6265a627555';

/// See also [unreadNotificationCount].
@ProviderFor(unreadNotificationCount)
final unreadNotificationCountProvider = AutoDisposeProvider<int>.internal(
  unreadNotificationCount,
  name: r'unreadNotificationCountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$unreadNotificationCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UnreadNotificationCountRef = AutoDisposeProviderRef<int>;
String _$userNotificationPreferencesHash() =>
    r'a3cf1118662b46b1916167da63d5666f8b112335';

/// See also [userNotificationPreferences].
@ProviderFor(userNotificationPreferences)
final userNotificationPreferencesProvider =
    AutoDisposeStreamProvider<NotificationPreferencesModel?>.internal(
      userNotificationPreferences,
      name: r'userNotificationPreferencesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$userNotificationPreferencesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserNotificationPreferencesRef =
    AutoDisposeStreamProviderRef<NotificationPreferencesModel?>;
String _$notificationMessagesHash() =>
    r'bbf0437527d5874efaffe050821005a338d95cb7';

/// See also [notificationMessages].
@ProviderFor(notificationMessages)
final notificationMessagesProvider =
    AutoDisposeStreamProvider<RemoteMessage>.internal(
      notificationMessages,
      name: r'notificationMessagesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$notificationMessagesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationMessagesRef = AutoDisposeStreamProviderRef<RemoteMessage>;
String _$notificationPermissionStatusHash() =>
    r'10bf9202782aac6d75d780587c84fac7d41708f5';

/// See also [notificationPermissionStatus].
@ProviderFor(notificationPermissionStatus)
final notificationPermissionStatusProvider =
    AutoDisposeFutureProvider<AuthorizationStatus>.internal(
      notificationPermissionStatus,
      name: r'notificationPermissionStatusProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$notificationPermissionStatusHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationPermissionStatusRef =
    AutoDisposeFutureProviderRef<AuthorizationStatus>;
String _$notificationStateHash() => r'1bef7e30c71f8c14799ae97b0febb7cae628f20b';

/// See also [NotificationState].
@ProviderFor(NotificationState)
final notificationStateProvider =
    AutoDisposeNotifierProvider<NotificationState, AsyncValue<void>>.internal(
      NotificationState.new,
      name: r'notificationStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$notificationStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NotificationState = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
