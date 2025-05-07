import 'package:hive/hive.dart';

class SyncMetadata {
  static final _box = Hive.box<DateTime>('syncMetadataBox');

  static DateTime? getLastSync(String key) {
    return _box.get(key);
  }

  static Future<void> setLastSync(String key, DateTime dateTime) async {
    await _box.put(key, dateTime);
  }
}
