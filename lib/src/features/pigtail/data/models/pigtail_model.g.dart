// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pigtail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PigtailItemImpl _$$PigtailItemImplFromJson(Map<String, dynamic> json) =>
    _$PigtailItemImpl(
      type: json['type'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$$PigtailItemImplToJson(_$PigtailItemImpl instance) =>
    <String, dynamic>{'type': instance.type, 'quantity': instance.quantity};

_$PigtailModelImpl _$$PigtailModelImplFromJson(Map<String, dynamic> json) =>
    _$PigtailModelImpl(
      id: json['id'] as String,
      jobName: json['jobName'] as String,
      address: json['address'] as String,
      pigtailItems:
          (json['pigtailItems'] as List<dynamic>)
              .map((e) => PigtailItem.fromJson(e as Map<String, dynamic>))
              .toList(),
      installedBy: json['installedBy'] as String,
      installedDate: DateTime.parse(json['installedDate'] as String),
      isRemoved: json['isRemoved'] as bool,
      removedDate:
          json['removedDate'] == null
              ? null
              : DateTime.parse(json['removedDate'] as String),
      removedBy: json['removedBy'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$PigtailModelImplToJson(_$PigtailModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'jobName': instance.jobName,
      'address': instance.address,
      'pigtailItems': instance.pigtailItems,
      'installedBy': instance.installedBy,
      'installedDate': instance.installedDate.toIso8601String(),
      'isRemoved': instance.isRemoved,
      'removedDate': instance.removedDate?.toIso8601String(),
      'removedBy': instance.removedBy,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
