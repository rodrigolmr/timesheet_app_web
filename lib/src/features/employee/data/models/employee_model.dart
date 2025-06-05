import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timesheet_app_web/src/core/interfaces/base_repository.dart';

part 'employee_model.freezed.dart';
part 'employee_model.g.dart';

@freezed
class EmployeeModel with _$EmployeeModel implements CleanableModel {
  const EmployeeModel._();
  
  String get name => '$firstName $lastName';
  
  const factory EmployeeModel({
    // Campos do sistema (não visíveis ao usuário final)
    required String id,
    
    // Campos visíveis ao usuário
    required String firstName,
    required String lastName,
    required bool isActive,
    double? weeklyHoursGoal,
    double? monthlyHoursGoal,
    
    // Associação com User (opcional)
    String? userId,
    
    // Campos de controle (sistema)
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _EmployeeModel;

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => _$EmployeeModelFromJson(json);

  factory EmployeeModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return EmployeeModel(
      id: doc.id,
      firstName: data['first_name'] as String,
      lastName: data['last_name'] as String,
      isActive: data['is_active'] as bool,
      weeklyHoursGoal: data['weekly_hours_goal'] as double?,
      monthlyHoursGoal: data['monthly_hours_goal'] as double?,
      userId: data['user_id'] as String?,
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'is_active': isActive,
      'weekly_hours_goal': weeklyHoursGoal,
      'monthly_hours_goal': monthlyHoursGoal,
      'user_id': userId,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }
  
  @override
  List<String> get cleanableFields => [
    'first_name',
    'last_name',
  ];
}