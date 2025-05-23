// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_scan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DocumentScanModelImpl _$$DocumentScanModelImplFromJson(
  Map<String, dynamic> json,
) => _$DocumentScanModelImpl(
  id: json['id'] as String,
  originalImage: const Uint8ListConverter().fromJson(
    json['originalImage'] as String,
  ),
  processedImage: const NullableUint8ListConverter().fromJson(
    json['processedImage'] as String?,
  ),
  cropCorners:
      json['cropCorners'] == null
          ? null
          : CropCorners.fromJson(json['cropCorners'] as Map<String, dynamic>),
  appliedFilter: $enumDecodeNullable(
    _$FilterTypeEnumMap,
    json['appliedFilter'],
  ),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$DocumentScanModelImplToJson(
  _$DocumentScanModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'originalImage': const Uint8ListConverter().toJson(instance.originalImage),
  'processedImage': const NullableUint8ListConverter().toJson(
    instance.processedImage,
  ),
  'cropCorners': instance.cropCorners,
  'appliedFilter': _$FilterTypeEnumMap[instance.appliedFilter],
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$FilterTypeEnumMap = {
  FilterType.document: 'document',
  FilterType.enhance: 'enhance',
  FilterType.blackWhite: 'blackwhite',
  FilterType.original: 'original',
};

_$CropCornersImpl _$$CropCornersImplFromJson(Map<String, dynamic> json) =>
    _$CropCornersImpl(
      topLeft: Point.fromJson(json['topLeft'] as Map<String, dynamic>),
      topRight: Point.fromJson(json['topRight'] as Map<String, dynamic>),
      bottomLeft: Point.fromJson(json['bottomLeft'] as Map<String, dynamic>),
      bottomRight: Point.fromJson(json['bottomRight'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CropCornersImplToJson(_$CropCornersImpl instance) =>
    <String, dynamic>{
      'topLeft': instance.topLeft,
      'topRight': instance.topRight,
      'bottomLeft': instance.bottomLeft,
      'bottomRight': instance.bottomRight,
    };

_$PointImpl _$$PointImplFromJson(Map<String, dynamic> json) => _$PointImpl(
  x: (json['x'] as num).toDouble(),
  y: (json['y'] as num).toDouble(),
);

Map<String, dynamic> _$$PointImplToJson(_$PointImpl instance) =>
    <String, dynamic>{'x': instance.x, 'y': instance.y};
