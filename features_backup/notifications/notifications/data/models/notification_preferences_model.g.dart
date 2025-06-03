// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationPreferencesModelImpl _$$NotificationPreferencesModelImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationPreferencesModelImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  enabled: json['enabled'] as bool,
  jobRecordCreated: json['jobRecordCreated'] as bool,
  jobRecordUpdated: json['jobRecordUpdated'] as bool,
  timesheetReminder: json['timesheetReminder'] as bool,
  expenseCreated: json['expenseCreated'] as bool,
  systemUpdates: json['systemUpdates'] as bool,
  fcmToken: json['fcmToken'] as String?,
  subscribedTopics:
      (json['subscribedTopics'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
  data: json['data'] as Map<String, dynamic>?,
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$NotificationPreferencesModelImplToJson(
  _$NotificationPreferencesModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'enabled': instance.enabled,
  'jobRecordCreated': instance.jobRecordCreated,
  'jobRecordUpdated': instance.jobRecordUpdated,
  'timesheetReminder': instance.timesheetReminder,
  'expenseCreated': instance.expenseCreated,
  'systemUpdates': instance.systemUpdates,
  'fcmToken': instance.fcmToken,
  'subscribedTopics': instance.subscribedTopics,
  'data': instance.data,
  'updatedAt': instance.updatedAt.toIso8601String(),
};
