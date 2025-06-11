import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:js' as js;
import 'dart:js_util' as js_util;

class WebWorkerService {
  static WebWorkerService? _instance;
  html.Worker? _worker;
  final Map<String, Completer> _pendingRequests = {};
  int _requestId = 0;
  
  static WebWorkerService get instance {
    _instance ??= WebWorkerService._();
    return _instance!;
  }
  
  WebWorkerService._() {
    _initializeWorker();
  }
  
  void _initializeWorker() {
    try {
      _worker = html.Worker('/image_processor_worker.js');
      
      _worker!.onMessage.listen((event) {
        final data = event.data;
        if (data is Map && data.containsKey('requestId')) {
          final requestId = data['requestId'].toString();
          final completer = _pendingRequests.remove(requestId);
          
          if (completer != null) {
            if (data['type'] == 'success') {
              completer.complete(data['result']);
            } else {
              completer.completeError(data['error'] ?? 'Unknown error');
            }
          }
        }
      });
      
      _worker!.onError.listen((error) {
        print('Web Worker error: $error');
      });
    } catch (e) {
      print('Failed to initialize Web Worker: $e');
    }
  }
  
  Future<Uint8List> processInWorker(String operation, Map<String, dynamic> data) async {
    if (_worker == null) {
      // Fallback to main thread if worker is not available
      throw Exception('Web Worker not available');
    }
    
    final requestId = (_requestId++).toString();
    final completer = Completer<Uint8List>();
    _pendingRequests[requestId] = completer;
    
    // Add request ID to the message
    final message = {
      'requestId': requestId,
      'type': operation,
      'data': data,
    };
    
    _worker!.postMessage(js_util.jsify(message));
    
    // Set a timeout
    Timer(const Duration(seconds: 30), () {
      if (_pendingRequests.containsKey(requestId)) {
        _pendingRequests.remove(requestId);
        completer.completeError('Operation timeout');
      }
    });
    
    return completer.future;
  }
  
  Future<Uint8List> perspectiveTransform({
    required Uint8List imageData,
    required List<Map<String, double>> corners,
    required Map<String, double> imageSize,
  }) async {
    try {
      return await processInWorker('perspectiveTransform', {
        'imageData': imageData,
        'corners': corners,
        'imageSize': imageSize,
      });
    } catch (e) {
      // Fallback to main thread processing
      throw e;
    }
  }
  
  Future<Uint8List> applyFilter({
    required Uint8List imageData,
    required String filter,
  }) async {
    try {
      return await processInWorker('applyFilter', {
        'imageData': imageData,
        'filter': filter,
      });
    } catch (e) {
      // Fallback to main thread processing
      throw e;
    }
  }
  
  void dispose() {
    _worker?.terminate();
    _worker = null;
    _pendingRequests.clear();
  }
}