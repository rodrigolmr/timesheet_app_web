// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pendingJobRecordsHash() => r'1e2f8ad6782db4c38f5a264313de851ed940c1d1';

/// Provider that watches pending job records for notifications
///
/// Copied from [pendingJobRecords].
@ProviderFor(pendingJobRecords)
final pendingJobRecordsProvider = StreamProvider<List<JobRecordModel>>.internal(
  pendingJobRecords,
  name: r'pendingJobRecordsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pendingJobRecordsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingJobRecordsRef = StreamProviderRef<List<JobRecordModel>>;
String _$pendingJobRecordsCountHash() =>
    r'64eb3b1bfb8d4290ec4b9b9c923cd62390b680d3';

/// Provider that gives the count of pending job records
///
/// Copied from [pendingJobRecordsCount].
@ProviderFor(pendingJobRecordsCount)
final pendingJobRecordsCountProvider = Provider<int>.internal(
  pendingJobRecordsCount,
  name: r'pendingJobRecordsCountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pendingJobRecordsCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingJobRecordsCountRef = ProviderRef<int>;
String _$pendingJobRecordsPreviewHash() =>
    r'89a204e472f0d1ebb2bf33ad2ebf4efaab67f8bf';

/// Provider for limited pending records to show in dropdown
///
/// Copied from [pendingJobRecordsPreview].
@ProviderFor(pendingJobRecordsPreview)
final pendingJobRecordsPreviewProvider =
    Provider<List<JobRecordModel>>.internal(
      pendingJobRecordsPreview,
      name: r'pendingJobRecordsPreviewProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$pendingJobRecordsPreviewHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingJobRecordsPreviewRef = ProviderRef<List<JobRecordModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
