import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:math' as math;
import '../../data/models/document_scan_model.dart';

class EdgeDetector {
  static Future<CropCorners?> detectDocumentEdges(Uint8List imageData) async {
    try {
      print('EdgeDetector: Starting edge detection...');
      
      // Create an image element
      final img = html.ImageElement();
      final blob = html.Blob([imageData]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      
      img.src = url;
      await img.onLoad.first;
      
      // Reduzir resolução para processamento mais rápido
      // Considerar que smartphones geralmente estão em modo retrato
      const maxProcessingSize = 800;
      int processWidth = img.width!;
      int processHeight = img.height!;
      double scale = 1.0;
      
      // Usar a maior dimensão para calcular o scale
      if (processWidth > maxProcessingSize || processHeight > maxProcessingSize) {
        scale = maxProcessingSize / math.max(processWidth, processHeight);
        processWidth = (processWidth * scale).round();
        processHeight = (processHeight * scale).round();
      }
      
      // Create canvas for processing com tamanho reduzido
      final canvas = html.CanvasElement(
        width: processWidth,
        height: processHeight,
      );
      final ctx = canvas.context2D;
      
      // Draw image to canvas com tamanho reduzido
      ctx.drawImageScaled(img, 0, 0, processWidth, processHeight);
      
      // Get image data
      final imageDataObj = ctx.getImageData(0, 0, processWidth, processHeight);
      final pixels = imageDataObj.data;
      
      // Convert to grayscale
      final grayscale = _convertToGrayscale(pixels, processWidth, processHeight);
      
      // Apply simplified edge detection
      final edges = _detectEdgesSimplified(grayscale, processWidth, processHeight);
      
      // Find corners
      var corners = _findDocumentCorners(edges, processWidth, processHeight);
      
      // Escalar corners de volta para dimensões originais
      if (corners != null && scale < 1.0) {
        corners = CropCorners(
          topLeft: Point(x: corners.topLeft.x / scale, y: corners.topLeft.y / scale),
          topRight: Point(x: corners.topRight.x / scale, y: corners.topRight.y / scale),
          bottomLeft: Point(x: corners.bottomLeft.x / scale, y: corners.bottomLeft.y / scale),
          bottomRight: Point(x: corners.bottomRight.x / scale, y: corners.bottomRight.y / scale),
        );
      }
      
      // Clean up
      html.Url.revokeObjectUrl(url);
      
      print('EdgeDetector: Detection complete, corners: $corners');
      return corners;
    } catch (e) {
      print('EdgeDetector: Error - $e');
      return null;
    }
  }
  
  static Uint8List _convertToGrayscale(List<int> pixels, int width, int height) {
    final grayscale = Uint8List(width * height);
    
    for (int i = 0; i < pixels.length; i += 4) {
      final r = pixels[i];
      final g = pixels[i + 1];
      final b = pixels[i + 2];
      
      // Convert to grayscale using luminance formula
      final gray = (0.299 * r + 0.587 * g + 0.114 * b).round();
      grayscale[i ~/ 4] = gray;
    }
    
    return grayscale;
  }
  
  static Uint8List _detectEdgesSimplified(Uint8List grayscale, int width, int height) {
    final edges = Uint8List(width * height);
    
    // Detecção de bordas otimizada com Sobel simplificado
    for (int y = 1; y < height - 1; y++) {
      for (int x = 1; x < width - 1; x++) {
        // Sobel simplificado - apenas direções principais
        final center = grayscale[y * width + x];
        final left = grayscale[y * width + (x - 1)];
        final right = grayscale[y * width + (x + 1)];
        final top = grayscale[(y - 1) * width + x];
        final bottom = grayscale[(y + 1) * width + x];
        
        // Gradientes horizontal e vertical
        final gx = (right - left).abs();
        final gy = (bottom - top).abs();
        
        // Magnitude do gradiente
        final magnitude = math.sqrt(gx * gx + gy * gy).clamp(0, 255).round();
        edges[y * width + x] = magnitude;
      }
    }
    
    return edges;
  }
  
  static CropCorners? _findDocumentCorners(Uint8List edges, int width, int height) {
    // Apply threshold to get binary edge image
    const threshold = 50;
    final binary = Uint8List(width * height);
    
    for (int i = 0; i < edges.length; i++) {
      binary[i] = edges[i] > threshold ? 255 : 0;
    }
    
    // Usar margem padrão mais simples para performance
    final margin = math.min(width, height) * 0.05;
    
    // Procurar corners apenas em regiões limitadas
    Point? topLeft = _findCornerPointFast(binary, width, height, 0, 0, 1, 1, margin.round());
    Point? topRight = _findCornerPointFast(binary, width, height, width - 1, 0, -1, 1, margin.round());
    Point? bottomLeft = _findCornerPointFast(binary, width, height, 0, height - 1, 1, -1, margin.round());
    Point? bottomRight = _findCornerPointFast(binary, width, height, width - 1, height - 1, -1, -1, margin.round());
    
    // If we couldn't find all corners, use default positions with margin
    final defaultMargin = math.min(width, height) * 0.1;
    
    topLeft ??= Point(x: defaultMargin, y: defaultMargin);
    topRight ??= Point(x: width - defaultMargin, y: defaultMargin);
    bottomLeft ??= Point(x: defaultMargin, y: height - defaultMargin);
    bottomRight ??= Point(x: width - defaultMargin, y: height - defaultMargin);
    
    return CropCorners(
      topLeft: topLeft,
      topRight: topRight,
      bottomLeft: bottomLeft,
      bottomRight: bottomRight,
    );
  }
  
  static Point? _findCornerPointFast(
    Uint8List binary,
    int width,
    int height,
    int startX,
    int startY,
    int dirX,
    int dirY,
    int minDistance,
  ) {
    // Busca rápida com passo maior
    const searchRange = 100;
    const step = 5; // Pular pixels para performance
    
    for (int d = minDistance; d < searchRange; d += step) {
      final x = startX + (d * dirX);
      final y = startY + (d * dirY);
      
      if (x < 0 || x >= width || y < 0 || y >= height) break;
      
      // Verificar apenas o pixel atual
      if (binary[y * width + x] > 0) {
        return Point(x: x.toDouble(), y: y.toDouble());
      }
    }
    
    return null;
  }
}