import 'package:timesheet_app_web/src/features/notifications/data/models/notification_model.dart';
import 'package:timesheet_app_web/src/features/notifications/data/models/notification_preferences_model.dart';

abstract class NotificationRepository {
  Future<List<NotificationModel>> getUserNotifications(String userId);
  Stream<List<NotificationModel>> watchUserNotifications(String userId);
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead(String userId);
  Future<void> deleteNotification(String notificationId);
  Future<void> createNotification(NotificationModel notification);
  Future<void> createOrUpdateNotification(NotificationModel notification);
  
  // Preferences
  Future<NotificationPreferencesModel?> getUserPreferences(String userId);
  Stream<NotificationPreferencesModel?> watchUserPreferences(String userId);
  Future<void> updatePreferences(String userId, NotificationPreferencesModel preferences);
  Future<void> updateFcmToken(String userId, String fcmToken);
}