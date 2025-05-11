import 'package:hive/hive.dart';

class SyncMetadata {
  static final _box = Hive.box<dynamic>('syncMetadataBox');

  // Gerenciar timestamps de sincronização
  static DateTime? getLastSync(String key) {
    return _box.get('last_sync_$key');
  }

  static Future<void> setLastSync(String key, DateTime dateTime) async {
    await _box.put('last_sync_$key', dateTime);
  }

  // Gerenciar chaves de itens excluídos
  static List<String>? getDeletedKeys(String collection) {
    final List<dynamic>? deletedKeys = _box.get('deleted_${collection}');
    if (deletedKeys == null) return [];
    print('📋 SyncMetadata: Encontrados ${deletedKeys.length} itens excluídos para $collection');
    return deletedKeys.cast<String>();
  }

  static Future<void> setDeletedKeys(String collection, List<String> keys) async {
    await _box.put('deleted_${collection}', keys);
  }

  // Adicionar uma chave específica à lista de excluídos
  static Future<void> addDeletedKey(String collection, String key) async {
    final List<String> deletedKeys = getDeletedKeys(collection) ?? [];
    if (!deletedKeys.contains(key)) {
      deletedKeys.add(key);
      await setDeletedKeys(collection, deletedKeys);
    }
  }
}
