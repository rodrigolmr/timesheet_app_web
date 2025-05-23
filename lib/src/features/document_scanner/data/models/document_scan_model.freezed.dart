// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_scan_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DocumentScanModel _$DocumentScanModelFromJson(Map<String, dynamic> json) {
  return _DocumentScanModel.fromJson(json);
}

/// @nodoc
mixin _$DocumentScanModel {
  String get id => throw _privateConstructorUsedError;
  @Uint8ListConverter()
  Uint8List get originalImage => throw _privateConstructorUsedError;
  @NullableUint8ListConverter()
  Uint8List? get processedImage => throw _privateConstructorUsedError;
  CropCorners? get cropCorners => throw _privateConstructorUsedError;
  FilterType? get appliedFilter => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this DocumentScanModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DocumentScanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DocumentScanModelCopyWith<DocumentScanModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DocumentScanModelCopyWith<$Res> {
  factory $DocumentScanModelCopyWith(
    DocumentScanModel value,
    $Res Function(DocumentScanModel) then,
  ) = _$DocumentScanModelCopyWithImpl<$Res, DocumentScanModel>;
  @useResult
  $Res call({
    String id,
    @Uint8ListConverter() Uint8List originalImage,
    @NullableUint8ListConverter() Uint8List? processedImage,
    CropCorners? cropCorners,
    FilterType? appliedFilter,
    DateTime createdAt,
    DateTime updatedAt,
  });

  $CropCornersCopyWith<$Res>? get cropCorners;
}

/// @nodoc
class _$DocumentScanModelCopyWithImpl<$Res, $Val extends DocumentScanModel>
    implements $DocumentScanModelCopyWith<$Res> {
  _$DocumentScanModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DocumentScanModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? originalImage = null,
    Object? processedImage = freezed,
    Object? cropCorners = freezed,
    Object? appliedFilter = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            originalImage:
                null == originalImage
                    ? _value.originalImage
                    : originalImage // ignore: cast_nullable_to_non_nullable
                        as Uint8List,
            processedImage:
                freezed == processedImage
                    ? _value.processedImage
                    : processedImage // ignore: cast_nullable_to_non_nullable
                        as Uint8List?,
            cropCorners:
                freezed == cropCorners
                    ? _value.cropCorners
                    : cropCorners // ignore: cast_nullable_to_non_nullable
                        as CropCorners?,
            appliedFilter:
                freezed == appliedFilter
                    ? _value.appliedFilter
                    : appliedFilter // ignore: cast_nullable_to_non_nullable
                        as FilterType?,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            updatedAt:
                null == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of DocumentScanModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CropCornersCopyWith<$Res>? get cropCorners {
    if (_value.cropCorners == null) {
      return null;
    }

    return $CropCornersCopyWith<$Res>(_value.cropCorners!, (value) {
      return _then(_value.copyWith(cropCorners: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DocumentScanModelImplCopyWith<$Res>
    implements $DocumentScanModelCopyWith<$Res> {
  factory _$$DocumentScanModelImplCopyWith(
    _$DocumentScanModelImpl value,
    $Res Function(_$DocumentScanModelImpl) then,
  ) = __$$DocumentScanModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @Uint8ListConverter() Uint8List originalImage,
    @NullableUint8ListConverter() Uint8List? processedImage,
    CropCorners? cropCorners,
    FilterType? appliedFilter,
    DateTime createdAt,
    DateTime updatedAt,
  });

  @override
  $CropCornersCopyWith<$Res>? get cropCorners;
}

/// @nodoc
class __$$DocumentScanModelImplCopyWithImpl<$Res>
    extends _$DocumentScanModelCopyWithImpl<$Res, _$DocumentScanModelImpl>
    implements _$$DocumentScanModelImplCopyWith<$Res> {
  __$$DocumentScanModelImplCopyWithImpl(
    _$DocumentScanModelImpl _value,
    $Res Function(_$DocumentScanModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentScanModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? originalImage = null,
    Object? processedImage = freezed,
    Object? cropCorners = freezed,
    Object? appliedFilter = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$DocumentScanModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        originalImage:
            null == originalImage
                ? _value.originalImage
                : originalImage // ignore: cast_nullable_to_non_nullable
                    as Uint8List,
        processedImage:
            freezed == processedImage
                ? _value.processedImage
                : processedImage // ignore: cast_nullable_to_non_nullable
                    as Uint8List?,
        cropCorners:
            freezed == cropCorners
                ? _value.cropCorners
                : cropCorners // ignore: cast_nullable_to_non_nullable
                    as CropCorners?,
        appliedFilter:
            freezed == appliedFilter
                ? _value.appliedFilter
                : appliedFilter // ignore: cast_nullable_to_non_nullable
                    as FilterType?,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        updatedAt:
            null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DocumentScanModelImpl extends _DocumentScanModel {
  const _$DocumentScanModelImpl({
    required this.id,
    @Uint8ListConverter() required this.originalImage,
    @NullableUint8ListConverter() this.processedImage,
    this.cropCorners,
    this.appliedFilter,
    required this.createdAt,
    required this.updatedAt,
  }) : super._();

  factory _$DocumentScanModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DocumentScanModelImplFromJson(json);

  @override
  final String id;
  @override
  @Uint8ListConverter()
  final Uint8List originalImage;
  @override
  @NullableUint8ListConverter()
  final Uint8List? processedImage;
  @override
  final CropCorners? cropCorners;
  @override
  final FilterType? appliedFilter;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'DocumentScanModel(id: $id, originalImage: $originalImage, processedImage: $processedImage, cropCorners: $cropCorners, appliedFilter: $appliedFilter, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentScanModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(
              other.originalImage,
              originalImage,
            ) &&
            const DeepCollectionEquality().equals(
              other.processedImage,
              processedImage,
            ) &&
            (identical(other.cropCorners, cropCorners) ||
                other.cropCorners == cropCorners) &&
            (identical(other.appliedFilter, appliedFilter) ||
                other.appliedFilter == appliedFilter) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    const DeepCollectionEquality().hash(originalImage),
    const DeepCollectionEquality().hash(processedImage),
    cropCorners,
    appliedFilter,
    createdAt,
    updatedAt,
  );

  /// Create a copy of DocumentScanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentScanModelImplCopyWith<_$DocumentScanModelImpl> get copyWith =>
      __$$DocumentScanModelImplCopyWithImpl<_$DocumentScanModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DocumentScanModelImplToJson(this);
  }
}

abstract class _DocumentScanModel extends DocumentScanModel {
  const factory _DocumentScanModel({
    required final String id,
    @Uint8ListConverter() required final Uint8List originalImage,
    @NullableUint8ListConverter() final Uint8List? processedImage,
    final CropCorners? cropCorners,
    final FilterType? appliedFilter,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$DocumentScanModelImpl;
  const _DocumentScanModel._() : super._();

  factory _DocumentScanModel.fromJson(Map<String, dynamic> json) =
      _$DocumentScanModelImpl.fromJson;

  @override
  String get id;
  @override
  @Uint8ListConverter()
  Uint8List get originalImage;
  @override
  @NullableUint8ListConverter()
  Uint8List? get processedImage;
  @override
  CropCorners? get cropCorners;
  @override
  FilterType? get appliedFilter;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of DocumentScanModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DocumentScanModelImplCopyWith<_$DocumentScanModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CropCorners _$CropCornersFromJson(Map<String, dynamic> json) {
  return _CropCorners.fromJson(json);
}

/// @nodoc
mixin _$CropCorners {
  Point get topLeft => throw _privateConstructorUsedError;
  Point get topRight => throw _privateConstructorUsedError;
  Point get bottomLeft => throw _privateConstructorUsedError;
  Point get bottomRight => throw _privateConstructorUsedError;

  /// Serializes this CropCorners to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CropCorners
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CropCornersCopyWith<CropCorners> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CropCornersCopyWith<$Res> {
  factory $CropCornersCopyWith(
    CropCorners value,
    $Res Function(CropCorners) then,
  ) = _$CropCornersCopyWithImpl<$Res, CropCorners>;
  @useResult
  $Res call({
    Point topLeft,
    Point topRight,
    Point bottomLeft,
    Point bottomRight,
  });

  $PointCopyWith<$Res> get topLeft;
  $PointCopyWith<$Res> get topRight;
  $PointCopyWith<$Res> get bottomLeft;
  $PointCopyWith<$Res> get bottomRight;
}

/// @nodoc
class _$CropCornersCopyWithImpl<$Res, $Val extends CropCorners>
    implements $CropCornersCopyWith<$Res> {
  _$CropCornersCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CropCorners
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topLeft = null,
    Object? topRight = null,
    Object? bottomLeft = null,
    Object? bottomRight = null,
  }) {
    return _then(
      _value.copyWith(
            topLeft:
                null == topLeft
                    ? _value.topLeft
                    : topLeft // ignore: cast_nullable_to_non_nullable
                        as Point,
            topRight:
                null == topRight
                    ? _value.topRight
                    : topRight // ignore: cast_nullable_to_non_nullable
                        as Point,
            bottomLeft:
                null == bottomLeft
                    ? _value.bottomLeft
                    : bottomLeft // ignore: cast_nullable_to_non_nullable
                        as Point,
            bottomRight:
                null == bottomRight
                    ? _value.bottomRight
                    : bottomRight // ignore: cast_nullable_to_non_nullable
                        as Point,
          )
          as $Val,
    );
  }

  /// Create a copy of CropCorners
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PointCopyWith<$Res> get topLeft {
    return $PointCopyWith<$Res>(_value.topLeft, (value) {
      return _then(_value.copyWith(topLeft: value) as $Val);
    });
  }

  /// Create a copy of CropCorners
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PointCopyWith<$Res> get topRight {
    return $PointCopyWith<$Res>(_value.topRight, (value) {
      return _then(_value.copyWith(topRight: value) as $Val);
    });
  }

  /// Create a copy of CropCorners
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PointCopyWith<$Res> get bottomLeft {
    return $PointCopyWith<$Res>(_value.bottomLeft, (value) {
      return _then(_value.copyWith(bottomLeft: value) as $Val);
    });
  }

  /// Create a copy of CropCorners
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PointCopyWith<$Res> get bottomRight {
    return $PointCopyWith<$Res>(_value.bottomRight, (value) {
      return _then(_value.copyWith(bottomRight: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CropCornersImplCopyWith<$Res>
    implements $CropCornersCopyWith<$Res> {
  factory _$$CropCornersImplCopyWith(
    _$CropCornersImpl value,
    $Res Function(_$CropCornersImpl) then,
  ) = __$$CropCornersImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Point topLeft,
    Point topRight,
    Point bottomLeft,
    Point bottomRight,
  });

  @override
  $PointCopyWith<$Res> get topLeft;
  @override
  $PointCopyWith<$Res> get topRight;
  @override
  $PointCopyWith<$Res> get bottomLeft;
  @override
  $PointCopyWith<$Res> get bottomRight;
}

/// @nodoc
class __$$CropCornersImplCopyWithImpl<$Res>
    extends _$CropCornersCopyWithImpl<$Res, _$CropCornersImpl>
    implements _$$CropCornersImplCopyWith<$Res> {
  __$$CropCornersImplCopyWithImpl(
    _$CropCornersImpl _value,
    $Res Function(_$CropCornersImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CropCorners
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topLeft = null,
    Object? topRight = null,
    Object? bottomLeft = null,
    Object? bottomRight = null,
  }) {
    return _then(
      _$CropCornersImpl(
        topLeft:
            null == topLeft
                ? _value.topLeft
                : topLeft // ignore: cast_nullable_to_non_nullable
                    as Point,
        topRight:
            null == topRight
                ? _value.topRight
                : topRight // ignore: cast_nullable_to_non_nullable
                    as Point,
        bottomLeft:
            null == bottomLeft
                ? _value.bottomLeft
                : bottomLeft // ignore: cast_nullable_to_non_nullable
                    as Point,
        bottomRight:
            null == bottomRight
                ? _value.bottomRight
                : bottomRight // ignore: cast_nullable_to_non_nullable
                    as Point,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CropCornersImpl implements _CropCorners {
  const _$CropCornersImpl({
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
  });

  factory _$CropCornersImpl.fromJson(Map<String, dynamic> json) =>
      _$$CropCornersImplFromJson(json);

  @override
  final Point topLeft;
  @override
  final Point topRight;
  @override
  final Point bottomLeft;
  @override
  final Point bottomRight;

  @override
  String toString() {
    return 'CropCorners(topLeft: $topLeft, topRight: $topRight, bottomLeft: $bottomLeft, bottomRight: $bottomRight)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CropCornersImpl &&
            (identical(other.topLeft, topLeft) || other.topLeft == topLeft) &&
            (identical(other.topRight, topRight) ||
                other.topRight == topRight) &&
            (identical(other.bottomLeft, bottomLeft) ||
                other.bottomLeft == bottomLeft) &&
            (identical(other.bottomRight, bottomRight) ||
                other.bottomRight == bottomRight));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, topLeft, topRight, bottomLeft, bottomRight);

  /// Create a copy of CropCorners
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CropCornersImplCopyWith<_$CropCornersImpl> get copyWith =>
      __$$CropCornersImplCopyWithImpl<_$CropCornersImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CropCornersImplToJson(this);
  }
}

abstract class _CropCorners implements CropCorners {
  const factory _CropCorners({
    required final Point topLeft,
    required final Point topRight,
    required final Point bottomLeft,
    required final Point bottomRight,
  }) = _$CropCornersImpl;

  factory _CropCorners.fromJson(Map<String, dynamic> json) =
      _$CropCornersImpl.fromJson;

  @override
  Point get topLeft;
  @override
  Point get topRight;
  @override
  Point get bottomLeft;
  @override
  Point get bottomRight;

  /// Create a copy of CropCorners
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CropCornersImplCopyWith<_$CropCornersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Point _$PointFromJson(Map<String, dynamic> json) {
  return _Point.fromJson(json);
}

/// @nodoc
mixin _$Point {
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;

  /// Serializes this Point to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Point
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PointCopyWith<Point> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PointCopyWith<$Res> {
  factory $PointCopyWith(Point value, $Res Function(Point) then) =
      _$PointCopyWithImpl<$Res, Point>;
  @useResult
  $Res call({double x, double y});
}

/// @nodoc
class _$PointCopyWithImpl<$Res, $Val extends Point>
    implements $PointCopyWith<$Res> {
  _$PointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Point
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? x = null, Object? y = null}) {
    return _then(
      _value.copyWith(
            x:
                null == x
                    ? _value.x
                    : x // ignore: cast_nullable_to_non_nullable
                        as double,
            y:
                null == y
                    ? _value.y
                    : y // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PointImplCopyWith<$Res> implements $PointCopyWith<$Res> {
  factory _$$PointImplCopyWith(
    _$PointImpl value,
    $Res Function(_$PointImpl) then,
  ) = __$$PointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double x, double y});
}

/// @nodoc
class __$$PointImplCopyWithImpl<$Res>
    extends _$PointCopyWithImpl<$Res, _$PointImpl>
    implements _$$PointImplCopyWith<$Res> {
  __$$PointImplCopyWithImpl(
    _$PointImpl _value,
    $Res Function(_$PointImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Point
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? x = null, Object? y = null}) {
    return _then(
      _$PointImpl(
        x:
            null == x
                ? _value.x
                : x // ignore: cast_nullable_to_non_nullable
                    as double,
        y:
            null == y
                ? _value.y
                : y // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PointImpl implements _Point {
  const _$PointImpl({required this.x, required this.y});

  factory _$PointImpl.fromJson(Map<String, dynamic> json) =>
      _$$PointImplFromJson(json);

  @override
  final double x;
  @override
  final double y;

  @override
  String toString() {
    return 'Point(x: $x, y: $y)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PointImpl &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, x, y);

  /// Create a copy of Point
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PointImplCopyWith<_$PointImpl> get copyWith =>
      __$$PointImplCopyWithImpl<_$PointImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PointImplToJson(this);
  }
}

abstract class _Point implements Point {
  const factory _Point({required final double x, required final double y}) =
      _$PointImpl;

  factory _Point.fromJson(Map<String, dynamic> json) = _$PointImpl.fromJson;

  @override
  double get x;
  @override
  double get y;

  /// Create a copy of Point
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PointImplCopyWith<_$PointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
