import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_draft_model.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_employee_model.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/job_draft_providers.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/job_record_providers.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/auth_providers.dart';

part 'timesheet_draft_providers.g.dart';

@riverpod
int currentStep(CurrentStepRef ref) {
  return 0;
}

@riverpod
class CurrentStepNotifier extends _$CurrentStepNotifier {
  @override
  int build() => 0;

  void setStep(int step) {
    state = step;
  }

  void nextStep() {
    if (state < 2) {
      state++;
    }
  }

  void previousStep() {
    if (state > 0) {
      state--;
    }
  }
}

@riverpod
class TimesheetDraft extends _$TimesheetDraft {
  @override
  AsyncValue<JobDraftModel?> build() {
    _loadExistingDraft();
    return const AsyncData(null);
  }

  Future<void> _loadExistingDraft() async {
    try {
      final userId = ref.read(currentUserIdProvider).valueOrNull;
      if (userId == null) return;

      final drafts = await ref.read(jobDraftRepositoryProvider)
          .getDraftsByUser(userId);
      
      if (drafts.isNotEmpty) {
        state = AsyncData(drafts.first);
      }
    } catch (e) {
      // Se não houver draft, isso é esperado
    }
  }

  void updateHeader(Map<String, dynamic> headerData) {
    final currentDraft = state.valueOrNull;
    final userId = ref.read(currentUserIdProvider).valueOrNull!;
    
    if (currentDraft == null) {
      // Criar novo draft
      final newDraft = JobDraftModel(
        id: '',
        userId: userId,
        jobName: headerData['jobName'] ?? '',
        date: headerData['date'] ?? DateTime.now(),
        territorialManager: headerData['territorialManager'] ?? '',
        jobSize: headerData['jobSize'] ?? '',
        material: headerData['material'] ?? '',
        jobDescription: headerData['jobDescription'] ?? '',
        foreman: headerData['foreman'] ?? '',
        vehicle: headerData['vehicle'] ?? '',
        employees: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      state = AsyncData(newDraft);
      _saveDraft();
    } else {
      // Atualizar draft existente
      final updatedDraft = currentDraft.copyWith(
        jobName: headerData['jobName'] ?? currentDraft.jobName,
        date: headerData['date'] ?? currentDraft.date,
        territorialManager: headerData['territorialManager'] ?? currentDraft.territorialManager,
        jobSize: headerData['jobSize'] ?? currentDraft.jobSize,
        material: headerData['material'] ?? currentDraft.material,
        jobDescription: headerData['jobDescription'] ?? currentDraft.jobDescription,
        foreman: headerData['foreman'] ?? currentDraft.foreman,
        vehicle: headerData['vehicle'] ?? currentDraft.vehicle,
        updatedAt: DateTime.now(),
      );
      
      state = AsyncData(updatedDraft);
      _saveDraft();
    }
  }

  void addEmployee(JobEmployeeModel employee) {
    final currentDraft = state.valueOrNull;
    if (currentDraft == null) return;

    final updatedEmployees = [...currentDraft.employees, employee];
    final updatedDraft = currentDraft.copyWith(
      employees: updatedEmployees,
      updatedAt: DateTime.now(),
    );
    
    state = AsyncData(updatedDraft);
    _saveDraft();
  }

  void updateEmployee(int index, JobEmployeeModel employee) {
    final currentDraft = state.valueOrNull;
    if (currentDraft == null) return;

    final updatedEmployees = [...currentDraft.employees];
    updatedEmployees[index] = employee;
    
    final updatedDraft = currentDraft.copyWith(
      employees: updatedEmployees,
      updatedAt: DateTime.now(),
    );
    
    state = AsyncData(updatedDraft);
    _saveDraft();
  }

  void removeEmployee(int index) {
    final currentDraft = state.valueOrNull;
    if (currentDraft == null) return;

    final updatedEmployees = [...currentDraft.employees];
    updatedEmployees.removeAt(index);
    
    final updatedDraft = currentDraft.copyWith(
      employees: updatedEmployees,
      updatedAt: DateTime.now(),
    );
    
    state = AsyncData(updatedDraft);
    _saveDraft();
  }

  void updateNote(String note) {
    final currentDraft = state.valueOrNull;
    if (currentDraft == null) return;

    // Note será adicionado como campo adicional se necessário
    // Por enquanto, não temos campo específico para nota no modelo
    // Podemos adicionar depois se necessário
  }

  Future<void> _saveDraft() async {
    final draft = state.valueOrNull;
    if (draft == null) return;

    try {
      final repository = ref.read(jobDraftRepositoryProvider);
      
      if (draft.id.isEmpty) {
        // Criar novo draft
        final id = await repository.create(draft);
        state = AsyncData(draft.copyWith(id: id));
      } else {
        // Atualizar draft existente
        await repository.update(draft.id, draft);
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<bool> submitTimesheet() async {
    state = const AsyncLoading();
    
    try {
      final draft = state.valueOrNull;
      if (draft == null) throw Exception('No draft found');

      // Validações
      if (draft.jobName.isEmpty || draft.jobDescription.isEmpty) {
        throw Exception('Required fields are missing');
      }
      
      if (draft.employees.isEmpty) {
        throw Exception('At least one employee is required');
      }

      // Criar record a partir do draft
      final repository = ref.read(jobRecordRepositoryProvider);
      final record = JobRecordModel(
        id: '',
        userId: draft.userId,
        jobName: draft.jobName,
        date: draft.date,
        territorialManager: draft.territorialManager,
        jobSize: draft.jobSize,
        material: draft.material,
        jobDescription: draft.jobDescription,
        foreman: draft.foreman,
        vehicle: draft.vehicle,
        employees: draft.employees,
        createdAt: draft.createdAt,
        updatedAt: DateTime.now(),
      );
      await repository.create(record);

      // Deletar draft após sucesso
      final draftRepository = ref.read(jobDraftRepositoryProvider);
      await draftRepository.delete(draft.id);

      state = const AsyncData(null);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }

  Future<void> cancelDraft() async {
    final draft = state.valueOrNull;
    if (draft == null) return;

    try {
      final repository = ref.read(jobDraftRepositoryProvider);
      await repository.delete(draft.id);
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}