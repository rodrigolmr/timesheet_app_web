// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NotificationSettingsModel _$NotificationSettingsModelFromJson(
  Map<String, dynamic> json,
) {
  return _NotificationSettingsModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationSettingsModel {
  String get id => throw _privateConstructorUsedError;
  Map<String, List<String>> get rolePermissions =>
      throw _privateConstructorUsedError; // notification_type -> [roles]
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get updatedBy => throw _privateConstructorUsedError;

  /// Serializes this NotificationSettingsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationSettingsModelCopyWith<NotificationSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationSettingsModelCopyWith<$Res> {
  factory $NotificationSettingsModelCopyWith(
    NotificationSettingsModel value,
    $Res Function(NotificationSettingsModel) then,
  ) = _$NotificationSettingsModelCopyWithImpl<$Res, NotificationSettingsModel>;
  @useResult
  $Res call({
    String id,
    Map<String, List<String>> rolePermissions,
    DateTime updatedAt,
    String? updatedBy,
  });
}

/// @nodoc
class _$NotificationSettingsModelCopyWithImpl<
  $Res,
  $Val extends NotificationSettingsModel
>
    implements $NotificationSettingsModelCopyWith<$Res> {
  _$NotificationSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rolePermissions = null,
    Object? updatedAt = null,
    Object? updatedBy = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            rolePermissions:
                null == rolePermissions
                    ? _value.rolePermissions
                    : rolePermissions // ignore: cast_nullable_to_non_nullable
                        as Map<String, List<String>>,
            updatedAt:
                null == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            updatedBy:
                freezed == updatedBy
                    ? _value.updatedBy
                    : updatedBy // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationSettingsModelImplCopyWith<$Res>
    implements $NotificationSettingsModelCopyWith<$Res> {
  factory _$$NotificationSettingsModelImplCopyWith(
    _$NotificationSettingsModelImpl value,
    $Res Function(_$NotificationSettingsModelImpl) then,
  ) = __$$NotificationSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    Map<String, List<String>> rolePermissions,
    DateTime updatedAt,
    String? updatedBy,
  });
}

/// @nodoc
class __$$NotificationSettingsModelImplCopyWithImpl<$Res>
    extends
        _$NotificationSettingsModelCopyWithImpl<
          $Res,
          _$NotificationSettingsModelImpl
        >
    implements _$$NotificationSettingsModelImplCopyWith<$Res> {
  __$$NotificationSettingsModelImplCopyWithImpl(
    _$NotificationSettingsModelImpl _value,
    $Res Function(_$NotificationSettingsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rolePermissions = null,
    Object? updatedAt = null,
    Object? updatedBy = freezed,
  }) {
    return _then(
      _$NotificationSettingsModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        rolePermissions:
            null == rolePermissions
                ? _value._rolePermissions
                : rolePermissions // ignore: cast_nullable_to_non_nullable
                    as Map<String, List<String>>,
        updatedAt:
            null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        updatedBy:
            freezed == updatedBy
                ? _value.updatedBy
                : updatedBy // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationSettingsModelImpl extends _NotificationSettingsModel {
  const _$NotificationSettingsModelImpl({
    required this.id,
    required final Map<String, List<String>> rolePermissions,
    required this.updatedAt,
    this.updatedBy,
  }) : _rolePermissions = rolePermissions,
       super._();

  factory _$NotificationSettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationSettingsModelImplFromJson(json);

  @override
  final String id;
  final Map<String, List<String>> _rolePermissions;
  @override
  Map<String, List<String>> get rolePermissions {
    if (_rolePermissions is EqualUnmodifiableMapView) return _rolePermissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_rolePermissions);
  }

  // notification_type -> [roles]
  @override
  final DateTime updatedAt;
  @override
  final String? updatedBy;

  @override
  String toString() {
    return 'NotificationSettingsModel(id: $id, rolePermissions: $rolePermissions, updatedAt: $updatedAt, updatedBy: $updatedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationSettingsModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(
              other._rolePermissions,
              _rolePermissions,
            ) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    const DeepCollectionEquality().hash(_rolePermissions),
    updatedAt,
    updatedBy,
  );

  /// Create a copy of NotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationSettingsModelImplCopyWith<_$NotificationSettingsModelImpl>
  get copyWith => __$$NotificationSettingsModelImplCopyWithImpl<
    _$NotificationSettingsModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationSettingsModelImplToJson(this);
  }
}

abstract class _NotificationSettingsModel extends NotificationSettingsModel {
  const factory _NotificationSettingsModel({
    required final String id,
    required final Map<String, List<String>> rolePermissions,
    required final DateTime updatedAt,
    final String? updatedBy,
  }) = _$NotificationSettingsModelImpl;
  const _NotificationSettingsModel._() : super._();

  factory _NotificationSettingsModel.fromJson(Map<String, dynamic> json) =
      _$NotificationSettingsModelImpl.fromJson;

  @override
  String get id;
  @override
  Map<String, List<String>> get rolePermissions; // notification_type -> [roles]
  @override
  DateTime get updatedAt;
  @override
  String? get updatedBy;

  /// Create a copy of NotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationSettingsModelImplCopyWith<_$NotificationSettingsModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
