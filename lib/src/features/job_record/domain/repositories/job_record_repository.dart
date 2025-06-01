import 'package:timesheet_app_web/src/core/interfaces/base_repository.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';

abstract class JobRecordRepository implements BaseRepository<JobRecordModel> {
  /// Busca registros por usuário
  Future<List<JobRecordModel>> getRecordsByUser(String userId);
  
  /// Stream de registros por usuário
  Stream<List<JobRecordModel>> watchRecordsByUser(String userId);
  
  /// Busca registros por funcionário (ID do funcionário)
  Future<List<JobRecordModel>> getRecordsByEmployee(String employeeId);
  
  /// Stream de registros por funcionário (ID do funcionário)
  Stream<List<JobRecordModel>> watchRecordsByEmployee(String employeeId);
  
  /// Aprova um job record
  Future<void> approveJobRecord({
    required String recordId,
    required String approverId,
    String? approverNote,
  });
}