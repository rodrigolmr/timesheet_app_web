import 'package:hive/hive.dart';
import '../core/hive/sync_metadata.dart';
import '../models/timesheet.dart';

class TimesheetRepository {
  final _box = Hive.box<TimesheetModel>('timesheetsBox');

  Future<void> syncTimesheets(List<Map<String, dynamic>> remoteTimesheets) async {
    final lastSync = SyncMetadata.getLastSync('timesheets') ?? DateTime.fromMillisecondsSinceEpoch(0);

    final newTimesheets = remoteTimesheets
        .map((e) => TimesheetModel.fromMap(e))
        .where((t) => t.updatedAt.isAfter(lastSync))
        .toList();

    for (var timesheet in newTimesheets) {
      final key = '${timesheet.userId}-${timesheet.timestamp.toIso8601String()}';
      await _box.put(key, timesheet);
    }

    if (newTimesheets.isNotEmpty) {
      final latest = newTimesheets.map((e) => e.updatedAt).reduce((a, b) => a.isAfter(b) ? a : b);
      await SyncMetadata.setLastSync('timesheets', latest);
    }
  }

  List<TimesheetModel> getLocalTimesheets() {
    return _box.values.toList();
  }

  Future<void> saveTimesheet(TimesheetModel timesheet) async {
    final key = '${timesheet.userId}-${timesheet.timestamp.toIso8601String()}';
    await _box.put(key, timesheet);
  }

  TimesheetModel? getTimesheet(String key) {
    return _box.get(key);
  }

  Future<void> deleteTimesheet(String id) async {
    await _box.delete(id);
  }
}