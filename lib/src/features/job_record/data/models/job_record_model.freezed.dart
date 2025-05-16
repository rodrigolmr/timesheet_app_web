// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_record_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

JobRecordModel _$JobRecordModelFromJson(Map<String, dynamic> json) {
  return _JobRecordModel.fromJson(json);
}

/// @nodoc
mixin _$JobRecordModel {
  // Campos do sistema
  String get id => throw _privateConstructorUsedError;
  String get userId =>
      throw _privateConstructorUsedError; // Header - Informações gerais do trabalho
  String get jobName => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get territorialManager => throw _privateConstructorUsedError;
  String get jobSize => throw _privateConstructorUsedError;
  String get material => throw _privateConstructorUsedError;
  String get jobDescription => throw _privateConstructorUsedError;
  String get foreman => throw _privateConstructorUsedError;
  String get vehicle =>
      throw _privateConstructorUsedError; // Array de funcionários
  List<JobEmployeeModel> get employees =>
      throw _privateConstructorUsedError; // Campos de controle
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this JobRecordModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JobRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JobRecordModelCopyWith<JobRecordModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobRecordModelCopyWith<$Res> {
  factory $JobRecordModelCopyWith(
    JobRecordModel value,
    $Res Function(JobRecordModel) then,
  ) = _$JobRecordModelCopyWithImpl<$Res, JobRecordModel>;
  @useResult
  $Res call({
    String id,
    String userId,
    String jobName,
    DateTime date,
    String territorialManager,
    String jobSize,
    String material,
    String jobDescription,
    String foreman,
    String vehicle,
    List<JobEmployeeModel> employees,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$JobRecordModelCopyWithImpl<$Res, $Val extends JobRecordModel>
    implements $JobRecordModelCopyWith<$Res> {
  _$JobRecordModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JobRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? jobName = null,
    Object? date = null,
    Object? territorialManager = null,
    Object? jobSize = null,
    Object? material = null,
    Object? jobDescription = null,
    Object? foreman = null,
    Object? vehicle = null,
    Object? employees = null,
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
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String,
            jobName:
                null == jobName
                    ? _value.jobName
                    : jobName // ignore: cast_nullable_to_non_nullable
                        as String,
            date:
                null == date
                    ? _value.date
                    : date // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            territorialManager:
                null == territorialManager
                    ? _value.territorialManager
                    : territorialManager // ignore: cast_nullable_to_non_nullable
                        as String,
            jobSize:
                null == jobSize
                    ? _value.jobSize
                    : jobSize // ignore: cast_nullable_to_non_nullable
                        as String,
            material:
                null == material
                    ? _value.material
                    : material // ignore: cast_nullable_to_non_nullable
                        as String,
            jobDescription:
                null == jobDescription
                    ? _value.jobDescription
                    : jobDescription // ignore: cast_nullable_to_non_nullable
                        as String,
            foreman:
                null == foreman
                    ? _value.foreman
                    : foreman // ignore: cast_nullable_to_non_nullable
                        as String,
            vehicle:
                null == vehicle
                    ? _value.vehicle
                    : vehicle // ignore: cast_nullable_to_non_nullable
                        as String,
            employees:
                null == employees
                    ? _value.employees
                    : employees // ignore: cast_nullable_to_non_nullable
                        as List<JobEmployeeModel>,
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
}

/// @nodoc
abstract class _$$JobRecordModelImplCopyWith<$Res>
    implements $JobRecordModelCopyWith<$Res> {
  factory _$$JobRecordModelImplCopyWith(
    _$JobRecordModelImpl value,
    $Res Function(_$JobRecordModelImpl) then,
  ) = __$$JobRecordModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String jobName,
    DateTime date,
    String territorialManager,
    String jobSize,
    String material,
    String jobDescription,
    String foreman,
    String vehicle,
    List<JobEmployeeModel> employees,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$JobRecordModelImplCopyWithImpl<$Res>
    extends _$JobRecordModelCopyWithImpl<$Res, _$JobRecordModelImpl>
    implements _$$JobRecordModelImplCopyWith<$Res> {
  __$$JobRecordModelImplCopyWithImpl(
    _$JobRecordModelImpl _value,
    $Res Function(_$JobRecordModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JobRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? jobName = null,
    Object? date = null,
    Object? territorialManager = null,
    Object? jobSize = null,
    Object? material = null,
    Object? jobDescription = null,
    Object? foreman = null,
    Object? vehicle = null,
    Object? employees = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$JobRecordModelImpl(
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
        jobName:
            null == jobName
                ? _value.jobName
                : jobName // ignore: cast_nullable_to_non_nullable
                    as String,
        date:
            null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        territorialManager:
            null == territorialManager
                ? _value.territorialManager
                : territorialManager // ignore: cast_nullable_to_non_nullable
                    as String,
        jobSize:
            null == jobSize
                ? _value.jobSize
                : jobSize // ignore: cast_nullable_to_non_nullable
                    as String,
        material:
            null == material
                ? _value.material
                : material // ignore: cast_nullable_to_non_nullable
                    as String,
        jobDescription:
            null == jobDescription
                ? _value.jobDescription
                : jobDescription // ignore: cast_nullable_to_non_nullable
                    as String,
        foreman:
            null == foreman
                ? _value.foreman
                : foreman // ignore: cast_nullable_to_non_nullable
                    as String,
        vehicle:
            null == vehicle
                ? _value.vehicle
                : vehicle // ignore: cast_nullable_to_non_nullable
                    as String,
        employees:
            null == employees
                ? _value._employees
                : employees // ignore: cast_nullable_to_non_nullable
                    as List<JobEmployeeModel>,
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
class _$JobRecordModelImpl extends _JobRecordModel {
  const _$JobRecordModelImpl({
    required this.id,
    required this.userId,
    required this.jobName,
    required this.date,
    required this.territorialManager,
    required this.jobSize,
    required this.material,
    required this.jobDescription,
    required this.foreman,
    required this.vehicle,
    required final List<JobEmployeeModel> employees,
    required this.createdAt,
    required this.updatedAt,
  }) : _employees = employees,
       super._();

  factory _$JobRecordModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$JobRecordModelImplFromJson(json);

  // Campos do sistema
  @override
  final String id;
  @override
  final String userId;
  // Header - Informações gerais do trabalho
  @override
  final String jobName;
  @override
  final DateTime date;
  @override
  final String territorialManager;
  @override
  final String jobSize;
  @override
  final String material;
  @override
  final String jobDescription;
  @override
  final String foreman;
  @override
  final String vehicle;
  // Array de funcionários
  final List<JobEmployeeModel> _employees;
  // Array de funcionários
  @override
  List<JobEmployeeModel> get employees {
    if (_employees is EqualUnmodifiableListView) return _employees;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_employees);
  }

  // Campos de controle
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'JobRecordModel(id: $id, userId: $userId, jobName: $jobName, date: $date, territorialManager: $territorialManager, jobSize: $jobSize, material: $material, jobDescription: $jobDescription, foreman: $foreman, vehicle: $vehicle, employees: $employees, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobRecordModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.jobName, jobName) || other.jobName == jobName) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.territorialManager, territorialManager) ||
                other.territorialManager == territorialManager) &&
            (identical(other.jobSize, jobSize) || other.jobSize == jobSize) &&
            (identical(other.material, material) ||
                other.material == material) &&
            (identical(other.jobDescription, jobDescription) ||
                other.jobDescription == jobDescription) &&
            (identical(other.foreman, foreman) || other.foreman == foreman) &&
            (identical(other.vehicle, vehicle) || other.vehicle == vehicle) &&
            const DeepCollectionEquality().equals(
              other._employees,
              _employees,
            ) &&
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
    userId,
    jobName,
    date,
    territorialManager,
    jobSize,
    material,
    jobDescription,
    foreman,
    vehicle,
    const DeepCollectionEquality().hash(_employees),
    createdAt,
    updatedAt,
  );

  /// Create a copy of JobRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JobRecordModelImplCopyWith<_$JobRecordModelImpl> get copyWith =>
      __$$JobRecordModelImplCopyWithImpl<_$JobRecordModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$JobRecordModelImplToJson(this);
  }
}

abstract class _JobRecordModel extends JobRecordModel {
  const factory _JobRecordModel({
    required final String id,
    required final String userId,
    required final String jobName,
    required final DateTime date,
    required final String territorialManager,
    required final String jobSize,
    required final String material,
    required final String jobDescription,
    required final String foreman,
    required final String vehicle,
    required final List<JobEmployeeModel> employees,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$JobRecordModelImpl;
  const _JobRecordModel._() : super._();

  factory _JobRecordModel.fromJson(Map<String, dynamic> json) =
      _$JobRecordModelImpl.fromJson;

  // Campos do sistema
  @override
  String get id;
  @override
  String get userId; // Header - Informações gerais do trabalho
  @override
  String get jobName;
  @override
  DateTime get date;
  @override
  String get territorialManager;
  @override
  String get jobSize;
  @override
  String get material;
  @override
  String get jobDescription;
  @override
  String get foreman;
  @override
  String get vehicle; // Array de funcionários
  @override
  List<JobEmployeeModel> get employees; // Campos de controle
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of JobRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JobRecordModelImplCopyWith<_$JobRecordModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
