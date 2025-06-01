import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/app_header.dart';
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

class JobRecordDetailsScreen extends ConsumerStatefulWidget {
  static const routePath = '/job-records/:id';
  static const routeName = 'job-record-details';

  final String recordId;

  const JobRecordDetailsScreen({
    super.key,
    required this.recordId,
  });

  @override
  ConsumerState<JobRecordDetailsScreen> createState() => _JobRecordDetailsScreenState();
}

class _JobRecordDetailsScreenState extends ConsumerState<JobRecordDetailsScreen> {
  
  @override
  Widget build(BuildContext context) {
    final recordAsync = ref.watch(jobRecordProvider(widget.recordId));

    return Scaffold(
      appBar: _buildAppBar(),
      body: recordAsync.when(
        data: (record) {
          if (record == null) {
            return _buildNotFound();
          }
          return _buildRecordDetails(record);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _buildError(error),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final canPrintAsync = ref.watch(canPrintJobRecordsProvider);
    final userRoleAsync = ref.watch(currentUserRoleProvider);
    final currentUserAsync = ref.watch(currentUserProfileProvider);
    final recordAsync = ref.watch(jobRecordProvider(widget.recordId));
    
    return AppHeader(
      title: 'Job Record Details',
      showBackButton: true,
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: _handleMenuAction,
          itemBuilder: (context) {
            final canPrint = canPrintAsync.valueOrNull ?? false;
            final userRole = userRoleAsync.valueOrNull ?? UserRole.user;
            final currentUser = currentUserAsync.valueOrNull;
            final record = recordAsync.valueOrNull;
            
            // Check if user can delete this specific record
            bool canDeleteThisRecord = false;
            if (currentUser != null && record != null) {
              canDeleteThisRecord = RolePermissions.canDeleteOwnJobRecord(
                userRole,
                record.userId,
                currentUser.authUid,
              );
            }
            
            final items = <PopupMenuEntry<String>>[];
            
            // Add print option only if user has permission
            if (canPrint) {
              items.add(
                const PopupMenuItem<String>(
                  value: 'print',
                  child: Row(
                    children: [
                      Icon(Icons.print, size: 20),
                      SizedBox(width: 8),
                      Text('Print'),
                    ],
                  ),
                ),
              );
            }
            
            // Add delete option if user can delete this specific record
            if (canDeleteThisRecord) {
              items.add(const PopupMenuDivider());
              items.add(
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              );
            }
            
            return items;
          },
        ),
      ],
    );
  }

  Widget _buildNotFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 80,
            color: context.colors.textSecondary.withOpacity(0.5),
          ),
          SizedBox(height: context.dimensions.spacingL),
          Text(
            'Job Record Not Found',
            style: context.textStyles.title.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          SizedBox(height: context.dimensions.spacingM),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildError(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: context.colors.error,
          ),
          SizedBox(height: context.dimensions.spacingL),
          Text(
            'Error Loading Record',
            style: context.textStyles.title.copyWith(
              color: context.colors.error,
            ),
          ),
          SizedBox(height: context.dimensions.spacingM),
          Text(
            error.toString(),
            style: context.textStyles.body.copyWith(
              color: context.colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.dimensions.spacingL),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordDetails(JobRecordModel record) {
    // Calcular largura base responsiva igual ao Step 3
    final baseWidth = context.responsive<double>(
      xs: 280,  // Mobile pequeno
      sm: 292,  // Mobile
      md: 340,  // Tablet
      lg: 400,  // Desktop pequeno
      xl: 450,  // Desktop grande
    );
    
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth > baseWidth + 40 ? baseWidth : screenWidth - 40;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: context.dimensions.spacingL,
        left: context.dimensions.spacingL,
        right: context.dimensions.spacingL,
        bottom: context.dimensions.spacingL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Add extra spacing above the record visualization
          SizedBox(height: context.dimensions.spacingM),
          
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
          
          // Job Record Layout - identical to Step 3
          Center(
            child: Container(
              width: containerWidth,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleTimeSheet(context, "JOB RECORD"),
                  _drawHorizontalLine(),
                  _buildLineJobName(context, "JOB NAME:", record.jobName),
                  _drawHorizontalLine(),
                  _buildLineDateTmRow(
                    context,
                    _getDateDisplay(record.date),
                    record.territorialManager,
                  ),
                  _drawHorizontalLine(),
                  _buildLineJobSize(context, "JOB SIZE:", record.jobSize),
                  _drawHorizontalLine(),
                  _buildLineMaterialRow(context, "MATERIAL:", record.material),
                  _drawHorizontalLine(),
                  _buildLineJobDesc(context, "JOB DESC.:", record.jobDescription),
                  _drawHorizontalLine(),
                  _buildLineForemanVehicle(context, record.foreman, record.vehicle),
                  _drawHorizontalLine(),
                  if (record.employees.isEmpty)
                    _buildLineText(context, "No Workers added.", "")
                  else
                    _buildWorkersTable(context, record.employees),
                ],
              ),
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

          SizedBox(height: context.dimensions.spacingXL),

          // Action buttons
          _buildActionButtons(containerWidth, record),
        ],
      ),
    );
  }

  Widget _buildActionButtons(double containerWidth, JobRecordModel record) {
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
    
    return Container(
      width: containerWidth,
      child: Column(
        children: [
          // Approve button (first line - full width)
          if (canApprove && record.status == JobRecordStatus.pending) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _approveRecord(record),
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
          
          // Print and Edit buttons (second line - side by side)
          if (canEdit || canPrint) ...[
            Row(
              children: [
                if (canPrint) ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _printRecord(record),
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
                      onPressed: () => _editRecord(),
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
  void _editRecord() async {
    // Get the record to check creator
    final record = ref.read(jobRecordProvider(widget.recordId)).valueOrNull;
    if (record == null) return;
    
    // Check permission
    final canEdit = await ref.read(canEditJobRecordProvider(record.userId).future);
    if (!canEdit) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('You do not have permission to edit job records'),
            backgroundColor: context.colors.error,
          ),
        );
      }
      return;
    }
    
    context.push('/job-records/edit/${widget.recordId}');
  }


  void _printRecord(JobRecordModel record) async {
    // Check permission first
    final canPrint = await ref.read(canPrintJobRecordsProvider.future);
    if (!canPrint) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('You do not have permission to print job records'),
            backgroundColor: context.colors.error,
          ),
        );
      }
      return;
    }
    
    try {
      // Show loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Preparing print...'),
          backgroundColor: context.colors.primary,
          duration: const Duration(seconds: 1),
        ),
      );
      
      // Call print service
      await JobRecordPrintService.printJobRecords([record]);
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Print dialog opened successfully'),
            backgroundColor: context.colors.success,
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error printing record: $e'),
            backgroundColor: context.colors.error,
          ),
        );
      }
    }
  }

  void _deleteRecord() async {
    // Obter o registro atual
    final record = ref.read(jobRecordProvider(widget.recordId)).valueOrNull;
    if (record == null) return;
    
    // Verificar permissão para deletar este registro específico
    final userRole = await ref.read(currentUserRoleProvider.future);
    final currentUser = await ref.read(currentUserProfileProvider.future);
    if (currentUser == null || userRole == null) return;
    
    final canDelete = RolePermissions.canDeleteOwnJobRecord(
      userRole,
      record.userId,
      currentUser.authUid,
    );
    
    if (!canDelete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('You do not have permission to delete this job record'),
          backgroundColor: context.colors.error,
        ),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
        ),
        title: Text(
          'Delete Job Record',
          style: context.textStyles.title,
        ),
        content: Text(
          'Are you sure you want to delete this job record? This action cannot be undone.',
          style: context.textStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: context.colors.textSecondary,
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _performDeletion();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.error,
              foregroundColor: context.colors.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _performDeletion() async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    
    try {
      // Delete the record
      await ref.read(jobRecordStateProvider(widget.recordId).notifier).delete(widget.recordId);
      
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Job record deleted successfully'),
            backgroundColor: context.colors.success,
          ),
        );
        
        // Navigate back to job records list
        context.go('/job-records');
      }
    } catch (e) {
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting record: $e'),
            backgroundColor: context.colors.error,
          ),
        );
      }
    }
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'print':
        final record = ref.read(jobRecordProvider(widget.recordId)).valueOrNull;
        if (record != null) _printRecord(record);
        break;
      case 'delete':
        _deleteRecord();
        break;
    }
  }

  void _approveRecord(JobRecordModel record) async {
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
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
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
      if (mounted) Navigator.of(context).pop();
      
      // Invalidate the provider to refresh the data
      ref.invalidate(jobRecordProvider(widget.recordId));
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Job record approved successfully'),
            backgroundColor: context.colors.success,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error approving record: $e'),
            backgroundColor: context.colors.error,
          ),
        );
      }
    }
  }

  // Utility methods (copied from Step 3)
  String _getDateDisplay(DateTime date) {
    return intl.DateFormat("M/d/yy, EEEE").format(date);
  }

  String _formatNumber(double value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }

  // UI Building methods (copied from Step 3)
  Widget _buildTitleTimeSheet(BuildContext context, String text) {
    return Container(
      width: double.infinity,
      height: context.responsive<double>(
        xs: 22,
        sm: 24,
        md: 26,
        lg: 28,
        xl: 30,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: context.responsive<double>(
            xs: 16,
            sm: 18,
            md: 20,
            lg: 22,
            xl: 24,
          ),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _drawHorizontalLine() => Container(height: 0.5, color: Colors.black);

  Widget _buildLineJobName(BuildContext context, String label, String value) {
    return SizedBox(
      height: context.responsive<double>(
        xs: 16,
        sm: 18,
        md: 20,
        lg: 22,
        xl: 24,
      ),
      child: Row(
        children: [
          SizedBox(
            width: context.responsive<double>(
              xs: 60,
              sm: 64,
              md: 70,
              lg: 80,
              xl: 90,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: context.responsive<double>(
                  xs: 10,
                  sm: 11,
                  md: 12,
                  lg: 13,
                  xl: 14,
                ),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: context.responsive<double>(
                  xs: 10,
                  sm: 11,
                  md: 12,
                  lg: 13,
                  xl: 14,
                ),
              ),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineDateTmRow(BuildContext context, String dateValue, String tmValue) {
    final fontSize = context.responsive<double>(
      xs: 10,
      sm: 11,
      md: 12,
      lg: 13,
      xl: 14,
    );
    
    return SizedBox(
      height: context.responsive<double>(
        xs: 16,
        sm: 18,
        md: 20,
        lg: 22,
        xl: 24,
      ),
      child: Row(
        children: [
          SizedBox(
            width: context.responsive<double>(
              xs: 34,
              sm: 36,
              md: 40,
              lg: 45,
              xl: 50,
            ),
            child: Text(
              "DATE:",
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              dateValue,
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(width: 0.5, color: Colors.black),
          SizedBox(
            width: context.responsive<double>(
              xs: 28,
              sm: 31,
              md: 35,
              lg: 40,
              xl: 45,
            ),
            child: Text(
              "T.M.:",
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              tmValue,
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineJobSize(BuildContext context, String label, String value) {
    return SizedBox(
      height: context.responsive<double>(
        xs: 16,
        sm: 18,
        md: 20,
        lg: 22,
        xl: 24,
      ),
      child: Row(
        children: [
          SizedBox(
            width: context.responsive<double>(
              xs: 52,
              sm: 56,
              md: 62,
              lg: 70,
              xl: 80,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: context.responsive<double>(
                  xs: 10,
                  sm: 11,
                  md: 12,
                  lg: 13,
                  xl: 14,
                ),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: context.responsive<double>(
                  xs: 10,
                  sm: 11,
                  md: 12,
                  lg: 13,
                  xl: 14,
                ),
              ),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineMaterialRow(BuildContext context, String label, String value) {
    final fontSize = context.responsive<double>(
      xs: 10,
      sm: 11,
      md: 12,
      lg: 13,
      xl: 14,
    );
    
    final lineHeight = context.responsive<double>(
      xs: 16,
      sm: 18,
      md: 20,
      lg: 22,
      xl: 24,
    );
    
    // Adiciona padding vertical quando tem múltiplas linhas
    final verticalPadding = value.contains('\n') ? 4.0 : 0.0;
    
    return Container(
      constraints: BoxConstraints(minHeight: lineHeight),
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: context.responsive<double>(
              xs: 62,
              sm: 66,
              md: 72,
              lg: 80,
              xl: 90,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: fontSize,
              ),
              textAlign: TextAlign.left,
              overflow: TextOverflow.visible,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineJobDesc(BuildContext context, String label, String value) {
    final fontSize = context.responsive<double>(
      xs: 10,
      sm: 11,
      md: 12,
      lg: 13,
      xl: 14,
    );
    
    final lineHeight = context.responsive<double>(
      xs: 16,
      sm: 18,
      md: 20,
      lg: 22,
      xl: 24,
    );
    
    // Adiciona padding vertical quando tem múltiplas linhas
    final verticalPadding = value.contains('\n') ? 4.0 : 0.0;
    
    return Container(
      constraints: BoxConstraints(minHeight: lineHeight),
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: context.responsive<double>(
              xs: 62,
              sm: 66,
              md: 72,
              lg: 80,
              xl: 90,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: fontSize,
              ),
              textAlign: TextAlign.left,
              overflow: TextOverflow.visible,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineForemanVehicle(BuildContext context, String foreman, String vehicle) {
    final fontSize = context.responsive<double>(
      xs: 10,
      sm: 11,
      md: 12,
      lg: 13,
      xl: 14,
    );
    
    return SizedBox(
      height: context.responsive<double>(
        xs: 16,
        sm: 18,
        md: 20,
        lg: 22,
        xl: 24,
      ),
      child: Row(
        children: [
          SizedBox(
            width: context.responsive<double>(
              xs: 56,
              sm: 60,
              md: 66,
              lg: 75,
              xl: 85,
            ),
            child: Text(
              "FOREMAN:",
              style: TextStyle(fontSize: fontSize * 0.9, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              foreman.isEmpty ? '' : foreman,
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(width: 0.5, color: Colors.black),
          SizedBox(
            width: context.responsive<double>(
              xs: 46,
              sm: 50,
              md: 56,
              lg: 65,
              xl: 75,
            ),
            child: Text(
              "VEHICLE:",
              style: TextStyle(fontSize: fontSize * 0.9, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              vehicle.isEmpty ? '' : vehicle,
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineText(BuildContext context, String label, String value, {bool multiLine = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      constraints: const BoxConstraints(minHeight: 18),
      child: Row(
        crossAxisAlignment:
            multiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkersTable(BuildContext context, List<dynamic> employees) {
    final baseFontSize = context.responsive<double>(
      xs: 10,
      sm: 11,
      md: 12,
      lg: 13,
      xl: 14,
    );
    
    final rows = <TableRow>[
      TableRow(
        decoration: const BoxDecoration(color: Color(0xFFEFEFEF)),
        children: [
          _buildHeaderCell("NAME", fontSize: baseFontSize, textAlign: TextAlign.center),
          _buildHeaderCell("START", fontSize: baseFontSize * 0.75, textAlign: TextAlign.center),
          _buildHeaderCell("FINISH", fontSize: baseFontSize * 0.75, textAlign: TextAlign.center),
          _buildHeaderCell("HOUR", fontSize: baseFontSize * 0.75, textAlign: TextAlign.center),
          _buildHeaderCell("TRAVEL", fontSize: baseFontSize * 0.65, textAlign: TextAlign.center),
          _buildHeaderCell("MEAL", fontSize: baseFontSize * 0.75, textAlign: TextAlign.center),
        ],
      ),
      for (final employee in employees)
        TableRow(
          children: [
            _buildDataCell(employee.employeeName,
                fontSize: baseFontSize, textAlign: TextAlign.left),
            _buildDataCell(employee.startTime,
                fontSize: baseFontSize, textAlign: TextAlign.center),
            _buildDataCell(employee.finishTime,
                fontSize: baseFontSize, textAlign: TextAlign.center),
            _buildDataCell(_formatNumber(employee.hours),
                fontSize: baseFontSize, textAlign: TextAlign.center),
            _buildDataCell(employee.travelHours > 0 ? _formatNumber(employee.travelHours) : '',
                fontSize: baseFontSize, textAlign: TextAlign.center),
            _buildDataCell(employee.meal > 0 ? _formatNumber(employee.meal) : '',
                fontSize: baseFontSize, textAlign: TextAlign.center),
          ],
        ),
    ];

    return SizedBox(
      width: double.infinity,
      child: Table(
        border: TableBorder(
          top: const BorderSide(width: 0, color: Colors.transparent),
          left: const BorderSide(width: 0, color: Colors.transparent),
          right: const BorderSide(width: 0, color: Colors.transparent),
          bottom: const BorderSide(width: 0, color: Colors.transparent),
          horizontalInside: const BorderSide(width: 0.5, color: Colors.black),
          verticalInside: const BorderSide(width: 0.5, color: Colors.black),
        ),
        columnWidths: {
          0: FlexColumnWidth(context.responsive<double>(
            xs: 2.5,
            sm: 3,
            md: 3.5,
            lg: 4,
            xl: 4.5,
          )),
          1: const FlexColumnWidth(1),
          2: const FlexColumnWidth(1),
          3: const FlexColumnWidth(0.8),
          4: const FlexColumnWidth(0.9),
          5: const FlexColumnWidth(0.8),
        },
        children: rows,
      ),
    );
  }

  Widget _buildHeaderCell(String text,
      {required double fontSize, required TextAlign textAlign}) {
    return Container(
      alignment: Alignment.center,
      height: 18,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF3B3B3B),
        ),
        textAlign: textAlign,
      ),
    );
  }

  Widget _buildDataCell(String text,
      {required double fontSize, required TextAlign textAlign}) {
    return Container(
      alignment: Alignment.center,
      height: 18,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: const Color(0xFF3B3B3B),
        ),
        textAlign: textAlign,
      ),
    );
  }
}