import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timesheet_app_web/src/core/providers/firebase_providers.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';
import 'package:timesheet_app_web/src/features/job_record/data/repositories/firestore_job_record_repository.dart';
import 'package:timesheet_app_web/src/features/job_record/domain/repositories/job_record_repository.dart';

part 'job_record_providers.g.dart';

/// Provider que fornece o repositório de registros de trabalho
@riverpod
JobRecordRepository jobRecordRepository(JobRecordRepositoryRef ref) {
  return FirestoreJobRecordRepository(
    firestore: ref.watch(firestoreProvider),
  );
}

/// Provider para obter todos os registros
@riverpod
Future<List<JobRecordModel>> jobRecords(JobRecordsRef ref) {
  return ref.watch(jobRecordRepositoryProvider).getAll();
}

/// Provider para observar todos os registros em tempo real
@riverpod
Stream<List<JobRecordModel>> jobRecordsStream(JobRecordsStreamRef ref) {
  return ref.watch(jobRecordRepositoryProvider).watchAll();
}

/// Provider para obter um registro específico por ID
@riverpod
Future<JobRecordModel?> jobRecord(JobRecordRef ref, String id) {
  return ref.watch(jobRecordRepositoryProvider).getById(id);
}

/// Provider para observar um registro específico em tempo real
@riverpod
Stream<JobRecordModel?> jobRecordStream(JobRecordStreamRef ref, String id) {
  return ref.watch(jobRecordRepositoryProvider).watchById(id);
}

/// Provider para obter registros por usuário
@riverpod
Future<List<JobRecordModel>> jobRecordsByUser(JobRecordsByUserRef ref, String userId) {
  return ref.watch(jobRecordRepositoryProvider).getRecordsByUser(userId);
}

/// Provider para observar registros por usuário em tempo real
@riverpod
Stream<List<JobRecordModel>> jobRecordsByUserStream(JobRecordsByUserStreamRef ref, String userId) {
  return ref.watch(jobRecordRepositoryProvider).watchRecordsByUser(userId);
}

/// Provider para obter registros por funcionário
@riverpod
Future<List<JobRecordModel>> jobRecordsByWorker(JobRecordsByWorkerRef ref, String workerId) {
  return ref.watch(jobRecordRepositoryProvider).getRecordsByWorker(workerId);
}

/// Provider para observar registros por funcionário em tempo real
@riverpod
Stream<List<JobRecordModel>> jobRecordsByWorkerStream(JobRecordsByWorkerStreamRef ref, String workerId) {
  return ref.watch(jobRecordRepositoryProvider).watchRecordsByWorker(workerId);
}

/// Provider para gerenciar o estado de um registro
@riverpod
class JobRecordState extends _$JobRecordState {
  @override
  FutureOr<JobRecordModel?> build(String id) async {
    return id.isEmpty ? null : await ref.watch(jobRecordProvider(id).future);
  }

  /// Atualiza um registro
  Future<JobRecordModel?> updateRecord(JobRecordModel record) async {
    state = const AsyncLoading();
    try {
      await ref.read(jobRecordRepositoryProvider).update(
        record.id,
        record,
      );
      state = AsyncData(record);
      return record;
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return null;
    }
  }

  /// Cria um novo registro
  Future<String> create(JobRecordModel record) async {
    try {
      return await ref.read(jobRecordRepositoryProvider).create(record);
    } catch (e) {
      rethrow;
    }
  }

  /// Exclui um registro
  Future<void> delete(String id) async {
    try {
      await ref.read(jobRecordRepositoryProvider).delete(id);
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}