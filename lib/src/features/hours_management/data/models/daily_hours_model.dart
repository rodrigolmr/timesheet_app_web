import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_hours_model.freezed.dart';
part 'daily_hours_model.g.dart';

@freezed
class DailyHoursModel with _$DailyHoursModel {
  const DailyHoursModel._();
  
  const factory DailyHoursModel({
    required DateTime date,
    required String employeeId,
    required String employeeName,
    required double regularHours,
    required double travelHours,
    required double totalHours,
    required List<JobRecordSummary> jobRecords,
  }) = _DailyHoursModel;

  factory DailyHoursModel.fromJson(Map<String, dynamic> json) => 
      _$DailyHoursModelFromJson(json);
}

@freezed
class JobRecordSummary with _$JobRecordSummary {
  const factory JobRecordSummary({
    required String jobRecordId,
    required String jobName,
    required double regularHours,
    required double travelHours,
  }) = _JobRecordSummary;

  factory JobRecordSummary.fromJson(Map<String, dynamic> json) => 
      _$JobRecordSummaryFromJson(json);
}