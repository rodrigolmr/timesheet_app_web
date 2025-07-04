import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import 'package:go_router/go_router.dart';
import '../../services/image_processing_service.dart';
import 'expense_info_screen.dart';
import '../../../../core/widgets/static_loading_indicator.dart';

class DocumentFilterScreen extends ConsumerStatefulWidget {
  final Uint8List imageData;

  const DocumentFilterScreen({
    super.key,
    required this.imageData,
  });

  @override
  ConsumerState<DocumentFilterScreen> createState() => _DocumentFilterScreenState();
}

class _DocumentFilterScreenState extends ConsumerState<DocumentFilterScreen> {
  DocumentFilter _selectedFilter = DocumentFilter.enhanced;
  Uint8List? _processedImage;
  bool _isProcessing = false;
  bool _isInitializing = true; // Add flag for initial loading
  
  // Cache for processed images with memory limit
  final Map<DocumentFilter, Uint8List> _filterCache = {};
  int maxCacheSize = 3; // Maximum number of cached filters, varies by platform
  final List<DocumentFilter> _cacheOrder = []; // Track order for LRU eviction

  @override
  void initState() {
    super.initState();
    // Cache original image
    _addToCache(DocumentFilter.original, widget.imageData);
    // Show original image initially
    _processedImage = widget.imageData;
    // Process enhanced filter immediately since it's the default
    _processEnhancedFilter();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _determineCacheSize();
  }
  
  void _determineCacheSize() {
    // Determine cache size based on platform
    if (kIsWeb) {
      // Web browsers have different memory constraints
      // PWA on mobile vs desktop
      final screenSize = MediaQuery.of(context).size;
      final isMobile = screenSize.width < 600;
      maxCacheSize = isMobile ? 2 : 3;
    } else if (Theme.of(context).platform == TargetPlatform.iOS || 
               Theme.of(context).platform == TargetPlatform.android) {
      // Mobile devices have less memory
      maxCacheSize = 2;
    } else {
      // Desktop has more memory available
      maxCacheSize = 4;
    }
    debugPrint('Set cache size to $maxCacheSize for platform');
  }
  
  void _addToCache(DocumentFilter filter, Uint8List data) {
    // Remove from order if already exists
    _cacheOrder.remove(filter);
    
    // Add to end (most recently used)
    _cacheOrder.add(filter);
    _filterCache[filter] = data;
    
    // Check if we need to evict
    if (_cacheOrder.length > maxCacheSize) {
      // Remove least recently used
      final toRemove = _cacheOrder.removeAt(0);
      _filterCache.remove(toRemove);
      debugPrint('Evicted filter from cache: $toRemove');
    }
  }
  
  Uint8List? _getFromCache(DocumentFilter filter) {
    if (_filterCache.containsKey(filter)) {
      // Move to end (most recently used)
      _cacheOrder.remove(filter);
      _cacheOrder.add(filter);
      return _filterCache[filter];
    }
    return null;
  }
  
  Future<void> _processEnhancedFilter() async {
    try {
      final processed = await ImageProcessingService.applyFilter(
        imageData: widget.imageData,
        filter: DocumentFilter.enhanced,
      );
      
      if (mounted) {
        // Cache the enhanced version
        _addToCache(DocumentFilter.enhanced, processed);
        
        // Update the display with enhanced version
        setState(() {
          _processedImage = processed;
          _isInitializing = false;
        });
      }
    } catch (e) {
      // If processing fails, stay with original
      debugPrint('Failed to apply enhanced filter: $e');
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }
  
  @override
  void dispose() {
    // Clear cache to free memory
    _filterCache.clear();
    super.dispose();
  }

  Future<void> _applyFilter(DocumentFilter filter) async {
    if (_isProcessing || _selectedFilter == filter) return;

    setState(() {
      _selectedFilter = filter;
    });

    // Check if we have this filter cached
    final cachedImage = _getFromCache(filter);
    if (cachedImage != null) {
      setState(() {
        _processedImage = cachedImage;
      });
      return;
    }

    // Filter not in cache, process it
    setState(() {
      _isProcessing = true;
    });

    try {
      // Add a small delay to show the loading indicator
      await Future.delayed(const Duration(milliseconds: 300));
      
      final processed = await ImageProcessingService.applyFilter(
        imageData: widget.imageData,
        filter: filter,
      );

      if (mounted) {
        // Cache the processed image
        _addToCache(filter, processed);
        
        setState(() {
          _processedImage = processed;
          _isProcessing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error applying filter: $e')),
        );
      }
    }
  }

  void _saveDocument() async {
    if (_processedImage == null) return;
    
    // Show loading dialog
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
                  message: 'Preparing document',
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
      // Navigate to expense info screen
      context.push(
        '/document-scanner/expense-info',
        extra: {
          'imageData': _processedImage!,
          'isPdf': false,
        },
      );
      
      // Close loading dialog after navigation
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    // Show loading screen while initializing
    if (_isInitializing) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          color: Colors.black,
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
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Image preview
          if (_processedImage != null)
            Center(
              child: Image.memory(
                _processedImage!,
                fit: BoxFit.contain,
              ),
            ),

          // Loading overlay - show spinner over the image
          if (_isProcessing)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: const Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: StaticLoadingIndicator(
                        message: 'Applying filter...',
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.black87,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Filter options
              Container(
                height: 100,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildFilterOption(
                      'Enhanced',
                      DocumentFilter.enhanced,
                      Colors.orange,
                    ),
                    _buildFilterOption(
                      'Original',
                      DocumentFilter.original,
                      Colors.blue,
                    ),
                    _buildFilterOption(
                      'Grayscale',
                      DocumentFilter.grayscale,
                      Colors.grey,
                    ),
                    _buildFilterOption(
                      'B&W',
                      DocumentFilter.blackAndWhite,
                      Colors.white,
                    ),
                    _buildFilterOption(
                      'Document',
                      DocumentFilter.document,
                      Colors.teal,
                    ),
                  ],
                ),
              ),
              // Action buttons
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Back button
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                    // Save button
                    ElevatedButton.icon(
                      onPressed: _isProcessing ? null : _saveDocument,
                      icon: const Icon(Icons.save),
                      label: const Text('Save'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOption(String label, DocumentFilter filter, Color color) {
    final isSelected = _selectedFilter == filter;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _applyFilter(filter),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.white : color,
                  width: isSelected ? 3 : 2,
                ),
              ),
              child: Icon(
                _getFilterIcon(filter),
                color: isSelected ? Colors.white : color,
                size: 28,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFilterIcon(DocumentFilter filter) {
    switch (filter) {
      case DocumentFilter.original:
        return Icons.image;
      case DocumentFilter.grayscale:
        return Icons.filter_b_and_w;
      case DocumentFilter.blackAndWhite:
        return Icons.text_fields;
      case DocumentFilter.enhanced:
        return Icons.auto_fix_high;
      case DocumentFilter.document:
        return Icons.description;
    }
  }
}