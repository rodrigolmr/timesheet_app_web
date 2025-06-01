import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timesheet_app_web/src/core/interfaces/base_repository.dart';
import 'package:timesheet_app_web/src/features/job_record/domain/enums/job_record_status.dart';
import 'job_employee_model.dart';

part 'job_record_model.freezed.dart';
part 'job_record_model.g.dart';

@freezed
class JobRecordModel with _$JobRecordModel implements CleanableModel {
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
    
    // Notas adicionais
    @Default('') String notes,
    
    // Campos de aprovação
    @Default(JobRecordStatus.pending) JobRecordStatus status,
    String? approverNote,
    DateTime? approvedAt,
    String? approverId,
    
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
      userId: data['user_id'] as String? ?? '',
      jobName: data['job_name'] as String? ?? 'Untitled Job',
      date: data['date'] != null ? (data['date'] as Timestamp).toDate() : DateTime.now(),
      territorialManager: data['territorial_manager'] as String? ?? '',
      jobSize: data['job_size'] as String? ?? '',
      material: data['material'] as String? ?? '',
      jobDescription: data['job_description'] as String? ?? '',
      foreman: data['foreman'] as String? ?? '',
      vehicle: data['vehicle'] as String? ?? '',
      employees: data['employees'] != null ? (data['employees'] as List<dynamic>)
          .map((e) => JobEmployeeModel.fromJson(e as Map<String, dynamic>))
          .toList() : [],
      notes: data['notes'] as String? ?? '',
      status: data['status'] != null 
          ? JobRecordStatus.values.firstWhere((e) => e.name == data['status'])
          : JobRecordStatus.pending,
      approverNote: data['approver_note'] as String?,
      approvedAt: data['approved_at'] != null 
          ? (data['approved_at'] as Timestamp).toDate()
          : null,
      approverId: data['approver_id'] as String?,
      createdAt: data['created_at'] != null ? (data['created_at'] as Timestamp).toDate() : DateTime.now(),
      updatedAt: data['updated_at'] != null ? (data['updated_at'] as Timestamp).toDate() : DateTime.now(),
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
      'notes': notes,
      'status': status.name,
      if (approverNote != null) 'approver_note': approverNote,
      if (approvedAt != null) 'approved_at': Timestamp.fromDate(approvedAt!),
      if (approverId != null) 'approver_id': approverId,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }
  
  @override
  List<String> get cleanableFields => [
    'job_name',
    'territorial_manager',
    'job_size',
    'material',
    'job_description',
    'foreman',
    'vehicle',
    'notes',
  ];
}