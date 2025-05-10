// lib/providers/timesheet_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modelo para representar um timesheet em edição
class TimesheetData {
  final String? id;
  final String? date;
  final String? cardNumber;
  final String? projectName;
  final String? projectLocation;
  final String? supervisor;
  final String? jobNumber;
  final String? notes;
  final List<Map<String, String>> workers;

  TimesheetData({
    this.id,
    this.date,
    this.cardNumber,
    this.projectName,
    this.projectLocation,
    this.supervisor,
    this.jobNumber,
    this.notes,
    this.workers = const [],
  });

  TimesheetData copyWith({
    String? id,
    String? date,
    String? cardNumber,
    String? projectName,
    String? projectLocation,
    String? supervisor,
    String? jobNumber,
    String? notes,
    List<Map<String, String>>? workers,
  }) {
    return TimesheetData(
      id: id ?? this.id,
      date: date ?? this.date,
      cardNumber: cardNumber ?? this.cardNumber,
      projectName: projectName ?? this.projectName,
      projectLocation: projectLocation ?? this.projectLocation,
      supervisor: supervisor ?? this.supervisor,
      jobNumber: jobNumber ?? this.jobNumber,
      notes: notes ?? this.notes,
      workers: workers ?? this.workers,
    );
  }
}

/// Provider que gerencia o estado do timesheet em edição
class TimesheetNotifier extends StateNotifier<TimesheetData> {
  TimesheetNotifier() : super(TimesheetData());

  /// Adiciona um novo trabalhador à lista
  void addWorker(Map<String, String> worker) {
    state = state.copyWith(
      workers: [...state.workers, worker],
    );
  }

  /// Edita um trabalhador existente
  void editWorker(int index, Map<String, String> updatedWorker) {
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
      case 'date':
        state = state.copyWith(date: value);
        break;
      case 'cardNumber':
        state = state.copyWith(cardNumber: value);
        break;
      case 'projectName':
        state = state.copyWith(projectName: value);
        break;
      case 'projectLocation':
        state = state.copyWith(projectLocation: value);
        break;
      case 'supervisor':
        state = state.copyWith(supervisor: value);
        break;
      case 'jobNumber':
        state = state.copyWith(jobNumber: value);
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
  void clearTimesheet() {
    state = TimesheetData();
  }
}

/// Provider para o timesheet em edição
final timesheetProvider = StateNotifierProvider<TimesheetNotifier, TimesheetData>(
  (ref) => TimesheetNotifier(),
);