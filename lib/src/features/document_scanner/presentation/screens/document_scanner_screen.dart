import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../providers/scanner_providers.dart';
import '../widgets/capture_screen.dart';
import '../widgets/crop_screen.dart';
import '../widgets/filter_screen.dart';

class DocumentScannerScreen extends ConsumerWidget {
  const DocumentScannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = ref.watch(currentScannerStepProvider);
    final scanState = ref.watch(scannerStateProvider);

    print('DocumentScannerScreen - Current step: $currentStep');
    print('DocumentScannerScreen - Scan state loading: ${scanState.isLoading}');

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildCurrentScreen(currentStep),
            ),
            if (scanState.isLoading)
              Container(
                color: Colors.black54,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Processing...',
                        style: context.textStyles.body.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentScreen(ScannerStep step) {
    switch (step) {
      case ScannerStep.capture:
        return const CaptureScreen(key: ValueKey('capture'));
      case ScannerStep.crop:
        return const CropScreen(key: ValueKey('crop'));
      case ScannerStep.filter:
        return const FilterScreen(key: ValueKey('filter'));
    }
  }
}