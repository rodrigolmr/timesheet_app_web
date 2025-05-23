import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:image/image.dart' as img;
import '../../data/models/document_scan_model.dart';

class PerspectiveTransform {
  static Future<Uint8List?> warpPerspective(
    Uint8List imageData,
    CropCorners corners,
  ) async {
    try {
      print('PerspectiveTransform: Starting perspective correction...');
      
      // Decode the image
      final sourceImage = img.decodeImage(imageData);
      if (sourceImage == null) return null;
      
      // Calculate output dimensions based on the corners
      final width = _calculateDistance(corners.topLeft, corners.topRight);
      final height = _calculateDistance(corners.topLeft, corners.bottomLeft);
      
      print('Output dimensions: ${width.round()}x${height.round()}');
      
      // Create destination points (perfect rectangle)
      final dstPoints = [
        [0.0, 0.0],
        [width, 0.0],
        [width, height],
        [0.0, height],
      ];
      
      // Source points from corners
      final srcPoints = [
        [corners.topLeft.x, corners.topLeft.y],
        [corners.topRight.x, corners.topRight.y],
        [corners.bottomRight.x, corners.bottomRight.y],
        [corners.bottomLeft.x, corners.bottomLeft.y],
      ];
      
      // Calculate perspective transform matrix (from destination to source)
      // We need the inverse transform, so we swap src and dst
      final matrix = _getPerspectiveTransform(dstPoints, srcPoints);
      
      // Create output image
      final outputImage = img.Image(
        width: width.round(),
        height: height.round(),
      );
      
      // Apply perspective transform
      for (int y = 0; y < outputImage.height; y++) {
        for (int x = 0; x < outputImage.width; x++) {
          // Transform destination point to source using the inverse matrix
          final w = matrix[6] * x + matrix[7] * y + matrix[8];
          final srcX = (matrix[0] * x + matrix[1] * y + matrix[2]) / w;
          final srcY = (matrix[3] * x + matrix[4] * y + matrix[5]) / w;
          
          if (srcX >= 0 && 
              srcX < sourceImage.width - 1 && 
              srcY >= 0 && 
              srcY < sourceImage.height - 1) {
            
            // Bilinear interpolation para qualidade
            final color = _bilinearInterpolate(
              sourceImage,
              srcX,
              srcY,
            );
            
            outputImage.setPixel(x, y, color);
          }
        }
      }
      
      print('PerspectiveTransform: Transform complete');
      
      // Encode back to bytes
      return Uint8List.fromList(img.encodePng(outputImage));
    } catch (e) {
      print('PerspectiveTransform: Error - $e');
      return null;
    }
  }
  
  static double _calculateDistance(Point p1, Point p2) {
    final dx = p2.x - p1.x;
    final dy = p2.y - p1.y;
    return math.sqrt(dx * dx + dy * dy);
  }
  
  static List<double> _getPerspectiveTransform(
    List<List<double>> src,
    List<List<double>> dst,
  ) {
    // Create matrices for solving the perspective transform
    // Using the DLT (Direct Linear Transform) algorithm
    
    final A = List.generate(8, (i) => List.filled(8, 0.0));
    final B = List.filled(8, 0.0);
    
    for (int i = 0; i < 4; i++) {
      final srcX = src[i][0];
      final srcY = src[i][1];
      final dstX = dst[i][0];
      final dstY = dst[i][1];
      
      A[i * 2][0] = srcX;
      A[i * 2][1] = srcY;
      A[i * 2][2] = 1;
      A[i * 2][3] = 0;
      A[i * 2][4] = 0;
      A[i * 2][5] = 0;
      A[i * 2][6] = -srcX * dstX;
      A[i * 2][7] = -srcY * dstX;
      B[i * 2] = dstX;
      
      A[i * 2 + 1][0] = 0;
      A[i * 2 + 1][1] = 0;
      A[i * 2 + 1][2] = 0;
      A[i * 2 + 1][3] = srcX;
      A[i * 2 + 1][4] = srcY;
      A[i * 2 + 1][5] = 1;
      A[i * 2 + 1][6] = -srcX * dstY;
      A[i * 2 + 1][7] = -srcY * dstY;
      B[i * 2 + 1] = dstY;
    }
    
    // Solve the system using Gaussian elimination
    final h = _gaussianElimination(A, B);
    
    // Return 3x3 matrix as list
    return [...h, 1.0];
  }
  
  static List<double> _gaussianElimination(
    List<List<double>> A,
    List<double> B,
  ) {
    final n = A.length;
    
    // Forward elimination
    for (int i = 0; i < n; i++) {
      // Find pivot
      int maxRow = i;
      for (int k = i + 1; k < n; k++) {
        if (A[k][i].abs() > A[maxRow][i].abs()) {
          maxRow = k;
        }
      }
      
      // Swap rows
      final tempRow = A[i];
      A[i] = A[maxRow];
      A[maxRow] = tempRow;
      
      final tempB = B[i];
      B[i] = B[maxRow];
      B[maxRow] = tempB;
      
      // Make all rows below this one 0 in current column
      for (int k = i + 1; k < n; k++) {
        final c = A[k][i] / A[i][i];
        for (int j = i; j < n; j++) {
          if (i == j) {
            A[k][j] = 0;
          } else {
            A[k][j] -= c * A[i][j];
          }
        }
        B[k] -= c * B[i];
      }
    }
    
    // Back substitution
    final x = List.filled(n, 0.0);
    for (int i = n - 1; i >= 0; i--) {
      x[i] = B[i] / A[i][i];
      for (int k = i - 1; k >= 0; k--) {
        B[k] -= A[k][i] * x[i];
      }
    }
    
    return x;
  }
  
  static img.ColorInt32 _bilinearInterpolate(
    img.Image image,
    double x,
    double y,
  ) {
    final x0 = x.floor();
    final x1 = x0 + 1;
    final y0 = y.floor();
    final y1 = y0 + 1;
    
    final fx = x - x0;
    final fy = y - y0;
    
    final p00 = image.getPixel(x0, y0);
    final p10 = image.getPixel(x1.clamp(0, image.width - 1), y0);
    final p01 = image.getPixel(x0, y1.clamp(0, image.height - 1));
    final p11 = image.getPixel(
      x1.clamp(0, image.width - 1),
      y1.clamp(0, image.height - 1),
    );
    
    // Interpolate each channel
    final r = _interpolateChannel(
      p00.r.toDouble(),
      p10.r.toDouble(),
      p01.r.toDouble(),
      p11.r.toDouble(),
      fx,
      fy,
    );
    
    final g = _interpolateChannel(
      p00.g.toDouble(),
      p10.g.toDouble(),
      p01.g.toDouble(),
      p11.g.toDouble(),
      fx,
      fy,
    );
    
    final b = _interpolateChannel(
      p00.b.toDouble(),
      p10.b.toDouble(),
      p01.b.toDouble(),
      p11.b.toDouble(),
      fx,
      fy,
    );
    
    return img.ColorInt32.rgba(r.round(), g.round(), b.round(), 255);
  }
  
  static double _interpolateChannel(
    double p00,
    double p10,
    double p01,
    double p11,
    double fx,
    double fy,
  ) {
    final p0 = p00 * (1 - fx) + p10 * fx;
    final p1 = p01 * (1 - fx) + p11 * fx;
    return p0 * (1 - fy) + p1 * fy;
  }
}