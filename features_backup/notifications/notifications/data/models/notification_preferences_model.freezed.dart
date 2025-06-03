// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_preferences_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NotificationPreferencesModel _$NotificationPreferencesModelFromJson(
  Map<String, dynamic> json,
) {
  return _NotificationPreferencesModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationPreferencesModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  bool get enabled => throw _privateConstructorUsedError;
  bool get jobRecordCreated => throw _privateConstructorUsedError;
  bool get jobRecordUpdated => throw _privateConstructorUsedError;
  bool get timesheetReminder => throw _privateConstructorUsedError;
  bool get expenseCreated => throw _privateConstructorUsedError;
  bool get systemUpdates => throw _privateConstructorUsedError;
  String? get fcmToken => throw _privateConstructorUsedError;
  List<String>? get subscribedTopics => throw _privateConstructorUsedError;
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this NotificationPreferencesModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationPreferencesModelCopyWith<NotificationPreferencesModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationPreferencesModelCopyWith<$Res> {
  factory $NotificationPreferencesModelCopyWith(
    NotificationPreferencesModel value,
    $Res Function(NotificationPreferencesModel) then,
  ) =
      _$NotificationPreferencesModelCopyWithImpl<
        $Res,
        NotificationPreferencesModel
      >;
  @useResult
  $Res call({
    String id,
    String userId,
    bool enabled,
    bool jobRecordCreated,
    bool jobRecordUpdated,
    bool timesheetReminder,
    bool expenseCreated,
    bool systemUpdates,
    String? fcmToken,
    List<String>? subscribedTopics,
    Map<String, dynamic>? data,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$NotificationPreferencesModelCopyWithImpl<
  $Res,
  $Val extends NotificationPreferencesModel
>
    implements $NotificationPreferencesModelCopyWith<$Res> {
  _$NotificationPreferencesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? enabled = null,
    Object? jobRecordCreated = null,
    Object? jobRecordUpdated = null,
    Object? timesheetReminder = null,
    Object? expenseCreated = null,
    Object? systemUpdates = null,
    Object? fcmToken = freezed,
    Object? subscribedTopics = freezed,
    Object? data = freezed,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String,
            enabled:
                null == enabled
                    ? _value.enabled
                    : enabled // ignore: cast_nullable_to_non_nullable
                        as bool,
            jobRecordCreated:
                null == jobRecordCreated
                    ? _value.jobRecordCreated
                    : jobRecordCreated // ignore: cast_nullable_to_non_nullable
                        as bool,
            jobRecordUpdated:
                null == jobRecordUpdated
                    ? _value.jobRecordUpdated
                    : jobRecordUpdated // ignore: cast_nullable_to_non_nullable
                        as bool,
            timesheetReminder:
                null == timesheetReminder
                    ? _value.timesheetReminder
                    : timesheetReminder // ignore: cast_nullable_to_non_nullable
                        as bool,
            expenseCreated:
                null == expenseCreated
                    ? _value.expenseCreated
                    : expenseCreated // ignore: cast_nullable_to_non_nullable
                        as bool,
            systemUpdates:
                null == systemUpdates
                    ? _value.systemUpdates
                    : systemUpdates // ignore: cast_nullable_to_non_nullable
                        as bool,
            fcmToken:
                freezed == fcmToken
                    ? _value.fcmToken
                    : fcmToken // ignore: cast_nullable_to_non_nullable
                        as String?,
            subscribedTopics:
                freezed == subscribedTopics
                    ? _value.subscribedTopics
                    : subscribedTopics // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
            data:
                freezed == data
                    ? _value.data
                    : data // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
            updatedAt:
                null == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationPreferencesModelImplCopyWith<$Res>
    implements $NotificationPreferencesModelCopyWith<$Res> {
  factory _$$NotificationPreferencesModelImplCopyWith(
    _$NotificationPreferencesModelImpl value,
    $Res Function(_$NotificationPreferencesModelImpl) then,
  ) = __$$NotificationPreferencesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    bool enabled,
    bool jobRecordCreated,
    bool jobRecordUpdated,
    bool timesheetReminder,
    bool expenseCreated,
    bool systemUpdates,
    String? fcmToken,
    List<String>? subscribedTopics,
    Map<String, dynamic>? data,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$NotificationPreferencesModelImplCopyWithImpl<$Res>
    extends
        _$NotificationPreferencesModelCopyWithImpl<
          $Res,
          _$NotificationPreferencesModelImpl
        >
    implements _$$NotificationPreferencesModelImplCopyWith<$Res> {
  __$$NotificationPreferencesModelImplCopyWithImpl(
    _$NotificationPreferencesModelImpl _value,
    $Res Function(_$NotificationPreferencesModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? enabled = null,
    Object? jobRecordCreated = null,
    Object? jobRecordUpdated = null,
    Object? timesheetReminder = null,
    Object? expenseCreated = null,
    Object? systemUpdates = null,
    Object? fcmToken = freezed,
    Object? subscribedTopics = freezed,
    Object? data = freezed,
    Object? updatedAt = null,
  }) {
    return _then(
      _$NotificationPreferencesModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String,
        enabled:
            null == enabled
                ? _value.enabled
                : enabled // ignore: cast_nullable_to_non_nullable
                    as bool,
        jobRecordCreated:
            null == jobRecordCreated
                ? _value.jobRecordCreated
                : jobRecordCreated // ignore: cast_nullable_to_non_nullable
                    as bool,
        jobRecordUpdated:
            null == jobRecordUpdated
                ? _value.jobRecordUpdated
                : jobRecordUpdated // ignore: cast_nullable_to_non_nullable
                    as bool,
        timesheetReminder:
            null == timesheetReminder
                ? _value.timesheetReminder
                : timesheetReminder // ignore: cast_nullable_to_non_nullable
                    as bool,
        expenseCreated:
            null == expenseCreated
                ? _value.expenseCreated
                : expenseCreated // ignore: cast_nullable_to_non_nullable
                    as bool,
        systemUpdates:
            null == systemUpdates
                ? _value.systemUpdates
                : systemUpdates // ignore: cast_nullable_to_non_nullable
                    as bool,
        fcmToken:
            freezed == fcmToken
                ? _value.fcmToken
                : fcmToken // ignore: cast_nullable_to_non_nullable
                    as String?,
        subscribedTopics:
            freezed == subscribedTopics
                ? _value._subscribedTopics
                : subscribedTopics // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
        data:
            freezed == data
                ? _value._data
                : data // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
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
class _$NotificationPreferencesModelImpl extends _NotificationPreferencesModel {
  const _$NotificationPreferencesModelImpl({
    required this.id,
    required this.userId,
    required this.enabled,
    required this.jobRecordCreated,
    required this.jobRecordUpdated,
    required this.timesheetReminder,
    required this.expenseCreated,
    required this.systemUpdates,
    this.fcmToken,
    final List<String>? subscribedTopics,
    final Map<String, dynamic>? data,
    required this.updatedAt,
  }) : _subscribedTopics = subscribedTopics,
       _data = data,
       super._();

  factory _$NotificationPreferencesModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$NotificationPreferencesModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final bool enabled;
  @override
  final bool jobRecordCreated;
  @override
  final bool jobRecordUpdated;
  @override
  final bool timesheetReminder;
  @override
  final bool expenseCreated;
  @override
  final bool systemUpdates;
  @override
  final String? fcmToken;
  final List<String>? _subscribedTopics;
  @override
  List<String>? get subscribedTopics {
    final value = _subscribedTopics;
    if (value == null) return null;
    if (_subscribedTopics is EqualUnmodifiableListView)
      return _subscribedTopics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'NotificationPreferencesModel(id: $id, userId: $userId, enabled: $enabled, jobRecordCreated: $jobRecordCreated, jobRecordUpdated: $jobRecordUpdated, timesheetReminder: $timesheetReminder, expenseCreated: $expenseCreated, systemUpdates: $systemUpdates, fcmToken: $fcmToken, subscribedTopics: $subscribedTopics, data: $data, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationPreferencesModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.jobRecordCreated, jobRecordCreated) ||
                other.jobRecordCreated == jobRecordCreated) &&
            (identical(other.jobRecordUpdated, jobRecordUpdated) ||
                other.jobRecordUpdated == jobRecordUpdated) &&
            (identical(other.timesheetReminder, timesheetReminder) ||
                other.timesheetReminder == timesheetReminder) &&
            (identical(other.expenseCreated, expenseCreated) ||
                other.expenseCreated == expenseCreated) &&
            (identical(other.systemUpdates, systemUpdates) ||
                other.systemUpdates == systemUpdates) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken) &&
            const DeepCollectionEquality().equals(
              other._subscribedTopics,
              _subscribedTopics,
            ) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    enabled,
    jobRecordCreated,
    jobRecordUpdated,
    timesheetReminder,
    expenseCreated,
    systemUpdates,
    fcmToken,
    const DeepCollectionEquality().hash(_subscribedTopics),
    const DeepCollectionEquality().hash(_data),
    updatedAt,
  );

  /// Create a copy of NotificationPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationPreferencesModelImplCopyWith<
    _$NotificationPreferencesModelImpl
  >
  get copyWith => __$$NotificationPreferencesModelImplCopyWithImpl<
    _$NotificationPreferencesModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationPreferencesModelImplToJson(this);
  }
}

abstract class _NotificationPreferencesModel
    extends NotificationPreferencesModel {
  const factory _NotificationPreferencesModel({
    required final String id,
    required final String userId,
    required final bool enabled,
    required final bool jobRecordCreated,
    required final bool jobRecordUpdated,
    required final bool timesheetReminder,
    required final bool expenseCreated,
    required final bool systemUpdates,
    final String? fcmToken,
    final List<String>? subscribedTopics,
    final Map<String, dynamic>? data,
    required final DateTime updatedAt,
  }) = _$NotificationPreferencesModelImpl;
  const _NotificationPreferencesModel._() : super._();

  factory _NotificationPreferencesModel.fromJson(Map<String, dynamic> json) =
      _$NotificationPreferencesModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  bool get enabled;
  @override
  bool get jobRecordCreated;
  @override
  bool get jobRecordUpdated;
  @override
  bool get timesheetReminder;
  @override
  bool get expenseCreated;
  @override
  bool get systemUpdates;
  @override
  String? get fcmToken;
  @override
  List<String>? get subscribedTopics;
  @override
  Map<String, dynamic>? get data;
  @override
  DateTime get updatedAt;

  /// Create a copy of NotificationPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationPreferencesModelImplCopyWith<
    _$NotificationPreferencesModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
