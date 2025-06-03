import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';
import 'package:timesheet_app_web/src/features/job_record/domain/enums/job_record_status.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/job_record_providers.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/permission_providers.dart';
import 'package:timesheet_app_web/src/features/user/domain/enums/user_role.dart';
import 'package:timesheet_app_web/src/features/notifications/data/models/notification_model.dart';
import 'package:timesheet_app_web/src/features/notifications/presentation/providers/notification_providers.dart';
import 'package:timesheet_app_web/src/features/user/presentation/providers/user_providers.dart';

part 'pending_approval_provider.g.dart';

/// Provider que monitora job records pendentes de aprovação
@riverpod
Stream<List<JobRecordModel>> pendingApprovalJobRecords(
  PendingApprovalJobRecordsRef ref,
) async* {
  // Verifica se o usuário tem permissão para aprovar
  final currentUser = ref.watch(currentUserProfileProvider).valueOrNull;
  
  if (currentUser == null) {
    print('PendingApprovalJobRecords: No current user');
    yield [];
    return;
  }
  
  final userRole = UserRole.fromString(currentUser.role);
  if (userRole != UserRole.admin && userRole != UserRole.manager) {
    print('PendingApprovalJobRecords: User is not admin/manager');
    yield [];
    return;
  }
  
  print('PendingApprovalJobRecords: Watching for pending records');
  
  // Usa o jobRecordsStreamProvider diretamente (não o filtered)
  await for (final jobRecords in ref.watch(jobRecordsStreamProvider.stream)) {
    // Filtra apenas os pendentes
    final pending = jobRecords.where((record) => 
      record.status == JobRecordStatus.pending
    ).toList();
    print('PendingApprovalJobRecords: Found ${pending.length} pending records of ${jobRecords.length} total');
    yield pending;
  }
}

/// Provider que retorna o número de job records aguardando aprovação
@riverpod
int pendingApprovalCount(PendingApprovalCountRef ref) {
  final pendingRecords = ref.watch(pendingApprovalJobRecordsProvider).valueOrNull ?? [];
  return pendingRecords.length;
}

/// Provider que cria/atualiza notificação de resumo de pendências
@riverpod
class PendingApprovalNotifier extends _$PendingApprovalNotifier {
  @override
  Future<void> build() async {
    // Observa mudanças no número de pendências
    ref.listen(pendingApprovalCountProvider, (previous, next) {
      if (next > 0) {
        _updatePendingNotification(next);
      } else {
        _removePendingNotification();
      }
    });
  }
  
  Future<void> _updatePendingNotification(int count) async {
    final notificationRepo = ref.read(notificationRepositoryProvider);
    final currentUser = await ref.read(currentUserProfileProvider.future);
    
    if (currentUser == null) return;
    
    // Cria ou atualiza a notificação de resumo
    final notification = NotificationModel(
      id: 'pending_approval_summary_${currentUser.id}', // ID único por usuário
      userId: currentUser.id,
      title: 'Pending Approvals',
      body: 'You have $count job record${count > 1 ? 's' : ''} waiting for approval',
      type: 'pending_approval_summary',
      data: {
        'count': count,
        'route': '/job-records',
      },
      isRead: false,
      createdAt: DateTime.now(),
    );
    
    // Usa createOrUpdate para manter sempre atualizado
    await notificationRepo.createOrUpdateNotification(notification);
  }
  
  Future<void> _removePendingNotification() async {
    final notificationRepo = ref.read(notificationRepositoryProvider);
    final currentUser = await ref.read(currentUserProfileProvider.future);
    
    if (currentUser == null) return;
    
    // Remove a notificação de resumo quando não há mais pendências
    try {
      await notificationRepo.deleteNotification('pending_approval_summary_${currentUser.id}');
    } catch (e) {
      // Ignora erro se a notificação não existir
    }
  }
}