// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scheduled_reminder_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ScheduledReminderModel _$ScheduledReminderModelFromJson(
  Map<String, dynamic> json,
) {
  return _ScheduledReminderModel.fromJson(json);
}

/// @nodoc
mixin _$ScheduledReminderModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  List<String> get targetUserIds =>
      throw _privateConstructorUsedError; // Lista de IDs de usuários que receberão o lembrete
  DateTime get scheduledTime =>
      throw _privateConstructorUsedError; // Hora específica para enviar
  String get frequency =>
      throw _privateConstructorUsedError; // 'once', 'daily', 'weekly', 'monthly'
  String? get dayOfWeek =>
      throw _privateConstructorUsedError; // Para lembretes semanais (1-7, onde 1 = segunda)
  int? get dayOfMonth =>
      throw _privateConstructorUsedError; // Para lembretes mensais (1-31)
  bool get isActive => throw _privateConstructorUsedError;
  String get createdBy =>
      throw _privateConstructorUsedError; // ID do admin que criou
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get lastSentAt =>
      throw _privateConstructorUsedError; // Última vez que foi enviado
  DateTime? get nextSendAt =>
      throw _privateConstructorUsedError; // Próxima vez que será enviado
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this ScheduledReminderModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScheduledReminderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduledReminderModelCopyWith<ScheduledReminderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduledReminderModelCopyWith<$Res> {
  factory $ScheduledReminderModelCopyWith(
    ScheduledReminderModel value,
    $Res Function(ScheduledReminderModel) then,
  ) = _$ScheduledReminderModelCopyWithImpl<$Res, ScheduledReminderModel>;
  @useResult
  $Res call({
    String id,
    String title,
    String message,
    List<String> targetUserIds,
    DateTime scheduledTime,
    String frequency,
    String? dayOfWeek,
    int? dayOfMonth,
    bool isActive,
    String createdBy,
    DateTime createdAt,
    DateTime? lastSentAt,
    DateTime? nextSendAt,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class _$ScheduledReminderModelCopyWithImpl<
  $Res,
  $Val extends ScheduledReminderModel
>
    implements $ScheduledReminderModelCopyWith<$Res> {
  _$ScheduledReminderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScheduledReminderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? message = null,
    Object? targetUserIds = null,
    Object? scheduledTime = null,
    Object? frequency = null,
    Object? dayOfWeek = freezed,
    Object? dayOfMonth = freezed,
    Object? isActive = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? lastSentAt = freezed,
    Object? nextSendAt = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            message:
                null == message
                    ? _value.message
                    : message // ignore: cast_nullable_to_non_nullable
                        as String,
            targetUserIds:
                null == targetUserIds
                    ? _value.targetUserIds
                    : targetUserIds // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            scheduledTime:
                null == scheduledTime
                    ? _value.scheduledTime
                    : scheduledTime // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            frequency:
                null == frequency
                    ? _value.frequency
                    : frequency // ignore: cast_nullable_to_non_nullable
                        as String,
            dayOfWeek:
                freezed == dayOfWeek
                    ? _value.dayOfWeek
                    : dayOfWeek // ignore: cast_nullable_to_non_nullable
                        as String?,
            dayOfMonth:
                freezed == dayOfMonth
                    ? _value.dayOfMonth
                    : dayOfMonth // ignore: cast_nullable_to_non_nullable
                        as int?,
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
            createdBy:
                null == createdBy
                    ? _value.createdBy
                    : createdBy // ignore: cast_nullable_to_non_nullable
                        as String,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            lastSentAt:
                freezed == lastSentAt
                    ? _value.lastSentAt
                    : lastSentAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            nextSendAt:
                freezed == nextSendAt
                    ? _value.nextSendAt
                    : nextSendAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            metadata:
                freezed == metadata
                    ? _value.metadata
                    : metadata // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScheduledReminderModelImplCopyWith<$Res>
    implements $ScheduledReminderModelCopyWith<$Res> {
  factory _$$ScheduledReminderModelImplCopyWith(
    _$ScheduledReminderModelImpl value,
    $Res Function(_$ScheduledReminderModelImpl) then,
  ) = __$$ScheduledReminderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String message,
    List<String> targetUserIds,
    DateTime scheduledTime,
    String frequency,
    String? dayOfWeek,
    int? dayOfMonth,
    bool isActive,
    String createdBy,
    DateTime createdAt,
    DateTime? lastSentAt,
    DateTime? nextSendAt,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class __$$ScheduledReminderModelImplCopyWithImpl<$Res>
    extends
        _$ScheduledReminderModelCopyWithImpl<$Res, _$ScheduledReminderModelImpl>
    implements _$$ScheduledReminderModelImplCopyWith<$Res> {
  __$$ScheduledReminderModelImplCopyWithImpl(
    _$ScheduledReminderModelImpl _value,
    $Res Function(_$ScheduledReminderModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScheduledReminderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? message = null,
    Object? targetUserIds = null,
    Object? scheduledTime = null,
    Object? frequency = null,
    Object? dayOfWeek = freezed,
    Object? dayOfMonth = freezed,
    Object? isActive = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? lastSentAt = freezed,
    Object? nextSendAt = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _$ScheduledReminderModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        message:
            null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String,
        targetUserIds:
            null == targetUserIds
                ? _value._targetUserIds
                : targetUserIds // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        scheduledTime:
            null == scheduledTime
                ? _value.scheduledTime
                : scheduledTime // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        frequency:
            null == frequency
                ? _value.frequency
                : frequency // ignore: cast_nullable_to_non_nullable
                    as String,
        dayOfWeek:
            freezed == dayOfWeek
                ? _value.dayOfWeek
                : dayOfWeek // ignore: cast_nullable_to_non_nullable
                    as String?,
        dayOfMonth:
            freezed == dayOfMonth
                ? _value.dayOfMonth
                : dayOfMonth // ignore: cast_nullable_to_non_nullable
                    as int?,
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
        createdBy:
            null == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                    as String,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        lastSentAt:
            freezed == lastSentAt
                ? _value.lastSentAt
                : lastSentAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        nextSendAt:
            freezed == nextSendAt
                ? _value.nextSendAt
                : nextSendAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        metadata:
            freezed == metadata
                ? _value._metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ScheduledReminderModelImpl extends _ScheduledReminderModel {
  const _$ScheduledReminderModelImpl({
    required this.id,
    required this.title,
    required this.message,
    required final List<String> targetUserIds,
    required this.scheduledTime,
    required this.frequency,
    this.dayOfWeek,
    this.dayOfMonth,
    required this.isActive,
    required this.createdBy,
    required this.createdAt,
    this.lastSentAt,
    this.nextSendAt,
    final Map<String, dynamic>? metadata,
  }) : _targetUserIds = targetUserIds,
       _metadata = metadata,
       super._();

  factory _$ScheduledReminderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScheduledReminderModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String message;
  final List<String> _targetUserIds;
  @override
  List<String> get targetUserIds {
    if (_targetUserIds is EqualUnmodifiableListView) return _targetUserIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_targetUserIds);
  }

  // Lista de IDs de usuários que receberão o lembrete
  @override
  final DateTime scheduledTime;
  // Hora específica para enviar
  @override
  final String frequency;
  // 'once', 'daily', 'weekly', 'monthly'
  @override
  final String? dayOfWeek;
  // Para lembretes semanais (1-7, onde 1 = segunda)
  @override
  final int? dayOfMonth;
  // Para lembretes mensais (1-31)
  @override
  final bool isActive;
  @override
  final String createdBy;
  // ID do admin que criou
  @override
  final DateTime createdAt;
  @override
  final DateTime? lastSentAt;
  // Última vez que foi enviado
  @override
  final DateTime? nextSendAt;
  // Próxima vez que será enviado
  final Map<String, dynamic>? _metadata;
  // Próxima vez que será enviado
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ScheduledReminderModel(id: $id, title: $title, message: $message, targetUserIds: $targetUserIds, scheduledTime: $scheduledTime, frequency: $frequency, dayOfWeek: $dayOfWeek, dayOfMonth: $dayOfMonth, isActive: $isActive, createdBy: $createdBy, createdAt: $createdAt, lastSentAt: $lastSentAt, nextSendAt: $nextSendAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduledReminderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(
              other._targetUserIds,
              _targetUserIds,
            ) &&
            (identical(other.scheduledTime, scheduledTime) ||
                other.scheduledTime == scheduledTime) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            (identical(other.dayOfMonth, dayOfMonth) ||
                other.dayOfMonth == dayOfMonth) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastSentAt, lastSentAt) ||
                other.lastSentAt == lastSentAt) &&
            (identical(other.nextSendAt, nextSendAt) ||
                other.nextSendAt == nextSendAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    message,
    const DeepCollectionEquality().hash(_targetUserIds),
    scheduledTime,
    frequency,
    dayOfWeek,
    dayOfMonth,
    isActive,
    createdBy,
    createdAt,
    lastSentAt,
    nextSendAt,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of ScheduledReminderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduledReminderModelImplCopyWith<_$ScheduledReminderModelImpl>
  get copyWith =>
      __$$ScheduledReminderModelImplCopyWithImpl<_$ScheduledReminderModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ScheduledReminderModelImplToJson(this);
  }
}

abstract class _ScheduledReminderModel extends ScheduledReminderModel {
  const factory _ScheduledReminderModel({
    required final String id,
    required final String title,
    required final String message,
    required final List<String> targetUserIds,
    required final DateTime scheduledTime,
    required final String frequency,
    final String? dayOfWeek,
    final int? dayOfMonth,
    required final bool isActive,
    required final String createdBy,
    required final DateTime createdAt,
    final DateTime? lastSentAt,
    final DateTime? nextSendAt,
    final Map<String, dynamic>? metadata,
  }) = _$ScheduledReminderModelImpl;
  const _ScheduledReminderModel._() : super._();

  factory _ScheduledReminderModel.fromJson(Map<String, dynamic> json) =
      _$ScheduledReminderModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get message;
  @override
  List<String> get targetUserIds; // Lista de IDs de usuários que receberão o lembrete
  @override
  DateTime get scheduledTime; // Hora específica para enviar
  @override
  String get frequency; // 'once', 'daily', 'weekly', 'monthly'
  @override
  String? get dayOfWeek; // Para lembretes semanais (1-7, onde 1 = segunda)
  @override
  int? get dayOfMonth; // Para lembretes mensais (1-31)
  @override
  bool get isActive;
  @override
  String get createdBy; // ID do admin que criou
  @override
  DateTime get createdAt;
  @override
  DateTime? get lastSentAt; // Última vez que foi enviado
  @override
  DateTime? get nextSendAt; // Próxima vez que será enviado
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of ScheduledReminderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduledReminderModelImplCopyWith<_$ScheduledReminderModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
