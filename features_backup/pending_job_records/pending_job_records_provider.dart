import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timesheet_app_web/src/features/job_record/domain/enums/job_record_status.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/job_record_providers.dart';
import 'package:timesheet_app_web/src/features/notifications/presentation/providers/notification_providers.dart';
import 'package:timesheet_app_web/src/features/notifications/data/models/notification_model.dart';

part 'pending_job_records_provider.g.dart';

/// Provider que monitora job records pendentes e suas notificações associadas
@riverpod
Stream<List<NotificationModel>> pendingJobRecordNotifications(
  PendingJobRecordNotificationsRef ref,
) async* {
  // Observa as notificações do usuário
  final notificationsStream = ref.watch(userNotificationsProvider);
  
  // Observa todos os job records
  final jobRecordsStream = ref.watch(jobRecordsStreamProvider);
  
  await for (final notifications in notificationsStream) {
    final jobRecords = await ref.read(jobRecordsStreamProvider.future);
    
    // Filtra apenas notificações de job records
    final jobRecordNotifications = notifications.where((n) => 
      n.type == 'job_record_created' || n.type == 'job_record_updated'
    ).toList();
    
    // Verifica quais job records ainda estão pendentes
    final pendingNotifications = <NotificationModel>[];
    
    for (final notification in jobRecordNotifications) {
      final jobRecordId = notification.data?['job_record_id'] as String?;
      if (jobRecordId != null) {
        // Encontra o job record correspondente
        final jobRecord = jobRecords.firstWhere(
          (jr) => jr.id == jobRecordId,
          orElse: () => throw Exception('Job record not found'),
        );
        
        // Se o job record ainda está pendente, mantém a notificação
        if (jobRecord.status == JobRecordStatus.pending) {
          pendingNotifications.add(notification);
        } else if (!notification.isRead) {
          // Se o job record foi aprovado/rejeitado mas a notificação não foi lida,
          // marca como lida automaticamente
          await ref.read(notificationRepositoryProvider).markAsRead(notification.id);
        }
      }
    }
    
    yield pendingNotifications;
  }
}

/// Provider que retorna o número de job records pendentes
@riverpod
int pendingJobRecordCount(PendingJobRecordCountRef ref) {
  final notifications = ref.watch(pendingJobRecordNotificationsProvider).valueOrNull ?? [];
  return notifications.length;
}