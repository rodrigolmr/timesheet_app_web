import 'package:hive/hive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/hive/sync_metadata.dart';
import '../models/user.dart';

class UserRepository {
  final _box = Hive.box<UserModel>('usersBox');
  final _auth = FirebaseAuth.instance;

  Future<void> syncUsers(List<Map<String, dynamic>> remoteUsers) async {
    final lastSync = SyncMetadata.getLastSync('users') ?? DateTime.fromMillisecondsSinceEpoch(0);

    final newUsers = remoteUsers
        .map((e) => UserModel.fromMap(e))
        .where((u) => u.updatedAt.isAfter(lastSync))
        .toList();

    for (var user in newUsers) {
      await _box.put(user.userId, user);
    }

    if (newUsers.isNotEmpty) {
      final latest = newUsers.map((e) => e.updatedAt).reduce((a, b) => a.isAfter(b) ? a : b);
      await SyncMetadata.setLastSync('users', latest);
    }
  }

  List<UserModel> getLocalUsers() {
    return _box.values.toList();
  }

  Future<void> saveUser(UserModel user) async {
    await _box.put(user.userId, user);
  }

  UserModel? getUser(String id) {
    return _box.get(id);
  }

  UserModel? getCurrentUser() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return null;
    }
    return getUser(currentUser.uid);
  }

  Future<void> deleteUser(String id) async {
    await _box.delete(id);
  }
}