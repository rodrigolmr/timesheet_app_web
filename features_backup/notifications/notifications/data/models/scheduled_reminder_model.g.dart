// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_reminder_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScheduledReminderModelImpl _$$ScheduledReminderModelImplFromJson(
  Map<String, dynamic> json,
) => _$ScheduledReminderModelImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  message: json['message'] as String,
  targetUserIds:
      (json['targetUserIds'] as List<dynamic>).map((e) => e as String).toList(),
  scheduledTime: DateTime.parse(json['scheduledTime'] as String),
  frequency: json['frequency'] as String,
  dayOfWeek: json['dayOfWeek'] as String?,
  dayOfMonth: (json['dayOfMonth'] as num?)?.toInt(),
  isActive: json['isActive'] as bool,
  createdBy: json['createdBy'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  lastSentAt:
      json['lastSentAt'] == null
          ? null
          : DateTime.parse(json['lastSentAt'] as String),
  nextSendAt:
      json['nextSendAt'] == null
          ? null
          : DateTime.parse(json['nextSendAt'] as String),
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$ScheduledReminderModelImplToJson(
  _$ScheduledReminderModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'message': instance.message,
  'targetUserIds': instance.targetUserIds,
  'scheduledTime': instance.scheduledTime.toIso8601String(),
  'frequency': instance.frequency,
  'dayOfWeek': instance.dayOfWeek,
  'dayOfMonth': instance.dayOfMonth,
  'isActive': instance.isActive,
  'createdBy': instance.createdBy,
  'createdAt': instance.createdAt.toIso8601String(),
  'lastSentAt': instance.lastSentAt?.toIso8601String(),
  'nextSendAt': instance.nextSendAt?.toIso8601String(),
  'metadata': instance.metadata,
};
