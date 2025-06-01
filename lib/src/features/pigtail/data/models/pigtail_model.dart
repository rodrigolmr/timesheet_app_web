import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pigtail_model.freezed.dart';
part 'pigtail_model.g.dart';

@freezed
class PigtailItem with _$PigtailItem {
  const factory PigtailItem({
    required String type,
    required int quantity,
  }) = _PigtailItem;

  factory PigtailItem.fromJson(Map<String, dynamic> json) => 
      _$PigtailItemFromJson(json);
}

@freezed
class PigtailModel with _$PigtailModel {
  const PigtailModel._();
  
  const factory PigtailModel({
    required String id,
    required String jobName,
    required String address,
    required List<PigtailItem> pigtailItems,
    required String installedBy,
    required DateTime installedDate,
    required bool isRemoved,
    DateTime? removedDate,
    String? removedBy,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PigtailModel;

  factory PigtailModel.fromJson(Map<String, dynamic> json) => 
      _$PigtailModelFromJson(json);

  factory PigtailModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return PigtailModel(
      id: doc.id,
      jobName: data['job_name'] as String,
      address: data['address'] as String,
      pigtailItems: (data['pigtail_items'] as List)
          .map((item) => PigtailItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      installedBy: data['installed_by'] as String,
      installedDate: (data['installed_date'] as Timestamp).toDate(),
      isRemoved: data['is_removed'] as bool? ?? false,
      removedDate: data['removed_date'] != null 
          ? (data['removed_date'] as Timestamp).toDate() 
          : null,
      removedBy: data['removed_by'] as String?,
      notes: data['notes'] as String?,
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'job_name': jobName,
      'address': address,
      'pigtail_items': pigtailItems.map((item) => item.toJson()).toList(),
      'installed_by': installedBy,
      'installed_date': Timestamp.fromDate(installedDate),
      'is_removed': isRemoved,
      'removed_date': removedDate != null ? Timestamp.fromDate(removedDate!) : null,
      'removed_by': removedBy,
      'notes': notes,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }
}