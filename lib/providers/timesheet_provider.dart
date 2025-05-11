// lib/providers/timesheet_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/timesheet_draft.dart';
import '../repositories/timesheet_draft_repository.dart';
import 'package:timesheet_app_web/models/user.dart';

/// Modelo para representar um timesheet em edição
class TimesheetData {
  final String? id;
  final String? userId;
  final String? jobName;
  final String? date;
  final String? tm;
  final String? jobSize;
  final String? material;
  final String? jobDesc;
  final String? foreman;
  final String? vehicle;
  final String? notes;
  final List<Map<String, dynamic>> workers;

  TimesheetData({
    this.id,
    this.userId,
    this.jobName,
    this.date,
    this.tm,
    this.jobSize,
    this.material,
    this.jobDesc,
    this.foreman,
    this.vehicle,
    this.notes,
    this.workers = const [],
  });

  TimesheetData copyWith({
    String? id,
    String? userId,
    String? jobName,
    String? date,
    String? tm,
    String? jobSize,
    String? material,
    String? jobDesc,
    String? foreman,
    String? vehicle,
    String? notes,
    List<Map<String, dynamic>>? workers,
  }) {
    return TimesheetData(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      jobName: jobName ?? this.jobName,
      date: date ?? this.date,
      tm: tm ?? this.tm,
      jobSize: jobSize ?? this.jobSize,
      material: material ?? this.material,
      jobDesc: jobDesc ?? this.jobDesc,
      foreman: foreman ?? this.foreman,
      vehicle: vehicle ?? this.vehicle,
      notes: notes ?? this.notes,
      workers: workers ?? this.workers,
    );
  }
}

/// Provider que gerencia o estado do timesheet em edição
class TimesheetNotifier extends StateNotifier<TimesheetData> {
  TimesheetNotifier() : super(TimesheetData());

  /// Adiciona um novo trabalhador à lista
  void addWorker(Map<String, dynamic> worker) {
    state = state.copyWith(
      workers: [...state.workers, worker],
    );
  }

  /// Edita um trabalhador existente
  void editWorker(int index, Map<String, dynamic> updatedWorker) {
    final newWorkers = [...state.workers];
    if (index >= 0 && index < newWorkers.length) {
      newWorkers[index] = updatedWorker;
      state = state.copyWith(workers: newWorkers);
    }
  }

  /// Remove um trabalhador da lista
  void deleteWorker(int index) {
    final newWorkers = [...state.workers];
    if (index >= 0 && index < newWorkers.length) {
      newWorkers.removeAt(index);
      state = state.copyWith(workers: newWorkers);
    }
  }

  /// Atualiza campos específicos do timesheet
  void updateField(String field, String value) {
    switch (field) {
      case 'userId':
        state = state.copyWith(userId: value);
        break;
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
    }
  }

  /// Carrega um timesheet existente
  void loadTimesheet(TimesheetData data) {
    state = data;
  }

  /// Limpa todos os dados do timesheet
  void reset() {
    state = TimesheetData();
  }

  /// Carrega dados de um rascunho
  void loadDraftData(TimesheetDraftModel draft) {
    state = TimesheetData(
      userId: draft.userId,
      jobName: draft.jobName,
      date: draft.date.toIso8601String(),
      tm: draft.tm,
      jobSize: draft.jobSize,
      material: draft.material,
      jobDesc: draft.jobDesc,
      foreman: draft.foreman,
      vehicle: draft.vehicle,
      notes: draft.notes,
      workers: draft.workers,
    );
  }
}

/// Provider para o timesheet em edição
final timesheetProvider = StateNotifierProvider<TimesheetNotifier, TimesheetData>(
  (ref) => TimesheetNotifier(),
);