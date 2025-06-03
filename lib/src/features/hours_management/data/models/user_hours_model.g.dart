// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_hours_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserHoursModelImpl _$$UserHoursModelImplFromJson(Map<String, dynamic> json) =>
    _$UserHoursModelImpl(
      date: DateTime.parse(json['date'] as String),
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      regularHours: (json['regularHours'] as num).toDouble(),
      travelHours: (json['travelHours'] as num).toDouble(),
      totalHours: (json['totalHours'] as num).toDouble(),
      jobRecords:
          (json['jobRecords'] as List<dynamic>)
              .map((e) => JobRecordDetail.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$$UserHoursModelImplToJson(
  _$UserHoursModelImpl instance,
) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'userId': instance.userId,
  'userName': instance.userName,
  'regularHours': instance.regularHours,
  'travelHours': instance.travelHours,
  'totalHours': instance.totalHours,
  'jobRecords': instance.jobRecords,
};

_$JobRecordDetailImpl _$$JobRecordDetailImplFromJson(
  Map<String, dynamic> json,
) => _$JobRecordDetailImpl(
  jobRecordId: json['jobRecordId'] as String,
  jobName: json['jobName'] as String,
  employeeHours:
      (json['employeeHours'] as List<dynamic>)
          .map((e) => EmployeeHours.fromJson(e as Map<String, dynamic>))
          .toList(),
  totalRegularHours: (json['totalRegularHours'] as num).toDouble(),
  totalTravelHours: (json['totalTravelHours'] as num).toDouble(),
);

Map<String, dynamic> _$$JobRecordDetailImplToJson(
  _$JobRecordDetailImpl instance,
) => <String, dynamic>{
  'jobRecordId': instance.jobRecordId,
  'jobName': instance.jobName,
  'employeeHours': instance.employeeHours,
  'totalRegularHours': instance.totalRegularHours,
  'totalTravelHours': instance.totalTravelHours,
};

_$EmployeeHoursImpl _$$EmployeeHoursImplFromJson(Map<String, dynamic> json) =>
    _$EmployeeHoursImpl(
      employeeId: json['employeeId'] as String,
      employeeName: json['employeeName'] as String,
      regularHours: (json['regularHours'] as num).toDouble(),
      travelHours: (json['travelHours'] as num).toDouble(),
    );

Map<String, dynamic> _$$EmployeeHoursImplToJson(_$EmployeeHoursImpl instance) =>
    <String, dynamic>{
      'employeeId': instance.employeeId,
      'employeeName': instance.employeeName,
      'regularHours': instance.regularHours,
      'travelHours': instance.travelHours,
    };
