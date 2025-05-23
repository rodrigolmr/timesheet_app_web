import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class CameraControllerWeb {
  final String facingMode;
  html.VideoElement? _videoElement;
  html.MediaStream? _stream;
  String? _viewId;

  CameraControllerWeb({required this.facingMode});

  Future<void> initialize() async {
    _viewId = 'camera-view-${DateTime.now().millisecondsSinceEpoch}';
    
    _videoElement = html.VideoElement()
      ..autoplay = true
      ..muted = true
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'contain'
      ..style.backgroundColor = 'black'
      ..setAttribute('playsinline', 'true');

    final constraints = {
      'video': {
        'facingMode': facingMode,
        // Otimizado para smartphones em modo retrato
        'width': {'ideal': 1080, 'max': 1440},
        'height': {'ideal': 1920, 'max': 2560},
      }
    };

    try {
      _stream = await html.window.navigator.mediaDevices!
          .getUserMedia(constraints);
      _videoElement!.srcObject = _stream;
      
      // Register the video element
      ui.platformViewRegistry.registerViewFactory(
        _viewId!,
        (int viewId) => _videoElement!,
      );
    } catch (e) {
      throw Exception('Failed to access camera: $e');
    }
  }

  Future<Uint8List> takePicture() async {
    if (_videoElement == null) {
      throw Exception('Camera not initialized');
    }

    print('Taking picture...');
    print('Video dimensions: ${_videoElement!.videoWidth}x${_videoElement!.videoHeight}');

    // Ensure video has valid dimensions
    if (_videoElement!.videoWidth == 0 || _videoElement!.videoHeight == 0) {
      throw Exception('Video element has invalid dimensions');
    }

    // Calcular dimensões otimizadas mantendo aspect ratio
    final videoWidth = _videoElement!.videoWidth;
    final videoHeight = _videoElement!.videoHeight;
    final aspectRatio = videoWidth / videoHeight;
    
    // Para smartphones, limitar baseado na maior dimensão
    final maxDimension = 1920; // Suporta Full HD em qualquer orientação
    int targetWidth = videoWidth;
    int targetHeight = videoHeight;
    
    // Verificar qual é a maior dimensão e limitar se necessário
    if (videoWidth > maxDimension || videoHeight > maxDimension) {
      if (videoHeight > videoWidth) {
        // Modo retrato
        targetHeight = maxDimension;
        targetWidth = (maxDimension * aspectRatio).round();
      } else {
        // Modo paisagem
        targetWidth = maxDimension;
        targetHeight = (maxDimension / aspectRatio).round();
      }
    }

    final canvas = html.CanvasElement(
      width: targetWidth,
      height: targetHeight,
    );
    
    final context = canvas.context2D;
    context.drawImageScaled(_videoElement!, 0, 0, targetWidth, targetHeight);
    
    print('Canvas created with dimensions: ${targetWidth}x${targetHeight}');
    
    // Manter boa qualidade
    final dataUrl = canvas.toDataUrl('image/jpeg', 0.92);
    print('Data URL created, length: ${dataUrl.length}');
    
    // Convert data URL to Uint8List
    final base64String = dataUrl.split(',')[1];
    final bytes = base64Decode(base64String);
    
    print('Image converted to bytes, size: ${bytes.length}');
    return bytes;
  }

  void setFlash(bool enable) {
    if (_stream == null) return;
    
    // Try to control torch/flash on video tracks
    final videoTracks = _stream!.getVideoTracks();
    if (videoTracks.isNotEmpty) {
      final track = videoTracks.first;
      
      // Web API for torch control (if supported)
      final constraints = {
        'advanced': [
          {
            'torch': enable,
          }
        ]
      };
      
      try {
        track.applyConstraints(constraints);
      } catch (e) {
        print('Flash control not supported on this device: $e');
      }
    }
  }

  void dispose() {
    _stream?.getTracks().forEach((track) => track.stop());
    _videoElement?.remove();
  }

  String get viewId => _viewId ?? '';
}

class CameraViewWeb extends StatelessWidget {
  final CameraControllerWeb controller;

  const CameraViewWeb({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(
      viewType: controller.viewId,
    );
  }
}