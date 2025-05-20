import 'package:timesheet_app_web/src/features/database/data/models/database_stats_model.dart';

abstract class DatabaseRepository {
  Future<List<DatabaseStatsModel>> getCollectionStats();
  Future<DatabaseCollectionModel> getCollectionDetails(String collectionName);
  Future<Map<String, dynamic>> getSampleDocument(String collectionName);
  Future<List<Map<String, dynamic>>> getDocuments(String collectionName, {int limit = 20});
  Future<Map<String, dynamic>> getDocument(String collectionName, String documentId);
  Future<String> createDocument(String collectionName, Map<String, dynamic> data);
  Future<void> updateDocument(String collectionName, String documentId, Map<String, dynamic> data);
  Future<void> deleteDocument(String collectionName, String documentId);
  Future<void> generateTestData(String collectionName, int count);
  Future<void> exportCollection(String collectionName);
  Future<void> backupDatabase();
  Future<void> clearCache();
  
  /// Importa dados de um arquivo CSV para uma coleção
  /// [collectionName] é o nome da coleção
  /// [csvData] é o conteúdo do arquivo CSV como uma string
  /// [overwrite] determina se os documentos existentes serão sobrescritos
  Future<int> importCollection(String collectionName, String csvData, {bool overwrite = false});
  
  /// Importa dados de um arquivo JSON para uma coleção
  /// [collectionName] é o nome da coleção
  /// [jsonData] é o conteúdo do arquivo JSON como uma string (array de objetos)
  /// [overwrite] determina se os documentos existentes serão sobrescritos
  Future<int> importJson(String collectionName, String jsonData, {bool overwrite = false});
}