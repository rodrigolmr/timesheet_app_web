// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pendingJobRecordsHash() => r'e6d679566ac24d13c153809ffb4f9f6b146ec0b1';

/// Provider that watches pending job records for notifications
///
/// Copied from [pendingJobRecords].
@ProviderFor(pendingJobRecords)
final pendingJobRecordsProvider =
    AutoDisposeStreamProvider<List<JobRecordModel>>.internal(
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
typedef PendingJobRecordsRef =
    AutoDisposeStreamProviderRef<List<JobRecordModel>>;
String _$pendingJobRecordsCountHash() =>
    r'70a3c9b5f231644849cfedf7c31f5902003ce538';

/// Provider that gives the count of pending job records
///
/// Copied from [pendingJobRecordsCount].
@ProviderFor(pendingJobRecordsCount)
final pendingJobRecordsCountProvider = AutoDisposeProvider<int>.internal(
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
typedef PendingJobRecordsCountRef = AutoDisposeProviderRef<int>;
String _$pendingJobRecordsPreviewHash() =>
    r'ab8b6c80543d98533f3e0c8c6a063ce594086ea4';

/// Provider for limited pending records to show in dropdown
///
/// Copied from [pendingJobRecordsPreview].
@ProviderFor(pendingJobRecordsPreview)
final pendingJobRecordsPreviewProvider =
    AutoDisposeProvider<List<JobRecordModel>>.internal(
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
typedef PendingJobRecordsPreviewRef =
    AutoDisposeProviderRef<List<JobRecordModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
