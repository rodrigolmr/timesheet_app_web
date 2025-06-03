import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timesheet_app_web/src/core/repositories/firestore_repository.dart';
import 'package:timesheet_app_web/src/features/notifications/data/models/scheduled_reminder_model.dart';
import 'package:timesheet_app_web/src/features/notifications/domain/repositories/scheduled_reminder_repository.dart';

class FirestoreScheduledReminderRepository extends FirestoreRepository<ScheduledReminderModel>
    implements ScheduledReminderRepository {
  FirestoreScheduledReminderRepository({required FirebaseFirestore firestore})
      : super(collectionPath: 'scheduled_reminders', firestore: firestore);

  @override
  ScheduledReminderModel fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return ScheduledReminderModel.fromFirestore(doc);
  }

  @override
  Map<String, dynamic> toFirestore(ScheduledReminderModel entity) {
    return entity.toFirestore();
  }

  @override
  Future<List<ScheduledReminderModel>> getActiveReminders() async {
    final snapshot = await collection
        .where('is_active', isEqualTo: true)
        .get();
    
    return snapshot.docs.map((doc) => fromFirestore(doc)).toList();
  }

  @override
  Future<List<ScheduledReminderModel>> getRemindersByUser(String userId) async {
    final snapshot = await collection
        .where('target_user_ids', arrayContains: userId)
        .where('is_active', isEqualTo: true)
        .get();
    
    return snapshot.docs.map((doc) => fromFirestore(doc)).toList();
  }

  @override
  Stream<List<ScheduledReminderModel>> watchAll() {
    return collection
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => fromFirestore(doc)).toList());
  }

  @override
  Stream<List<ScheduledReminderModel>> watchActiveReminders() {
    return collection
        .where('is_active', isEqualTo: true)
        .orderBy('next_send_at')
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => fromFirestore(doc)).toList());
  }

  @override
  Future<void> toggleActive(String id, bool isActive) async {
    await collection.doc(id).update({
      'is_active': isActive,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> updateLastSent(String id, DateTime lastSentAt, DateTime? nextSendAt) async {
    await collection.doc(id).update({
      'last_sent_at': Timestamp.fromDate(lastSentAt),
      'next_send_at': nextSendAt != null ? Timestamp.fromDate(nextSendAt) : null,
    });
  }
}