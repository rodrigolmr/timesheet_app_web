import 'package:hive/hive.dart';
import '../core/hive/sync_metadata.dart';
import '../models/worker.dart';

class WorkerRepository {
  final _box = Hive.box<WorkerModel>('workersBox');

  Future<void> syncWorkers(List<Map<String, dynamic>> remoteWorkers) async {
    final lastSync = SyncMetadata.getLastSync('workers') ?? DateTime.fromMillisecondsSinceEpoch(0);

    final newWorkers = remoteWorkers
        .map((e) => WorkerModel.fromMap(e))
        .where((w) => w.updatedAt.isAfter(lastSync))
        .toList();

    for (var worker in newWorkers) {
      await _box.put(worker.uniqueId, worker);
    }

    if (newWorkers.isNotEmpty) {
      final latest = newWorkers.map((e) => e.updatedAt).reduce((a, b) => a.isAfter(b) ? a : b);
      await SyncMetadata.setLastSync('workers', latest);
    }
  }

  List<WorkerModel> getLocalWorkers() {
    return _box.values.toList();
  }

  Future<void> saveWorker(WorkerModel worker) async {
    await _box.put(worker.uniqueId, worker);
  }

  WorkerModel? getWorker(String id) {
    return _box.get(id);
  }

  Future<void> deleteWorker(String id) async {
    await _box.delete(id);
  }
}