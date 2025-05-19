// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_create_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentStepNotifierHash() =>
    r'87b9caed6a5fa61d68de0a00ad5cdc14625a7e04';

/// Provider para gerenciar o step atual do formulário
///
/// Copied from [CurrentStepNotifier].
@ProviderFor(CurrentStepNotifier)
final currentStepNotifierProvider =
    NotifierProvider<CurrentStepNotifier, int>.internal(
      CurrentStepNotifier.new,
      name: r'currentStepNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$currentStepNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrentStepNotifier = Notifier<int>;
String _$timesheetFormStateHash() =>
    r'6b487e6f3c4fb40a6461b00ba00483c5262fee9f';

/// Provider para gerenciar o estado do timesheet em criação (sem draft)
///
/// Copied from [TimesheetFormState].
@ProviderFor(TimesheetFormState)
final timesheetFormStateProvider =
    NotifierProvider<TimesheetFormState, JobRecordModel>.internal(
      TimesheetFormState.new,
      name: r'timesheetFormStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$timesheetFormStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TimesheetFormState = Notifier<JobRecordModel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
