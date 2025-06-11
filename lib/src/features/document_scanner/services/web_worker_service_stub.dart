import 'dart:typed_data';

class WebWorkerService {
  static WebWorkerService? _instance;
  
  static WebWorkerService get instance {
    _instance ??= WebWorkerService._();
    return _instance!;
  }
  
  WebWorkerService._();
  
  Future<Uint8List> perspectiveTransform({
    required Uint8List imageData,
    required List<Map<String, double>> corners,
    required Map<String, double> imageSize,
  }) async {
    // On non-web platforms, throw to use fallback
    throw Exception('Web Worker not available on this platform');
  }
  
  Future<Uint8List> applyFilter({
    required Uint8List imageData,
    required String filter,
  }) async {
    // On non-web platforms, throw to use fallback
    throw Exception('Web Worker not available on this platform');
  }
  
  void dispose() {
    // No-op on non-web platforms
  }
}