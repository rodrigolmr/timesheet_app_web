import 'package:hive/hive.dart';
import '../core/hive/sync_metadata.dart';
import '../models/timesheet_draft.dart';

class TimesheetDraftRepository {
  final _box = Hive.box<TimesheetDraftModel>('timesheetDraftsBox');

  Future<void> syncDrafts(List<Map<String, dynamic>> remoteDrafts) async {
    final lastSync = SyncMetadata.getLastSync('timesheetDrafts') ?? DateTime.fromMillisecondsSinceEpoch(0);

    final newDrafts = remoteDrafts
        .map((e) => TimesheetDraftModel.fromMap(e))
        .where((d) => d.updatedAt.isAfter(lastSync))
        .toList();

    for (var draft in newDrafts) {
      final key = '${draft.userId}-${draft.date.toIso8601String()}';
      await _box.put(key, draft);
    }

    if (newDrafts.isNotEmpty) {
      final latest = newDrafts.map((e) => e.updatedAt).reduce((a, b) => a.isAfter(b) ? a : b);
      await SyncMetadata.setLastSync('timesheetDrafts', latest);
    }
  }

  List<TimesheetDraftModel> getLocalDrafts() {
    return _box.values.toList();
  }

  Future<void> saveDraft(TimesheetDraftModel draft) async {
    final key = '${draft.userId}-${draft.date.toIso8601String()}';
    await _box.put(key, draft);
  }

  TimesheetDraftModel? getDraft(String key) {
    return _box.get(key);
  }

  Future<void> deleteDraft(String id) async {
    await _box.delete(id);
  }
}