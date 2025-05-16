import 'package:timesheet_app_web/src/core/interfaces/base_repository.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';

abstract class JobRecordRepository implements BaseRepository<JobRecordModel> {
  /// Busca registros por usuário
  Future<List<JobRecordModel>> getRecordsByUser(String userId);
  
  /// Stream de registros por usuário
  Stream<List<JobRecordModel>> watchRecordsByUser(String userId);
  
  /// Busca registros por funcionário
  Future<List<JobRecordModel>> getRecordsByWorker(String workerId);
  
  /// Stream de registros por funcionário
  Stream<List<JobRecordModel>> watchRecordsByWorker(String workerId);
}