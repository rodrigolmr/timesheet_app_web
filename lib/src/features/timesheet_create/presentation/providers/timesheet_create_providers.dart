import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_employee_model.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/job_record_providers.dart';
import 'package:timesheet_app_web/src/features/timesheet_create/presentation/widgets/step1_header_form.dart';

part 'timesheet_create_providers.g.dart';

/// Provider for Step1 form GlobalKey
final step1FormKeyProvider = Provider((ref) => GlobalKey<Step1HeaderFormState>());

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

/// Provider para gerenciar o estado do timesheet em criação (sem draft)
@Riverpod(keepAlive: true)
class TimesheetFormState extends _$TimesheetFormState {
  
  @override
  JobRecordModel build() {
    developer.log('=== BUILDING TimesheetFormState ===', name: 'TimesheetFormState');
    
    // Get current user ID - use ref.read to avoid unnecessary rebuilds
    final authState = ref.read(authStateProvider);
    final userId = authState.valueOrNull?.uid ?? '';
    
    // Log the build
    developer.log('Building new TimesheetFormState with userId: $userId', 
      name: 'TimesheetFormState');
    
    // Return empty timesheet data
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
      name: 'TimesheetFormState');
    return model;
  }

  /// Updates header data (step 1)
  void updateHeader(Map<String, dynamic> headerData) {
    developer.log('=== UPDATE HEADER START ===', name: 'TimesheetFormState');
    developer.log('Input data: $headerData', name: 'TimesheetFormState');
    
    final previousState = state;
    developer.log('Previous state: JobName="${previousState.jobName}", Date="${previousState.date}"', 
      name: 'TimesheetFormState');
    
    state = state.copyWith(
      jobName: headerData['jobName'] ?? state.jobName,
      date: headerData['date'] ?? state.date,
      territorialManager: headerData['territorialManager'] ?? state.territorialManager,
      jobSize: headerData['jobSize'] ?? state.jobSize,
      material: headerData['material'] ?? state.material,
      jobDescription: headerData['jobDescription'] ?? state.jobDescription,
      foreman: headerData['foreman'] ?? state.foreman,
      vehicle: headerData['vehicle'] ?? state.vehicle,
      updatedAt: DateTime.now(),
    );
    
    developer.log('New state: JobName="${state.jobName}", Date="${state.date}"', 
      name: 'TimesheetFormState');
    developer.log('Full state: {jobName: "${state.jobName}", date: "${state.date}", territorialManager: "${state.territorialManager}", jobSize: "${state.jobSize}", material: "${state.material}", jobDescription: "${state.jobDescription}", foreman: "${state.foreman}", vehicle: "${state.vehicle}"}', 
      name: 'TimesheetFormState');
    developer.log('=== UPDATE HEADER END ===', name: 'TimesheetFormState');
  }

  /// Clears header data (step 1) fields
  void clearHeaderData() {
    developer.log('Clearing header data', name: 'TimesheetFormState');
    
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
      updatedAt: DateTime.now(),
      // Keep date and employees intact
    );
    
    developer.log('Header data cleared', name: 'TimesheetFormState');
  }

  /// Adds an employee
  void addEmployee(JobEmployeeModel employee) {
    developer.log('Adding employee', name: 'TimesheetFormState');
    
    state = state.copyWith(
      employees: [...state.employees, employee],
      updatedAt: DateTime.now(),
    );
    
    developer.log('Employee added. Total employees: ${state.employees.length}', name: 'TimesheetFormState');
  }

  /// Updates an existing employee
  void updateEmployee(int index, JobEmployeeModel employee) {
    developer.log('Updating employee at index $index', name: 'TimesheetFormState');
    
    if (index < 0 || index >= state.employees.length) {
      developer.log('Invalid employee index: $index', name: 'TimesheetFormState');
      return;
    }
    
    final updatedEmployees = [...state.employees];
    updatedEmployees[index] = employee;
    
    state = state.copyWith(
      employees: updatedEmployees,
      updatedAt: DateTime.now(),
    );
    
    developer.log('Employee updated at index $index', name: 'TimesheetFormState');
  }

  /// Removes an employee
  void removeEmployee(int index) {
    developer.log('Removing employee at index $index', name: 'TimesheetFormState');
    
    if (index < 0 || index >= state.employees.length) {
      developer.log('Invalid employee index: $index', name: 'TimesheetFormState');
      return;
    }
    
    final updatedEmployees = [...state.employees];
    updatedEmployees.removeAt(index);
    
    state = state.copyWith(
      employees: updatedEmployees,
      updatedAt: DateTime.now(),
    );
    
    developer.log('Employee removed. Total employees: ${state.employees.length}', name: 'TimesheetFormState');
  }

  /// Submits the timesheet directly to job_records collection
  Future<bool> submitTimesheet() async {
    developer.log('Submitting timesheet...', name: 'TimesheetFormState');
    
    try {
      // Validations
      if (state.jobName.isEmpty || state.jobDescription.isEmpty) {
        throw Exception('Required fields are missing');
      }
      
      if (state.employees.isEmpty) {
        throw Exception('At least one employee is required');
      }
      
      // Save directly to job_records
      final repository = ref.read(jobRecordRepositoryProvider);
      final id = await repository.create(state);
      
      developer.log('Timesheet created with ID: $id', name: 'TimesheetFormState');
      
      // Reset form after successful submission
      ref.invalidateSelf();
      
      return true;
    } catch (e, stackTrace) {
      developer.log('Error submitting timesheet', error: e, stackTrace: stackTrace, name: 'TimesheetFormState');
      throw e;
    }
  }


  /// Resets the form to initial state
  void resetForm() {
    developer.log('Resetting form', name: 'TimesheetFormState');
    ref.invalidateSelf();
  }
}