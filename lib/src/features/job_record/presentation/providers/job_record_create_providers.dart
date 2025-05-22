import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_employee_model.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/job_record_providers.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/widgets/create/step1_header_form.dart';

part 'job_record_create_providers.g.dart';

/// Provider for Step1 form GlobalKey
final step1FormKeyProvider = Provider((ref) => GlobalKey<Step1HeaderFormState>());

/// Provider para indicar se estamos em modo de edição
@Riverpod(keepAlive: true)
class IsEditMode extends _$IsEditMode {
  @override
  bool build() => false;

  void setEditMode(bool isEditing) {
    state = isEditing;
  }
}

/// Provider para gerenciar o step atual do formulário
@Riverpod(keepAlive: true)
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

/// Provider para gerenciar o estado do job record em criação
@Riverpod(keepAlive: true)
class JobRecordFormState extends _$JobRecordFormState {
  
  @override
  JobRecordModel build() {
    developer.log('=== BUILDING JobRecordFormState ===', name: 'JobRecordFormState');
    
    // Get current user ID - use ref.read to avoid unnecessary rebuilds
    final authState = ref.read(authStateProvider);
    final userId = authState.valueOrNull?.uid ?? '';
    
    // Log the build
    developer.log('Building new JobRecordFormState with userId: $userId', 
      name: 'JobRecordFormState');
    
    // Return empty job record data
    final model = JobRecordModel(
      id: '',
      userId: userId,
      jobName: '',
      date: DateTime.now(),
      territorialManager: '',
      jobSize: '',
      material: '',
      jobDescription: '',
      foreman: '',
      vehicle: '',
      employees: [],
      notes: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    developer.log('Built initial model: jobName="${model.jobName}", date="${model.date}"', 
      name: 'JobRecordFormState');
    return model;
  }

  /// Updates header data (step 1)
  void updateHeader(Map<String, dynamic> headerData) {
    developer.log('=== UPDATE HEADER START ===', name: 'JobRecordFormState');
    developer.log('Input data: $headerData', name: 'JobRecordFormState');
    
    final previousState = state;
    developer.log('Previous state: JobName="${previousState.jobName}", Date="${previousState.date}"', 
      name: 'JobRecordFormState');
    
    state = state.copyWith(
      jobName: headerData['jobName'] ?? state.jobName,
      date: headerData['date'] ?? state.date,
      territorialManager: headerData['territorialManager'] ?? state.territorialManager,
      jobSize: headerData['jobSize'] ?? state.jobSize,
      material: headerData['material'] ?? state.material,
      jobDescription: headerData['jobDescription'] ?? state.jobDescription,
      foreman: headerData['foreman'] ?? state.foreman,
      vehicle: headerData['vehicle'] ?? state.vehicle,
      notes: headerData['notes'] ?? state.notes,
      updatedAt: DateTime.now(),
    );
    
    developer.log('New state: JobName="${state.jobName}", Date="${state.date}"', 
      name: 'JobRecordFormState');
    developer.log('Full state: {jobName: "${state.jobName}", date: "${state.date}", territorialManager: "${state.territorialManager}", jobSize: "${state.jobSize}", material: "${state.material}", jobDescription: "${state.jobDescription}", foreman: "${state.foreman}", vehicle: "${state.vehicle}"}', 
      name: 'JobRecordFormState');
    developer.log('=== UPDATE HEADER END ===', name: 'JobRecordFormState');
  }

  /// Clears header data (step 1) fields
  void clearHeaderData() {
    developer.log('Clearing header data', name: 'JobRecordFormState');
    
    // Get current user ID - use ref.read to avoid unnecessary rebuilds
    final authState = ref.read(authStateProvider);
    final userId = authState.valueOrNull?.uid ?? '';
    
    state = state.copyWith(
      jobName: '',
      territorialManager: '',
      jobSize: '',
      material: '',
      jobDescription: '',
      foreman: '',
      vehicle: '',
      notes: '',
      updatedAt: DateTime.now(),
      // Keep date and employees intact
    );
    
    developer.log('Header data cleared', name: 'JobRecordFormState');
  }

  /// Adds an employee
  void addEmployee(JobEmployeeModel employee) {
    developer.log('Adding employee', name: 'JobRecordFormState');
    
    state = state.copyWith(
      employees: [...state.employees, employee],
      updatedAt: DateTime.now(),
    );
    
    developer.log('Employee added. Total employees: ${state.employees.length}', name: 'JobRecordFormState');
  }

  /// Updates an existing employee
  void updateEmployee(int index, JobEmployeeModel employee) {
    developer.log('Updating employee at index $index', name: 'JobRecordFormState');
    
    if (index < 0 || index >= state.employees.length) {
      developer.log('Invalid employee index: $index', name: 'JobRecordFormState');
      return;
    }
    
    final updatedEmployees = [...state.employees];
    updatedEmployees[index] = employee;
    
    state = state.copyWith(
      employees: updatedEmployees,
      updatedAt: DateTime.now(),
    );
    
    developer.log('Employee updated at index $index', name: 'JobRecordFormState');
  }

  /// Removes an employee
  void removeEmployee(int index) {
    developer.log('Removing employee at index $index', name: 'JobRecordFormState');
    
    if (index < 0 || index >= state.employees.length) {
      developer.log('Invalid employee index: $index', name: 'JobRecordFormState');
      return;
    }
    
    final updatedEmployees = [...state.employees];
    updatedEmployees.removeAt(index);
    
    state = state.copyWith(
      employees: updatedEmployees,
      updatedAt: DateTime.now(),
    );
    
    developer.log('Employee removed. Total employees: ${state.employees.length}', name: 'JobRecordFormState');
  }

  /// Loads data from an existing record for editing
  void loadFromExistingRecord(JobRecordModel record) {
    developer.log('Loading existing record for editing: ${record.id}', name: 'JobRecordFormState');
    
    state = record.copyWith(
      updatedAt: DateTime.now(),
    );
    
    developer.log('Record loaded successfully', name: 'JobRecordFormState');
  }

  /// Submits the job record (create or update)
  Future<bool> submitJobRecord({String? editRecordId}) async {
    developer.log('Submitting job record... Edit ID: $editRecordId', name: 'JobRecordFormState');
    
    try {
      // Validations
      if (state.jobName.isEmpty || state.jobDescription.isEmpty) {
        throw Exception('Required fields are missing');
      }
      
      if (state.employees.isEmpty) {
        throw Exception('At least one employee is required');
      }
      
      final repository = ref.read(jobRecordRepositoryProvider);
      
      if (editRecordId != null) {
        // Update existing record
        await repository.update(editRecordId, state.copyWith(
          updatedAt: DateTime.now(),
        ));
        developer.log('Job record updated with ID: $editRecordId', name: 'JobRecordFormState');
      } else {
        // Create new record
        final id = await repository.create(state);
        developer.log('Job record created with ID: $id', name: 'JobRecordFormState');
      }
      
      // Reset form after successful submission
      ref.invalidateSelf();
      
      return true;
    } catch (e, stackTrace) {
      developer.log('Error submitting job record', error: e, stackTrace: stackTrace, name: 'JobRecordFormState');
      throw e;
    }
  }


  /// Resets the form to initial state
  void resetForm() {
    developer.log('Resetting form', name: 'JobRecordFormState');
    ref.invalidateSelf();
  }
}