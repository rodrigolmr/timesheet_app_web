import 'package:freezed_annotation/freezed_annotation.dart';

part 'job_employee_model.freezed.dart';
part 'job_employee_model.g.dart';

@freezed
class JobEmployeeModel with _$JobEmployeeModel {
  const JobEmployeeModel._();
  
  const factory JobEmployeeModel({
    required String employeeId,
    required String employeeName,
    required String startTime,
    required String finishTime,
    required double hours,
    required double travelHours,
    required double meal,
  }) = _JobEmployeeModel;

  factory JobEmployeeModel.fromJson(Map<String, dynamic> json) => 
      _$JobEmployeeModelFromJson(json);

  Map<String, dynamic> toFirestore() {
    return {
      'employee_id': employeeId,
      'employee_name': employeeName,
      'start_time': startTime,
      'finish_time': finishTime,
      'hours': hours,
      'travel_hours': travelHours,
      'meal': meal,
    };
  }
}