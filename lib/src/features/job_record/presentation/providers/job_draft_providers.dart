import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timesheet_app_web/src/core/providers/firebase_providers.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_draft_model.dart';
import 'package:timesheet_app_web/src/features/job_record/data/repositories/firestore_job_draft_repository.dart';
import 'package:timesheet_app_web/src/features/job_record/domain/repositories/job_draft_repository.dart';

part 'job_draft_providers.g.dart';

/// Provider que fornece o repositório de rascunhos de trabalho
@riverpod
JobDraftRepository jobDraftRepository(JobDraftRepositoryRef ref) {
  return FirestoreJobDraftRepository(
    firestore: ref.watch(firestoreProvider),
  );
}

/// Provider para obter todos os rascunhos
@riverpod
Future<List<JobDraftModel>> jobDrafts(JobDraftsRef ref) {
  return ref.watch(jobDraftRepositoryProvider).getAll();
}

/// Provider para observar todos os rascunhos em tempo real
@riverpod
Stream<List<JobDraftModel>> jobDraftsStream(JobDraftsStreamRef ref) {
  return ref.watch(jobDraftRepositoryProvider).watchAll();
}

/// Provider para obter um rascunho específico por ID
@riverpod
Future<JobDraftModel?> jobDraft(JobDraftRef ref, String id) {
  return ref.watch(jobDraftRepositoryProvider).getById(id);
}

/// Provider para observar um rascunho específico em tempo real
@riverpod
Stream<JobDraftModel?> jobDraftStream(JobDraftStreamRef ref, String id) {
  return ref.watch(jobDraftRepositoryProvider).watchById(id);
}

/// Provider para obter rascunhos por usuário
@riverpod
Future<List<JobDraftModel>> jobDraftsByUser(JobDraftsByUserRef ref, String userId) {
  return ref.watch(jobDraftRepositoryProvider).getDraftsByUser(userId);
}

/// Provider para observar rascunhos por usuário em tempo real
@riverpod
Stream<List<JobDraftModel>> jobDraftsByUserStream(JobDraftsByUserStreamRef ref, String userId) {
  return ref.watch(jobDraftRepositoryProvider).watchDraftsByUser(userId);
}

/// Provider para obter rascunhos por funcionário
@riverpod
Future<List<JobDraftModel>> jobDraftsByWorker(JobDraftsByWorkerRef ref, String workerId) {
  return ref.watch(jobDraftRepositoryProvider).getDraftsByWorker(workerId);
}

/// Provider para gerenciar o estado de um rascunho
@riverpod
class JobDraftState extends _$JobDraftState {
  @override
  FutureOr<JobDraftModel?> build(String id) async {
    return id.isEmpty ? null : await ref.watch(jobDraftProvider(id).future);
  }

  /// Atualiza um rascunho
  Future<void> updateDraft(JobDraftModel draft) async {
    state = const AsyncLoading();
    try {
      await ref.read(jobDraftRepositoryProvider).update(
        draft.id,
        draft,
      );
      state = AsyncData(draft);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  /// Cria um novo rascunho
  Future<String> create(JobDraftModel draft) async {
    try {
      return await ref.read(jobDraftRepositoryProvider).create(draft);
    } catch (e) {
      rethrow;
    }
  }

  /// Exclui um rascunho
  Future<void> delete(String id) async {
    try {
      await ref.read(jobDraftRepositoryProvider).delete(id);
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
  
  /// Converte um rascunho em registro oficial
  Future<void> convertToRecord() async {
    if (state.value == null) return;
    
    state = const AsyncLoading();
    try {
      await ref.read(jobDraftRepositoryProvider).convertToRecord(state.value!.id);
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}