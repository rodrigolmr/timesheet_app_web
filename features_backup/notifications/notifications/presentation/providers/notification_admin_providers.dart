import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timesheet_app_web/src/features/notifications/data/models/notification_model.dart';
import 'package:timesheet_app_web/src/features/notifications/data/models/notification_preferences_model.dart';
import 'package:timesheet_app_web/src/features/notifications/presentation/providers/notification_providers.dart';

part 'notification_admin_providers.g.dart';

@riverpod
Stream<List<NotificationModel>> allNotificationsStream(AllNotificationsStreamRef ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  
  // Access Firestore collection directly
  return FirebaseFirestore.instance
      .collection('notifications')
      .orderBy('created_at', descending: true)
      .snapshots()
      .map((snapshot) => 
          snapshot.docs.map((doc) => NotificationModel.fromFirestore(doc)).toList());
}

@riverpod
Stream<NotificationPreferencesModel?> userNotificationPreferencesById(
  UserNotificationPreferencesByIdRef ref,
  String userId,
) {
  return ref.watch(notificationRepositoryProvider)
      .watchUserPreferences(userId);
}