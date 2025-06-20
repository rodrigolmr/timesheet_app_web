import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:go_router/go_router.dart';
import '../widgets/web_camera_view.dart';
import 'document_crop_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../services/heic_converter_web.dart' 
  if (dart.library.io) '../../services/heic_converter_stub.dart';
import '../../../../core/widgets/static_loading_indicator.dart';

class DocumentScannerScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? extra;
  
  const DocumentScannerScreen({super.key, this.extra});

  @override
  ConsumerState<DocumentScannerScreen> createState() => _DocumentScannerScreenState();
}

class _DocumentScannerScreenState extends ConsumerState<DocumentScannerScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  bool _hasNavigated = false;
  
  @override
  void initState() {
    super.initState();
    // Always open camera or gallery directly based on source
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openImageSource();
    });
  }
  
  void _openImageSource() async {
    if (_hasNavigated) return;
    
    final source = widget.extra?['source'] as String?;
    if (source == 'camera') {
      await _captureImage();
    } else if (source == 'gallery') {
      await _pickFromGallery();
    } else {
      // If no source provided, default to gallery
      await _pickFromGallery();
    }
  }

  Future<void> _captureImage() async {
    // Show the web camera view
    final result = await showDialog<Uint8List>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.zero,
        child: WebCameraView(
          onImageCaptured: (imageData) {
            Navigator.of(context).pop(imageData);
          },
        ),
      ),
    );
    
    if (result != null && mounted) {
      // Show loading dialog immediately after capture
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
          onWillPop: () async => false,
          child: Container(
            color: Colors.black.withOpacity(0.7),
            child: const Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: StaticLoadingIndicator(
                    message: 'Processing image',
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      
      // Small delay to ensure loading is visible
      await Future.delayed(const Duration(milliseconds: 300));
      
      if (mounted) {
        // Close loading dialog
        Navigator.of(context).pop();
        
        // Mark as navigated before pushing to crop
        _hasNavigated = true;
        // Go directly to crop screen using GoRouter
        context.push(
          '/document-scanner/crop',
          extra: {'imageData': result},
        );
      }
    } else if (mounted) {
      // User cancelled, go back
      context.pop();
    }
  }

  Future<void> _pickFromGallery() async {
    setState(() => _isLoading = true);
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        // Don't compress here, we'll optimize in image processing
      );
      
      if (image != null) {
        print('Selected image path: ${image.path}');
        print('Selected image name: ${image.name}');
        print('Selected image mimeType: ${image.mimeType}');
        
        // Check if it's HEIC format
        final mimeType = image.mimeType?.toLowerCase() ?? '';
        final isHeic = mimeType.contains('heic') || mimeType.contains('heif') || 
                       image.name.toLowerCase().endsWith('.heic') || 
                       image.name.toLowerCase().endsWith('.heif');
        
        Uint8List? bytes;
        
        if (isHeic && kIsWeb) {
          // Try to convert HEIC to JPEG on web
          print('Attempting to convert HEIC image...');
          
          // Show loading dialog
          if (mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Container(
                color: Colors.black.withOpacity(0.7),
                child: const Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: StaticLoadingIndicator(
                        message: 'Converting HEIC image...',
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          
          bytes = await HeicConverterWeb.convertHeicToJpeg(image);
          
          // Close loading dialog
          if (mounted) {
            Navigator.of(context).pop();
          }
          
          if (bytes == null && mounted) {
            // Conversion failed, show help dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('HEIC Conversion Failed'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Unable to convert this HEIC image.\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('Please try these alternatives:'),
                    const SizedBox(height: 8),
                    const Text('• Open the image in your Samsung Gallery'),
                    const Text('• Tap the share button'),
                    const Text('• Select "Convert to JPEG" or save as JPEG'),
                    const Text('• Then select the converted image here'),
                    const SizedBox(height: 12),
                    const Text('Or change camera settings:'),
                    const SizedBox(height: 8),
                    const Text('• Camera app → Settings → Picture formats'),
                    const Text('• Select "JPEG" instead of "HEIF"'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.of(context).pop(); // Go back to previous screen
                    },
                    child: const Text('Got it'),
                  ),
                ],
              ),
            );
            return;
          }
        } else {
          // For non-HEIC formats, just read the bytes
          bytes = await image.readAsBytes();
        }
        
        if (bytes != null) {
          print('Image size in bytes: ${bytes.length}');
          
          if (mounted) {
            // Mark as navigated before pushing to crop
            _hasNavigated = true;
            // Go directly to crop screen using GoRouter
            context.push(
              '/document-scanner/crop',
              extra: {'imageData': bytes!},
            );
          }
        }
      } else {
        print('No image selected');
        if (mounted) {
          // User cancelled, go back
          context.pop();
        }
      }
    } catch (e) {
      print('Error details: $e');
      print('Error type: ${e.runtimeType}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
        // Go back on error
        context.pop();
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    // Show loading screen while the camera or gallery is being opened
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const StaticLoadingIndicator(
                    message: 'Loading...',
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

