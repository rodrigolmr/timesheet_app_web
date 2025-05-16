// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_employee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JobEmployeeModelImpl _$$JobEmployeeModelImplFromJson(
  Map<String, dynamic> json,
) => _$JobEmployeeModelImpl(
  employeeId: json['employeeId'] as String,
  employeeName: json['employeeName'] as String,
  startTime: json['startTime'] as String,
  finishTime: json['finishTime'] as String,
  hours: (json['hours'] as num).toDouble(),
  travelHours: (json['travelHours'] as num).toDouble(),
  meal: (json['meal'] as num).toDouble(),
);

Map<String, dynamic> _$$JobEmployeeModelImplToJson(
  _$JobEmployeeModelImpl instance,
) => <String, dynamic>{
  'employeeId': instance.employeeId,
  'employeeName': instance.employeeName,
  'startTime': instance.startTime,
  'finishTime': instance.finishTime,
  'hours': instance.hours,
  'travelHours': instance.travelHours,
  'meal': instance.meal,
};
