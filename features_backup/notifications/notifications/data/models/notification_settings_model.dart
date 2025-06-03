import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'notification_settings_model.freezed.dart';
part 'notification_settings_model.g.dart';

@freezed
class NotificationSettingsModel with _$NotificationSettingsModel {
  const NotificationSettingsModel._();
  
  const factory NotificationSettingsModel({
    required String id,
    required Map<String, List<String>> rolePermissions, // notification_type -> [roles]
    required DateTime updatedAt,
    String? updatedBy,
  }) = _NotificationSettingsModel;

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) => 
      _$NotificationSettingsModelFromJson(json);

  factory NotificationSettingsModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return NotificationSettingsModel(
      id: doc.id,
      rolePermissions: Map<String, List<String>>.from(
        data['role_permissions'].map((key, value) => 
          MapEntry(key, List<String>.from(value))
        ),
      ),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
      updatedBy: data['updated_by'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'role_permissions': rolePermissions,
      'updated_at': Timestamp.fromDate(updatedAt),
      'updated_by': updatedBy,
    };
  }

  // Default settings
  factory NotificationSettingsModel.defaultSettings() {
    return NotificationSettingsModel(
      id: 'default',
      rolePermissions: {
        'job_record_created': ['admin', 'manager'],
        'job_record_updated': ['admin', 'manager'],
        'timesheet_reminder': ['admin', 'manager', 'user'],
        'system_updates': ['admin'],
      },
      updatedAt: DateTime.now(),
    );
  }

  // Check if a role can receive a notification type
  bool canRoleReceiveNotification(String role, String notificationType) {
    final allowedRoles = rolePermissions[notificationType] ?? [];
    return allowedRoles.contains(role);
  }
}