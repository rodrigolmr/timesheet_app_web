import 'package:timesheet_app_web/src/features/notifications/data/models/scheduled_reminder_model.dart';

abstract class ScheduledReminderRepository {
  Future<ScheduledReminderModel> create(ScheduledReminderModel reminder);
  Future<ScheduledReminderModel?> getById(String id);
  Future<List<ScheduledReminderModel>> getAll();
  Future<List<ScheduledReminderModel>> getActiveReminders();
  Future<List<ScheduledReminderModel>> getRemindersByUser(String userId);
  Stream<List<ScheduledReminderModel>> watchAll();
  Stream<List<ScheduledReminderModel>> watchActiveReminders();
  Future<void> update(ScheduledReminderModel reminder);
  Future<void> delete(String id);
  Future<void> toggleActive(String id, bool isActive);
  Future<void> updateLastSent(String id, DateTime lastSentAt, DateTime? nextSendAt);
}