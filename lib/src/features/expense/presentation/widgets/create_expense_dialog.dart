import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import '../../../document_scanner/presentation/screens/expense_info_screen.dart';
import 'pdf_picker_web.dart' if (dart.library.io) '';

class CreateExpenseDialog extends StatelessWidget {
  const CreateExpenseDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Create Expense',
              style: context.textStyles.title.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose how to add your receipt',
              style: context.textStyles.body.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            
            // Camera option
            _buildOption(
              context: context,
              icon: Icons.camera_alt,
              title: 'Camera',
              subtitle: 'Take a photo of your receipt',
              onTap: () {
                Navigator.of(context).pop();
                context.push('/document-scanner', extra: {'source': 'camera'});
              },
            ),
            
            const SizedBox(height: 12),
            
            // Gallery option
            _buildOption(
              context: context,
              icon: Icons.photo_library,
              title: 'Gallery',
              subtitle: 'Select from your photos',
              onTap: () {
                Navigator.of(context).pop();
                context.push('/document-scanner', extra: {'source': 'gallery'});
              },
            ),
            
            const SizedBox(height: 12),
            
            // Upload PDF option
            _buildOption(
              context: context,
              icon: Icons.picture_as_pdf,
              title: 'Upload PDF',
              subtitle: 'Select a PDF receipt',
              onTap: () async {
                await _handlePdfUpload(context);
              },
            ),
            
            const SizedBox(height: 24),
            
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: context.colors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: context.colors.outline.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: context.colors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 24,
                color: context.colors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: context.textStyles.caption.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: context.colors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePdfUpload(BuildContext context) async {
    try {
      Uint8List? fileBytes;
      String? fileName;
      
      // Try using FilePicker first for all platforms
      try {
        debugPrint('Attempting to pick PDF with FilePicker...');
        
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
          withData: true,
          allowMultiple: false,
          lockParentWindow: false, // Changed to false for mobile compatibility
          dialogTitle: 'Select PDF Receipt',
        );
        
        if (result != null && result.files.isNotEmpty) {
          final file = result.files.first;
          fileBytes = file.bytes;
          fileName = file.name;
          debugPrint('PDF selected: $fileName, size: ${fileBytes?.length ?? 0} bytes');
        } else {
          debugPrint('No file selected');
          return;
        }
      } catch (e) {
        debugPrint('FilePicker error: $e');
        
        // If FilePicker fails on mobile web, try HTML5 approach
        if (kIsWeb) {
          debugPrint('Falling back to HTML5 file input...');
          try {
            final result = await PdfPickerWeb.pickPdf();
            if (result != null) {
              fileBytes = result.bytes;
              fileName = result.name;
              debugPrint('PDF selected via HTML5: $fileName, size: ${fileBytes!.length} bytes');
            } else {
              debugPrint('No PDF selected via HTML5');
              return;
            }
          } catch (htmlError) {
            debugPrint('HTML5 picker error: $htmlError');
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Unable to select PDF. Please try again.'),
                  backgroundColor: context.colors.error,
                ),
              );
            }
            return;
          }
        } else {
          throw e;
        }
      }

      if (fileBytes != null && fileName != null) {
        // Navigate to expense info screen with PDF data
        if (context.mounted) {
          // Close the dialog first
          Navigator.of(context).pop();
          
          // Then navigate to expense info screen
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExpenseInfoScreen(
                imageData: fileBytes!,
                isPdf: true,
                fileName: fileName,
              ),
            ),
          );
        }
      } else if (fileBytes == null) {
        // Show error when file bytes are null
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Failed to load PDF file'),
              backgroundColor: context.colors.error,
            ),
          );
        }
      }
    } catch (e) {
      // Hide loading indicator if still showing
      if (context.mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      if (context.mounted) {
        String errorMessage = 'Error selecting PDF';
        
        // Handle specific errors
        if (e.toString().contains('_instance')) {
          errorMessage = 'Please try again. If the problem persists, try refreshing the page.';
        } else if (e.toString().contains('User canceled')) {
          // User canceled the picker, no need to show error
          return;
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: context.colors.error,
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => _handlePdfUpload(context),
              textColor: Colors.white,
            ),
          ),
        );
      }
    }
  }
}