import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timesheet_app_web/src/core/interfaces/base_repository.dart';

part 'job_employee_model.freezed.dart';
part 'job_employee_model.g.dart';

@freezed
class JobEmployeeModel with _$JobEmployeeModel implements CleanableModel {
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

  factory JobEmployeeModel.fromJson(Map<String, dynamic> json) => _$JobEmployeeModelFromJson({
    'employeeId': json['employee_id'] as String? ?? '',
    'employeeName': json['employee_name'] as String? ?? 'Unknown Employee',
    'startTime': json['start_time'] as String? ?? '00:00',
    'finishTime': json['finish_time'] as String? ?? '00:00',
    'hours': json['hours'] != null ? (json['hours'] as num).toDouble() : 0.0,
    'travelHours': json['travel_hours'] != null ? (json['travel_hours'] as num).toDouble() : 0.0,
    'meal': json['meal'] != null ? (json['meal'] as num).toDouble() : 0.0,
  });

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

  // Necessário para Freezed
  Map<String, dynamic> toJson() => {
    'employee_id': employeeId,
    'employee_name': employeeName,
    'start_time': startTime,
    'finish_time': finishTime,
    'hours': hours,
    'travel_hours': travelHours,
    'meal': meal,
  };
  
  @override
  List<String> get cleanableFields => [
    'employee_name',
  ];
}