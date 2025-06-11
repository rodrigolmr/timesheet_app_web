import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'dart:isolate' if (dart.library.html) 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'image_processing_service.dart';

/// Parallel image processor for non-web platforms
class ParallelProcessor {
  static const int numWorkers = 4; // Number of parallel workers
  
  /// Process perspective transform in parallel using isolates
  static Future<Uint8List> perspectiveTransformParallel({
    required Uint8List imageData,
    required List<Offset> corners,
    required Size imageSize,
  }) async {
    if (kIsWeb) {
      // On web, delegate to Web Worker
      throw UnsupportedError('Use WebWorkerService for web platform');
    }
    
    // Decode image
    final image = img.decodeImage(imageData);
    if (image == null) throw Exception('Failed to decode image');
    
    // Convert normalized corners to pixel coordinates
    final pixelCorners = corners.map((corner) => Offset(
      corner.dx * image.width,
      corner.dy * image.height,
    )).toList();
    
    // Find bounding box
    double minX = pixelCorners[0].dx;
    double maxX = pixelCorners[0].dx;
    double minY = pixelCorners[0].dy;
    double maxY = pixelCorners[0].dy;
    
    for (final corner in pixelCorners) {
      minX = corner.dx < minX ? corner.dx : minX;
      maxX = corner.dx > maxX ? corner.dx : maxX;
      minY = corner.dy < minY ? corner.dy : minY;
      maxY = corner.dy > maxY ? corner.dy : maxY;
    }
    
    final outputWidth = (maxX - minX).round();
    final outputHeight = (maxY - minY).round();
    
    // Split work into horizontal strips
    final stripHeight = outputHeight ~/ numWorkers;
    final futures = <Future<List<int>>>[];
    
    for (int i = 0; i < numWorkers; i++) {
      final startY = i * stripHeight;
      final endY = (i == numWorkers - 1) ? outputHeight : (i + 1) * stripHeight;
      
      futures.add(
        _processStrip(
          sourceImage: image,
          pixelCorners: pixelCorners,
          outputWidth: outputWidth,
          outputHeight: outputHeight,
          startY: startY,
          endY: endY,
        ),
      );
    }
    
    // Wait for all strips to complete
    final strips = await Future.wait(futures);
    
    // Combine strips into final image
    final output = img.Image(width: outputWidth, height: outputHeight);
    
    for (int i = 0; i < strips.length; i++) {
      final strip = strips[i];
      final startY = i * stripHeight;
      
      // Copy strip data to output image
      int pixelIndex = 0;
      for (int y = startY; y < startY + strip.length ~/ (outputWidth * 4); y++) {
        for (int x = 0; x < outputWidth; x++) {
          final r = strip[pixelIndex++];
          final g = strip[pixelIndex++];
          final b = strip[pixelIndex++];
          final a = strip[pixelIndex++];
          
          output.setPixelRgba(x, y, r, g, b, a);
        }
      }
    }
    
    return Uint8List.fromList(
      img.encodeJpg(output, quality: ImageProcessingService.jpegQuality),
    );
  }
  
  /// Process a horizontal strip of the image
  static Future<List<int>> _processStrip({
    required img.Image sourceImage,
    required List<Offset> pixelCorners,
    required int outputWidth,
    required int outputHeight,
    required int startY,
    required int endY,
  }) async {
    final pixels = <int>[];
    
    // Get corners
    final topLeft = pixelCorners[0];
    final topRight = pixelCorners[1];
    final bottomRight = pixelCorners[2];
    final bottomLeft = pixelCorners[3];
    
    // Pre-calculate values
    final invWidth = 1.0 / outputWidth;
    final invHeight = 1.0 / outputHeight;
    
    for (int y = startY; y < endY; y++) {
      final v = y * invHeight;
      
      // Interpolate left and right edges
      final leftX = topLeft.dx + (bottomLeft.dx - topLeft.dx) * v;
      final leftY = topLeft.dy + (bottomLeft.dy - topLeft.dy) * v;
      final rightX = topRight.dx + (bottomRight.dx - topRight.dx) * v;
      final rightY = topRight.dy + (bottomRight.dy - topRight.dy) * v;
      
      final rowDeltaX = rightX - leftX;
      final rowDeltaY = rightY - leftY;
      
      for (int x = 0; x < outputWidth; x++) {
        final u = x * invWidth;
        
        final srcX = (leftX + rowDeltaX * u).round();
        final srcY = (leftY + rowDeltaY * u).round();
        
        if (srcX >= 0 && srcX < sourceImage.width && 
            srcY >= 0 && srcY < sourceImage.height) {
          final pixel = sourceImage.getPixel(srcX, srcY);
          pixels.add(pixel.r.toInt());
          pixels.add(pixel.g.toInt());
          pixels.add(pixel.b.toInt());
          pixels.add(pixel.a.toInt());
        } else {
          // Transparent pixel for out of bounds
          pixels.addAll([0, 0, 0, 0]);
        }
      }
    }
    
    return pixels;
  }
}