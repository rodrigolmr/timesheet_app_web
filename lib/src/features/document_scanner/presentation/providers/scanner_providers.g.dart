// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scanner_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$scannerStateHash() => r'29b37a39037b6e1a36d5d4b8efbabdd3bc6cde82';

/// See also [ScannerState].
@ProviderFor(ScannerState)
final scannerStateProvider = AutoDisposeNotifierProvider<
  ScannerState,
  AsyncValue<DocumentScanModel?>
>.internal(
  ScannerState.new,
  name: r'scannerStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$scannerStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ScannerState = AutoDisposeNotifier<AsyncValue<DocumentScanModel?>>;
String _$currentScannerStepHash() =>
    r'7a17f9099f948a925455e22c9c4dd2730a48984c';

/// See also [CurrentScannerStep].
@ProviderFor(CurrentScannerStep)
final currentScannerStepProvider =
    AutoDisposeNotifierProvider<CurrentScannerStep, ScannerStep>.internal(
      CurrentScannerStep.new,
      name: r'currentScannerStepProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$currentScannerStepHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrentScannerStep = AutoDisposeNotifier<ScannerStep>;
String _$activeFilterHash() => r'8bebf139e3941ba829d10c3bd9266e7f374812ab';

/// See also [ActiveFilter].
@ProviderFor(ActiveFilter)
final activeFilterProvider =
    AutoDisposeNotifierProvider<ActiveFilter, FilterType>.internal(
      ActiveFilter.new,
      name: r'activeFilterProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$activeFilterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActiveFilter = AutoDisposeNotifier<FilterType>;
String _$cameraFacingModeHash() => r'5c377e26d9bd6f9300a47f8e80c7cc5b8cb5410d';

/// See also [CameraFacingMode].
@ProviderFor(CameraFacingMode)
final cameraFacingModeProvider =
    AutoDisposeNotifierProvider<CameraFacingMode, String>.internal(
      CameraFacingMode.new,
      name: r'cameraFacingModeProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$cameraFacingModeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CameraFacingMode = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
