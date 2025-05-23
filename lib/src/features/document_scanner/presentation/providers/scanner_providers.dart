import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/document_scan_model.dart';

part 'scanner_providers.g.dart';

enum ScannerStep {
  capture,
  crop,
  filter,
}

@riverpod
class ScannerState extends _$ScannerState {
  @override
  AsyncValue<DocumentScanModel?> build() {
    return const AsyncData(null);
  }

  void setOriginalImage(Uint8List imageData) {
    print('ScannerState: Setting original image with ${imageData.length} bytes');
    state = AsyncData(DocumentScanModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      originalImage: imageData,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));
    print('ScannerState: State updated');
  }

  void setCropCorners(CropCorners corners) {
    state.whenData((scan) {
      if (scan != null) {
        state = AsyncData(scan.copyWith(
          cropCorners: corners,
          updatedAt: DateTime.now(),
        ));
      }
    });
  }

  void setProcessedImage(Uint8List imageData, FilterType filter) {
    state.whenData((scan) {
      if (scan != null) {
        state = AsyncData(scan.copyWith(
          processedImage: imageData,
          appliedFilter: filter,
          updatedAt: DateTime.now(),
        ));
      }
    });
  }

  void reset() {
    state = const AsyncData(null);
  }
}

@riverpod
class CurrentScannerStep extends _$CurrentScannerStep {
  @override
  ScannerStep build() => ScannerStep.capture;

  void goToStep(ScannerStep step) {
    state = step;
  }

  void nextStep() {
    print('CurrentScannerStep: Current step = $state');
    switch (state) {
      case ScannerStep.capture:
        state = ScannerStep.crop;
        print('CurrentScannerStep: Moving to crop');
        break;
      case ScannerStep.crop:
        state = ScannerStep.filter;
        print('CurrentScannerStep: Moving to filter');
        break;
      case ScannerStep.filter:
        print('CurrentScannerStep: Already at filter');
        break;
    }
  }

  void previousStep() {
    switch (state) {
      case ScannerStep.capture:
        break;
      case ScannerStep.crop:
        state = ScannerStep.capture;
        break;
      case ScannerStep.filter:
        state = ScannerStep.crop;
        break;
    }
  }
}

@riverpod
class ActiveFilter extends _$ActiveFilter {
  @override
  FilterType build() => FilterType.original;

  void setFilter(FilterType filter) {
    state = filter;
  }
}

@riverpod
class CameraFacingMode extends _$CameraFacingMode {
  @override
  String build() => 'environment';

  void toggle() {
    state = state == 'environment' ? 'user' : 'environment';
  }
}