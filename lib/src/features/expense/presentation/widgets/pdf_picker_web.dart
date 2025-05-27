import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:async';

class PdfPickerWeb {
  static Future<PdfPickerResult?> pickPdf() async {
    final completer = Completer<PdfPickerResult?>();
    
    try {
      // Create an input element
      final uploadInput = html.FileUploadInputElement();
      uploadInput.accept = '.pdf,application/pdf';
      uploadInput.multiple = false;
      
      // Add the input to the DOM temporarily
      html.document.body!.children.add(uploadInput);
      
      // Set up timeout
      Timer? timeoutTimer;
      
      // Listen for file selection
      uploadInput.onChange.listen((e) async {
        timeoutTimer?.cancel();
        
        final files = uploadInput.files;
        if (files != null && files.isNotEmpty) {
          final file = files[0];
          final reader = html.FileReader();
          
          reader.onLoadEnd.listen((e) {
            try {
              final bytes = reader.result as Uint8List;
              if (!completer.isCompleted) {
                completer.complete(PdfPickerResult(
                  bytes: bytes,
                  name: file.name,
                ));
              }
            } catch (e) {
              if (!completer.isCompleted) {
                completer.completeError('Failed to process file: $e');
              }
            } finally {
              // Remove the input from DOM
              uploadInput.remove();
            }
          });
          
          reader.onError.listen((error) {
            if (!completer.isCompleted) {
              completer.completeError('Failed to read file');
            }
            uploadInput.remove();
          });
          
          reader.readAsArrayBuffer(file);
        } else {
          if (!completer.isCompleted) {
            completer.complete(null);
          }
          uploadInput.remove();
        }
      });
      
      // Also listen for cancel
      uploadInput.addEventListener('cancel', (e) {
        timeoutTimer?.cancel();
        if (!completer.isCompleted) {
          completer.complete(null);
        }
        uploadInput.remove();
      });
      
      // Set timeout for mobile devices that might not trigger events properly
      timeoutTimer = Timer(const Duration(seconds: 30), () {
        if (!completer.isCompleted) {
          completer.complete(null);
          uploadInput.remove();
        }
      });
      
      // Trigger file picker
      uploadInput.click();
      
    } catch (e) {
      if (!completer.isCompleted) {
        completer.completeError('Error initializing file picker: $e');
      }
    }
    
    return completer.future;
  }
}

class PdfPickerResult {
  final Uint8List bytes;
  final String name;
  
  PdfPickerResult({
    required this.bytes,
    required this.name,
  });
}