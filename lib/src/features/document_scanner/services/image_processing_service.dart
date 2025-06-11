import 'dart:typed_data';
import 'dart:math' as math;
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'web_worker_service.dart'
    if (dart.library.html) 'web_worker_service.dart'
    if (dart.library.io) 'web_worker_service_stub.dart';
import 'image_cache_service.dart';

class ImageProcessingService {
  static const int maxDimension = 2048;
  static const int jpegQuality = 85;
  static const bool skipOptimization = true; // Skip resize for max performance
  
  /// Optimize image before processing to improve performance
  static Future<Uint8List> _optimizeImage(Uint8List imageData) async {
    final image = ImageCacheService.instance.getImage(imageData);
    if (image == null) throw Exception('Failed to decode image');
    
    // Check if resizing is needed
    if (image.width > maxDimension || image.height > maxDimension) {
      // Calculate new dimensions maintaining aspect ratio
      double scale = 1.0;
      if (image.width > image.height) {
        scale = maxDimension / image.width;
      } else {
        scale = maxDimension / image.height;
      }
      
      final newWidth = (image.width * scale).round();
      final newHeight = (image.height * scale).round();
      
      // Resize using high-quality interpolation
      final resized = img.copyResize(
        image,
        width: newWidth,
        height: newHeight,
        interpolation: img.Interpolation.cubic,
      );
      
      return Uint8List.fromList(img.encodeJpg(resized, quality: jpegQuality));
    }
    
    // If no resize needed, just re-encode with optimal quality
    return Uint8List.fromList(img.encodeJpg(image, quality: jpegQuality));
  }
  
  /// Apply perspective transformation to crop and correct document
  static Future<Uint8List> perspectiveTransform({
    required Uint8List imageData,
    required List<Offset> corners,
    required Size imageSize,
  }) async {
    // Try to use Web Worker first if on web
    if (kIsWeb) {
      try {
        final cornersData = corners.map((c) => {'dx': c.dx, 'dy': c.dy}).toList();
        final imageSizeData = {'width': imageSize.width, 'height': imageSize.height};
        
        return await WebWorkerService.instance.perspectiveTransform(
          imageData: imageData,
          corners: cornersData,
          imageSize: imageSizeData,
        );
      } catch (e) {
        print('Web Worker failed for perspective transform, falling back: $e');
        // Fall through to main thread processing
      }
    }
    
    // Use cached image if available
    final image = ImageCacheService.instance.getImage(imageData);
    if (image == null) throw Exception('Failed to decode image');
    
    // Convert normalized corners to actual pixel coordinates
    final pixelCorners = corners.map((corner) => Offset(
      corner.dx * image.width,
      corner.dy * image.height,
    )).toList();

    // Find the bounding box
    double minX = pixelCorners[0].dx;
    double maxX = pixelCorners[0].dx;
    double minY = pixelCorners[0].dy;
    double maxY = pixelCorners[0].dy;

    for (final corner in pixelCorners) {
      minX = math.min(minX, corner.dx);
      maxX = math.max(maxX, corner.dx);
      minY = math.min(minY, corner.dy);
      maxY = math.max(maxY, corner.dy);
    }

    // Calculate output dimensions
    final width = (maxX - minX).round();
    final height = (maxY - minY).round();

    // Create output image
    final output = img.Image(width: width, height: height);

    // Pre-calculate corner references for better performance
    final topLeft = pixelCorners[0];
    final topRight = pixelCorners[1];
    final bottomRight = pixelCorners[2];
    final bottomLeft = pixelCorners[3];
    
    // Pre-calculate more values for performance
    final invWidth = 1.0 / width;
    final invHeight = 1.0 / height;
    
    // Get direct access to buffers when possible
    final srcWidth = image.width;
    final srcHeight = image.height;
    
    // Process in larger chunks for better cache performance
    const chunkSize = 128;
    
    for (int yChunk = 0; yChunk < height; yChunk += chunkSize) {
      final yEnd = math.min(yChunk + chunkSize, height);
      
      for (int xChunk = 0; xChunk < width; xChunk += chunkSize) {
        final xEnd = math.min(xChunk + chunkSize, width);
        
        // Process chunk
        for (int y = yChunk; y < yEnd; y++) {
          final v = y * invHeight;
          
          // Pre-calculate vertical interpolation for this row
          final leftX = topLeft.dx + (bottomLeft.dx - topLeft.dx) * v;
          final leftY = topLeft.dy + (bottomLeft.dy - topLeft.dy) * v;
          final rightX = topRight.dx + (bottomRight.dx - topRight.dx) * v;
          final rightY = topRight.dy + (bottomRight.dy - topRight.dy) * v;
          
          final rowDeltaX = rightX - leftX;
          final rowDeltaY = rightY - leftY;
          
          // Check if entire row is within bounds for faster processing
          final minRowX = math.min(leftX, rightX);
          final maxRowX = math.max(leftX, rightX);
          final minRowY = math.min(leftY, rightY);
          final maxRowY = math.max(leftY, rightY);
          
          if (minRowX >= 0 && maxRowX < srcWidth && minRowY >= 0 && maxRowY < srcHeight) {
            // Fast path: no bounds checking needed for individual pixels
            for (int x = xChunk; x < xEnd; x++) {
              final u = x * invWidth;
              final srcX = (leftX + rowDeltaX * u).round();
              final srcY = (leftY + rowDeltaY * u).round();
              final pixel = image.getPixel(srcX, srcY);
              output.setPixel(x, y, pixel);
            }
          } else {
            // Slow path: need bounds checking
            for (int x = xChunk; x < xEnd; x++) {
              final u = x * invWidth;
              final srcX = leftX + rowDeltaX * u;
              final srcY = leftY + rowDeltaY * u;
              
              if (srcX >= 0 && srcX < srcWidth && srcY >= 0 && srcY < srcHeight) {
                final pixel = image.getPixel(srcX.round(), srcY.round());
                output.setPixel(x, y, pixel);
              }
            }
          }
        }
      }
    }

    // Encode back to bytes with optimized quality
    return Uint8List.fromList(img.encodeJpg(output, quality: jpegQuality));
  }

  /// Apply filters to the image
  static Future<Uint8List> applyFilter({
    required Uint8List imageData,
    required DocumentFilter filter,
  }) async {
    // Try to use Web Worker first if on web
    if (kIsWeb && filter != DocumentFilter.original) {
      try {
        return await WebWorkerService.instance.applyFilter(
          imageData: imageData,
          filter: filter.name,
        );
      } catch (e) {
        print('Web Worker failed, falling back to main thread: $e');
        // Fall through to main thread processing
      }
    }
    final image = ImageCacheService.instance.getImage(imageData);
    if (image == null) throw Exception('Failed to decode image');

    img.Image processed;

    switch (filter) {
      case DocumentFilter.original:
        processed = image;
        break;
      
      case DocumentFilter.grayscale:
        processed = img.grayscale(image);
        break;
      
      case DocumentFilter.blackAndWhite:
        // Convert to grayscale and increase contrast
        processed = img.grayscale(image);
        processed = img.adjustColor(processed, contrast: 1.5);
        
        // Apply threshold using built-in function for better performance
        processed = img.luminanceThreshold(processed, threshold: 0.5);
        break;
      
      case DocumentFilter.enhanced:
        processed = img.adjustColor(image, contrast: 1.2, brightness: 1.1);
        break;
      
      case DocumentFilter.document:
        // Specialized filter for documents - high contrast, slight brightness, reduced saturation
        processed = img.adjustColor(image, contrast: 1.4, brightness: 1.15, saturation: 0.7);
        
        // Apply slight gamma correction to improve readability
        processed = img.gamma(processed, gamma: 1.2);
        
        // Normalize to improve contrast
        processed = img.normalize(processed, min: 10, max: 245);
        break;
    }

    return Uint8List.fromList(img.encodeJpg(processed, quality: jpegQuality));
  }
}

enum DocumentFilter {
  original,
  grayscale,
  blackAndWhite,
  enhanced,
  document,
}

class Offset {
  final double dx;
  final double dy;

  const Offset(this.dx, this.dy);
}

class Size {
  final double width;
  final double height;

  const Size(this.width, this.height);
}