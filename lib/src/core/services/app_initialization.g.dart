// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_initialization.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appInitializerHash() => r'cef6f533b48bc31f6792beb5b5e77f9b21baf1f0';

/// Provider for app initialization.
///
/// Copied from [AppInitializer].
@ProviderFor(AppInitializer)
final appInitializerProvider = AutoDisposeNotifierProvider<
  AppInitializer,
  AsyncValue<AppInitializationStatus>
>.internal(
  AppInitializer.new,
  name: r'appInitializerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$appInitializerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AppInitializer =
    AutoDisposeNotifier<AsyncValue<AppInitializationStatus>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
