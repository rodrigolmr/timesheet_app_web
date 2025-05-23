import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../data/models/document_scan_model.dart';
import '../providers/scanner_providers.dart';
import 'edge_detection.dart';

class CropScreen extends ConsumerStatefulWidget {
  const CropScreen({super.key});

  @override
  ConsumerState<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends ConsumerState<CropScreen> {
  ui.Image? _image;
  CropCorners? _cropCorners;
  String? _activeDragCorner;
  Size _imageSize = Size.zero;
  Size _displaySize = Size.zero;
  final GlobalKey _containerKey = GlobalKey();
  bool _isLoading = true;
  Offset? _magnifierPosition;
  Offset? _magnifierFocusPoint;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    print('CropScreen: Loading image...');
    
    try {
      final scanState = ref.read(scannerStateProvider);
      final scan = scanState.valueOrNull;
      
      print('CropScreen: Scan data available: ${scan != null}');
      
      if (scan != null && scan.originalImage.isNotEmpty) {
        print('CropScreen: Image size: ${scan.originalImage.length} bytes');
        
        // Detect edges first
        final detectedCorners = await EdgeDetector.detectDocumentEdges(scan.originalImage);
        
        final codec = await ui.instantiateImageCodec(scan.originalImage);
        final frame = await codec.getNextFrame();
        print('CropScreen: Image decoded successfully');
        
        if (mounted) {
          setState(() {
            _image = frame.image;
            _imageSize = Size(
              _image!.width.toDouble(),
              _image!.height.toDouble(),
            );
            _isLoading = false;
          });
          
          // Initialize corners after first frame
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              if (detectedCorners != null) {
                _initializeCropCornersFromDetection(detectedCorners);
              } else {
                _initializeCropCorners();
              }
            }
          });
        }
      } else {
        print('CropScreen: No image data available');
        setState(() => _isLoading = false);
      }
    } catch (e, stack) {
      print('CropScreen: Error loading image: $e');
      print('Stack: $stack');
      setState(() => _isLoading = false);
    }
  }

  void _initializeCropCorners() {
    final renderBox = _containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    
    _displaySize = _calculateImageSize();
    final padding = 40.0;
    
    setState(() {
      _cropCorners = CropCorners(
        topLeft: Point(x: padding, y: padding),
        topRight: Point(x: _displaySize.width - padding, y: padding),
        bottomLeft: Point(x: padding, y: _displaySize.height - padding),
        bottomRight: Point(x: _displaySize.width - padding, y: _displaySize.height - padding),
      );
    });
  }

  void _initializeCropCornersFromDetection(CropCorners detectedCorners) {
    _displaySize = _calculateImageSize();
    
    // Scale detected corners from original image size to display size
    final scaleX = _displaySize.width / _imageSize.width;
    final scaleY = _displaySize.height / _imageSize.height;
    
    setState(() {
      _cropCorners = CropCorners(
        topLeft: Point(
          x: detectedCorners.topLeft.x * scaleX,
          y: detectedCorners.topLeft.y * scaleY,
        ),
        topRight: Point(
          x: detectedCorners.topRight.x * scaleX,
          y: detectedCorners.topRight.y * scaleY,
        ),
        bottomLeft: Point(
          x: detectedCorners.bottomLeft.x * scaleX,
          y: detectedCorners.bottomLeft.y * scaleY,
        ),
        bottomRight: Point(
          x: detectedCorners.bottomRight.x * scaleX,
          y: detectedCorners.bottomRight.y * scaleY,
        ),
      );
    });
    
    print('CropScreen: Initialized corners from edge detection');
  }

  void _handlePanStart(DragStartDetails details, String corner) {
    setState(() {
      _activeDragCorner = corner;
      _updateMagnifierPosition(corner);
    });
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (_activeDragCorner == null) return;

    setState(() {
      final renderBox = _containerKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null) return;

      final localPosition = renderBox.globalToLocal(details.globalPosition);
      
      final newX = localPosition.dx.clamp(0.0, _displaySize.width);
      final newY = localPosition.dy.clamp(0.0, _displaySize.height);
      final newPoint = Point(x: newX, y: newY);

      if (_cropCorners != null) {
        switch (_activeDragCorner) {
          case 'topLeft':
            _cropCorners = _cropCorners!.copyWith(topLeft: newPoint);
            break;
          case 'topRight':
            _cropCorners = _cropCorners!.copyWith(topRight: newPoint);
            break;
          case 'bottomLeft':
            _cropCorners = _cropCorners!.copyWith(bottomLeft: newPoint);
            break;
          case 'bottomRight':
            _cropCorners = _cropCorners!.copyWith(bottomRight: newPoint);
            break;
        }
        _magnifierFocusPoint = Offset(newX, newY);
      }
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    setState(() {
      _activeDragCorner = null;
      _magnifierPosition = null;
      _magnifierFocusPoint = null;
    });
  }

  void _updateMagnifierPosition(String corner) {
    final screenSize = MediaQuery.of(context).size;
    final containerRect = _containerKey.currentContext?.findRenderObject() as RenderBox?;
    
    if (containerRect == null) return;
    
    // Position magnifier based on corner being dragged
    // Place it on the opposite side to avoid obstruction
    switch (corner) {
      case 'topLeft':
        _magnifierPosition = Offset(screenSize.width - 140, 20);
        break;
      case 'topRight':
        _magnifierPosition = Offset(20, 20);
        break;
      case 'bottomLeft':
        _magnifierPosition = Offset(screenSize.width - 140, screenSize.height - 180);
        break;
      case 'bottomRight':
        _magnifierPosition = Offset(20, screenSize.height - 180);
        break;
    }
  }

  Future<void> _applyCrop() async {
    if (_cropCorners != null && _image != null) {
      // Convert display coordinates to image coordinates
      final scaleX = _imageSize.width / _displaySize.width;
      final scaleY = _imageSize.height / _displaySize.height;
      
      final imageCropCorners = CropCorners(
        topLeft: Point(
          x: _cropCorners!.topLeft.x * scaleX,
          y: _cropCorners!.topLeft.y * scaleY,
        ),
        topRight: Point(
          x: _cropCorners!.topRight.x * scaleX,
          y: _cropCorners!.topRight.y * scaleY,
        ),
        bottomLeft: Point(
          x: _cropCorners!.bottomLeft.x * scaleX,
          y: _cropCorners!.bottomLeft.y * scaleY,
        ),
        bottomRight: Point(
          x: _cropCorners!.bottomRight.x * scaleX,
          y: _cropCorners!.bottomRight.y * scaleY,
        ),
      );
      
      print('Display corners: $_cropCorners');
      print('Image corners: $imageCropCorners');
      print('Scale factors: X=$scaleX, Y=$scaleY');
      
      ref.read(scannerStateProvider.notifier).setCropCorners(imageCropCorners);
      ref.read(currentScannerStepProvider.notifier).nextStep();
    }
  }

  void _cancelCrop() {
    ref.read(currentScannerStepProvider.notifier).previousStep();
  }

  void _resetToDefaultCorners() {
    _initializeCropCorners();
  }

  @override
  Widget build(BuildContext context) {
    print('CropScreen build: _image = ${_image != null}, _isLoading = $_isLoading');
    
    if (_isLoading || _image == null) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                'Loading image...',
                style: context.textStyles.body.copyWith(color: Colors.white),
              ),
              if (!_isLoading && _image == null) ...[
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _cancelCrop(),
                  child: const Text('Back'),
                ),
              ],
            ],
          ),
        ),
      );
    }

    // Calculate display size if not yet calculated
    if (_displaySize == Size.zero) {
      _displaySize = _calculateImageSize();
    }

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.black,
                child: Center(
                  child: Container(
                    key: _containerKey,
                    width: _displaySize.width,
                    height: _displaySize.height,
                    child: Stack(
                      children: [
                        CustomPaint(
                          size: _displaySize,
                          painter: _cropCorners != null
                              ? CropPainter(
                                  image: _image!,
                                  cropCorners: _cropCorners!,
                                )
                              : null,
                        ),
                        ..._buildCornerHandles(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
          padding: const EdgeInsets.all(20),
          color: Colors.black87,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Adjust the corners to match document edges',
                style: context.textStyles.caption.copyWith(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildControlButton(
                    onPressed: _cancelCrop,
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  _buildControlButton(
                    onPressed: () => _resetToDefaultCorners(),
                    child: Text(
                      'Reset',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  _buildControlButton(
                    onPressed: _applyCrop,
                    isPrimary: true,
                    child: Text(
                      'Crop',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
          ],
        ),
        if (_magnifierPosition != null && _magnifierFocusPoint != null && _image != null)
          Positioned(
            left: _magnifierPosition!.dx,
            top: _magnifierPosition!.dy,
            child: _buildMagnifier(),
          ),
      ],
    );
  }

  Size _calculateImageSize() {
    if (_imageSize.width == 0 || _imageSize.height == 0) {
      return Size.zero;
    }
    
    final screenSize = MediaQuery.of(context).size;
    final maxWidth = screenSize.width;
    final maxHeight = screenSize.height - 200; // Account for controls
    
    final scale = (_imageSize.width / _imageSize.height) > (maxWidth / maxHeight)
        ? maxWidth / _imageSize.width
        : maxHeight / _imageSize.height;
    
    return Size(
      _imageSize.width * scale,
      _imageSize.height * scale,
    );
  }

  List<Widget> _buildCornerHandles() {
    if (_cropCorners == null) return [];
    
    final corners = {
      'topLeft': _cropCorners!.topLeft,
      'topRight': _cropCorners!.topRight,
      'bottomLeft': _cropCorners!.bottomLeft,
      'bottomRight': _cropCorners!.bottomRight,
    };

    return corners.entries.map((entry) {
      return Positioned(
        left: entry.value.x - 15,
        top: entry.value.y - 15,
        child: GestureDetector(
          onPanStart: (details) => _handlePanStart(details, entry.key),
          onPanUpdate: _handlePanUpdate,
          onPanEnd: _handlePanEnd,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF4CAF50),
                width: 3,
              ),
              borderRadius: _getCornerRadius(entry.key),
            ),
            child: Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  BorderRadius _getCornerRadius(String corner) {
    const radius = Radius.circular(3);
    switch (corner) {
      case 'topLeft':
        return const BorderRadius.only(topLeft: radius);
      case 'topRight':
        return const BorderRadius.only(topRight: radius);
      case 'bottomLeft':
        return const BorderRadius.only(bottomLeft: radius);
      case 'bottomRight':
        return const BorderRadius.only(bottomRight: radius);
      default:
        return BorderRadius.zero;
    }
  }

  Widget _buildMagnifier() {
    const magnifierSize = 120.0;
    const magnification = 2.0; // Reduced from 3.0 to show more area
    
    return Container(
      width: magnifierSize,
      height: magnifierSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipOval(
        child: CustomPaint(
          size: const Size(magnifierSize, magnifierSize),
          painter: MagnifierPainter(
            image: _image!,
            focusPoint: _magnifierFocusPoint!,
            imageSize: _displaySize,
            magnification: magnification,
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required VoidCallback onPressed,
    required Widget child,
    bool isPrimary = false,
  }) {
    return Material(
      color: isPrimary ? const Color(0xFF4CAF50) : Colors.white,
      borderRadius: BorderRadius.circular(25),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          child: DefaultTextStyle(
            style: TextStyle(
              color: isPrimary ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class CropPainter extends CustomPainter {
  final ui.Image image;
  final CropCorners cropCorners;

  CropPainter({
    required this.image,
    required this.cropCorners,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..filterQuality = FilterQuality.high;
    
    // Draw image
    final src = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final dst = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawImageRect(image, src, dst, paint);
    
    // Draw darkened overlay
    final overlayPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    
    final cropPath = Path()
      ..moveTo(cropCorners.topLeft.x, cropCorners.topLeft.y)
      ..lineTo(cropCorners.topRight.x, cropCorners.topRight.y)
      ..lineTo(cropCorners.bottomRight.x, cropCorners.bottomRight.y)
      ..lineTo(cropCorners.bottomLeft.x, cropCorners.bottomLeft.y)
      ..close();
    
    final differencePath = Path.combine(
      PathOperation.difference,
      overlayPath,
      cropPath,
    );
    
    canvas.drawPath(
      differencePath,
      Paint()..color = Colors.black.withOpacity(0.5),
    );
    
    // Draw crop lines
    canvas.drawPath(
      cropPath,
      Paint()
        ..color = const Color(0xFF4CAF50)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(CropPainter oldDelegate) {
    return oldDelegate.cropCorners != cropCorners;
  }
}

class MagnifierPainter extends CustomPainter {
  final ui.Image image;
  final Offset focusPoint;
  final Size imageSize;
  final double magnification;

  MagnifierPainter({
    required this.image,
    required this.focusPoint,
    required this.imageSize,
    required this.magnification,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..filterQuality = FilterQuality.high;
    
    // Calculate source rectangle based on focus point
    final srcSize = Size(
      size.width / magnification,
      size.height / magnification,
    );
    
    // Convert display coordinates to image coordinates
    final scaleX = image.width / imageSize.width;
    final scaleY = image.height / imageSize.height;
    
    final srcX = (focusPoint.dx * scaleX - srcSize.width / 2).clamp(0.0, image.width - srcSize.width);
    final srcY = (focusPoint.dy * scaleY - srcSize.height / 2).clamp(0.0, image.height - srcSize.height);
    
    final srcRect = Rect.fromLTWH(srcX, srcY, srcSize.width, srcSize.height);
    final dstRect = Rect.fromLTWH(0, 0, size.width, size.height);
    
    // Draw magnified portion
    canvas.drawImageRect(image, srcRect, dstRect, paint);
    
    // Draw crosshair
    final crosshairPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    // Horizontal line
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      crosshairPaint,
    );
    
    // Vertical line
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      crosshairPaint,
    );
    
    // Center circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      3,
      crosshairPaint..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(MagnifierPainter oldDelegate) {
    return oldDelegate.focusPoint != focusPoint;
  }
}