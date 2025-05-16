// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_employee_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

JobEmployeeModel _$JobEmployeeModelFromJson(Map<String, dynamic> json) {
  return _JobEmployeeModel.fromJson(json);
}

/// @nodoc
mixin _$JobEmployeeModel {
  String get employeeId => throw _privateConstructorUsedError;
  String get employeeName => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  String get finishTime => throw _privateConstructorUsedError;
  double get hours => throw _privateConstructorUsedError;
  double get travelHours => throw _privateConstructorUsedError;
  double get meal => throw _privateConstructorUsedError;

  /// Serializes this JobEmployeeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JobEmployeeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JobEmployeeModelCopyWith<JobEmployeeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobEmployeeModelCopyWith<$Res> {
  factory $JobEmployeeModelCopyWith(
    JobEmployeeModel value,
    $Res Function(JobEmployeeModel) then,
  ) = _$JobEmployeeModelCopyWithImpl<$Res, JobEmployeeModel>;
  @useResult
  $Res call({
    String employeeId,
    String employeeName,
    String startTime,
    String finishTime,
    double hours,
    double travelHours,
    double meal,
  });
}

/// @nodoc
class _$JobEmployeeModelCopyWithImpl<$Res, $Val extends JobEmployeeModel>
    implements $JobEmployeeModelCopyWith<$Res> {
  _$JobEmployeeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JobEmployeeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? employeeName = null,
    Object? startTime = null,
    Object? finishTime = null,
    Object? hours = null,
    Object? travelHours = null,
    Object? meal = null,
  }) {
    return _then(
      _value.copyWith(
            employeeId:
                null == employeeId
                    ? _value.employeeId
                    : employeeId // ignore: cast_nullable_to_non_nullable
                        as String,
            employeeName:
                null == employeeName
                    ? _value.employeeName
                    : employeeName // ignore: cast_nullable_to_non_nullable
                        as String,
            startTime:
                null == startTime
                    ? _value.startTime
                    : startTime // ignore: cast_nullable_to_non_nullable
                        as String,
            finishTime:
                null == finishTime
                    ? _value.finishTime
                    : finishTime // ignore: cast_nullable_to_non_nullable
                        as String,
            hours:
                null == hours
                    ? _value.hours
                    : hours // ignore: cast_nullable_to_non_nullable
                        as double,
            travelHours:
                null == travelHours
                    ? _value.travelHours
                    : travelHours // ignore: cast_nullable_to_non_nullable
                        as double,
            meal:
                null == meal
                    ? _value.meal
                    : meal // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$JobEmployeeModelImplCopyWith<$Res>
    implements $JobEmployeeModelCopyWith<$Res> {
  factory _$$JobEmployeeModelImplCopyWith(
    _$JobEmployeeModelImpl value,
    $Res Function(_$JobEmployeeModelImpl) then,
  ) = __$$JobEmployeeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String employeeId,
    String employeeName,
    String startTime,
    String finishTime,
    double hours,
    double travelHours,
    double meal,
  });
}

/// @nodoc
class __$$JobEmployeeModelImplCopyWithImpl<$Res>
    extends _$JobEmployeeModelCopyWithImpl<$Res, _$JobEmployeeModelImpl>
    implements _$$JobEmployeeModelImplCopyWith<$Res> {
  __$$JobEmployeeModelImplCopyWithImpl(
    _$JobEmployeeModelImpl _value,
    $Res Function(_$JobEmployeeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JobEmployeeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? employeeName = null,
    Object? startTime = null,
    Object? finishTime = null,
    Object? hours = null,
    Object? travelHours = null,
    Object? meal = null,
  }) {
    return _then(
      _$JobEmployeeModelImpl(
        employeeId:
            null == employeeId
                ? _value.employeeId
                : employeeId // ignore: cast_nullable_to_non_nullable
                    as String,
        employeeName:
            null == employeeName
                ? _value.employeeName
                : employeeName // ignore: cast_nullable_to_non_nullable
                    as String,
        startTime:
            null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                    as String,
        finishTime:
            null == finishTime
                ? _value.finishTime
                : finishTime // ignore: cast_nullable_to_non_nullable
                    as String,
        hours:
            null == hours
                ? _value.hours
                : hours // ignore: cast_nullable_to_non_nullable
                    as double,
        travelHours:
            null == travelHours
                ? _value.travelHours
                : travelHours // ignore: cast_nullable_to_non_nullable
                    as double,
        meal:
            null == meal
                ? _value.meal
                : meal // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$JobEmployeeModelImpl extends _JobEmployeeModel {
  const _$JobEmployeeModelImpl({
    required this.employeeId,
    required this.employeeName,
    required this.startTime,
    required this.finishTime,
    required this.hours,
    required this.travelHours,
    required this.meal,
  }) : super._();

  factory _$JobEmployeeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$JobEmployeeModelImplFromJson(json);

  @override
  final String employeeId;
  @override
  final String employeeName;
  @override
  final String startTime;
  @override
  final String finishTime;
  @override
  final double hours;
  @override
  final double travelHours;
  @override
  final double meal;

  @override
  String toString() {
    return 'JobEmployeeModel(employeeId: $employeeId, employeeName: $employeeName, startTime: $startTime, finishTime: $finishTime, hours: $hours, travelHours: $travelHours, meal: $meal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobEmployeeModelImpl &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.employeeName, employeeName) ||
                other.employeeName == employeeName) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.finishTime, finishTime) ||
                other.finishTime == finishTime) &&
            (identical(other.hours, hours) || other.hours == hours) &&
            (identical(other.travelHours, travelHours) ||
                other.travelHours == travelHours) &&
            (identical(other.meal, meal) || other.meal == meal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    employeeId,
    employeeName,
    startTime,
    finishTime,
    hours,
    travelHours,
    meal,
  );

  /// Create a copy of JobEmployeeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JobEmployeeModelImplCopyWith<_$JobEmployeeModelImpl> get copyWith =>
      __$$JobEmployeeModelImplCopyWithImpl<_$JobEmployeeModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$JobEmployeeModelImplToJson(this);
  }
}

abstract class _JobEmployeeModel extends JobEmployeeModel {
  const factory _JobEmployeeModel({
    required final String employeeId,
    required final String employeeName,
    required final String startTime,
    required final String finishTime,
    required final double hours,
    required final double travelHours,
    required final double meal,
  }) = _$JobEmployeeModelImpl;
  const _JobEmployeeModel._() : super._();

  factory _JobEmployeeModel.fromJson(Map<String, dynamic> json) =
      _$JobEmployeeModelImpl.fromJson;

  @override
  String get employeeId;
  @override
  String get employeeName;
  @override
  String get startTime;
  @override
  String get finishTime;
  @override
  double get hours;
  @override
  double get travelHours;
  @override
  double get meal;

  /// Create a copy of JobEmployeeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JobEmployeeModelImplCopyWith<_$JobEmployeeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
