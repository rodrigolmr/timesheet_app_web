import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timesheet_app_web/src/core/providers/firebase_providers.dart';
import 'package:timesheet_app_web/src/features/database/data/models/database_stats_model.dart';
import 'package:timesheet_app_web/src/features/database/data/repositories/firestore_database_repository.dart';
import 'package:timesheet_app_web/src/features/database/domain/repositories/database_repository.dart';

part 'database_providers.g.dart';

// Provider do repositório
@riverpod
DatabaseRepository databaseRepository(DatabaseRepositoryRef ref) {
  return FirestoreDatabaseRepository(
    firestore: ref.watch(firestoreProvider),
  );
}

// Provider para estatísticas de coleções
@riverpod
Future<List<DatabaseStatsModel>> databaseStats(DatabaseStatsRef ref) {
  return ref.watch(databaseRepositoryProvider).getCollectionStats();
}

// Provider para detalhes de uma coleção específica
@riverpod
Future<DatabaseCollectionModel> collectionDetails(
  CollectionDetailsRef ref,
  String collectionName,
) {
  return ref.watch(databaseRepositoryProvider).getCollectionDetails(collectionName);
}

// Provider para documento de amostra
@riverpod
Future<Map<String, dynamic>> sampleDocument(
  SampleDocumentRef ref,
  String collectionName,
) {
  return ref.watch(databaseRepositoryProvider).getSampleDocument(collectionName);
}

// Provider para listar documentos
@riverpod
Future<List<Map<String, dynamic>>> collectionDocuments(
  CollectionDocumentsRef ref,
  String collectionName,
  {int limit = 20}
) {
  return ref.watch(databaseRepositoryProvider).getDocuments(collectionName, limit: limit);
}

// Provider para obter um documento específico
@riverpod
Future<Map<String, dynamic>> documentDetails(
  DocumentDetailsRef ref,
  String collectionName,
  String documentId,
) {
  return ref.watch(databaseRepositoryProvider).getDocument(collectionName, documentId);
}

// Provider para gerenciar estado de operações
@riverpod
class DatabaseOperations extends _$DatabaseOperations {
  @override
  AsyncValue<String?> build() {
    return const AsyncData(null);
  }

  Future<void> exportCollection(String collectionName) async {
    state = const AsyncLoading();
    try {
      await ref.read(databaseRepositoryProvider).exportCollection(collectionName);
      state = AsyncData('Collection $collectionName exported successfully');
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> backupDatabase() async {
    state = const AsyncLoading();
    try {
      await ref.read(databaseRepositoryProvider).backupDatabase();
      state = const AsyncData('Database backup initiated');
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> clearCache() async {
    state = const AsyncLoading();
    try {
      await ref.read(databaseRepositoryProvider).clearCache();
      state = const AsyncData('Cache cleared successfully');
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<String> createDocument(String collectionName, Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      final id = await ref.read(databaseRepositoryProvider).createDocument(collectionName, data);
      state = AsyncData('Document created successfully with ID: $id');
      // Refresh collection stats
      ref.invalidate(databaseStatsProvider);
      ref.invalidate(collectionDetailsProvider(collectionName));
      return id;
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> updateDocument(String collectionName, String documentId, Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      await ref.read(databaseRepositoryProvider).updateDocument(collectionName, documentId, data);
      state = const AsyncData('Document updated successfully');
      // Refresh data
      ref.invalidate(databaseStatsProvider);
      ref.invalidate(collectionDetailsProvider(collectionName));
      ref.invalidate(documentDetailsProvider(collectionName, documentId));
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteDocument(String collectionName, String documentId) async {
    state = const AsyncLoading();
    try {
      await ref.read(databaseRepositoryProvider).deleteDocument(collectionName, documentId);
      state = const AsyncData('Document deleted successfully');
      // Refresh data
      ref.invalidate(databaseStatsProvider);
      ref.invalidate(collectionDetailsProvider(collectionName));
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> generateTestData(String collectionName, int count) async {
    state = const AsyncLoading();
    try {
      await ref.read(databaseRepositoryProvider).generateTestData(collectionName, count);
      state = AsyncData('Generated $count test documents in $collectionName');
      // Refresh data
      ref.invalidate(databaseStatsProvider);
      ref.invalidate(collectionDetailsProvider(collectionName));
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }
  
  Future<int> importData(String collectionName, String data, {bool isJson = true, bool overwrite = false}) async {
    state = const AsyncLoading();
    try {
      final importedCount = isJson 
          ? await ref.read(databaseRepositoryProvider).importJson(
              collectionName, 
              data,
              overwrite: overwrite,
            )
          : await ref.read(databaseRepositoryProvider).importCollection(
              collectionName, 
              data,
              overwrite: overwrite,
            );
      
      state = AsyncData('Imported $importedCount documents to $collectionName');
      // Refresh data
      ref.invalidate(databaseStatsProvider);
      ref.invalidate(collectionDetailsProvider(collectionName));
      ref.invalidate(collectionDocumentsProvider(collectionName));
      return importedCount;
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }
}