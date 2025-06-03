import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timesheet_app_web/src/core/providers/firebase_providers.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:timesheet_app_web/src/features/notifications/data/models/scheduled_reminder_model.dart';
import 'package:timesheet_app_web/src/features/notifications/data/repositories/firestore_scheduled_reminder_repository.dart';
import 'package:timesheet_app_web/src/features/notifications/domain/repositories/scheduled_reminder_repository.dart';

part 'scheduled_reminder_providers.g.dart';

@riverpod
ScheduledReminderRepository scheduledReminderRepository(ScheduledReminderRepositoryRef ref) {
  return FirestoreScheduledReminderRepository(
    firestore: ref.watch(firestoreProvider),
  );
}

@riverpod
Stream<List<ScheduledReminderModel>> scheduledReminders(ScheduledRemindersRef ref) {
  return ref.watch(scheduledReminderRepositoryProvider).watchAll();
}

@riverpod
Stream<List<ScheduledReminderModel>> activeScheduledReminders(ActiveScheduledRemindersRef ref) {
  return ref.watch(scheduledReminderRepositoryProvider).watchActiveReminders();
}

@riverpod
Future<List<ScheduledReminderModel>> userScheduledReminders(
  UserScheduledRemindersRef ref,
  String userId,
) async {
  return ref.watch(scheduledReminderRepositoryProvider).getRemindersByUser(userId);
}

@riverpod
class ScheduledReminderState extends _$ScheduledReminderState {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> createReminder({
    required String title,
    required String message,
    required List<String> targetUserIds,
    required DateTime scheduledTime,
    required String frequency,
    String? dayOfWeek,
    int? dayOfMonth,
  }) async {
    state = const AsyncLoading();
    
    try {
      final currentUser = await ref.read(currentUserProvider.future);
      if (currentUser == null) throw Exception('User not authenticated');
      
      final reminder = ScheduledReminderModel(
        id: '',
        title: title,
        message: message,
        targetUserIds: targetUserIds,
        scheduledTime: scheduledTime,
        frequency: frequency,
        dayOfWeek: dayOfWeek,
        dayOfMonth: dayOfMonth,
        isActive: true,
        createdBy: currentUser.uid,
        createdAt: DateTime.now(),
      );
      
      // Calculate next send time
      final nextSendAt = reminder.calculateNextSendTime();
      final reminderWithNextSend = reminder.copyWith(nextSendAt: nextSendAt);
      
      await ref.read(scheduledReminderRepositoryProvider).create(reminderWithNextSend);
      
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  Future<void> updateReminder({
    required String id,
    required String title,
    required String message,
    required List<String> targetUserIds,
    required DateTime scheduledTime,
    required String frequency,
    String? dayOfWeek,
    int? dayOfMonth,
    required bool isActive,
  }) async {
    state = const AsyncLoading();
    
    try {
      final existing = await ref.read(scheduledReminderRepositoryProvider).getById(id);
      if (existing == null) throw Exception('Reminder not found');
      
      final updated = existing.copyWith(
        title: title,
        message: message,
        targetUserIds: targetUserIds,
        scheduledTime: scheduledTime,
        frequency: frequency,
        dayOfWeek: dayOfWeek,
        dayOfMonth: dayOfMonth,
        isActive: isActive,
      );
      
      // Recalculate next send time
      final nextSendAt = updated.calculateNextSendTime();
      final reminderWithNextSend = updated.copyWith(nextSendAt: nextSendAt);
      
      await ref.read(scheduledReminderRepositoryProvider).update(reminderWithNextSend);
      
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  Future<void> toggleActive(String id, bool isActive) async {
    try {
      await ref.read(scheduledReminderRepositoryProvider).toggleActive(id, isActive);
      
      // If reactivating, recalculate next send time
      if (isActive) {
        final reminder = await ref.read(scheduledReminderRepositoryProvider).getById(id);
        if (reminder != null) {
          final nextSendAt = reminder.calculateNextSendTime();
          await ref.read(scheduledReminderRepositoryProvider).update(
            reminder.copyWith(nextSendAt: nextSendAt),
          );
        }
      }
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  Future<void> deleteReminder(String id) async {
    try {
      await ref.read(scheduledReminderRepositoryProvider).delete(id);
    } catch (e) {
      // Handle error
      rethrow;
    }
  }
}