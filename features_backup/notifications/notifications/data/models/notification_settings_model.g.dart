// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationSettingsModelImpl _$$NotificationSettingsModelImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationSettingsModelImpl(
  id: json['id'] as String,
  rolePermissions: (json['rolePermissions'] as Map<String, dynamic>).map(
    (k, e) =>
        MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
  ),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  updatedBy: json['updatedBy'] as String?,
);

Map<String, dynamic> _$$NotificationSettingsModelImplToJson(
  _$NotificationSettingsModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'rolePermissions': instance.rolePermissions,
  'updatedAt': instance.updatedAt.toIso8601String(),
  'updatedBy': instance.updatedBy,
};
