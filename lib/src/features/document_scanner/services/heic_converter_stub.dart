// Stub implementation for non-web platforms
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class HeicConverterWeb {
  static Future<Uint8List?> convertHeicToJpeg(XFile imageFile) async {
    throw UnimplementedError('HeicConverterWeb is only available on web platform');
  }
}