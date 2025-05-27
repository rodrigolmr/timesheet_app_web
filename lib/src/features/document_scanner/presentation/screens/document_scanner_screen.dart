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
      if (!_hasNavigated) {
        _hasNavigated = true;
        final source = widget.extra?['source'] as String?;
        if (source == 'camera') {
          _captureImage();
        } else if (source == 'gallery') {
          _pickFromGallery();
        } else {
          // If no source provided, default to gallery
          _pickFromGallery();
        }
      }
    });
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
      // Go directly to crop screen
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DocumentCropScreen(
            imageData: result,
          ),
        ),
      );
      
      // When we return from crop screen, close this screen too
      if (mounted) {
        Navigator.of(context).pop();
      }
    } else if (mounted) {
      // User cancelled, go back
      Navigator.of(context).pop();
    }
  }

  Future<void> _pickFromGallery() async {
    setState(() => _isLoading = true);
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,  // Maximum quality
        // Remove size limits to preserve original resolution
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
            // Go directly to crop screen
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DocumentCropScreen(
                  imageData: bytes!,
                ),
              ),
            );
            
            // When we return from crop screen, close this screen too
            if (mounted) {
              Navigator.of(context).pop();
            }
          }
        }
      } else {
        print('No image selected');
        if (mounted) {
          // User cancelled, go back
          Navigator.of(context).pop();
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
        Navigator.of(context).pop();
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
        child: const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: StaticLoadingIndicator(
                message: 'Loading...',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

