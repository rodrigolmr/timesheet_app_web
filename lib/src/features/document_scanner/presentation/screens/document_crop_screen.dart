import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:go_router/go_router.dart';
import '../../services/image_processing_service.dart' as img_service;
import 'document_filter_screen.dart';
import '../../../../core/widgets/static_loading_indicator.dart';

class DocumentCropScreen extends ConsumerStatefulWidget {
  final Uint8List imageData;

  const DocumentCropScreen({
    super.key,
    required this.imageData,
  });

  @override
  ConsumerState<DocumentCropScreen> createState() => _DocumentCropScreenState();
}

class _DocumentCropScreenState extends ConsumerState<DocumentCropScreen> {
  // Corner positions (normalized 0.0 to 1.0)
  late List<Offset> _corners;
  int? _selectedCornerIndex;
  int? _selectedEdgeIndex;
  bool _showMagnifier = false;
  Offset? _dragStartPosition;
  List<Offset>? _dragStartCorners;
  
  // Image dimensions
  Size? _imageSize;
  Size? _displaySize;
  Offset? _imageOffset;

  @override
  void initState() {
    super.initState();
    // Initialize corners to default rectangle (slightly inset)
    _corners = [
      const Offset(0.1, 0.1),  // Top-left
      const Offset(0.9, 0.1),  // Top-right
      const Offset(0.9, 0.9),  // Bottom-right
      const Offset(0.1, 0.9),  // Bottom-left
    ];
  }

  void _updateCorner(int index, Offset position) {
    setState(() {
      // Convert screen position to normalized coordinates
      if (_displaySize != null && _imageOffset != null) {
        final normalizedX = (position.dx - _imageOffset!.dx) / _displaySize!.width;
        final normalizedY = (position.dy - _imageOffset!.dy) / _displaySize!.height;
        
        // Clamp to valid range
        _corners[index] = Offset(
          normalizedX.clamp(0.0, 1.0),
          normalizedY.clamp(0.0, 1.0),
        );
      }
    });
  }
  
  void _updateEdge(int edgeIndex, Offset position) {
    setState(() {
      if (_displaySize == null || _imageOffset == null || _dragStartCorners == null || _dragStartPosition == null) return;
      
      // Get the two corners of this edge from drag start positions
      final corner1Index = edgeIndex;
      final corner2Index = (edgeIndex + 1) % 4;
      
      final startCorner1 = _dragStartCorners![corner1Index];
      final startCorner2 = _dragStartCorners![corner2Index];
      
      // Convert positions to normalized coordinates
      final normalizedMouseX = (position.dx - _imageOffset!.dx) / _displaySize!.width;
      final normalizedMouseY = (position.dy - _imageOffset!.dy) / _displaySize!.height;
      final normalizedStartX = (_dragStartPosition!.dx - _imageOffset!.dx) / _displaySize!.width;
      final normalizedStartY = (_dragStartPosition!.dy - _imageOffset!.dy) / _displaySize!.height;
      
      // Calculate edge vector and perpendicular from start positions
      final edgeVector = startCorner2 - startCorner1;
      final edgeLength = edgeVector.distance;
      
      if (edgeLength == 0) return;
      
      // Normalize edge vector
      final edgeNormal = Offset(edgeVector.dx / edgeLength, edgeVector.dy / edgeLength);
      // Calculate perpendicular vector (90 degrees)
      final perpVector = Offset(-edgeNormal.dy, edgeNormal.dx);
      
      // Calculate delta movement from drag start
      final deltaX = normalizedMouseX - normalizedStartX;
      final deltaY = normalizedMouseY - normalizedStartY;
      final delta = Offset(deltaX, deltaY);
      
      // Project delta onto perpendicular to get movement distance
      final projectionLength = delta.dx * perpVector.dx + delta.dy * perpVector.dy;
      
      // Calculate movement vector
      final movement = perpVector * projectionLength;
      
      // Update both corners from their start positions
      _corners[corner1Index] = Offset(
        (startCorner1.dx + movement.dx).clamp(0.0, 1.0),
        (startCorner1.dy + movement.dy).clamp(0.0, 1.0),
      );
      _corners[corner2Index] = Offset(
        (startCorner2.dx + movement.dx).clamp(0.0, 1.0),
        (startCorner2.dy + movement.dy).clamp(0.0, 1.0),
      );
    });
  }

  Offset _normalizedToScreen(Offset normalized) {
    if (_displaySize == null || _imageOffset == null) return Offset.zero;
    return Offset(
      normalized.dx * _displaySize!.width + _imageOffset!.dx,
      normalized.dy * _displaySize!.height + _imageOffset!.dy,
    );
  }

  Future<void> _processCrop() async {
    // Show full screen loading overlay
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Container(
          color: Colors.black.withOpacity(0.7),
          child: const Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: StaticLoadingIndicator(
                  message: 'Processing document',
                ),
              ),
            ),
          ),
        ),
      ),
    );

    try {
      // Add a small delay to ensure the loading indicator is visible
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Apply perspective transformation
      final croppedImage = await img_service.ImageProcessingService.perspectiveTransform(
        imageData: widget.imageData,
        corners: _corners.map((offset) => img_service.Offset(offset.dx, offset.dy)).toList(),
        imageSize: img_service.Size(_imageSize!.width, _imageSize!.height),
      );

      if (mounted) {
        // Close loading dialog
        Navigator.of(context).pop();
        
        // Navigate to filter screen using GoRouter immediately
        // The filter screen will show its own loading
        context.push(
          '/document-scanner/filter',
          extra: {'imageData': croppedImage},
        );
      }
    } catch (e) {
      if (mounted) {
        // Close loading dialog
        Navigator.of(context).pop();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error processing document: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Image display
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return FutureBuilder<Size>(
                  future: _getImageSize(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const StaticLoadingIndicator();
                    }

                    _imageSize = snapshot.data!;
                    final imageAspectRatio = _imageSize!.width / _imageSize!.height;
                    final screenAspectRatio = constraints.maxWidth / constraints.maxHeight;

                    double displayWidth, displayHeight;
                    if (imageAspectRatio > screenAspectRatio) {
                      displayWidth = constraints.maxWidth;
                      displayHeight = displayWidth / imageAspectRatio;
                    } else {
                      displayHeight = constraints.maxHeight;
                      displayWidth = displayHeight * imageAspectRatio;
                    }

                    _displaySize = Size(displayWidth, displayHeight);
                    _imageOffset = Offset(
                      (constraints.maxWidth - displayWidth) / 2,
                      (constraints.maxHeight - displayHeight) / 2,
                    );

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Image
                        Image.memory(
                          widget.imageData,
                          fit: BoxFit.contain,
                        ),
                        // Crop overlay
                        CustomPaint(
                          size: Size(constraints.maxWidth, constraints.maxHeight),
                          painter: CropOverlayPainter(
                            corners: _corners.map(_normalizedToScreen).toList(),
                            imageRect: Rect.fromLTWH(
                              _imageOffset!.dx,
                              _imageOffset!.dy,
                              _displaySize!.width,
                              _displaySize!.height,
                            ),
                          ),
                        ),
                        // Edge handles (rendered below corner handles)
                        ..._buildEdgeHandles(),
                        // Corner handles (rendered on top)
                        ..._buildCornerHandles(),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          // Magnifiers for each corner (fixed positions)
          if (_showMagnifier && _selectedCornerIndex != null)
            _buildMagnifier(),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.black87,
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,
          top: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Back button
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: () => context.go('/expenses'),
              tooltip: 'Back',
            ),
            // Reset button
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _corners = [
                    const Offset(0.1, 0.1),
                    const Offset(0.9, 0.1),
                    const Offset(0.9, 0.9),
                    const Offset(0.1, 0.9),
                  ];
                });
              },
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text('Reset', style: TextStyle(color: Colors.white)),
            ),
            // Done button
            ElevatedButton.icon(
              onPressed: _processCrop,
              icon: const Icon(Icons.check),
              label: const Text('Done'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCornerHandles() {
    return List.generate(4, (index) {
      final screenPosition = _normalizedToScreen(_corners[index]);
      return Positioned(
        left: screenPosition.dx - 20,
        top: screenPosition.dy - 20,
        child: GestureDetector(
          onPanStart: (details) {
            setState(() {
              _selectedCornerIndex = index;
              _selectedEdgeIndex = null;
              _showMagnifier = true;
            });
          },
          onPanUpdate: (details) {
            _updateCorner(index, details.globalPosition);
          },
          onPanEnd: (details) {
            setState(() {
              _selectedCornerIndex = null;
              _showMagnifier = false;
            });
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _selectedCornerIndex == index
                  ? Colors.blue
                  : Colors.white,
              border: Border.all(
                color: _selectedCornerIndex == index
                    ? Colors.white
                    : Colors.blue,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _selectedCornerIndex == index
                      ? Colors.white
                      : Colors.blue,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  List<Widget> _buildEdgeHandles() {
    final handles = <Widget>[];
    
    for (int i = 0; i < 4; i++) {
      final start = _corners[i];
      final end = _corners[(i + 1) % 4];
      final startScreen = _normalizedToScreen(start);
      final endScreen = _normalizedToScreen(end);
      
      // Calculate midpoint and angle
      final midPoint = Offset(
        (startScreen.dx + endScreen.dx) / 2,
        (startScreen.dy + endScreen.dy) / 2,
      );
      
      final dx = endScreen.dx - startScreen.dx;
      final dy = endScreen.dy - startScreen.dy;
      final length = math.sqrt(dx * dx + dy * dy);
      final angle = math.atan2(dy, dx);
      
      handles.add(
        Positioned(
          left: midPoint.dx - length / 2,
          top: midPoint.dy - 15, // Adjusted for larger touch area
          child: Transform.rotate(
            angle: angle,
            alignment: Alignment.center,
            child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  _selectedEdgeIndex = i;
                  _selectedCornerIndex = null;
                  _dragStartPosition = details.globalPosition;
                  _dragStartCorners = List<Offset>.from(_corners);
                });
              },
              onPanUpdate: (details) {
                _updateEdge(i, details.globalPosition);
              },
              onPanEnd: (details) {
                setState(() {
                  _selectedEdgeIndex = null;
                  _dragStartPosition = null;
                  _dragStartCorners = null;
                });
              },
              child: Container(
                width: length,
                height: 30, // Increased touch area
                color: Colors.transparent, // Make it invisible but touchable
                child: Center(
                  child: Container(
                    width: length - 40, // Leave space for corners
                    height: 4,
                    decoration: BoxDecoration(
                      color: _selectedEdgeIndex == i
                          ? Colors.blue
                          : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    
    return handles;
  }

  Future<Size> _getImageSize() async {
    final image = await decodeImageFromList(widget.imageData);
    return Size(image.width.toDouble(), image.height.toDouble());
  }

  Widget _buildMagnifier() {
    if (_selectedCornerIndex == null || _displaySize == null || _imageOffset == null) {
      return const SizedBox.shrink();
    }

    // Fixed positions for magnifiers based on which corner is selected
    double left, top;
    switch (_selectedCornerIndex!) {
      case 0: // Top-left corner - show magnifier on the right
        left = MediaQuery.of(context).size.width - 170;
        top = 50;
        break;
      case 1: // Top-right corner - show magnifier on the left
        left = 20;
        top = 50;
        break;
      case 2: // Bottom-right corner - show magnifier on the left
        left = 20;
        top = MediaQuery.of(context).size.height - 250;
        break;
      case 3: // Bottom-left corner - show magnifier on the right
        left = MediaQuery.of(context).size.width - 170;
        top = MediaQuery.of(context).size.height - 250;
        break;
      default:
        return const SizedBox.shrink();
    }

    // Get the actual corner position relative to the image
    final normalizedCorner = _corners[_selectedCornerIndex!];
    final cornerPositionInImage = Offset(
      normalizedCorner.dx * _displaySize!.width,
      normalizedCorner.dy * _displaySize!.height,
    );
    
    final magnifierSize = 150.0;
    final magnifierRadius = magnifierSize / 2;
    final zoomLevel = 3.0;

    return Positioned(
      left: left,
      top: top,
      child: IgnorePointer(
        child: Container(
          width: magnifierSize,
          height: magnifierSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.8),
                blurRadius: 8,
              ),
            ],
          ),
          child: ClipOval(
            child: Stack(
              children: [
                // Magnified content - show the area around the corner
                Positioned(
                  left: magnifierRadius - (cornerPositionInImage.dx * zoomLevel),
                  top: magnifierRadius - (cornerPositionInImage.dy * zoomLevel),
                  child: Transform.scale(
                    scale: zoomLevel,
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      width: _displaySize!.width,
                      height: _displaySize!.height,
                      child: Stack(
                        children: [
                          // The image
                          Image.memory(
                            widget.imageData,
                            fit: BoxFit.fill,
                            width: _displaySize!.width,
                            height: _displaySize!.height,
                          ),
                          // The crop overlay
                          CustomPaint(
                            size: _displaySize!,
                            painter: CropOverlayPainter(
                              corners: _corners.map((c) => Offset(
                                c.dx * _displaySize!.width,
                                c.dy * _displaySize!.height,
                              )).toList(),
                              imageRect: Rect.fromLTWH(
                                0,
                                0,
                                _displaySize!.width,
                                _displaySize!.height,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Crosshair overlay
                Center(
                  child: Container(
                    width: 40,
                    height: 2,
                    color: Colors.red,
                  ),
                ),
                Center(
                  child: Container(
                    width: 2,
                    height: 40,
                    color: Colors.red,
                  ),
                ),
                // Center dot
                Center(
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CropOverlayPainter extends CustomPainter {
  final List<Offset> corners;
  final Rect imageRect;

  CropOverlayPainter({
    required this.corners,
    required this.imageRect,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Create path for the crop area
    final cropPath = Path()
      ..moveTo(corners[0].dx, corners[0].dy)
      ..lineTo(corners[1].dx, corners[1].dy)
      ..lineTo(corners[2].dx, corners[2].dy)
      ..lineTo(corners[3].dx, corners[3].dy)
      ..close();

    // Create path for the entire canvas
    final fullPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Subtract crop area from full canvas to create overlay
    final overlayPath = Path.combine(
      PathOperation.difference,
      fullPath,
      cropPath,
    );

    // Draw the overlay
    canvas.drawPath(overlayPath, paint);

    // Draw crop area border
    final borderPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawPath(cropPath, borderPaint);

    // Draw lines between corners
    final linePaint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int i = 0; i < 4; i++) {
      final start = corners[i];
      final end = corners[(i + 1) % 4];
      canvas.drawLine(start, end, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}