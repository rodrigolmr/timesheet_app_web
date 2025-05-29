import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:async';
import 'dart:convert';
import '../../../../core/widgets/static_loading_indicator.dart';

class WebCameraView extends StatefulWidget {
  final Function(Uint8List) onImageCaptured;
  
  const WebCameraView({
    super.key,
    required this.onImageCaptured,
  });

  @override
  State<WebCameraView> createState() => _WebCameraViewState();
}

class _WebCameraViewState extends State<WebCameraView> {
  html.VideoElement? _videoElement;
  html.MediaStream? _stream;
  bool _isInitialized = false;
  bool _isCapturing = false;
  String? _errorMessage;
  bool _showGrid = true;
  final String _viewType = 'webcamera-${DateTime.now().millisecondsSinceEpoch}';
  
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }
  
  Future<void> _initializeCamera() async {
    try {
      // Create video element
      _videoElement = html.VideoElement()
        ..autoplay = true
        ..muted = true
        ..setAttribute('playsinline', 'true')
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover'
        ..style.transform = 'scaleX(-1)'; // Mirror the video for selfie mode
      
      // Register the video element as a platform view
      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(
        _viewType,
        (int viewId) => _videoElement!,
      );
      
      // Request camera permission and get stream
      try {
        // Try back camera first with higher resolution
        _stream = await html.window.navigator.mediaDevices!.getUserMedia({
          'video': {
            'facingMode': {'ideal': 'environment'},
            'width': {'ideal': 3840},  // 4K width
            'height': {'ideal': 2160}, // 4K height
            'aspectRatio': {'ideal': 16/9},
          }
        });
      } catch (e) {
        // Fallback to any available camera
        _stream = await html.window.navigator.mediaDevices!.getUserMedia({
          'video': true,
        });
      }
      
      _videoElement!.srcObject = _stream;
      
      // Wait for video to be ready
      await _videoElement!.play();
      
      // Remove mirror effect if using back camera
      if (_stream!.getVideoTracks().first.getSettings()['facingMode'] == 'environment') {
        _videoElement!.style.transform = '';
      }
      
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Camera access denied. Please allow camera access and reload the page.';
      });
    }
  }
  
  Future<void> _captureImage() async {
    if (_videoElement == null || _isCapturing) return;
    
    setState(() {
      _isCapturing = true;
    });
    
    try {
      // Wait a bit for any UI updates
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Create canvas with video dimensions
      final canvas = html.CanvasElement(
        width: _videoElement!.videoWidth,
        height: _videoElement!.videoHeight,
      );
      
      final ctx = canvas.context2D;
      
      // Draw the current video frame to canvas
      ctx.drawImage(_videoElement!, 0, 0);
      
      // Convert canvas to blob
      final completer = Completer<Uint8List>();
      
      canvas.toBlob('image/jpeg', 1.0).then((blob) async {  // Maximum quality
        final reader = html.FileReader();
        reader.readAsArrayBuffer(blob);
        await reader.onLoad.first;
        final result = reader.result;
        if (result is Uint8List) {
          completer.complete(result);
        } else if (result is ByteBuffer) {
          completer.complete(Uint8List.view(result));
        } else {
          throw Exception('Unexpected result type: ${result.runtimeType}');
        }
      });
      
      final imageData = await completer.future;
      
      // Return the captured image
      widget.onImageCaptured(imageData);
      
    } catch (e) {
      setState(() {
        _isCapturing = false;
        _errorMessage = 'Failed to capture image: $e';
      });
    }
  }
  
  void _dispose() {
    _stream?.getTracks().forEach((track) => track.stop());
    _videoElement?.pause();
    _videoElement?.srcObject = null;
  }
  
  @override
  void dispose() {
    _dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    if (!_isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: StaticLoadingIndicator(
            color: Colors.white,
            message: 'Initializing camera...',
          ),
        ),
      );
    }
    
    return Stack(
      fit: StackFit.expand,
      children: [
        // Video preview
        HtmlElementView(viewType: _viewType),
        
        // Grid overlay
        if (_showGrid)
          IgnorePointer(
            child: CustomPaint(
              size: MediaQuery.of(context).size,
              painter: GridPainter(),
            ),
          ),
        
        
        // Bottom controls
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black87, Colors.transparent],
              ),
            ),
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).padding.bottom + 16,
              top: 16,
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                // Capture button
                GestureDetector(
                  onTap: _isCapturing ? null : _captureImage,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: _isCapturing
                        ? const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: StaticLoadingIndicator(
                              size: 26,
                              color: Colors.black,
                            ),
                          )
                        : const Icon(
                            Icons.circle,
                            size: 48,
                            color: Colors.black,
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                // Other controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 28),
                      onPressed: () {
                        _dispose();
                        Navigator.of(context).pop();
                      },
                      tooltip: 'Cancel',
                    ),
                    IconButton(
                      icon: Icon(
                        _showGrid ? Icons.grid_on : Icons.grid_off,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        setState(() {
                          _showGrid = !_showGrid;
                        });
                      },
                      tooltip: _showGrid ? 'Hide grid' : 'Show grid',
                    ),
                  ],
                ),
              ],
            ),
            ),
          ),
        ),
      ],
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw 3x3 grid
    final horizontalSpacing = size.width / 3;
    final verticalSpacing = size.height / 3;

    for (int i = 1; i < 3; i++) {
      // Vertical lines
      canvas.drawLine(
        Offset(horizontalSpacing * i, 0),
        Offset(horizontalSpacing * i, size.height),
        paint,
      );
      
      // Horizontal lines
      canvas.drawLine(
        Offset(0, verticalSpacing * i),
        Offset(size.width, verticalSpacing * i),
        paint,
      );
    }

    // Draw frame border
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final padding = 16.0;
    canvas.drawRect(
      Rect.fromLTWH(
        padding,
        padding,
        size.width - (padding * 2),
        size.height - (padding * 2),
      ),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}