import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/dialogs/dialogs.dart';
import 'package:timesheet_app_web/src/core/widgets/tables/job_record_table.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/job_record_providers.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/job_record_create_providers.dart';
import 'package:timesheet_app_web/src/features/user/presentation/providers/user_providers.dart';
import 'package:timesheet_app_web/src/features/job_record/data/services/job_record_print_service.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/permission_providers.dart';
import 'package:timesheet_app_web/src/features/user/domain/enums/user_role.dart';
import 'package:timesheet_app_web/src/features/auth/domain/models/role_permissions.dart';
import 'package:timesheet_app_web/src/features/job_record/domain/enums/job_record_status.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/auth_providers.dart';

class JobRecordDetailsWidget extends ConsumerWidget {
  final JobRecordModel record;
  final bool showActions;
  final bool isFullScreen;

  const JobRecordDetailsWidget({
    super.key,
    required this.record,
    this.showActions = true,
    this.isFullScreen = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Calcular largura base responsiva igual ao Step 3
    final baseWidth = context.responsive<double>(
      xs: 280,  // Mobile pequeno
      sm: 292,  // Mobile
      md: 340,  // Tablet
      lg: 400,  // Desktop pequeno
      xl: 450,  // Desktop grande
    );
    
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = isFullScreen 
        ? (screenWidth > baseWidth + 40 ? baseWidth : screenWidth - 40)
        : baseWidth; // Always use baseWidth for non-fullscreen to maintain consistency

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: isFullScreen ? context.dimensions.spacingL : context.dimensions.spacingM,
        left: isFullScreen ? context.dimensions.spacingL : context.dimensions.spacingM,
        right: isFullScreen ? context.dimensions.spacingL : context.dimensions.spacingM,
        bottom: context.dimensions.spacingL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Add extra spacing above the record visualization (only for full screen)
          if (isFullScreen) SizedBox(height: context.dimensions.spacingM),
          
          // Status indicator
          Center(
            child: Container(
              width: containerWidth,
              margin: EdgeInsets.only(bottom: context.dimensions.spacingM),
              padding: EdgeInsets.symmetric(
                horizontal: context.dimensions.spacingM,
                vertical: context.dimensions.spacingS,
              ),
              decoration: BoxDecoration(
                color: record.status == JobRecordStatus.approved 
                    ? context.colors.success.withOpacity(0.1)
                    : context.colors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                border: Border.all(
                  color: record.status == JobRecordStatus.approved
                      ? context.colors.success.withOpacity(0.3)
                      : context.colors.warning.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    record.status.icon,
                    style: TextStyle(
                      fontSize: context.responsive<double>(
                        xs: 20,
                        sm: 22,
                        md: 24,
                        lg: 26,
                        xl: 28,
                      ),
                    ),
                  ),
                  SizedBox(width: context.dimensions.spacingS),
                  Text(
                    'Status: ${record.status.displayName}',
                    style: context.textStyles.subtitle.copyWith(
                      color: record.status == JobRecordStatus.approved
                          ? context.colors.success
                          : context.colors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Job Record Table
          Center(
            child: JobRecordTable(
              record: record,
              width: containerWidth,
            ),
          ),

          // Notes display outside borders
          if (record.notes.isNotEmpty)
            Container(
              width: containerWidth,
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Note: ",
                    style: TextStyle(
                      fontSize: 11, 
                      fontWeight: FontWeight.normal
                    ),
                  ),
                  Expanded(
                    child: Text(
                      record.notes,
                      style: const TextStyle(
                        fontSize: 11, 
                        fontWeight: FontWeight.normal
                      ),
                    ),
                  ),
                ],
              ),
            ),

          if (showActions) ...[
            SizedBox(height: context.dimensions.spacingXL),
            // Action buttons
            _buildActionButtons(context, ref, containerWidth),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, double containerWidth) {
    // Responsividade para botões
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    final buttonPadding = EdgeInsets.symmetric(
      horizontal: context.responsive<double>(xs: 8, sm: 12, md: 16),
      vertical: context.responsive<double>(xs: 10, sm: 12, md: 14),
    );
    final iconSize = context.responsive<double>(xs: 14, sm: 16, md: 18);
    final fontSize = context.responsive<double>(xs: 12, sm: 14, md: 16);
    
    // Watch permissions
    final canEditAsync = ref.watch(canEditJobRecordProvider(record.userId));
    final canPrintAsync = ref.watch(canPrintJobRecordsProvider);
    final userRoleAsync = ref.watch(currentUserRoleProvider);
    final canEdit = canEditAsync.valueOrNull ?? false;
    final canPrint = canPrintAsync.valueOrNull ?? false;
    final userRole = userRoleAsync.valueOrNull ?? UserRole.user;
    final canApprove = RolePermissions.canApproveJobRecord(userRole);
    
    // Check delete permission
    final currentUser = ref.watch(currentUserProvider);
    final canDelete = currentUser != null ? RolePermissions.canDeleteOwnJobRecord(
      userRole,
      record.userId,
      currentUser.uid,
    ) : false;
    
    return Container(
      width: containerWidth,
      child: Column(
        children: [
          // Approve button (first line - full width)
          if (canApprove && record.status == JobRecordStatus.pending) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _approveRecord(context, ref),
                icon: Icon(Icons.check_circle, size: iconSize),
                label: Text('Approve', style: TextStyle(fontSize: fontSize)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.success,
                  foregroundColor: context.colors.onSuccess,
                  padding: buttonPadding,
                ),
              ),
            ),
            SizedBox(height: context.dimensions.spacingS),
          ],
          
          // Delete, Print and Edit buttons (second line - side by side)
          if (canDelete || canPrint || canEdit) ...[
            Row(
              children: [
                if (canDelete) ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _deleteRecord(context, ref),
                      icon: Icon(Icons.delete, size: iconSize),
                      label: Text('Delete', style: TextStyle(fontSize: fontSize)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.error,
                        foregroundColor: context.colors.onError,
                        padding: buttonPadding,
                      ),
                    ),
                  ),
                  if (canPrint || canEdit) SizedBox(width: context.dimensions.spacingS),
                ],
                if (canPrint) ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _printRecord(context, ref),
                      icon: Icon(Icons.print, size: iconSize),
                      label: Text('Print', style: TextStyle(fontSize: fontSize)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.primary,
                        foregroundColor: context.colors.onPrimary,
                        padding: buttonPadding,
                      ),
                    ),
                  ),
                  if (canEdit) SizedBox(width: context.dimensions.spacingS),
                ],
                if (canEdit) ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _editRecord(context, ref),
                      icon: Icon(Icons.edit, size: iconSize),
                      label: Text('Edit', style: TextStyle(fontSize: fontSize)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.secondary,
                        foregroundColor: context.colors.onSecondary,
                        padding: buttonPadding,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  // Action handlers
  void _editRecord(BuildContext context, WidgetRef ref) async {
    // Check permission
    final canEdit = await ref.read(canEditJobRecordProvider(record.userId).future);
    if (!canEdit) {
      if (context.mounted) {
        await showErrorDialog(
          context: context,
          title: 'Permission Denied',
          message: 'You do not have permission to edit job records.',
        );
      }
      return;
    }
    
    context.push('/job-records/edit/${record.id}');
  }

  void _printRecord(BuildContext context, WidgetRef ref) async {
    // Check permission first
    final canPrint = await ref.read(canPrintJobRecordsProvider.future);
    if (!canPrint) {
      if (context.mounted) {
        await showErrorDialog(
          context: context,
          title: 'Permission Denied',
          message: 'You do not have permission to print job records.',
        );
      }
      return;
    }
    
    try {
      // Show loading
      showAppProgressDialog(
        context: context,
        title: 'Preparing Print',
        message: 'Please wait...',
      );
      
      // Call print service
      await JobRecordPrintService.printJobRecords([record]);
      
      // Close loading
      if (context.mounted) Navigator.of(context).pop();
      
      // Show success message
      if (context.mounted) {
        await showSuccessDialog(
          context: context,
          title: 'Success',
          message: 'Print dialog opened successfully.',
        );
      }
    } catch (e) {
      // Close loading
      if (context.mounted) Navigator.of(context).pop();
      
      // Show error message
      if (context.mounted) {
        await showErrorDialog(
          context: context,
          title: 'Print Error',
          message: 'Failed to print record: $e',
        );
      }
    }
  }

  void _approveRecord(BuildContext context, WidgetRef ref) async {
    final TextEditingController noteController = TextEditingController();
    
    // Show custom dialog with note field
    final shouldApprove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Approve Job Record',
          style: context.textStyles.title,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to approve this job record?',
              style: context.textStyles.body,
            ),
            SizedBox(height: context.dimensions.spacingL),
            Text(
              'Optionally add a note:',
              style: context.textStyles.body.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: context.dimensions.spacingS),
            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter approval note (optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.success,
              foregroundColor: context.colors.onSuccess,
            ),
            child: const Text('Approve'),
          ),
        ],
      ),
    );
    
    if (shouldApprove != true) return;
    
    try {
      // Show loading
      showAppProgressDialog(
        context: context,
        title: 'Approving Record',
        message: 'Please wait...',
      );
      
      // Get current user ID
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) throw Exception('User not authenticated');
      
      // Approve the record
      await ref.read(jobRecordRepositoryProvider).approveJobRecord(
        recordId: record.id,
        approverId: currentUser.uid,
        approverNote: noteController.text.isEmpty ? null : noteController.text,
      );
      
      // Close loading dialog
      if (context.mounted) Navigator.of(context).pop();
      
      // Invalidate the provider to refresh the data
      ref.invalidate(jobRecordProvider(record.id));
      
      // Show success message
      if (context.mounted) {
        await showSuccessDialog(
          context: context,
          title: 'Success',
          message: 'Job record approved successfully.',
        );
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) Navigator.of(context).pop();
      
      // Show error message
      if (context.mounted) {
        await showErrorDialog(
          context: context,
          title: 'Error',
          message: 'Failed to approve record: $e',
        );
      }
    }
  }

  void _deleteRecord(BuildContext context, WidgetRef ref) async {
    // Show confirmation dialog
    final confirmed = await showAppConfirmDialog(
      context: context,
      title: 'Delete Job Record',
      message: 'Are you sure you want to delete this job record? This action cannot be undone.',
      confirmText: 'Delete',
      actionType: ConfirmActionType.danger,
    );
    
    if (confirmed != true) return;
    
    try {
      // Show loading
      showAppProgressDialog(
        context: context,
        title: 'Deleting Record',
        message: 'Please wait...',
      );
      
      // Delete the record
      await ref.read(jobRecordStateProvider(record.id).notifier).delete(record.id);
      
      // Close loading dialog
      if (context.mounted) Navigator.of(context).pop();
      
      // Clear selection on desktop to go back to empty state
      ref.read(selectedJobRecordProvider.notifier).selectRecord(null);
      
      // Show success message
      if (context.mounted) {
        await showSuccessDialog(
          context: context,
          title: 'Success',
          message: 'Job record deleted successfully.',
        );
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) Navigator.of(context).pop();
      
      // Show error message
      if (context.mounted) {
        await showErrorDialog(
          context: context,
          title: 'Error',
          message: 'Failed to delete record: $e',
        );
      }
    }
  }
}