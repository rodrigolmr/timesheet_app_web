import 'package:hive/hive.dart';
import '../core/hive/sync_metadata.dart';
import '../models/timesheet.dart';

class TimesheetRepository {
  final _box = Hive.box<TimesheetModel>('timesheetsBox');

  Future<void> syncTimesheets(List<Map<String, dynamic>> remoteTimesheets) async {
    final lastSync = SyncMetadata.getLastSync('timesheets') ?? DateTime.fromMillisecondsSinceEpoch(0);

    // Mantenha controle das exclusões locais
    final deletedKeys = SyncMetadata.getDeletedKeys('timesheets') ?? <String>[];
    print('🔄 TimesheetRepository.syncTimesheets: ${deletedKeys.length} timesheets excluídos localmente');

    // Converter dados remotos para objetos TimesheetModel
    final newTimesheets = remoteTimesheets
        .map((e) => TimesheetModel.fromMap(e))
        .where((t) => t.updatedAt.isAfter(lastSync))
        // Filtrar timesheets que foram excluídos localmente
        .where((t) {
          final key = '${t.userId}-${t.timestamp.toIso8601String()}';
          final isDeleted = deletedKeys.contains(key);
          if (isDeleted) {
            print('⚠️ TimesheetRepository.syncTimesheets: ignorando ${t.jobName} (${key}) pois foi excluído localmente');
          }
          return !isDeleted;
        })
        .toList();

    print('🔄 TimesheetRepository.syncTimesheets: sincronizando ${newTimesheets.length} timesheets do servidor');

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

  Future<void> addTimesheet(TimesheetModel timesheet) async {
    final key = '${timesheet.userId}-${timesheet.timestamp.toIso8601String()}';
    await _box.put(key, timesheet);
  }

  TimesheetModel? getTimesheet(String key) {
    return _box.get(key);
  }

  Future<void> deleteTimesheet(String id) async {
    print('🔴 TimesheetRepository.deleteTimesheet: Excluindo timesheet com ID: $id');

    try {
      // Verificar se o timesheet existe antes de excluir
      final existingTimesheet = _box.get(id);
      if (existingTimesheet != null) {
        print('🔴 TimesheetRepository.deleteTimesheet: Timesheet encontrado, excluindo: ${existingTimesheet.jobName}');
      } else {
        print('⚠️ TimesheetRepository.deleteTimesheet: Timesheet não encontrado com ID: $id');
      }

      // Excluir do box
      await _box.delete(id);
      print('🔴 TimesheetRepository.deleteTimesheet: Timesheet excluído do box: $id');

      // Registrar a exclusão para evitar que sincronizações futuras ressuscitem este timesheet
      final deletedKeys = SyncMetadata.getDeletedKeys('timesheets') ?? <String>[];
      if (!deletedKeys.contains(id)) {
        deletedKeys.add(id);
        await SyncMetadata.setDeletedKeys('timesheets', deletedKeys);
        print('🔴 TimesheetRepository.deleteTimesheet: ID $id adicionado à lista de exclusões');
      } else {
        print('🔴 TimesheetRepository.deleteTimesheet: ID $id já estava na lista de exclusões');
      }

      // Verificar se a exclusão foi realizada com sucesso
      final checkTimesheet = _box.get(id);
      final checkDeletedKeys = SyncMetadata.getDeletedKeys('timesheets') ?? <String>[];
      if (checkTimesheet == null) {
        print('✅ TimesheetRepository.deleteTimesheet: Verificação confirma que o timesheet não existe mais no box');
      } else {
        print('⚠️ TimesheetRepository.deleteTimesheet: Verificação falhou - o timesheet ainda existe no box');
      }
      if (checkDeletedKeys.contains(id)) {
        print('✅ TimesheetRepository.deleteTimesheet: Verificação confirma que o ID está na lista de exclusões');
      } else {
        print('⚠️ TimesheetRepository.deleteTimesheet: Verificação falhou - o ID não está na lista de exclusões');
      }
    } catch (e) {
      print('❌ TimesheetRepository.deleteTimesheet: Erro ao excluir timesheet: $e');
      rethrow;
    }
  }
}