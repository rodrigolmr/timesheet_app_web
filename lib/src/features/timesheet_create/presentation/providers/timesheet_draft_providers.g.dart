// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_draft_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentStepHash() => r'0d3b2b2355c56f4816c723cd93ce6d4aadbff705';

/// See also [currentStep].
@ProviderFor(currentStep)
final currentStepProvider = AutoDisposeProvider<int>.internal(
  currentStep,
  name: r'currentStepProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentStepHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentStepRef = AutoDisposeProviderRef<int>;
String _$currentStepNotifierHash() =>
    r'c068d6d7d447533c05783e9aa35b61d570789b4f';

/// See also [CurrentStepNotifier].
@ProviderFor(CurrentStepNotifier)
final currentStepNotifierProvider =
    AutoDisposeNotifierProvider<CurrentStepNotifier, int>.internal(
      CurrentStepNotifier.new,
      name: r'currentStepNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$currentStepNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrentStepNotifier = AutoDisposeNotifier<int>;
String _$timesheetDraftHash() => r'877d67bc8db81d86dbd82a8a770ec91a923aff67';

/// See also [TimesheetDraft].
@ProviderFor(TimesheetDraft)
final timesheetDraftProvider = AutoDisposeNotifierProvider<
  TimesheetDraft,
  AsyncValue<JobDraftModel?>
>.internal(
  TimesheetDraft.new,
  name: r'timesheetDraftProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$timesheetDraftHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TimesheetDraft = AutoDisposeNotifier<AsyncValue<JobDraftModel?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
