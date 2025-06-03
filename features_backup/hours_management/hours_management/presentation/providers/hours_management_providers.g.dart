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
String _$userDailyHoursHash() => r'42cc3df2b753889944a0944aa3a4c2c69aa23803';

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
String _$userHoursSummaryHash() => r'64982ffe0128d9f22d5c4191148becea09aa51cf';

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
String _$dateRangeSelectionHash() =>
    r'5951025df42a1e45b1e47a94ff3c8ac7eb81953c';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
