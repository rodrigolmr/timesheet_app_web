import 'package:hive/hive.dart';
import '../core/hive/sync_metadata.dart';
import '../models/timesheet_draft.dart';
import '../providers/timesheet_provider.dart';

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

  Future<void> saveDraft(TimesheetData data) async {
    if (data.userId == null || data.userId!.isEmpty) {
      return; // Não pode salvar sem userId
    }

    if (data.date == null || data.date!.isEmpty) {
      return; // Não pode salvar sem data
    }

    // Criar um objeto TimesheetDraftModel a partir do TimesheetData
    final now = DateTime.now();
    final draftDate = DateTime.tryParse(data.date!) ?? now;

    final draft = TimesheetDraftModel(
      userId: data.userId!,
      jobName: data.jobName ?? '',
      date: draftDate,
      tm: data.tm ?? '',
      jobSize: data.jobSize ?? '',
      material: data.material ?? '',
      jobDesc: data.jobDesc ?? '',
      foreman: data.foreman ?? '',
      vehicle: data.vehicle ?? '',
      notes: data.notes ?? '',
      workers: data.workers.map((w) => Map<String, dynamic>.from(w)).toList(),
      lastUpdated: now,
      updatedAt: now,
    );

    final key = '${draft.userId}-${draft.date.toIso8601String()}';
    await _box.put(key, draft);
  }

  // Obter o rascunho mais recente para um usuário
  TimesheetDraftModel? loadDraft(String userId) {
    try {
      // Filtrar os rascunhos pelo userId
      final drafts = _box.values.where((draft) => draft.userId == userId).toList();

      if (drafts.isEmpty) {
        return null;
      }

      // Ordenar por data de atualização (mais recente primeiro)
      drafts.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));

      // Retornar o rascunho mais recente
      return drafts.first;
    } catch (e) {
      print('Erro ao carregar rascunho: $e');
      return null;
    }
  }

  // Deletar um rascunho específico por userId
  Future<void> deleteDraft(String userId) async {
    try {
      // Encontrar rascunhos deste usuário
      final drafts = _box.values.where((draft) => draft.userId == userId).toList();

      // Excluir cada rascunho
      for (var draft in drafts) {
        final key = draft.key.toString();
        await _box.delete(key);
      }
    } catch (e) {
      print('Erro ao excluir rascunho: $e');
    }
  }
}