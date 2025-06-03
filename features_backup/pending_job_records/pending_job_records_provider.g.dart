// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_job_records_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pendingJobRecordNotificationsHash() =>
    r'9367e1690e48a67a726010da790ba06cd71a12fe';

/// Provider que monitora job records pendentes e suas notificações associadas
///
/// Copied from [pendingJobRecordNotifications].
@ProviderFor(pendingJobRecordNotifications)
final pendingJobRecordNotificationsProvider =
    AutoDisposeStreamProvider<List<NotificationModel>>.internal(
      pendingJobRecordNotifications,
      name: r'pendingJobRecordNotificationsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$pendingJobRecordNotificationsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingJobRecordNotificationsRef =
    AutoDisposeStreamProviderRef<List<NotificationModel>>;
String _$pendingJobRecordCountHash() =>
    r'1fe20f1de9df0a229249665638a7721e04abf5bb';

/// Provider que retorna o número de job records pendentes
///
/// Copied from [pendingJobRecordCount].
@ProviderFor(pendingJobRecordCount)
final pendingJobRecordCountProvider = AutoDisposeProvider<int>.internal(
  pendingJobRecordCount,
  name: r'pendingJobRecordCountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pendingJobRecordCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingJobRecordCountRef = AutoDisposeProviderRef<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
