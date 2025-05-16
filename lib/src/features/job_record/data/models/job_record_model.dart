import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'job_employee_model.dart';

part 'job_record_model.freezed.dart';
part 'job_record_model.g.dart';

@freezed
class JobRecordModel with _$JobRecordModel {
  const JobRecordModel._();
  
  const factory JobRecordModel({
    // Campos do sistema
    required String id,
    required String userId,
    
    // Header - Informações gerais do trabalho
    required String jobName,
    required DateTime date,
    required String territorialManager,
    required String jobSize,
    required String material,
    required String jobDescription,
    required String foreman,
    required String vehicle,
    
    // Array de funcionários
    required List<JobEmployeeModel> employees,
    
    // Campos de controle
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _JobRecordModel;

  factory JobRecordModel.fromJson(Map<String, dynamic> json) => 
      _$JobRecordModelFromJson(json);

  factory JobRecordModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return JobRecordModel(
      id: doc.id,
      userId: data['user_id'] as String,
      jobName: data['job_name'] as String,
      date: (data['date'] as Timestamp).toDate(),
      territorialManager: data['territorial_manager'] as String,
      jobSize: data['job_size'] as String,
      material: data['material'] as String,
      jobDescription: data['job_description'] as String,
      foreman: data['foreman'] as String,
      vehicle: data['vehicle'] as String,
      employees: (data['employees'] as List<dynamic>)
          .map((e) => JobEmployeeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'job_name': jobName,
      'date': Timestamp.fromDate(date),
      'territorial_manager': territorialManager,
      'job_size': jobSize,
      'material': material,
      'job_description': jobDescription,
      'foreman': foreman,
      'vehicle': vehicle,
      'employees': employees.map((e) => e.toFirestore()).toList(),
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }
}