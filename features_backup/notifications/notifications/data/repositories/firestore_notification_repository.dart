import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timesheet_app_web/src/core/repositories/firestore_repository.dart';
import 'package:timesheet_app_web/src/features/notifications/data/models/notification_model.dart';
import 'package:timesheet_app_web/src/features/notifications/data/models/notification_preferences_model.dart';
import 'package:timesheet_app_web/src/features/notifications/domain/repositories/notification_repository.dart';

class FirestoreNotificationRepository extends FirestoreRepository<NotificationModel>
    implements NotificationRepository {
  FirestoreNotificationRepository({required FirebaseFirestore firestore})
      : super(collectionPath: 'notifications', firestore: firestore);

  @override
  NotificationModel fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return NotificationModel.fromFirestore(doc);
  }

  @override
  Map<String, dynamic> toFirestore(NotificationModel entity) {
    return entity.toFirestore();
  }

  @override
  Future<List<NotificationModel>> getUserNotifications(String userId) async {
    final snapshot = await collection
        .where('user_id', isEqualTo: userId)
        .get();
    
    final notifications = snapshot.docs.map((doc) => fromFirestore(doc)).toList();
    // Sort in memory to avoid index requirement
    notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notifications;
  }

  @override
  Stream<List<NotificationModel>> watchUserNotifications(String userId) {
    return collection
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .handleError((error) {
          print('Error watching notifications: $error');
          // Return empty list on error to avoid breaking the UI
          return Stream.value(<NotificationModel>[]);
        })
        .map((snapshot) {
          try {
            final notifications = snapshot.docs.map((doc) => fromFirestore(doc)).toList();
            // Sort in memory to avoid index requirement
            notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            return notifications;
          } catch (e) {
            print('Error parsing notifications: $e');
            return <NotificationModel>[];
          }
        });
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await collection.doc(notificationId).update({
      'is_read': true,
      'read_at': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    final batch = FirebaseFirestore.instance.batch();
    final unreadNotifications = await collection
        .where('user_id', isEqualTo: userId)
        .where('is_read', isEqualTo: false)
        .get();
    
    for (final doc in unreadNotifications.docs) {
      batch.update(doc.reference, {
        'is_read': true,
        'read_at': FieldValue.serverTimestamp(),
      });
    }
    
    await batch.commit();
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await delete(notificationId);
  }

  @override
  Future<void> createNotification(NotificationModel notification) async {
    await create(notification);
  }

  @override
  Future<void> createOrUpdateNotification(NotificationModel notification) async {
    // Se a notificação tem um ID específico, tenta atualizar
    if (notification.id.isNotEmpty) {
      try {
        // Verifica se existe
        final doc = await collection.doc(notification.id).get();
        if (doc.exists) {
          // Atualiza mantendo o mesmo ID
          await collection.doc(notification.id).set(
            notification.toFirestore(),
            SetOptions(merge: false),
          );
        } else {
          // Cria com o ID específico
          await collection.doc(notification.id).set(
            notification.toFirestore(),
          );
        }
      } catch (e) {
        // Se falhar, cria uma nova
        await create(notification);
      }
    } else {
      // Se não tem ID, cria uma nova
      await create(notification);
    }
  }

  // Preferences methods
  CollectionReference<Map<String, dynamic>> get preferencesCollection =>
      FirebaseFirestore.instance.collection('notification_preferences');

  @override
  Future<NotificationPreferencesModel?> getUserPreferences(String userId) async {
    final snapshot = await preferencesCollection
        .where('user_id', isEqualTo: userId)
        .limit(1)
        .get();
    
    if (snapshot.docs.isEmpty) {
      return null;
    }
    
    return NotificationPreferencesModel.fromFirestore(snapshot.docs.first);
  }

  @override
  Stream<NotificationPreferencesModel?> watchUserPreferences(String userId) {
    return preferencesCollection
        .where('user_id', isEqualTo: userId)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) {
            return null;
          }
          return NotificationPreferencesModel.fromFirestore(snapshot.docs.first);
        });
  }

  @override
  Future<void> updatePreferences(String userId, NotificationPreferencesModel preferences) async {
    // First check if preferences exist
    final existing = await getUserPreferences(userId);
    
    if (existing != null) {
      // Update existing
      await preferencesCollection.doc(existing.id).update(
        preferences.toFirestore()..['updated_at'] = FieldValue.serverTimestamp(),
      );
    } else {
      // Create new
      await preferencesCollection.add(
        preferences.toFirestore()..['updated_at'] = FieldValue.serverTimestamp(),
      );
    }
  }

  @override
  Future<void> updateFcmToken(String userId, String fcmToken) async {
    final existing = await getUserPreferences(userId);
    
    if (existing != null) {
      await preferencesCollection.doc(existing.id).update({
        'fcm_token': fcmToken,
        'updated_at': FieldValue.serverTimestamp(),
      });
    } else {
      // Create new preferences with token
      final newPrefs = NotificationPreferencesModel.defaultPreferences(userId)
          .copyWith(fcmToken: fcmToken);
      await preferencesCollection.add(newPrefs.toFirestore());
    }
  }
}