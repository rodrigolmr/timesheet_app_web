import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import '../../../../core/theme/theme_extensions.dart';
import '../../data/models/document_scan_model.dart';
import '../providers/scanner_providers.dart';
import 'dart:html' as html;
import 'perspective_transform.dart';

class FilterScreen extends ConsumerStatefulWidget {
  const FilterScreen({super.key});

  @override
  ConsumerState<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends ConsumerState<FilterScreen> {
  ui.Image? _processedImage;
  img.Image? _workingImage;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadAndProcessImage();
  }

  Future<void> _loadAndProcessImage() async {
    setState(() => _isProcessing = true);
    
    final scanState = ref.read(scannerStateProvider);
    await scanState.whenData((scan) async {
      if (scan != null) {
        if (scan.cropCorners != null) {
          // Apply perspective transform
          print('FilterScreen: Applying perspective transform...');
          final transformedData = await PerspectiveTransform.warpPerspective(
            scan.originalImage,
            scan.cropCorners!,
          );
          
          if (transformedData != null) {
            _workingImage = img.decodeImage(transformedData);
            print('FilterScreen: Perspective transform complete');
          } else {
            print('FilterScreen: Perspective transform failed, using simple crop');
            _workingImage = img.decodeImage(scan.originalImage);
            if (_workingImage != null) {
              _workingImage = _applyCropToImage(_workingImage!, scan.cropCorners!);
            }
          }
        } else {
          // No crop, use original image
          _workingImage = img.decodeImage(scan.originalImage);
        }
        
        // Apply current filter
        await _applyFilter(ref.read(activeFilterProvider));
      }
    });
  }

  img.Image _applyCropToImage(img.Image source, CropCorners corners) {
    // Note: The corners are already in image coordinates from the crop screen
    // They were scaled from display to image coordinates before being saved
    
    final minX = [corners.topLeft.x, corners.bottomLeft.x].reduce((a, b) => a < b ? a : b).toInt();
    final maxX = [corners.topRight.x, corners.bottomRight.x].reduce((a, b) => a > b ? a : b).toInt();
    final minY = [corners.topLeft.y, corners.topRight.y].reduce((a, b) => a < b ? a : b).toInt();
    final maxY = [corners.bottomLeft.y, corners.bottomRight.y].reduce((a, b) => a > b ? a : b).toInt();
    
    // Ensure we don't exceed image bounds
    final cropX = minX.clamp(0, source.width - 1);
    final cropY = minY.clamp(0, source.height - 1);
    final cropWidth = (maxX - minX).clamp(1, source.width - cropX);
    final cropHeight = (maxY - minY).clamp(1, source.height - cropY);
    
    print('Crop coordinates: x=$cropX, y=$cropY, width=$cropWidth, height=$cropHeight');
    print('Source image size: ${source.width}x${source.height}');
    
    return img.copyCrop(
      source,
      x: cropX,
      y: cropY,
      width: cropWidth,
      height: cropHeight,
    );
  }

  Future<void> _applyFilter(FilterType filter) async {
    if (_workingImage == null) return;
    
    setState(() => _isProcessing = true);
    ref.read(activeFilterProvider.notifier).setFilter(filter);
    
    img.Image processed = img.Image.from(_workingImage!);
    
    switch (filter) {
      case FilterType.original:
        // No processing needed - keep original colors
        break;
        
      case FilterType.enhance:
        // General enhancement for better visibility
        processed = img.adjustColor(
          processed,
          contrast: 1.2,
          brightness: 1.05,
          saturation: 1.1,
        );
        // Slight sharpening
        processed = img.convolution(
          processed,
          filter: [0, -1, 0, -1, 5, -1, 0, -1, 0],
          div: 1,
        );
        break;
        
      case FilterType.blackWhite:
        // Simple black and white conversion
        processed = img.grayscale(processed);
        processed = img.adjustColor(
          processed,
          contrast: 1.3,
        );
        break;
        
      case FilterType.document:
        // Optimized for documents - high contrast B&W
        processed = img.grayscale(processed);
        processed = img.adjustColor(
          processed,
          contrast: 1.8,
          brightness: 1.1,
        );
        
        // Use imagem library's built-in threshold for better performance
        // This is much faster than pixel-by-pixel processing
        processed = img.luminanceThreshold(processed, threshold: 128);
        break;
    }
    
    // Convert to Flutter image
    final codec = await ui.instantiateImageCodec(
      Uint8List.fromList(img.encodePng(processed)),
    );
    final frame = await codec.getNextFrame();
    
    if (mounted) {
      setState(() {
        _processedImage = frame.image;
        _isProcessing = false;
      });
      
      // Update state with processed image
      ref.read(scannerStateProvider.notifier).setProcessedImage(
        Uint8List.fromList(img.encodePng(processed)),
        filter,
      );
    }
  }

  Future<void> _saveImage() async {
    final scanState = ref.read(scannerStateProvider);
    scanState.whenData((scan) {
      if (scan?.processedImage != null) {
        final blob = html.Blob([scan!.processedImage!]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement()
          ..href = url
          ..download = 'scan_${DateTime.now().millisecondsSinceEpoch}.jpg'
          ..click();
        html.Url.revokeObjectUrl(url);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image saved successfully!'),
            backgroundColor: context.colors.success,
          ),
        );
        
        // Reset scanner after save
        Future.delayed(const Duration(seconds: 1), () {
          ref.read(scannerStateProvider.notifier).reset();
          ref.read(currentScannerStepProvider.notifier).goToStep(ScannerStep.capture);
        });
      }
    });
  }

  void _goBack() {
    ref.read(currentScannerStepProvider.notifier).previousStep();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.black,
            child: Center(
              child: _isProcessing
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : _processedImage != null
                      ? CustomPaint(
                          size: _calculateImageSize(),
                          painter: ImagePainter(image: _processedImage!),
                        )
                      : const SizedBox(),
            ),
          ),
        ),
        Container(
          color: Colors.black87,
          child: Column(
            children: [
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  children: [
                    FilterType.document,
                    FilterType.enhance,
                    FilterType.blackWhite,
                    FilterType.original,
                  ].map((filter) {
                    final isActive = ref.watch(activeFilterProvider) == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: _buildFilterButton(
                        label: _getFilterLabel(filter),
                        isActive: isActive,
                        onTap: () => _applyFilter(filter),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildControlButton(
                      onPressed: _goBack,
                      child: Text(
                        'Back',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    _buildControlButton(
                      onPressed: _saveImage,
                      isPrimary: true,
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getFilterLabel(FilterType filter) {
    switch (filter) {
      case FilterType.document:
        return 'Document';
      case FilterType.enhance:
        return 'Enhance';
      case FilterType.blackWhite:
        return 'B&W';
      case FilterType.original:
        return 'Original';
    }
  }
  

  Widget _buildFilterButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.grey[800] : Colors.grey[900],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? const Color(0xFF4CAF50) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
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

  Size _calculateImageSize() {
    if (_processedImage == null) return Size.zero;
    
    final screenSize = MediaQuery.of(context).size;
    final maxWidth = screenSize.width * 0.9;
    final maxHeight = screenSize.height * 0.6;
    
    final imageWidth = _processedImage!.width.toDouble();
    final imageHeight = _processedImage!.height.toDouble();
    
    final scale = (imageWidth / imageHeight) > (maxWidth / maxHeight)
        ? maxWidth / imageWidth
        : maxHeight / imageHeight;
    
    return Size(
      imageWidth * scale,
      imageHeight * scale,
    );
  }
}

class ImagePainter extends CustomPainter {
  final ui.Image image;

  ImagePainter({required this.image});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..filterQuality = FilterQuality.high;
    final src = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final dst = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawImageRect(image, src, dst, paint);
  }

  @override
  bool shouldRepaint(ImagePainter oldDelegate) => false;
}