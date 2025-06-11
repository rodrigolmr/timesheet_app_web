import 'dart:typed_data';
import 'package:image/image.dart' as img;

/// Service to cache decoded images and avoid repeated decoding
class ImageCacheService {
  static final ImageCacheService _instance = ImageCacheService._();
  static ImageCacheService get instance => _instance;
  
  ImageCacheService._();
  
  // Cache for decoded images
  final Map<int, img.Image> _cache = {};
  static const int maxCacheSize = 3;
  final List<int> _cacheOrder = [];
  
  /// Get image from cache or decode it
  img.Image? getImage(Uint8List imageData) {
    final key = imageData.hashCode;
    
    if (_cache.containsKey(key)) {
      // Move to end (most recently used)
      _cacheOrder.remove(key);
      _cacheOrder.add(key);
      return _cache[key];
    }
    
    // Decode image
    final image = img.decodeImage(imageData);
    if (image == null) return null;
    
    // Add to cache
    _addToCache(key, image);
    
    return image;
  }
  
  void _addToCache(int key, img.Image image) {
    _cacheOrder.add(key);
    _cache[key] = image;
    
    // Check if we need to evict
    if (_cacheOrder.length > maxCacheSize) {
      final toRemove = _cacheOrder.removeAt(0);
      _cache.remove(toRemove);
    }
  }
  
  /// Clear the cache
  void clear() {
    _cache.clear();
    _cacheOrder.clear();
  }
  
  /// Remove specific image from cache
  void remove(Uint8List imageData) {
    final key = imageData.hashCode;
    _cache.remove(key);
    _cacheOrder.remove(key);
  }
}