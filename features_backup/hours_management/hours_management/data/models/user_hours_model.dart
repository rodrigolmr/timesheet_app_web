import 'package:freezed_annotation/freezed_annotation.dart';
import 'daily_hours_model.dart';

part 'user_hours_model.freezed.dart';
part 'user_hours_model.g.dart';

@freezed
class UserHoursModel with _$UserHoursModel {
  const UserHoursModel._();
  
  const factory UserHoursModel({
    required DateTime date,
    required String userId,
    required String userName,
    required double regularHours,
    required double travelHours,
    required double totalHours,
    required List<JobRecordDetail> jobRecords,
  }) = _UserHoursModel;

  factory UserHoursModel.fromJson(Map<String, dynamic> json) => 
      _$UserHoursModelFromJson(json);
}

@freezed
class JobRecordDetail with _$JobRecordDetail {
  const factory JobRecordDetail({
    required String jobRecordId,
    required String jobName,
    required List<EmployeeHours> employeeHours,
    required double totalRegularHours,
    required double totalTravelHours,
  }) = _JobRecordDetail;

  factory JobRecordDetail.fromJson(Map<String, dynamic> json) => 
      _$JobRecordDetailFromJson(json);
}

@freezed
class EmployeeHours with _$EmployeeHours {
  const factory EmployeeHours({
    required String employeeId,
    required String employeeName,
    required double regularHours,
    required double travelHours,
  }) = _EmployeeHours;

  factory EmployeeHours.fromJson(Map<String, dynamic> json) => 
      _$EmployeeHoursFromJson(json);
}