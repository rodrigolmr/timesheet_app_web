// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_reminder_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$scheduledReminderRepositoryHash() =>
    r'd27521ccf60a8d0aa97e6ac66a7c7446654effc5';

/// See also [scheduledReminderRepository].
@ProviderFor(scheduledReminderRepository)
final scheduledReminderRepositoryProvider =
    AutoDisposeProvider<ScheduledReminderRepository>.internal(
      scheduledReminderRepository,
      name: r'scheduledReminderRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$scheduledReminderRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ScheduledReminderRepositoryRef =
    AutoDisposeProviderRef<ScheduledReminderRepository>;
String _$scheduledRemindersHash() =>
    r'8f47361ede2d73bd9cc784e1509fc55e813e51f7';

/// See also [scheduledReminders].
@ProviderFor(scheduledReminders)
final scheduledRemindersProvider =
    AutoDisposeStreamProvider<List<ScheduledReminderModel>>.internal(
      scheduledReminders,
      name: r'scheduledRemindersProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$scheduledRemindersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ScheduledRemindersRef =
    AutoDisposeStreamProviderRef<List<ScheduledReminderModel>>;
String _$activeScheduledRemindersHash() =>
    r'12cabf1410ca3989ee3ac8bbfa26d107dec0be69';

/// See also [activeScheduledReminders].
@ProviderFor(activeScheduledReminders)
final activeScheduledRemindersProvider =
    AutoDisposeStreamProvider<List<ScheduledReminderModel>>.internal(
      activeScheduledReminders,
      name: r'activeScheduledRemindersProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$activeScheduledRemindersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveScheduledRemindersRef =
    AutoDisposeStreamProviderRef<List<ScheduledReminderModel>>;
String _$userScheduledRemindersHash() =>
    r'2a8ee7155fb089f3c27f5363dc617e78677e4a3f';

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

/// See also [userScheduledReminders].
@ProviderFor(userScheduledReminders)
const userScheduledRemindersProvider = UserScheduledRemindersFamily();

/// See also [userScheduledReminders].
class UserScheduledRemindersFamily
    extends Family<AsyncValue<List<ScheduledReminderModel>>> {
  /// See also [userScheduledReminders].
  const UserScheduledRemindersFamily();

  /// See also [userScheduledReminders].
  UserScheduledRemindersProvider call(String userId) {
    return UserScheduledRemindersProvider(userId);
  }

  @override
  UserScheduledRemindersProvider getProviderOverride(
    covariant UserScheduledRemindersProvider provider,
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
  String? get name => r'userScheduledRemindersProvider';
}

/// See also [userScheduledReminders].
class UserScheduledRemindersProvider
    extends AutoDisposeFutureProvider<List<ScheduledReminderModel>> {
  /// See also [userScheduledReminders].
  UserScheduledRemindersProvider(String userId)
    : this._internal(
        (ref) =>
            userScheduledReminders(ref as UserScheduledRemindersRef, userId),
        from: userScheduledRemindersProvider,
        name: r'userScheduledRemindersProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$userScheduledRemindersHash,
        dependencies: UserScheduledRemindersFamily._dependencies,
        allTransitiveDependencies:
            UserScheduledRemindersFamily._allTransitiveDependencies,
        userId: userId,
      );

  UserScheduledRemindersProvider._internal(
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
    FutureOr<List<ScheduledReminderModel>> Function(
      UserScheduledRemindersRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserScheduledRemindersProvider._internal(
        (ref) => create(ref as UserScheduledRemindersRef),
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
  AutoDisposeFutureProviderElement<List<ScheduledReminderModel>>
  createElement() {
    return _UserScheduledRemindersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserScheduledRemindersProvider && other.userId == userId;
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
mixin UserScheduledRemindersRef
    on AutoDisposeFutureProviderRef<List<ScheduledReminderModel>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserScheduledRemindersProviderElement
    extends AutoDisposeFutureProviderElement<List<ScheduledReminderModel>>
    with UserScheduledRemindersRef {
  _UserScheduledRemindersProviderElement(super.provider);

  @override
  String get userId => (origin as UserScheduledRemindersProvider).userId;
}

String _$scheduledReminderStateHash() =>
    r'8b1d0804a53c7ba359bd1394f04fd4e3b984d739';

/// See also [ScheduledReminderState].
@ProviderFor(ScheduledReminderState)
final scheduledReminderStateProvider = AutoDisposeNotifierProvider<
  ScheduledReminderState,
  AsyncValue<void>
>.internal(
  ScheduledReminderState.new,
  name: r'scheduledReminderStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$scheduledReminderStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ScheduledReminderState = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
