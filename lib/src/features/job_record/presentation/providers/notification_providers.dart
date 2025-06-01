import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';
import 'package:timesheet_app_web/src/features/job_record/domain/enums/job_record_status.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/job_record_providers.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/permission_providers.dart';
import 'package:timesheet_app_web/src/features/user/domain/enums/user_role.dart';

part 'notification_providers.g.dart';

/// Provider that watches pending job records for notifications
@Riverpod(keepAlive: true)
Stream<List<JobRecordModel>> pendingJobRecords(PendingJobRecordsRef ref) async* {
  // Check if user can approve (only managers and admins)
  final userRole = await ref.watch(currentUserRoleProvider.future);
  if (userRole == null || 
      (userRole != UserRole.admin && userRole != UserRole.manager)) {
    yield [];
    return;
  }

  // Watch all job records (filtered by permissions)
  await for (final records in ref.watch(filteredJobRecordsStreamProvider.stream)) {
    // Filter only pending records
    final pendingRecords = records
        .where((record) => record.status == JobRecordStatus.pending)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Most recent first
    
    yield pendingRecords;
  }
}

/// Provider that gives the count of pending job records
@Riverpod(keepAlive: true)
int pendingJobRecordsCount(PendingJobRecordsCountRef ref) {
  final pendingRecordsAsync = ref.watch(pendingJobRecordsProvider);
  
  return pendingRecordsAsync.when(
    data: (records) => records.length,
    loading: () => 0,
    error: (_, __) => 0,
  );
}

/// Provider for limited pending records to show in dropdown
@Riverpod(keepAlive: true)
List<JobRecordModel> pendingJobRecordsPreview(PendingJobRecordsPreviewRef ref) {
  final pendingRecordsAsync = ref.watch(pendingJobRecordsProvider);
  
  return pendingRecordsAsync.when(
    data: (records) => records.take(5).toList(), // Show only first 5
    loading: () => [],
    error: (_, __) => [],
  );
}