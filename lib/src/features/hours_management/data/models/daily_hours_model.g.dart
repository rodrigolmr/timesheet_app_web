// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_hours_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyHoursModelImpl _$$DailyHoursModelImplFromJson(
  Map<String, dynamic> json,
) => _$DailyHoursModelImpl(
  date: DateTime.parse(json['date'] as String),
  employeeId: json['employeeId'] as String,
  employeeName: json['employeeName'] as String,
  regularHours: (json['regularHours'] as num).toDouble(),
  travelHours: (json['travelHours'] as num).toDouble(),
  totalHours: (json['totalHours'] as num).toDouble(),
  jobRecords:
      (json['jobRecords'] as List<dynamic>)
          .map((e) => JobRecordSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$$DailyHoursModelImplToJson(
  _$DailyHoursModelImpl instance,
) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'employeeId': instance.employeeId,
  'employeeName': instance.employeeName,
  'regularHours': instance.regularHours,
  'travelHours': instance.travelHours,
  'totalHours': instance.totalHours,
  'jobRecords': instance.jobRecords,
};

_$JobRecordSummaryImpl _$$JobRecordSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$JobRecordSummaryImpl(
  jobRecordId: json['jobRecordId'] as String,
  jobName: json['jobName'] as String,
  regularHours: (json['regularHours'] as num).toDouble(),
  travelHours: (json['travelHours'] as num).toDouble(),
);

Map<String, dynamic> _$$JobRecordSummaryImplToJson(
  _$JobRecordSummaryImpl instance,
) => <String, dynamic>{
  'jobRecordId': instance.jobRecordId,
  'jobName': instance.jobName,
  'regularHours': instance.regularHours,
  'travelHours': instance.travelHours,
};
