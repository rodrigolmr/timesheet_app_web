import 'dart:typed_data';
import 'dart:math' as math;
import 'package:image/image.dart' as img;

class ImageProcessingService {
  /// Apply perspective transformation to crop and correct document
  static Future<Uint8List> perspectiveTransform({
    required Uint8List imageData,
    required List<Offset> corners,
    required Size imageSize,
  }) async {
    // Decode the image
    final image = img.decodeImage(imageData);
    if (image == null) throw Exception('Failed to decode image');

    // Convert normalized corners to actual pixel coordinates
    final pixelCorners = corners.map((corner) => Offset(
      corner.dx * imageSize.width,
      corner.dy * imageSize.height,
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

    // Simple perspective correction using bilinear interpolation
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        // Map output coordinates to input coordinates
        final u = x / width;
        final v = y / height;

        // Bilinear interpolation of the corners
        final topLeft = pixelCorners[0];
        final topRight = pixelCorners[1];
        final bottomRight = pixelCorners[2];
        final bottomLeft = pixelCorners[3];

        // Interpolate horizontally
        final topX = topLeft.dx + (topRight.dx - topLeft.dx) * u;
        final topY = topLeft.dy + (topRight.dy - topLeft.dy) * u;
        final bottomX = bottomLeft.dx + (bottomRight.dx - bottomLeft.dx) * u;
        final bottomY = bottomLeft.dy + (bottomRight.dy - bottomLeft.dy) * u;

        // Interpolate vertically
        final srcX = topX + (bottomX - topX) * v;
        final srcY = topY + (bottomY - topY) * v;

        // Get pixel from source image
        if (srcX >= 0 && srcX < image.width && srcY >= 0 && srcY < image.height) {
          final pixel = image.getPixel(srcX.round(), srcY.round());
          output.setPixel(x, y, pixel);
        }
      }
    }

    // Encode back to bytes
    return Uint8List.fromList(img.encodeJpg(output, quality: 95));
  }

  /// Apply filters to the image
  static Future<Uint8List> applyFilter({
    required Uint8List imageData,
    required DocumentFilter filter,
  }) async {
    final image = img.decodeImage(imageData);
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
        processed = img.grayscale(image);
        processed = img.adjustColor(processed, contrast: 1.5);
        // Apply threshold
        for (int y = 0; y < processed.height; y++) {
          for (int x = 0; x < processed.width; x++) {
            final pixel = processed.getPixel(x, y);
            final luminance = img.getLuminance(pixel);
            final newColor = luminance > 128 ? img.ColorRgb8(255, 255, 255) : img.ColorRgb8(0, 0, 0);
            processed.setPixel(x, y, newColor);
          }
        }
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

    return Uint8List.fromList(img.encodeJpg(processed, quality: 95));
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