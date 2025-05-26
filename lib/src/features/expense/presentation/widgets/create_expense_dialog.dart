import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
// import 'package:file_picker/file_picker.dart'; // TODO: Add file_picker dependency when implementing PDF upload

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
                Navigator.of(context).pop();
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
    // TODO: Implement PDF upload when file_picker dependency is added
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF upload functionality coming soon'),
        backgroundColor: context.colors.info,
      ),
    );
  }
}