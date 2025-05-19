// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DatabaseStatsModelImpl _$$DatabaseStatsModelImplFromJson(
  Map<String, dynamic> json,
) => _$DatabaseStatsModelImpl(
  collectionName: json['collectionName'] as String,
  documentCount: (json['documentCount'] as num).toInt(),
  lastUpdated:
      json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
  approximateSizeInBytes: (json['approximateSizeInBytes'] as num).toInt(),
);

Map<String, dynamic> _$$DatabaseStatsModelImplToJson(
  _$DatabaseStatsModelImpl instance,
) => <String, dynamic>{
  'collectionName': instance.collectionName,
  'documentCount': instance.documentCount,
  'lastUpdated': instance.lastUpdated?.toIso8601String(),
  'approximateSizeInBytes': instance.approximateSizeInBytes,
};

_$DatabaseCollectionModelImpl _$$DatabaseCollectionModelImplFromJson(
  Map<String, dynamic> json,
) => _$DatabaseCollectionModelImpl(
  name: json['name'] as String,
  documentCount: (json['documentCount'] as num).toInt(),
  fields: (json['fields'] as List<dynamic>).map((e) => e as String).toList(),
  lastUpdated:
      json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
);

Map<String, dynamic> _$$DatabaseCollectionModelImplToJson(
  _$DatabaseCollectionModelImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'documentCount': instance.documentCount,
  'fields': instance.fields,
  'lastUpdated': instance.lastUpdated?.toIso8601String(),
};
