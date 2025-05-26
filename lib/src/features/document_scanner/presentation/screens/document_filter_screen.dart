import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import 'package:go_router/go_router.dart';
import '../../services/image_processing_service.dart';
import 'expense_info_screen.dart';

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

  @override
  void initState() {
    super.initState();
    // Show original image initially and apply enhanced filter
    _processedImage = widget.imageData;
    // Apply enhanced filter after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyFilter(DocumentFilter.enhanced);
    });
  }

  Future<void> _applyFilter(DocumentFilter filter) async {
    if (_isProcessing || _selectedFilter == filter) return;

    setState(() {
      _selectedFilter = filter;
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

  void _saveDocument() {
    if (_processedImage == null) return;
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ExpenseInfoScreen(
          imageData: _processedImage!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

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
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
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