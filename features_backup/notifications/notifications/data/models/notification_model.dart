import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const NotificationModel._();
  
  const factory NotificationModel({
    required String id,
    required String userId,
    required String title,
    required String body,
    String? imageUrl,
    required String type,
    Map<String, dynamic>? data,
    required bool isRead,
    DateTime? readAt,
    required DateTime createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => 
      _$NotificationModelFromJson(json);

  factory NotificationModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return NotificationModel(
      id: doc.id,
      userId: data['user_id'] as String,
      title: data['title'] as String,
      body: data['body'] as String,
      imageUrl: data['image_url'] as String?,
      type: data['type'] as String,
      data: data['data'] as Map<String, dynamic>?,
      isRead: data['is_read'] as bool? ?? false,
      readAt: data['read_at'] != null 
          ? (data['read_at'] as Timestamp).toDate() 
          : null,
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'title': title,
      'body': body,
      'image_url': imageUrl,
      'type': type,
      'data': data,
      'is_read': isRead,
      'read_at': readAt != null ? Timestamp.fromDate(readAt!) : null,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }
}