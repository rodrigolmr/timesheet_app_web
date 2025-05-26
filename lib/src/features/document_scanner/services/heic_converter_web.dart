import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:js_util' as js_util;
import 'dart:async';
import 'package:image_picker/image_picker.dart';

class HeicConverterWeb {
  static Future<Uint8List?> convertHeicToJpeg(XFile imageFile) async {
    try {
      print('HeicConverterWeb: Starting conversion for ${imageFile.name}');
      
      // First, get the blob from the XFile path (which is a blob URL)
      final response = await html.HttpRequest.request(
        imageFile.path,
        responseType: 'blob',
      );
      
      final blob = response.response as html.Blob;
      print('HeicConverterWeb: Got blob, size: ${blob.size} bytes');
      
      // Call the JavaScript function to convert HEIC to JPEG
      final convertedBlobPromise = js_util.callMethod(
        html.window, 
        'convertHeicToJpeg', 
        [blob]
      );
      
      // Wait for the promise to resolve
      final convertedBlob = await js_util.promiseToFuture(convertedBlobPromise);
      
      if (convertedBlob == null) {
        print('HeicConverterWeb: Conversion returned null');
        return null;
      }
      
      print('HeicConverterWeb: Conversion successful, reading result...');
      
      // Convert the blob to Uint8List
      final reader = html.FileReader();
      final completer = Completer<Uint8List?>();
      
      reader.onLoadEnd.listen((_) {
        final result = reader.result;
        if (result is Uint8List) {
          print('HeicConverterWeb: Got Uint8List, size: ${result.length} bytes');
          completer.complete(result);
        } else {
          print('HeicConverterWeb: Unexpected result type: ${result.runtimeType}');
          completer.complete(null);
        }
      });
      
      reader.onError.listen((error) {
        print('HeicConverterWeb: FileReader error: $error');
        completer.complete(null);
      });
      
      // Read as array buffer
      reader.readAsArrayBuffer(convertedBlob as html.Blob);
      
      return await completer.future;
    } catch (e, stackTrace) {
      print('HeicConverterWeb: Error during conversion: $e');
      print('HeicConverterWeb: Stack trace: $stackTrace');
      return null;
    }
  }
}