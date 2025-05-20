// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_record_create_providers.dart';

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
String _$jobRecordFormStateHash() =>
    r'61cf0a4afd8e0661b715b9e4bab688c14488efa9';

/// Provider para gerenciar o estado do job record em criação
///
/// Copied from [JobRecordFormState].
@ProviderFor(JobRecordFormState)
final jobRecordFormStateProvider =
    NotifierProvider<JobRecordFormState, JobRecordModel>.internal(
      JobRecordFormState.new,
      name: r'jobRecordFormStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$jobRecordFormStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$JobRecordFormState = Notifier<JobRecordModel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
