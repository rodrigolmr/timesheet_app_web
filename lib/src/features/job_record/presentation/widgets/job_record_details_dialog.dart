import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/dialogs/dialogs.dart';
import 'package:timesheet_app_web/src/core/widgets/tables/job_record_table.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/job_record_providers.dart';
import 'package:timesheet_app_web/src/features/job_record/data/services/job_record_print_service.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/permission_providers.dart';
import 'package:timesheet_app_web/src/features/user/domain/enums/user_role.dart';
import 'package:timesheet_app_web/src/features/auth/domain/models/role_permissions.dart';
import 'package:timesheet_app_web/src/features/job_record/domain/enums/job_record_status.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/auth_providers.dart';

/// Dialog to show job record details on mobile
/// Shows the job record table with action buttons at the bottom
class JobRecordDetailsDialog extends ConsumerWidget {
  final JobRecordModel record;

  const JobRecordDetailsDialog({
    super.key,
    required this.record,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch permissions
    final canEditAsync = ref.watch(canEditJobRecordProvider(record.userId));
    final canPrintAsync = ref.watch(canPrintJobRecordsProvider);
    final userRoleAsync = ref.watch(currentUserRoleProvider);
    final canEdit = canEditAsync.valueOrNull ?? false;
    final canPrint = canPrintAsync.valueOrNull ?? false;
    final userRole = userRoleAsync.valueOrNull ?? UserRole.user;
    final canApprove = RolePermissions.canApproveJobRecord(userRole);
    final canDelete = RolePermissions.canDeleteOwnJobRecord(
      userRole,
      record.userId,
      ref.read(currentUserProvider)?.uid ?? '',
    );

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with title and close button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.colors.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Job Record Details',
                      style: context.textStyles.title.copyWith(
                        color: context.colors.onPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: context.colors.onPrimary,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Status indicator
                    Container(
                      width: double.infinity,
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
                            style: TextStyle(fontSize: 20),
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
                    
                    // Job Record Table
                    Center(
                      child: JobRecordTable(
                        record: record,
                      ),
                    ),
                    
                    // Notes display outside borders
                    if (record.notes.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
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
                    ],
                  ],
                ),
              ),
            ),
            
            // Action buttons at bottom
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: context.colors.divider,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  // Approve button (full width if pending)
                  if (canApprove && record.status == JobRecordStatus.pending) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _approveRecord(context, ref),
                        icon: const Icon(Icons.check_circle, size: 18),
                        label: const Text('Approve'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.success,
                          foregroundColor: context.colors.onSuccess,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  
                  // Delete, Print and Edit buttons
                  Row(
                    children: [
                      if (canDelete) ...[
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _deleteRecord(context, ref),
                            icon: const Icon(Icons.delete, size: 18),
                            label: const Text('Delete'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.colors.error,
                              foregroundColor: context.colors.onError,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        if (canPrint || canEdit) const SizedBox(width: 8),
                      ],
                      if (canPrint) ...[
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _printRecord(context, ref),
                            icon: const Icon(Icons.print, size: 18),
                            label: const Text('Print'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.colors.primary,
                              foregroundColor: context.colors.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        if (canEdit) const SizedBox(width: 8),
                      ],
                      if (canEdit) ...[
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _editRecord(context, ref),
                            icon: const Icon(Icons.edit, size: 18),
                            label: const Text('Edit'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.colors.secondary,
                              foregroundColor: context.colors.onSecondary,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editRecord(BuildContext context, WidgetRef ref) {
    Navigator.of(context).pop(); // Close dialog
    context.push('/job-records/edit/${record.id}');
  }

  void _printRecord(BuildContext context, WidgetRef ref) async {
    try {
      // Show loading
      showAppProgressDialog(
        context: context,
        title: 'Preparing Print',
        message: 'Please wait...',
      );
      
      // Call print service
      await JobRecordPrintService.printJobRecords([record]);
      
      // Close loading and dialog
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading
        Navigator.of(context).pop(); // Close dialog
      }
      
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
      
      // Close loading and dialog
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading
        Navigator.of(context).pop(); // Close dialog
      }
      
      // Show success message
      if (context.mounted) {
        await showSuccessDialog(
          context: context,
          title: 'Success',
          message: 'Job record deleted successfully.',
        );
      }
    } catch (e) {
      // Close loading
      if (context.mounted) Navigator.of(context).pop();
      
      // Show error message
      if (context.mounted) {
        await showErrorDialog(
          context: context,
          title: 'Delete Error',
          message: 'Failed to delete record: $e',
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
      
      // Close loading and dialog
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading
        Navigator.of(context).pop(); // Close dialog
      }
      
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
      // Close loading
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
}