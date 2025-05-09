import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/timesheet_data.dart';
import '../repositories/timesheet_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class TimesheetNotifier extends StateNotifier<TimesheetData> {
  final TimesheetRepository _repository;
  Timer? _autosaveTimer;
  bool _shouldAutosave = false;
  String? _currentUserId;

  TimesheetNotifier(this._repository) : super(TimesheetData()) {
    // Iniciar temporizador para salvamento automático a cada 10 segundos
    _autosaveTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _autosaveDraft();
    });
  }

  @override
  void dispose() {
    _autosaveTimer?.cancel();
    super.dispose();
  }

  void updateField(String key, dynamic value) {
    switch (key) {
      case 'jobName':
        state = state.copyWith(jobName: value);
        break;
      case 'date':
        state = state.copyWith(date: value);
        break;
      case 'tm':
        state = state.copyWith(tm: value);
        break;
      case 'jobSize':
        state = state.copyWith(jobSize: value);
        break;
      case 'material':
        state = state.copyWith(material: value);
        break;
      case 'jobDesc':
        state = state.copyWith(jobDesc: value);
        break;
      case 'foreman':
        state = state.copyWith(foreman: value);
        break;
      case 'vehicle':
        state = state.copyWith(vehicle: value);
        break;
      case 'notes':
        state = state.copyWith(notes: value);
        break;
      case 'userId':
        state = state.copyWith(userId: value);
        _currentUserId = value;
        break;
    }

    // Marcar que deve autosalvar
    _shouldAutosave = true;
  }

  // Carrega dados de um TimesheetData existente para o state
  void loadFromData(TimesheetData data) {
    state = TimesheetData(
      id: data.id,
      jobName: data.jobName,
      date: data.date,
      tm: data.tm,
      jobSize: data.jobSize,
      material: data.material,
      jobDesc: data.jobDesc,
      foreman: data.foreman,
      vehicle: data.vehicle,
      notes: data.notes,
      userId: data.userId,
      workers: List<Map<String, String>>.from(data.workers),
    );

    _currentUserId = data.userId;
  }

  // Define userId quando o timesheet é criado
  void setCurrentUserId(String uid) {
    state = state.copyWith(userId: uid);
    _currentUserId = uid;
  }

  void addWorker(Map<String, String> worker) {
    final updatedList = [...state.workers, worker];
    state = state.copyWith(workers: updatedList);
    _shouldAutosave = true;
  }

  void editWorker(int index, Map<String, String> updatedWorker) {
    final updatedList = [...state.workers];
    if (index >= 0 && index < updatedList.length) {
      updatedList[index] = updatedWorker;
      state = state.copyWith(workers: updatedList);
      _shouldAutosave = true;
    }
  }

  void deleteWorker(int index) {
    final updatedList = [...state.workers];
    if (index >= 0 && index < updatedList.length) {
      updatedList.removeAt(index);
      state = state.copyWith(workers: updatedList);
      _shouldAutosave = true;
    }
  }

  void reset() {
    state = TimesheetData();
    _currentUserId = null;
  }

  // Novos métodos para gerenciamento de rascunhos

  // Carrega rascunho do repositório
  Future<bool> loadDraft() async {
    if (_currentUserId == null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;
      _currentUserId = user.uid;
    }

    final draft = await _repository.loadDraft(_currentUserId!);
    if (draft != null) {
      loadFromData(draft);
      return true;
    }
    return false;
  }

  // Salva rascunho no repositório
  Future<void> saveDraft() async {
    if (_currentUserId == null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      _currentUserId = user.uid;
    }

    await _repository.saveDraft(_currentUserId!, state);
  }

  // Deleta rascunho do repositório
  Future<void> deleteDraft() async {
    if (_currentUserId == null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      _currentUserId = user.uid;
    }

    await _repository.deleteDraft(_currentUserId!);
  }

  // Método que verifica se deve salvar automaticamente
  void _autosaveDraft() async {
    if (!_shouldAutosave || _currentUserId == null) return;

    // Verificamos se há conteúdo mínimo para salvar (pelo menos o nome do trabalho)
    if (state.jobName.isEmpty) return;

    try {
      await saveDraft();
      _shouldAutosave = false;
      // Salvamento silencioso, sem notificação visual
    } catch (e) {
      // Silenciosamente falha, continuará tentando no próximo ciclo
      print('Erro ao salvar rascunho: $e');
    }
  }
}

final timesheetProvider =
    StateNotifierProvider<TimesheetNotifier, TimesheetData>(
  (ref) => TimesheetNotifier(ref.watch(timesheetRepositoryProvider)),
);

/// StreamProvider para lista de TimesheetData
final timesheetListProvider = StreamProvider<List<TimesheetData>>((ref) {
  return ref.watch(timesheetRepositoryProvider).watchTimesheets();
});

/// FutureProvider.family para buscar TimesheetData por ID
final timesheetByIdProvider = FutureProvider.family<TimesheetData?, String>((
  ref,
  id,
) {
  return ref.read(timesheetRepositoryProvider).getTimesheetById(id);
});
