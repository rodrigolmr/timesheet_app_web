import 'package:flutter/material.dart';
import 'package:timesheet_app_web/src/core/widgets/fullscreen_viewer_base.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

class PdfViewerDialog extends StatefulWidget {
  final String pdfUrl;
  final String title;

  const PdfViewerDialog({
    super.key,
    required this.pdfUrl,
    this.title = 'PDF Receipt',
  });

  @override
  State<PdfViewerDialog> createState() => _PdfViewerDialogState();
}

class _PdfViewerDialogState extends State<PdfViewerDialog> {
  final String _iframeId = 'pdf-viewer-${DateTime.now().millisecondsSinceEpoch}';
  double _zoomLevel = 1.0;
  html.IFrameElement? _iframe;

  @override
  void initState() {
    super.initState();
    _setupIframe();
  }

  void _setupIframe() {
    // Create an iframe element
    final pdfUrl = '${widget.pdfUrl}#toolbar=0&navpanes=0&scrollbar=0';
    _iframe = html.IFrameElement()
      ..src = pdfUrl
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.border = 'none'
      ..style.backgroundColor = '#000000'
      ..allowFullscreen = true;

    // Register the iframe with Flutter
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      _iframeId,
      (int viewId) => _iframe!,
    );
  }

  void _updateZoom(double newZoom) {
    setState(() {
      _zoomLevel = newZoom.clamp(0.5, 3.0);
    });
    
    if (_iframe != null) {
      _iframe!.style.transform = 'scale($_zoomLevel)';
      _iframe!.style.transformOrigin = 'center center';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FullscreenViewerBase(
      child: Stack(
        children: [
          // PDF Container
          Container(
            color: Colors.black,
            child: HtmlElementView(
              viewType: _iframeId,
            ),
          ),
          // Zoom Controls
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Zoom out
                  IconButton(
                    icon: const Icon(Icons.zoom_out, color: Colors.white),
                    onPressed: () => _updateZoom(_zoomLevel - 0.25),
                  ),
                  // Reset zoom
                  TextButton(
                    onPressed: () => _updateZoom(1.0),
                    child: Text(
                      '${(_zoomLevel * 100).round()}%',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  // Zoom in
                  IconButton(
                    icon: const Icon(Icons.zoom_in, color: Colors.white),
                    onPressed: () => _updateZoom(_zoomLevel + 0.25),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}