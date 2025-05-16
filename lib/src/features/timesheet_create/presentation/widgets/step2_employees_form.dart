import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive_grid.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/input/input.dart';
import 'package:timesheet_app_web/src/core/widgets/buttons/buttons.dart';
import 'package:timesheet_app_web/src/features/employee/presentation/providers/employee_providers.dart';
import 'package:timesheet_app_web/src/features/employee/data/models/employee_model.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_employee_model.dart';
import 'package:timesheet_app_web/src/features/timesheet_create/presentation/providers/timesheet_draft_providers.dart';

class Step2EmployeesForm extends ConsumerStatefulWidget {
  const Step2EmployeesForm({super.key});

  @override
  ConsumerState<Step2EmployeesForm> createState() => _Step2EmployeesFormState();
}

class _Step2EmployeesFormState extends ConsumerState<Step2EmployeesForm> {
  EmployeeModel? _selectedEmployee;
  final _startTimeController = TextEditingController();
  final _finishTimeController = TextEditingController();
  final _hoursController = TextEditingController();
  final _travelHoursController = TextEditingController();
  final _mealController = TextEditingController();
  
  int? _editingIndex;

  @override
  void dispose() {
    _startTimeController.dispose();
    _finishTimeController.dispose();
    _hoursController.dispose();
    _travelHoursController.dispose();
    _mealController.dispose();
    super.dispose();
  }

  void _clearForm() {
    setState(() {
      _selectedEmployee = null;
      _startTimeController.clear();
      _finishTimeController.clear();
      _hoursController.clear();
      _travelHoursController.clear();
      _mealController.clear();
      _editingIndex = null;
    });
  }

  void _addOrUpdateEmployee() {
    if (_selectedEmployee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an employee'),
          backgroundColor: context.colors.error,
        ),
      );
      return;
    }

    if (_hoursController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hours field is required'),
          backgroundColor: context.colors.error,
        ),
      );
      return;
    }

    final employee = JobEmployeeModel(
      employeeId: _selectedEmployee!.id,
      employeeName: _selectedEmployee!.name,
      startTime: _startTimeController.text,
      finishTime: _finishTimeController.text,
      hours: double.tryParse(_hoursController.text) ?? 0.0,
      travelHours: double.tryParse(_travelHoursController.text) ?? 0.0,
      meal: double.tryParse(_mealController.text) ?? 0.0,
    );

    if (_editingIndex != null) {
      ref.read(timesheetDraftProvider.notifier).updateEmployee(_editingIndex!, employee);
    } else {
      ref.read(timesheetDraftProvider.notifier).addEmployee(employee);
    }

    _clearForm();
  }

  void _editEmployee(int index, JobEmployeeModel employee) {
    setState(() {
      _editingIndex = index;
      _startTimeController.text = employee.startTime;
      _finishTimeController.text = employee.finishTime;
      _hoursController.text = employee.hours.toString();
      _travelHoursController.text = employee.travelHours.toString();
      _mealController.text = employee.meal.toString();
    });
    
    // Buscar o employee model completo
    ref.read(employeesStreamProvider).whenData((employees) {
      final emp = employees.firstWhere(
        (e) => e.id == employee.employeeId,
        orElse: () => EmployeeModel(
          id: employee.employeeId,
          firstName: employee.employeeName.split(' ').first,
          lastName: employee.employeeName.split(' ').last,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      setState(() {
        _selectedEmployee = emp;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final employeesAsync = ref.watch(employeesStreamProvider);
    final draft = ref.watch(timesheetDraftProvider).valueOrNull;
    final addedEmployees = draft?.employees ?? [];

    return ResponsiveContainer(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.dimensions.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Employees',
              style: context.textStyles.headline,
            ),
            SizedBox(height: context.dimensions.spacingL),

            // Employee Form
            Container(
              padding: EdgeInsets.all(context.dimensions.spacingM),
              decoration: BoxDecoration(
                border: Border.all(
                  color: context.colors.textSecondary.withOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
              ),
              child: Column(
                children: [
                  // Employee Dropdown
                  employeesAsync.when(
                    data: (employees) {
                      final activeEmployees = employees.where((e) => e.isActive).toList();
                      return AppDropdownField<EmployeeModel>(
                        label: 'Employee Name *',
                        hintText: 'Select an employee',
                        value: _selectedEmployee,
                        items: activeEmployees,
                        itemLabelBuilder: (employee) => employee.name,
                        onChanged: (employee) {
                          setState(() {
                            _selectedEmployee = employee;
                          });
                        },
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stack) => Text('Error loading employees'),
                  ),

                  SizedBox(height: context.dimensions.spacingM),

                  // Time fields
                  ResponsiveGrid(
                    spacing: context.dimensions.spacingM,
                    xsColumns: 1,
                    mdColumns: 3,
                    children: [
                      AppTextField(
                        label: 'Start Time',
                        hintText: 'HH:mm',
                        controller: _startTimeController,
                        keyboardType: TextInputType.datetime,
                      ),
                      AppTextField(
                        label: 'Finish Time',
                        hintText: 'HH:mm',
                        controller: _finishTimeController,
                        keyboardType: TextInputType.datetime,
                      ),
                      AppTextField(
                        label: 'Hours *',
                        hintText: '0.0',
                        controller: _hoursController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ],
                  ),

                  SizedBox(height: context.dimensions.spacingM),

                  // Additional fields
                  ResponsiveGrid(
                    spacing: context.dimensions.spacingM,
                    xsColumns: 1,
                    mdColumns: 2,
                    children: [
                      AppTextField(
                        label: 'Travel Hours',
                        hintText: '0.0',
                        controller: _travelHoursController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                      AppTextField(
                        label: 'Meal',
                        hintText: '0.0',
                        controller: _mealController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ],
                  ),

                  SizedBox(height: context.dimensions.spacingL),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (_editingIndex != null)
                        AppButton(
                          label: 'Cancel',
                          type: AppButtonType.secondary,
                          onPressed: _clearForm,
                        ),
                      SizedBox(width: context.dimensions.spacingM),
                      AppButton(
                        label: _editingIndex != null ? 'Update' : 'Add Employee',
                        onPressed: _addOrUpdateEmployee,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: context.dimensions.spacingXL),

            // Employees Table
            if (addedEmployees.isNotEmpty) ...[
              Text(
                'Added Employees',
                style: context.textStyles.title,
              ),
              SizedBox(height: context.dimensions.spacingM),
              
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: context.dimensions.spacingL,
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Start')),
                    DataColumn(label: Text('Finish')),
                    DataColumn(label: Text('Hours')),
                    DataColumn(label: Text('Travel')),
                    DataColumn(label: Text('Meal')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: List.generate(addedEmployees.length, (index) {
                    final employee = addedEmployees[index];
                    return DataRow(
                      cells: [
                        DataCell(Text(employee.employeeName)),
                        DataCell(Text(employee.startTime)),
                        DataCell(Text(employee.finishTime)),
                        DataCell(Text(employee.hours.toStringAsFixed(1))),
                        DataCell(Text(employee.travelHours.toStringAsFixed(1))),
                        DataCell(Text(employee.meal.toStringAsFixed(1))),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppIconButton(
                                icon: Icons.edit,
                                onPressed: () => _editEmployee(index, employee),
                                tooltip: 'Edit',
                              ),
                              AppIconButton(
                                icon: Icons.delete,
                                onPressed: () {
                                  ref.read(timesheetDraftProvider.notifier).removeEmployee(index);
                                },
                                tooltip: 'Delete',
                                color: context.colors.error,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ] else
              Container(
                padding: EdgeInsets.all(context.dimensions.spacingXL),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                  border: Border.all(
                    color: context.colors.textSecondary.withOpacity(0.3),
                  ),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 64,
                        color: context.colors.textSecondary.withOpacity(0.5),
                      ),
                      SizedBox(height: context.dimensions.spacingM),
                      Text(
                        'No employees added yet',
                        style: context.textStyles.body.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}