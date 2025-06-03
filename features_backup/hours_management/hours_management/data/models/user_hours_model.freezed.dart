// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_hours_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserHoursModel _$UserHoursModelFromJson(Map<String, dynamic> json) {
  return _UserHoursModel.fromJson(json);
}

/// @nodoc
mixin _$UserHoursModel {
  DateTime get date => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  double get regularHours => throw _privateConstructorUsedError;
  double get travelHours => throw _privateConstructorUsedError;
  double get totalHours => throw _privateConstructorUsedError;
  List<JobRecordDetail> get jobRecords => throw _privateConstructorUsedError;

  /// Serializes this UserHoursModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserHoursModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserHoursModelCopyWith<UserHoursModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserHoursModelCopyWith<$Res> {
  factory $UserHoursModelCopyWith(
    UserHoursModel value,
    $Res Function(UserHoursModel) then,
  ) = _$UserHoursModelCopyWithImpl<$Res, UserHoursModel>;
  @useResult
  $Res call({
    DateTime date,
    String userId,
    String userName,
    double regularHours,
    double travelHours,
    double totalHours,
    List<JobRecordDetail> jobRecords,
  });
}

/// @nodoc
class _$UserHoursModelCopyWithImpl<$Res, $Val extends UserHoursModel>
    implements $UserHoursModelCopyWith<$Res> {
  _$UserHoursModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserHoursModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? userId = null,
    Object? userName = null,
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
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String,
            userName:
                null == userName
                    ? _value.userName
                    : userName // ignore: cast_nullable_to_non_nullable
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
                        as List<JobRecordDetail>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserHoursModelImplCopyWith<$Res>
    implements $UserHoursModelCopyWith<$Res> {
  factory _$$UserHoursModelImplCopyWith(
    _$UserHoursModelImpl value,
    $Res Function(_$UserHoursModelImpl) then,
  ) = __$$UserHoursModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime date,
    String userId,
    String userName,
    double regularHours,
    double travelHours,
    double totalHours,
    List<JobRecordDetail> jobRecords,
  });
}

/// @nodoc
class __$$UserHoursModelImplCopyWithImpl<$Res>
    extends _$UserHoursModelCopyWithImpl<$Res, _$UserHoursModelImpl>
    implements _$$UserHoursModelImplCopyWith<$Res> {
  __$$UserHoursModelImplCopyWithImpl(
    _$UserHoursModelImpl _value,
    $Res Function(_$UserHoursModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserHoursModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? userId = null,
    Object? userName = null,
    Object? regularHours = null,
    Object? travelHours = null,
    Object? totalHours = null,
    Object? jobRecords = null,
  }) {
    return _then(
      _$UserHoursModelImpl(
        date:
            null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String,
        userName:
            null == userName
                ? _value.userName
                : userName // ignore: cast_nullable_to_non_nullable
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
                    as List<JobRecordDetail>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserHoursModelImpl extends _UserHoursModel {
  const _$UserHoursModelImpl({
    required this.date,
    required this.userId,
    required this.userName,
    required this.regularHours,
    required this.travelHours,
    required this.totalHours,
    required final List<JobRecordDetail> jobRecords,
  }) : _jobRecords = jobRecords,
       super._();

  factory _$UserHoursModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserHoursModelImplFromJson(json);

  @override
  final DateTime date;
  @override
  final String userId;
  @override
  final String userName;
  @override
  final double regularHours;
  @override
  final double travelHours;
  @override
  final double totalHours;
  final List<JobRecordDetail> _jobRecords;
  @override
  List<JobRecordDetail> get jobRecords {
    if (_jobRecords is EqualUnmodifiableListView) return _jobRecords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_jobRecords);
  }

  @override
  String toString() {
    return 'UserHoursModel(date: $date, userId: $userId, userName: $userName, regularHours: $regularHours, travelHours: $travelHours, totalHours: $totalHours, jobRecords: $jobRecords)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserHoursModelImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
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
    userId,
    userName,
    regularHours,
    travelHours,
    totalHours,
    const DeepCollectionEquality().hash(_jobRecords),
  );

  /// Create a copy of UserHoursModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserHoursModelImplCopyWith<_$UserHoursModelImpl> get copyWith =>
      __$$UserHoursModelImplCopyWithImpl<_$UserHoursModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserHoursModelImplToJson(this);
  }
}

abstract class _UserHoursModel extends UserHoursModel {
  const factory _UserHoursModel({
    required final DateTime date,
    required final String userId,
    required final String userName,
    required final double regularHours,
    required final double travelHours,
    required final double totalHours,
    required final List<JobRecordDetail> jobRecords,
  }) = _$UserHoursModelImpl;
  const _UserHoursModel._() : super._();

  factory _UserHoursModel.fromJson(Map<String, dynamic> json) =
      _$UserHoursModelImpl.fromJson;

  @override
  DateTime get date;
  @override
  String get userId;
  @override
  String get userName;
  @override
  double get regularHours;
  @override
  double get travelHours;
  @override
  double get totalHours;
  @override
  List<JobRecordDetail> get jobRecords;

  /// Create a copy of UserHoursModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserHoursModelImplCopyWith<_$UserHoursModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

JobRecordDetail _$JobRecordDetailFromJson(Map<String, dynamic> json) {
  return _JobRecordDetail.fromJson(json);
}

/// @nodoc
mixin _$JobRecordDetail {
  String get jobRecordId => throw _privateConstructorUsedError;
  String get jobName => throw _privateConstructorUsedError;
  List<EmployeeHours> get employeeHours => throw _privateConstructorUsedError;
  double get totalRegularHours => throw _privateConstructorUsedError;
  double get totalTravelHours => throw _privateConstructorUsedError;

  /// Serializes this JobRecordDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JobRecordDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JobRecordDetailCopyWith<JobRecordDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobRecordDetailCopyWith<$Res> {
  factory $JobRecordDetailCopyWith(
    JobRecordDetail value,
    $Res Function(JobRecordDetail) then,
  ) = _$JobRecordDetailCopyWithImpl<$Res, JobRecordDetail>;
  @useResult
  $Res call({
    String jobRecordId,
    String jobName,
    List<EmployeeHours> employeeHours,
    double totalRegularHours,
    double totalTravelHours,
  });
}

/// @nodoc
class _$JobRecordDetailCopyWithImpl<$Res, $Val extends JobRecordDetail>
    implements $JobRecordDetailCopyWith<$Res> {
  _$JobRecordDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JobRecordDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jobRecordId = null,
    Object? jobName = null,
    Object? employeeHours = null,
    Object? totalRegularHours = null,
    Object? totalTravelHours = null,
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
            employeeHours:
                null == employeeHours
                    ? _value.employeeHours
                    : employeeHours // ignore: cast_nullable_to_non_nullable
                        as List<EmployeeHours>,
            totalRegularHours:
                null == totalRegularHours
                    ? _value.totalRegularHours
                    : totalRegularHours // ignore: cast_nullable_to_non_nullable
                        as double,
            totalTravelHours:
                null == totalTravelHours
                    ? _value.totalTravelHours
                    : totalTravelHours // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$JobRecordDetailImplCopyWith<$Res>
    implements $JobRecordDetailCopyWith<$Res> {
  factory _$$JobRecordDetailImplCopyWith(
    _$JobRecordDetailImpl value,
    $Res Function(_$JobRecordDetailImpl) then,
  ) = __$$JobRecordDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String jobRecordId,
    String jobName,
    List<EmployeeHours> employeeHours,
    double totalRegularHours,
    double totalTravelHours,
  });
}

/// @nodoc
class __$$JobRecordDetailImplCopyWithImpl<$Res>
    extends _$JobRecordDetailCopyWithImpl<$Res, _$JobRecordDetailImpl>
    implements _$$JobRecordDetailImplCopyWith<$Res> {
  __$$JobRecordDetailImplCopyWithImpl(
    _$JobRecordDetailImpl _value,
    $Res Function(_$JobRecordDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JobRecordDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jobRecordId = null,
    Object? jobName = null,
    Object? employeeHours = null,
    Object? totalRegularHours = null,
    Object? totalTravelHours = null,
  }) {
    return _then(
      _$JobRecordDetailImpl(
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
        employeeHours:
            null == employeeHours
                ? _value._employeeHours
                : employeeHours // ignore: cast_nullable_to_non_nullable
                    as List<EmployeeHours>,
        totalRegularHours:
            null == totalRegularHours
                ? _value.totalRegularHours
                : totalRegularHours // ignore: cast_nullable_to_non_nullable
                    as double,
        totalTravelHours:
            null == totalTravelHours
                ? _value.totalTravelHours
                : totalTravelHours // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$JobRecordDetailImpl implements _JobRecordDetail {
  const _$JobRecordDetailImpl({
    required this.jobRecordId,
    required this.jobName,
    required final List<EmployeeHours> employeeHours,
    required this.totalRegularHours,
    required this.totalTravelHours,
  }) : _employeeHours = employeeHours;

  factory _$JobRecordDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$JobRecordDetailImplFromJson(json);

  @override
  final String jobRecordId;
  @override
  final String jobName;
  final List<EmployeeHours> _employeeHours;
  @override
  List<EmployeeHours> get employeeHours {
    if (_employeeHours is EqualUnmodifiableListView) return _employeeHours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_employeeHours);
  }

  @override
  final double totalRegularHours;
  @override
  final double totalTravelHours;

  @override
  String toString() {
    return 'JobRecordDetail(jobRecordId: $jobRecordId, jobName: $jobName, employeeHours: $employeeHours, totalRegularHours: $totalRegularHours, totalTravelHours: $totalTravelHours)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobRecordDetailImpl &&
            (identical(other.jobRecordId, jobRecordId) ||
                other.jobRecordId == jobRecordId) &&
            (identical(other.jobName, jobName) || other.jobName == jobName) &&
            const DeepCollectionEquality().equals(
              other._employeeHours,
              _employeeHours,
            ) &&
            (identical(other.totalRegularHours, totalRegularHours) ||
                other.totalRegularHours == totalRegularHours) &&
            (identical(other.totalTravelHours, totalTravelHours) ||
                other.totalTravelHours == totalTravelHours));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    jobRecordId,
    jobName,
    const DeepCollectionEquality().hash(_employeeHours),
    totalRegularHours,
    totalTravelHours,
  );

  /// Create a copy of JobRecordDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JobRecordDetailImplCopyWith<_$JobRecordDetailImpl> get copyWith =>
      __$$JobRecordDetailImplCopyWithImpl<_$JobRecordDetailImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$JobRecordDetailImplToJson(this);
  }
}

abstract class _JobRecordDetail implements JobRecordDetail {
  const factory _JobRecordDetail({
    required final String jobRecordId,
    required final String jobName,
    required final List<EmployeeHours> employeeHours,
    required final double totalRegularHours,
    required final double totalTravelHours,
  }) = _$JobRecordDetailImpl;

  factory _JobRecordDetail.fromJson(Map<String, dynamic> json) =
      _$JobRecordDetailImpl.fromJson;

  @override
  String get jobRecordId;
  @override
  String get jobName;
  @override
  List<EmployeeHours> get employeeHours;
  @override
  double get totalRegularHours;
  @override
  double get totalTravelHours;

  /// Create a copy of JobRecordDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JobRecordDetailImplCopyWith<_$JobRecordDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EmployeeHours _$EmployeeHoursFromJson(Map<String, dynamic> json) {
  return _EmployeeHours.fromJson(json);
}

/// @nodoc
mixin _$EmployeeHours {
  String get employeeId => throw _privateConstructorUsedError;
  String get employeeName => throw _privateConstructorUsedError;
  double get regularHours => throw _privateConstructorUsedError;
  double get travelHours => throw _privateConstructorUsedError;

  /// Serializes this EmployeeHours to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmployeeHours
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeHoursCopyWith<EmployeeHours> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeHoursCopyWith<$Res> {
  factory $EmployeeHoursCopyWith(
    EmployeeHours value,
    $Res Function(EmployeeHours) then,
  ) = _$EmployeeHoursCopyWithImpl<$Res, EmployeeHours>;
  @useResult
  $Res call({
    String employeeId,
    String employeeName,
    double regularHours,
    double travelHours,
  });
}

/// @nodoc
class _$EmployeeHoursCopyWithImpl<$Res, $Val extends EmployeeHours>
    implements $EmployeeHoursCopyWith<$Res> {
  _$EmployeeHoursCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeeHours
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? employeeName = null,
    Object? regularHours = null,
    Object? travelHours = null,
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
abstract class _$$EmployeeHoursImplCopyWith<$Res>
    implements $EmployeeHoursCopyWith<$Res> {
  factory _$$EmployeeHoursImplCopyWith(
    _$EmployeeHoursImpl value,
    $Res Function(_$EmployeeHoursImpl) then,
  ) = __$$EmployeeHoursImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String employeeId,
    String employeeName,
    double regularHours,
    double travelHours,
  });
}

/// @nodoc
class __$$EmployeeHoursImplCopyWithImpl<$Res>
    extends _$EmployeeHoursCopyWithImpl<$Res, _$EmployeeHoursImpl>
    implements _$$EmployeeHoursImplCopyWith<$Res> {
  __$$EmployeeHoursImplCopyWithImpl(
    _$EmployeeHoursImpl _value,
    $Res Function(_$EmployeeHoursImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmployeeHours
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? employeeName = null,
    Object? regularHours = null,
    Object? travelHours = null,
  }) {
    return _then(
      _$EmployeeHoursImpl(
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeeHoursImpl implements _EmployeeHours {
  const _$EmployeeHoursImpl({
    required this.employeeId,
    required this.employeeName,
    required this.regularHours,
    required this.travelHours,
  });

  factory _$EmployeeHoursImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeeHoursImplFromJson(json);

  @override
  final String employeeId;
  @override
  final String employeeName;
  @override
  final double regularHours;
  @override
  final double travelHours;

  @override
  String toString() {
    return 'EmployeeHours(employeeId: $employeeId, employeeName: $employeeName, regularHours: $regularHours, travelHours: $travelHours)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeHoursImpl &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.employeeName, employeeName) ||
                other.employeeName == employeeName) &&
            (identical(other.regularHours, regularHours) ||
                other.regularHours == regularHours) &&
            (identical(other.travelHours, travelHours) ||
                other.travelHours == travelHours));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    employeeId,
    employeeName,
    regularHours,
    travelHours,
  );

  /// Create a copy of EmployeeHours
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeHoursImplCopyWith<_$EmployeeHoursImpl> get copyWith =>
      __$$EmployeeHoursImplCopyWithImpl<_$EmployeeHoursImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeHoursImplToJson(this);
  }
}

abstract class _EmployeeHours implements EmployeeHours {
  const factory _EmployeeHours({
    required final String employeeId,
    required final String employeeName,
    required final double regularHours,
    required final double travelHours,
  }) = _$EmployeeHoursImpl;

  factory _EmployeeHours.fromJson(Map<String, dynamic> json) =
      _$EmployeeHoursImpl.fromJson;

  @override
  String get employeeId;
  @override
  String get employeeName;
  @override
  double get regularHours;
  @override
  double get travelHours;

  /// Create a copy of EmployeeHours
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeHoursImplCopyWith<_$EmployeeHoursImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
