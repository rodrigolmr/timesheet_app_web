import 'package:hive/hive.dart';

class PrefsRepository {
  final Box _box = Hive.box('prefs');

  Future<void> setCurrentUserId(String userId) async {
    await _box.put('currentUserId', userId);
  }

  String? getCurrentUserId() {
    return _box.get('currentUserId');
  }

  Future<void> clearCurrentUserId() async {
    await _box.delete('currentUserId');
  }

  Future<void> clearAllPrefs() async {
    await _box.clear();
  }
}