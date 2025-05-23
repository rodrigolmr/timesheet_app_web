import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:typed_data';
import 'dart:convert';

part 'document_scan_model.freezed.dart';
part 'document_scan_model.g.dart';

class Uint8ListConverter implements JsonConverter<Uint8List, String> {
  const Uint8ListConverter();

  @override
  Uint8List fromJson(String json) => base64Decode(json);

  @override
  String toJson(Uint8List object) => base64Encode(object);
}

class NullableUint8ListConverter implements JsonConverter<Uint8List?, String?> {
  const NullableUint8ListConverter();

  @override
  Uint8List? fromJson(String? json) => json != null ? base64Decode(json) : null;

  @override
  String? toJson(Uint8List? object) => object != null ? base64Encode(object) : null;
}

@freezed
class DocumentScanModel with _$DocumentScanModel {
  const DocumentScanModel._();

  const factory DocumentScanModel({
    required String id,
    @Uint8ListConverter() required Uint8List originalImage,
    @NullableUint8ListConverter() Uint8List? processedImage,
    CropCorners? cropCorners,
    FilterType? appliedFilter,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DocumentScanModel;

  factory DocumentScanModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentScanModelFromJson(json);
}

@freezed
class CropCorners with _$CropCorners {
  const factory CropCorners({
    required Point topLeft,
    required Point topRight,
    required Point bottomLeft,
    required Point bottomRight,
  }) = _CropCorners;

  factory CropCorners.fromJson(Map<String, dynamic> json) =>
      _$CropCornersFromJson(json);
}

@freezed
class Point with _$Point {
  const factory Point({
    required double x,
    required double y,
  }) = _Point;

  factory Point.fromJson(Map<String, dynamic> json) => _$PointFromJson(json);
}

enum FilterType {
  @JsonValue('document')
  document,
  @JsonValue('enhance')
  enhance,
  @JsonValue('blackwhite')
  blackWhite,
  @JsonValue('original')
  original,
}