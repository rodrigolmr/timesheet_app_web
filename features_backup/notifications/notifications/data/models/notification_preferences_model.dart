import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'notification_preferences_model.freezed.dart';
part 'notification_preferences_model.g.dart';

@freezed
class NotificationPreferencesModel with _$NotificationPreferencesModel {
  const NotificationPreferencesModel._();
  
  const factory NotificationPreferencesModel({
    required String id,
    required String userId,
    required bool enabled,
    required bool jobRecordCreated,
    required bool jobRecordUpdated,
    required bool timesheetReminder,
    required bool expenseCreated,
    required bool systemUpdates,
    String? fcmToken,
    List<String>? subscribedTopics,
    Map<String, dynamic>? data,
    required DateTime updatedAt,
  }) = _NotificationPreferencesModel;

  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) => 
      _$NotificationPreferencesModelFromJson(json);

  factory NotificationPreferencesModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return NotificationPreferencesModel(
      id: doc.id,
      userId: data['user_id'] as String,
      enabled: data['enabled'] as bool? ?? true,
      jobRecordCreated: data['job_record_created'] as bool? ?? true,
      jobRecordUpdated: data['job_record_updated'] as bool? ?? true,
      timesheetReminder: data['timesheet_reminder'] as bool? ?? true,
      expenseCreated: data['expense_created'] as bool? ?? true,
      systemUpdates: data['system_updates'] as bool? ?? false,
      fcmToken: data['fcm_token'] as String?,
      subscribedTopics: (data['subscribed_topics'] as List<dynamic>?)?.cast<String>(),
      data: data['data'] as Map<String, dynamic>?,
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'enabled': enabled,
      'job_record_created': jobRecordCreated,
      'job_record_updated': jobRecordUpdated,
      'timesheet_reminder': timesheetReminder,
      'expense_created': expenseCreated,
      'system_updates': systemUpdates,
      'fcm_token': fcmToken,
      'subscribed_topics': subscribedTopics,
      'data': data,
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }

  factory NotificationPreferencesModel.defaultPreferences(String userId) {
    return NotificationPreferencesModel(
      id: '',
      userId: userId,
      enabled: true,
      jobRecordCreated: true,
      jobRecordUpdated: true,
      timesheetReminder: true,
      expenseCreated: true,
      systemUpdates: false,
      subscribedTopics: [],
      data: null,
      updatedAt: DateTime.now(),
    );
  }
}