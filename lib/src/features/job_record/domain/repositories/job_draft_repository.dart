import 'package:timesheet_app_web/src/core/interfaces/base_repository.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_draft_model.dart';

abstract class JobDraftRepository implements BaseRepository<JobDraftModel> {
  /// Busca rascunhos por usuário
  Future<List<JobDraftModel>> getDraftsByUser(String userId);
  
  /// Stream de rascunhos por usuário
  Stream<List<JobDraftModel>> watchDraftsByUser(String userId);
  
  /// Busca rascunhos por funcionário
  Future<List<JobDraftModel>> getDraftsByWorker(String workerId);
  
  /// Converte um rascunho em registro oficial
  Future<void> convertToRecord(String draftId);
}