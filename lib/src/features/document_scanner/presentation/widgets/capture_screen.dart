import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker_web/image_picker_web.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../providers/scanner_providers.dart';
import 'camera_view_web.dart';

class CaptureScreen extends ConsumerStatefulWidget {
  const CaptureScreen({super.key});

  @override
  ConsumerState<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends ConsumerState<CaptureScreen> {
  CameraControllerWeb? _cameraController;
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameraController = CameraControllerWeb(facingMode: 'environment');
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error accessing camera: $e'),
            backgroundColor: context.colors.error,
          ),
        );
      }
    }
  }

  Future<void> _captureImage() async {
    if (_cameraController == null) return;

    try {
      print('Starting image capture...');
      
      // Add a small delay to ensure video is ready
      await Future.delayed(const Duration(milliseconds: 100));
      
      final imageData = await _cameraController!.takePicture();
      print('Image captured, size: ${imageData.length} bytes');
      
      if (imageData.isEmpty) {
        throw Exception('Captured image is empty');
      }
      
      ref.read(scannerStateProvider.notifier).setOriginalImage(imageData);
      print('Image set in state');
      
      ref.read(currentScannerStepProvider.notifier).nextStep();
      print('Navigated to crop screen');
    } catch (e, stack) {
      print('Error capturing image: $e');
      print('Stack: $stack');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error capturing image: $e'),
            backgroundColor: context.colors.error,
          ),
        );
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final pickedFile = await ImagePickerWeb.getImageAsBytes();
      if (pickedFile != null) {
        ref.read(scannerStateProvider.notifier).setOriginalImage(pickedFile);
        ref.read(currentScannerStepProvider.notifier).nextStep();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: context.colors.error,
          ),
        );
      }
    }
  }

  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
    _cameraController?.setFlash(_isFlashOn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          if (_isCameraInitialized && _cameraController != null)
            CameraViewWeb(controller: _cameraController!)
          else
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          // Grid overlay for alignment
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: GridOverlayPainter(),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildControlButton(
                    onPressed: _pickFromGallery,
                    child: Text(
                      'Gallery',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  _buildCaptureButton(onPressed: _captureImage),
                  _buildControlButton(
                    onPressed: _toggleFlash,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isFlashOn ? Icons.flash_on : Icons.flash_off,
                          color: Colors.black,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Flash',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required VoidCallback onPressed,
    required Widget child,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: DefaultTextStyle(
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildCaptureButton({required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class GridOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw vertical lines (rule of thirds)
    final thirdWidth = size.width / 3;
    canvas.drawLine(
      Offset(thirdWidth, 0),
      Offset(thirdWidth, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(thirdWidth * 2, 0),
      Offset(thirdWidth * 2, size.height),
      paint,
    );

    // Draw horizontal lines (rule of thirds)
    final thirdHeight = size.height / 3;
    canvas.drawLine(
      Offset(0, thirdHeight),
      Offset(size.width, thirdHeight),
      paint,
    );
    canvas.drawLine(
      Offset(0, thirdHeight * 2),
      Offset(size.width, thirdHeight * 2),
      paint,
    );

    // Draw center crosshair
    final centerPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    const crosshairSize = 30.0;

    // Horizontal center line
    canvas.drawLine(
      Offset(centerX - crosshairSize, centerY),
      Offset(centerX + crosshairSize, centerY),
      centerPaint,
    );

    // Vertical center line
    canvas.drawLine(
      Offset(centerX, centerY - crosshairSize),
      Offset(centerX, centerY + crosshairSize),
      centerPaint,
    );

    // Draw corner guides
    final cornerPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const cornerSize = 40.0;
    const cornerMargin = 20.0;

    // Top-left corner
    canvas.drawPath(
      Path()
        ..moveTo(cornerMargin, cornerMargin + cornerSize)
        ..lineTo(cornerMargin, cornerMargin)
        ..lineTo(cornerMargin + cornerSize, cornerMargin),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerMargin - cornerSize, cornerMargin)
        ..lineTo(size.width - cornerMargin, cornerMargin)
        ..lineTo(size.width - cornerMargin, cornerMargin + cornerSize),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawPath(
      Path()
        ..moveTo(cornerMargin, size.height - cornerMargin - cornerSize)
        ..lineTo(cornerMargin, size.height - cornerMargin)
        ..lineTo(cornerMargin + cornerSize, size.height - cornerMargin),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerMargin - cornerSize, size.height - cornerMargin)
        ..lineTo(size.width - cornerMargin, size.height - cornerMargin)
        ..lineTo(size.width - cornerMargin, size.height - cornerMargin - cornerSize),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(GridOverlayPainter oldDelegate) => false;
}