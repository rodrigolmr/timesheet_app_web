// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'database_stats_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DatabaseStatsModel _$DatabaseStatsModelFromJson(Map<String, dynamic> json) {
  return _DatabaseStatsModel.fromJson(json);
}

/// @nodoc
mixin _$DatabaseStatsModel {
  String get collectionName => throw _privateConstructorUsedError;
  int get documentCount => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;
  int get approximateSizeInBytes => throw _privateConstructorUsedError;

  /// Serializes this DatabaseStatsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DatabaseStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DatabaseStatsModelCopyWith<DatabaseStatsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DatabaseStatsModelCopyWith<$Res> {
  factory $DatabaseStatsModelCopyWith(
    DatabaseStatsModel value,
    $Res Function(DatabaseStatsModel) then,
  ) = _$DatabaseStatsModelCopyWithImpl<$Res, DatabaseStatsModel>;
  @useResult
  $Res call({
    String collectionName,
    int documentCount,
    DateTime? lastUpdated,
    int approximateSizeInBytes,
  });
}

/// @nodoc
class _$DatabaseStatsModelCopyWithImpl<$Res, $Val extends DatabaseStatsModel>
    implements $DatabaseStatsModelCopyWith<$Res> {
  _$DatabaseStatsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DatabaseStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? collectionName = null,
    Object? documentCount = null,
    Object? lastUpdated = freezed,
    Object? approximateSizeInBytes = null,
  }) {
    return _then(
      _value.copyWith(
            collectionName:
                null == collectionName
                    ? _value.collectionName
                    : collectionName // ignore: cast_nullable_to_non_nullable
                        as String,
            documentCount:
                null == documentCount
                    ? _value.documentCount
                    : documentCount // ignore: cast_nullable_to_non_nullable
                        as int,
            lastUpdated:
                freezed == lastUpdated
                    ? _value.lastUpdated
                    : lastUpdated // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            approximateSizeInBytes:
                null == approximateSizeInBytes
                    ? _value.approximateSizeInBytes
                    : approximateSizeInBytes // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DatabaseStatsModelImplCopyWith<$Res>
    implements $DatabaseStatsModelCopyWith<$Res> {
  factory _$$DatabaseStatsModelImplCopyWith(
    _$DatabaseStatsModelImpl value,
    $Res Function(_$DatabaseStatsModelImpl) then,
  ) = __$$DatabaseStatsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String collectionName,
    int documentCount,
    DateTime? lastUpdated,
    int approximateSizeInBytes,
  });
}

/// @nodoc
class __$$DatabaseStatsModelImplCopyWithImpl<$Res>
    extends _$DatabaseStatsModelCopyWithImpl<$Res, _$DatabaseStatsModelImpl>
    implements _$$DatabaseStatsModelImplCopyWith<$Res> {
  __$$DatabaseStatsModelImplCopyWithImpl(
    _$DatabaseStatsModelImpl _value,
    $Res Function(_$DatabaseStatsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DatabaseStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? collectionName = null,
    Object? documentCount = null,
    Object? lastUpdated = freezed,
    Object? approximateSizeInBytes = null,
  }) {
    return _then(
      _$DatabaseStatsModelImpl(
        collectionName:
            null == collectionName
                ? _value.collectionName
                : collectionName // ignore: cast_nullable_to_non_nullable
                    as String,
        documentCount:
            null == documentCount
                ? _value.documentCount
                : documentCount // ignore: cast_nullable_to_non_nullable
                    as int,
        lastUpdated:
            freezed == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        approximateSizeInBytes:
            null == approximateSizeInBytes
                ? _value.approximateSizeInBytes
                : approximateSizeInBytes // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DatabaseStatsModelImpl extends _DatabaseStatsModel {
  const _$DatabaseStatsModelImpl({
    required this.collectionName,
    required this.documentCount,
    required this.lastUpdated,
    required this.approximateSizeInBytes,
  }) : super._();

  factory _$DatabaseStatsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DatabaseStatsModelImplFromJson(json);

  @override
  final String collectionName;
  @override
  final int documentCount;
  @override
  final DateTime? lastUpdated;
  @override
  final int approximateSizeInBytes;

  @override
  String toString() {
    return 'DatabaseStatsModel(collectionName: $collectionName, documentCount: $documentCount, lastUpdated: $lastUpdated, approximateSizeInBytes: $approximateSizeInBytes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DatabaseStatsModelImpl &&
            (identical(other.collectionName, collectionName) ||
                other.collectionName == collectionName) &&
            (identical(other.documentCount, documentCount) ||
                other.documentCount == documentCount) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.approximateSizeInBytes, approximateSizeInBytes) ||
                other.approximateSizeInBytes == approximateSizeInBytes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    collectionName,
    documentCount,
    lastUpdated,
    approximateSizeInBytes,
  );

  /// Create a copy of DatabaseStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DatabaseStatsModelImplCopyWith<_$DatabaseStatsModelImpl> get copyWith =>
      __$$DatabaseStatsModelImplCopyWithImpl<_$DatabaseStatsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DatabaseStatsModelImplToJson(this);
  }
}

abstract class _DatabaseStatsModel extends DatabaseStatsModel {
  const factory _DatabaseStatsModel({
    required final String collectionName,
    required final int documentCount,
    required final DateTime? lastUpdated,
    required final int approximateSizeInBytes,
  }) = _$DatabaseStatsModelImpl;
  const _DatabaseStatsModel._() : super._();

  factory _DatabaseStatsModel.fromJson(Map<String, dynamic> json) =
      _$DatabaseStatsModelImpl.fromJson;

  @override
  String get collectionName;
  @override
  int get documentCount;
  @override
  DateTime? get lastUpdated;
  @override
  int get approximateSizeInBytes;

  /// Create a copy of DatabaseStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DatabaseStatsModelImplCopyWith<_$DatabaseStatsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DatabaseCollectionModel _$DatabaseCollectionModelFromJson(
  Map<String, dynamic> json,
) {
  return _DatabaseCollectionModel.fromJson(json);
}

/// @nodoc
mixin _$DatabaseCollectionModel {
  String get name => throw _privateConstructorUsedError;
  int get documentCount => throw _privateConstructorUsedError;
  List<String> get fields => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this DatabaseCollectionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DatabaseCollectionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DatabaseCollectionModelCopyWith<DatabaseCollectionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DatabaseCollectionModelCopyWith<$Res> {
  factory $DatabaseCollectionModelCopyWith(
    DatabaseCollectionModel value,
    $Res Function(DatabaseCollectionModel) then,
  ) = _$DatabaseCollectionModelCopyWithImpl<$Res, DatabaseCollectionModel>;
  @useResult
  $Res call({
    String name,
    int documentCount,
    List<String> fields,
    DateTime? lastUpdated,
  });
}

/// @nodoc
class _$DatabaseCollectionModelCopyWithImpl<
  $Res,
  $Val extends DatabaseCollectionModel
>
    implements $DatabaseCollectionModelCopyWith<$Res> {
  _$DatabaseCollectionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DatabaseCollectionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? documentCount = null,
    Object? fields = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(
      _value.copyWith(
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            documentCount:
                null == documentCount
                    ? _value.documentCount
                    : documentCount // ignore: cast_nullable_to_non_nullable
                        as int,
            fields:
                null == fields
                    ? _value.fields
                    : fields // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            lastUpdated:
                freezed == lastUpdated
                    ? _value.lastUpdated
                    : lastUpdated // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DatabaseCollectionModelImplCopyWith<$Res>
    implements $DatabaseCollectionModelCopyWith<$Res> {
  factory _$$DatabaseCollectionModelImplCopyWith(
    _$DatabaseCollectionModelImpl value,
    $Res Function(_$DatabaseCollectionModelImpl) then,
  ) = __$$DatabaseCollectionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    int documentCount,
    List<String> fields,
    DateTime? lastUpdated,
  });
}

/// @nodoc
class __$$DatabaseCollectionModelImplCopyWithImpl<$Res>
    extends
        _$DatabaseCollectionModelCopyWithImpl<
          $Res,
          _$DatabaseCollectionModelImpl
        >
    implements _$$DatabaseCollectionModelImplCopyWith<$Res> {
  __$$DatabaseCollectionModelImplCopyWithImpl(
    _$DatabaseCollectionModelImpl _value,
    $Res Function(_$DatabaseCollectionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DatabaseCollectionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? documentCount = null,
    Object? fields = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(
      _$DatabaseCollectionModelImpl(
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        documentCount:
            null == documentCount
                ? _value.documentCount
                : documentCount // ignore: cast_nullable_to_non_nullable
                    as int,
        fields:
            null == fields
                ? _value._fields
                : fields // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        lastUpdated:
            freezed == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DatabaseCollectionModelImpl extends _DatabaseCollectionModel {
  const _$DatabaseCollectionModelImpl({
    required this.name,
    required this.documentCount,
    required final List<String> fields,
    required this.lastUpdated,
  }) : _fields = fields,
       super._();

  factory _$DatabaseCollectionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DatabaseCollectionModelImplFromJson(json);

  @override
  final String name;
  @override
  final int documentCount;
  final List<String> _fields;
  @override
  List<String> get fields {
    if (_fields is EqualUnmodifiableListView) return _fields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fields);
  }

  @override
  final DateTime? lastUpdated;

  @override
  String toString() {
    return 'DatabaseCollectionModel(name: $name, documentCount: $documentCount, fields: $fields, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DatabaseCollectionModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.documentCount, documentCount) ||
                other.documentCount == documentCount) &&
            const DeepCollectionEquality().equals(other._fields, _fields) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    documentCount,
    const DeepCollectionEquality().hash(_fields),
    lastUpdated,
  );

  /// Create a copy of DatabaseCollectionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DatabaseCollectionModelImplCopyWith<_$DatabaseCollectionModelImpl>
  get copyWith => __$$DatabaseCollectionModelImplCopyWithImpl<
    _$DatabaseCollectionModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DatabaseCollectionModelImplToJson(this);
  }
}

abstract class _DatabaseCollectionModel extends DatabaseCollectionModel {
  const factory _DatabaseCollectionModel({
    required final String name,
    required final int documentCount,
    required final List<String> fields,
    required final DateTime? lastUpdated,
  }) = _$DatabaseCollectionModelImpl;
  const _DatabaseCollectionModel._() : super._();

  factory _DatabaseCollectionModel.fromJson(Map<String, dynamic> json) =
      _$DatabaseCollectionModelImpl.fromJson;

  @override
  String get name;
  @override
  int get documentCount;
  @override
  List<String> get fields;
  @override
  DateTime? get lastUpdated;

  /// Create a copy of DatabaseCollectionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DatabaseCollectionModelImplCopyWith<_$DatabaseCollectionModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
