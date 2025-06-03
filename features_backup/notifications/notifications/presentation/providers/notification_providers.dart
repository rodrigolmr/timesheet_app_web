import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timesheet_app_web/src/core/providers/firebase_providers.dart';
import 'package:timesheet_app_web/src/core/services/notification_service.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:timesheet_app_web/src/features/user/presentation/providers/user_providers.dart';
import 'package:timesheet_app_web/src/features/notifications/data/models/notification_model.dart';
import 'package:timesheet_app_web/src/features/notifications/data/models/notification_preferences_model.dart';
import 'package:timesheet_app_web/src/features/notifications/data/repositories/firestore_notification_repository.dart';
import 'package:timesheet_app_web/src/features/notifications/domain/repositories/notification_repository.dart';
import 'package:timesheet_app_web/src/features/notifications/domain/services/notification_helper.dart';

part 'notification_providers.g.dart';

@riverpod
NotificationRepository notificationRepository(NotificationRepositoryRef ref) {
  return FirestoreNotificationRepository(
    firestore: ref.watch(firestoreProvider),
  );
}

@riverpod
NotificationService notificationService(NotificationServiceRef ref) {
  return NotificationService();
}

@riverpod
NotificationHelper notificationHelper(NotificationHelperRef ref) {
  return NotificationHelper(
    notificationRepository: ref.watch(notificationRepositoryProvider),
    userRepository: ref.watch(userRepositoryProvider),
  );
}

@riverpod
Stream<List<NotificationModel>> userNotifications(UserNotificationsRef ref) {
  final userProfile = ref.watch(currentUserProfileProvider).valueOrNull;
  if (userProfile == null) {
    return Stream.value([]);
  }
  
  return ref.watch(notificationRepositoryProvider)
      .watchUserNotifications(userProfile.id);
}

@riverpod
int unreadNotificationCount(UnreadNotificationCountRef ref) {
  final notifications = ref.watch(userNotificationsProvider).valueOrNull ?? [];
  return notifications.where((n) => !n.isRead).length;
}

@riverpod
Stream<NotificationPreferencesModel?> userNotificationPreferences(
  UserNotificationPreferencesRef ref
) {
  final userProfile = ref.watch(currentUserProfileProvider).valueOrNull;
  if (userProfile == null) {
    return Stream.value(null);
  }
  
  return ref.watch(notificationRepositoryProvider)
      .watchUserPreferences(userProfile.id);
}

@riverpod
class NotificationState extends _$NotificationState {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> initializeNotifications() async {
    state = const AsyncLoading();
    try {
      final service = ref.read(notificationServiceProvider);
      await service.initialize();
      
      // Update FCM token in user preferences
      final token = service.fcmToken;
      if (token != null) {
        final userProfile = await ref.read(currentUserProfileProvider.future);
        if (userProfile != null) {
          await ref.read(notificationRepositoryProvider)
              .updateFcmToken(userProfile.id, token);
        }
      }
      
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> requestPermission() async {
    state = const AsyncLoading();
    try {
      final service = ref.read(notificationServiceProvider);
      final settings = await service.requestPermission();
      
      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        await initializeNotifications();
      } else {
        throw Exception('Notification permission denied');
      }
      
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await ref.read(notificationRepositoryProvider).markAsRead(notificationId);
    } catch (e) {
      // Handle error silently or show snackbar
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final userProfile = await ref.read(currentUserProfileProvider.future);
      if (userProfile != null) {
        await ref.read(notificationRepositoryProvider)
            .markAllAsRead(userProfile.id);
      }
    } catch (e) {
      // Handle error silently or show snackbar
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await ref.read(notificationRepositoryProvider)
          .deleteNotification(notificationId);
    } catch (e) {
      // Handle error silently or show snackbar
    }
  }

  Future<void> updatePreferences(NotificationPreferencesModel preferences) async {
    state = const AsyncLoading();
    try {
      final userProfile = await ref.read(currentUserProfileProvider.future);
      if (userProfile != null) {
        await ref.read(notificationRepositoryProvider)
            .updatePreferences(userProfile.id, preferences);
      }
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      final service = ref.read(notificationServiceProvider);
      await service.subscribeToTopic(topic);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      final service = ref.read(notificationServiceProvider);
      await service.unsubscribeFromTopic(topic);
    } catch (e) {
      // Handle error
    }
  }
}

@riverpod
Stream<RemoteMessage> notificationMessages(NotificationMessagesRef ref) {
  final service = ref.watch(notificationServiceProvider);
  return service.messageStream;
}

@riverpod
Future<AuthorizationStatus> notificationPermissionStatus(
  NotificationPermissionStatusRef ref
) async {
  final service = ref.watch(notificationServiceProvider);
  return await service.getPermissionStatus();
}