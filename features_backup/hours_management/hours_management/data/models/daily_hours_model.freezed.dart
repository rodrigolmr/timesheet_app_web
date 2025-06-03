// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_hours_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DailyHoursModel _$DailyHoursModelFromJson(Map<String, dynamic> json) {
  return _DailyHoursModel.fromJson(json);
}

/// @nodoc
mixin _$DailyHoursModel {
  DateTime get date => throw _privateConstructorUsedError;
  String get employeeId => throw _privateConstructorUsedError;
  String get employeeName => throw _privateConstructorUsedError;
  double get regularHours => throw _privateConstructorUsedError;
  double get travelHours => throw _privateConstructorUsedError;
  double get totalHours => throw _privateConstructorUsedError;
  List<JobRecordSummary> get jobRecords => throw _privateConstructorUsedError;

  /// Serializes this DailyHoursModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyHoursModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyHoursModelCopyWith<DailyHoursModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyHoursModelCopyWith<$Res> {
  factory $DailyHoursModelCopyWith(
    DailyHoursModel value,
    $Res Function(DailyHoursModel) then,
  ) = _$DailyHoursModelCopyWithImpl<$Res, DailyHoursModel>;
  @useResult
  $Res call({
    DateTime date,
    String employeeId,
    String employeeName,
    double regularHours,
    double travelHours,
    double totalHours,
    List<JobRecordSummary> jobRecords,
  });
}

/// @nodoc
class _$DailyHoursModelCopyWithImpl<$Res, $Val extends DailyHoursModel>
    implements $DailyHoursModelCopyWith<$Res> {
  _$DailyHoursModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyHoursModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? employeeId = null,
    Object? employeeName = null,
    Object? regularHours = null,
    Object? travelHours = null,
    Object? totalHours = null,
    Object? jobRecords = null,
  }) {
    return _then(
      _value.copyWith(
            date:
                null == date
                    ? _value.date
                    : date // ignore: cast_nullable_to_non_nullable
                        as DateTime,
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
            regularHours:
                null == regularHours
                    ? _value.regularHours
                    : regularHours // ignore: cast_nullable_to_non_nullable
                        as double,
            travelHours:
                null == travelHours
                    ? _value.travelHours
                    : travelHours // ignore: cast_nullable_to_non_nullable
                        as double,
            totalHours:
                null == totalHours
                    ? _value.totalHours
                    : totalHours // ignore: cast_nullable_to_non_nullable
                        as double,
            jobRecords:
                null == jobRecords
                    ? _value.jobRecords
                    : jobRecords // ignore: cast_nullable_to_non_nullable
                        as List<JobRecordSummary>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailyHoursModelImplCopyWith<$Res>
    implements $DailyHoursModelCopyWith<$Res> {
  factory _$$DailyHoursModelImplCopyWith(
    _$DailyHoursModelImpl value,
    $Res Function(_$DailyHoursModelImpl) then,
  ) = __$$DailyHoursModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime date,
    String employeeId,
    String employeeName,
    double regularHours,
    double travelHours,
    double totalHours,
    List<JobRecordSummary> jobRecords,
  });
}

/// @nodoc
class __$$DailyHoursModelImplCopyWithImpl<$Res>
    extends _$DailyHoursModelCopyWithImpl<$Res, _$DailyHoursModelImpl>
    implements _$$DailyHoursModelImplCopyWith<$Res> {
  __$$DailyHoursModelImplCopyWithImpl(
    _$DailyHoursModelImpl _value,
    $Res Function(_$DailyHoursModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyHoursModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? employeeId = null,
    Object? employeeName = null,
    Object? regularHours = null,
    Object? travelHours = null,
    Object? totalHours = null,
    Object? jobRecords = null,
  }) {
    return _then(
      _$DailyHoursModelImpl(
        date:
            null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                    as DateTime,
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
        regularHours:
            null == regularHours
                ? _value.regularHours
                : regularHours // ignore: cast_nullable_to_non_nullable
                    as double,
        travelHours:
            null == travelHours
                ? _value.travelHours
                : travelHours // ignore: cast_nullable_to_non_nullable
                    as double,
        totalHours:
            null == totalHours
                ? _value.totalHours
                : totalHours // ignore: cast_nullable_to_non_nullable
                    as double,
        jobRecords:
            null == jobRecords
                ? _value._jobRecords
                : jobRecords // ignore: cast_nullable_to_non_nullable
                    as List<JobRecordSummary>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyHoursModelImpl extends _DailyHoursModel {
  const _$DailyHoursModelImpl({
    required this.date,
    required this.employeeId,
    required this.employeeName,
    required this.regularHours,
    required this.travelHours,
    required this.totalHours,
    required final List<JobRecordSummary> jobRecords,
  }) : _jobRecords = jobRecords,
       super._();

  factory _$DailyHoursModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyHoursModelImplFromJson(json);

  @override
  final DateTime date;
  @override
  final String employeeId;
  @override
  final String employeeName;
  @override
  final double regularHours;
  @override
  final double travelHours;
  @override
  final double totalHours;
  final List<JobRecordSummary> _jobRecords;
  @override
  List<JobRecordSummary> get jobRecords {
    if (_jobRecords is EqualUnmodifiableListView) return _jobRecords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_jobRecords);
  }

  @override
  String toString() {
    return 'DailyHoursModel(date: $date, employeeId: $employeeId, employeeName: $employeeName, regularHours: $regularHours, travelHours: $travelHours, totalHours: $totalHours, jobRecords: $jobRecords)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyHoursModelImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.employeeName, employeeName) ||
                other.employeeName == employeeName) &&
            (identical(other.regularHours, regularHours) ||
                other.regularHours == regularHours) &&
            (identical(other.travelHours, travelHours) ||
                other.travelHours == travelHours) &&
            (identical(other.totalHours, totalHours) ||
                other.totalHours == totalHours) &&
            const DeepCollectionEquality().equals(
              other._jobRecords,
              _jobRecords,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    date,
    employeeId,
    employeeName,
    regularHours,
    travelHours,
    totalHours,
    const DeepCollectionEquality().hash(_jobRecords),
  );

  /// Create a copy of DailyHoursModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyHoursModelImplCopyWith<_$DailyHoursModelImpl> get copyWith =>
      __$$DailyHoursModelImplCopyWithImpl<_$DailyHoursModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyHoursModelImplToJson(this);
  }
}

abstract class _DailyHoursModel extends DailyHoursModel {
  const factory _DailyHoursModel({
    required final DateTime date,
    required final String employeeId,
    required final String employeeName,
    required final double regularHours,
    required final double travelHours,
    required final double totalHours,
    required final List<JobRecordSummary> jobRecords,
  }) = _$DailyHoursModelImpl;
  const _DailyHoursModel._() : super._();

  factory _DailyHoursModel.fromJson(Map<String, dynamic> json) =
      _$DailyHoursModelImpl.fromJson;

  @override
  DateTime get date;
  @override
  String get employeeId;
  @override
  String get employeeName;
  @override
  double get regularHours;
  @override
  double get travelHours;
  @override
  double get totalHours;
  @override
  List<JobRecordSummary> get jobRecords;

  /// Create a copy of DailyHoursModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyHoursModelImplCopyWith<_$DailyHoursModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

JobRecordSummary _$JobRecordSummaryFromJson(Map<String, dynamic> json) {
  return _JobRecordSummary.fromJson(json);
}

/// @nodoc
mixin _$JobRecordSummary {
  String get jobRecordId => throw _privateConstructorUsedError;
  String get jobName => throw _privateConstructorUsedError;
  double get regularHours => throw _privateConstructorUsedError;
  double get travelHours => throw _privateConstructorUsedError;

  /// Serializes this JobRecordSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JobRecordSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JobRecordSummaryCopyWith<JobRecordSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobRecordSummaryCopyWith<$Res> {
  factory $JobRecordSummaryCopyWith(
    JobRecordSummary value,
    $Res Function(JobRecordSummary) then,
  ) = _$JobRecordSummaryCopyWithImpl<$Res, JobRecordSummary>;
  @useResult
  $Res call({
    String jobRecordId,
    String jobName,
    double regularHours,
    double travelHours,
  });
}

/// @nodoc
class _$JobRecordSummaryCopyWithImpl<$Res, $Val extends JobRecordSummary>
    implements $JobRecordSummaryCopyWith<$Res> {
  _$JobRecordSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JobRecordSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jobRecordId = null,
    Object? jobName = null,
    Object? regularHours = null,
    Object? travelHours = null,
  }) {
    return _then(
      _value.copyWith(
            jobRecordId:
                null == jobRecordId
                    ? _value.jobRecordId
                    : jobRecordId // ignore: cast_nullable_to_non_nullable
                        as String,
            jobName:
                null == jobName
                    ? _value.jobName
                    : jobName // ignore: cast_nullable_to_non_nullable
                        as String,
            regularHours:
                null == regularHours
                    ? _value.regularHours
                    : regularHours // ignore: cast_nullable_to_non_nullable
                        as double,
            travelHours:
                null == travelHours
                    ? _value.travelHours
                    : travelHours // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$JobRecordSummaryImplCopyWith<$Res>
    implements $JobRecordSummaryCopyWith<$Res> {
  factory _$$JobRecordSummaryImplCopyWith(
    _$JobRecordSummaryImpl value,
    $Res Function(_$JobRecordSummaryImpl) then,
  ) = __$$JobRecordSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String jobRecordId,
    String jobName,
    double regularHours,
    double travelHours,
  });
}

/// @nodoc
class __$$JobRecordSummaryImplCopyWithImpl<$Res>
    extends _$JobRecordSummaryCopyWithImpl<$Res, _$JobRecordSummaryImpl>
    implements _$$JobRecordSummaryImplCopyWith<$Res> {
  __$$JobRecordSummaryImplCopyWithImpl(
    _$JobRecordSummaryImpl _value,
    $Res Function(_$JobRecordSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JobRecordSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jobRecordId = null,
    Object? jobName = null,
    Object? regularHours = null,
    Object? travelHours = null,
  }) {
    return _then(
      _$JobRecordSummaryImpl(
        jobRecordId:
            null == jobRecordId
                ? _value.jobRecordId
                : jobRecordId // ignore: cast_nullable_to_non_nullable
                    as String,
        jobName:
            null == jobName
                ? _value.jobName
                : jobName // ignore: cast_nullable_to_non_nullable
                    as String,
        regularHours:
            null == regularHours
                ? _value.regularHours
                : regularHours // ignore: cast_nullable_to_non_nullable
                    as double,
        travelHours:
            null == travelHours
                ? _value.travelHours
                : travelHours // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$JobRecordSummaryImpl implements _JobRecordSummary {
  const _$JobRecordSummaryImpl({
    required this.jobRecordId,
    required this.jobName,
    required this.regularHours,
    required this.travelHours,
  });

  factory _$JobRecordSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$JobRecordSummaryImplFromJson(json);

  @override
  final String jobRecordId;
  @override
  final String jobName;
  @override
  final double regularHours;
  @override
  final double travelHours;

  @override
  String toString() {
    return 'JobRecordSummary(jobRecordId: $jobRecordId, jobName: $jobName, regularHours: $regularHours, travelHours: $travelHours)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobRecordSummaryImpl &&
            (identical(other.jobRecordId, jobRecordId) ||
                other.jobRecordId == jobRecordId) &&
            (identical(other.jobName, jobName) || other.jobName == jobName) &&
            (identical(other.regularHours, regularHours) ||
                other.regularHours == regularHours) &&
            (identical(other.travelHours, travelHours) ||
                other.travelHours == travelHours));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, jobRecordId, jobName, regularHours, travelHours);

  /// Create a copy of JobRecordSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JobRecordSummaryImplCopyWith<_$JobRecordSummaryImpl> get copyWith =>
      __$$JobRecordSummaryImplCopyWithImpl<_$JobRecordSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$JobRecordSummaryImplToJson(this);
  }
}

abstract class _JobRecordSummary implements JobRecordSummary {
  const factory _JobRecordSummary({
    required final String jobRecordId,
    required final String jobName,
    required final double regularHours,
    required final double travelHours,
  }) = _$JobRecordSummaryImpl;

  factory _JobRecordSummary.fromJson(Map<String, dynamic> json) =
      _$JobRecordSummaryImpl.fromJson;

  @override
  String get jobRecordId;
  @override
  String get jobName;
  @override
  double get regularHours;
  @override
  double get travelHours;

  /// Create a copy of JobRecordSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JobRecordSummaryImplCopyWith<_$JobRecordSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
