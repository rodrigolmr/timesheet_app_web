import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_employee_model.dart';
import 'package:timesheet_app_web/src/features/timesheet_create/presentation/providers/timesheet_create_providers.dart';
import 'package:timesheet_app_web/src/features/timesheet_create/presentation/widgets/add_employee_form.dart';

class Step2EmployeesForm extends ConsumerStatefulWidget {
  const Step2EmployeesForm({super.key});

  @override
  ConsumerState<Step2EmployeesForm> createState() => _Step2EmployeesFormState();
}

class _Step2EmployeesFormState extends ConsumerState<Step2EmployeesForm> {
  int? _editingIndex;
  JobEmployeeModel? _employeeToEdit;
  bool _showAddForm = false;

  void _handleAddOrUpdate(JobEmployeeModel employee) {
    if (_editingIndex != null) {
      ref.read(timesheetFormStateProvider.notifier).updateEmployee(_editingIndex!, employee);
      // When updating, close the form
      setState(() {
        _editingIndex = null;
        _employeeToEdit = null;
        _showAddForm = false;
      });
    } else {
      ref.read(timesheetFormStateProvider.notifier).addEmployee(employee);
      // When adding, keep the form open
      setState(() {
        _employeeToEdit = null; // Reset for next entry
      });
    }
  }

  void _handleCancel() {
    setState(() {
      _editingIndex = null;
      _employeeToEdit = null;
      _showAddForm = false;
    });
  }

  void _editEmployee(int index, JobEmployeeModel employee) {
    setState(() {
      _editingIndex = index;
      _employeeToEdit = employee;
      _showAddForm = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(timesheetFormStateProvider);
    final employees = formState.employees;
    
    final bool isDesktop = context.isDesktop;
    
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsive<double>(
          xs: context.dimensions.spacingS,
          sm: context.dimensions.spacingM,
          md: context.dimensions.spacingL,
        ),
        vertical: 0,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: context.responsive<double>(
              xs: double.infinity,
              sm: double.infinity,
              md: 800,
              lg: 1000,
              xl: 1200,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add button - only show when form is hidden AND no employees added yet
              if (!_showAddForm) ...[
                Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: context.dimensions.spacingL),
                    child: Material(
                      color: context.colors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _showAddForm = true;
                            _editingIndex = null;
                            _employeeToEdit = null;
                          });
                        },
                        borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.dimensions.spacingL,
                            vertical: context.dimensions.spacingS + 2,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: context.colors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: context.colors.onPrimary,
                                  size: 16,
                                ),
                              ),
                              SizedBox(width: context.dimensions.spacingM),
                              Text(
                                'Add Employee',
                                style: context.textStyles.subtitle.copyWith(
                                  color: context.colors.primary,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              
              // Add employee form - keep it visible after clicking the button
              AnimatedSize(
                duration: Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: AnimatedOpacity(
                  opacity: _showAddForm ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 200),
                  child: _showAddForm 
                    ? Column(
                        children: [
                          AddEmployeeForm(
                            key: ValueKey(_employeeToEdit), // Force rebuild when employeeToEdit changes
                            employeeToEdit: _employeeToEdit,
                            onSave: _handleAddOrUpdate,
                            onCancel: _handleCancel,
                          ),
                          SizedBox(height: context.dimensions.spacingM),
                        ],
                      )
                    : SizedBox.shrink(),
                ),
              ),
              
              // Employee list - table-like format
              if (employees.isNotEmpty) 
                Builder(
                  builder: (context) {
                    // Check if any employee has travel or meal values
                    final hasTravelData = employees.any((e) => e.travelHours > 0);
                    final hasMealData = employees.any((e) => e.meal > 0);
                    final hasExtraData = hasTravelData || hasMealData;
                    
                    return Column(
                      children: [
                        
                        // Table header - different layouts
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.dimensions.spacingM,
                            vertical: context.dimensions.spacingS,
                          ),
                          decoration: BoxDecoration(
                            color: context.colors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(context.dimensions.borderRadiusM),
                              topRight: Radius.circular(context.dimensions.borderRadiusM),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: hasExtraData ? 3 : 2,
                                child: Text(
                                  'Name',
                                  style: context.textStyles.caption.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: context.colors.primary,
                                  ),
                                ),
                              ),
                              if (!hasExtraData) ...[
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Start',
                                    style: context.textStyles.caption.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: context.colors.primary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Finish',
                                    style: context.textStyles.caption.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: context.colors.primary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Hours',
                                  style: context.textStyles.caption.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: context.colors.primary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              if (hasExtraData) ...[
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Travel',
                                    style: context.textStyles.caption.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: context.colors.primary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Meal',
                                    style: context.textStyles.caption.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: context.colors.primary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                              SizedBox(width: 28), // Space for menu button
                            ],
                          ),
                        ),
                
                // Employee rows
                Column(
                  children: List.generate(employees.length, (index) {
                    final employee = employees[index];
                    final isEditing = _editingIndex == index;
                    final isLast = index == employees.length - 1;
                    
                    return Container(
                      decoration: BoxDecoration(
                        color: isEditing 
                          ? context.colors.primary.withOpacity(0.05)
                          : index.isEven
                            ? context.colors.surface
                            : context.colors.background,
                        border: Border(
                          left: BorderSide(
                            color: context.colors.outline.withOpacity(0.5),
                            width: 1,
                          ),
                          right: BorderSide(
                            color: context.colors.outline.withOpacity(0.5),
                            width: 1,
                          ),
                          bottom: BorderSide(
                            color: context.colors.outline.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        borderRadius: isLast
                          ? BorderRadius.only(
                              bottomLeft: Radius.circular(context.dimensions.borderRadiusM),
                              bottomRight: Radius.circular(context.dimensions.borderRadiusM),
                            )
                          : null,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: context.dimensions.spacingM,
                        vertical: context.dimensions.spacingS,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: hasExtraData ? 3 : 2,
                            child: hasExtraData
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      employee.employeeName,
                                      style: context.textStyles.body.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      '${employee.startTime} - ${employee.finishTime}',
                                      style: context.textStyles.caption.copyWith(
                                        color: context.colors.textSecondary,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  employee.employeeName,
                                  style: context.textStyles.body.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                          ),
                          if (!hasExtraData) ...[
                            Expanded(
                              flex: 1,
                              child: Text(
                                employee.startTime,
                                style: context.textStyles.body,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                employee.finishTime,
                                style: context.textStyles.body,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                          Expanded(
                            flex: 1,
                            child: Text(
                              employee.hours.toStringAsFixed(1),
                              style: context.textStyles.body,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          if (hasExtraData) ...[
                            Expanded(
                              flex: 1,
                              child: Text(
                                employee.travelHours > 0 
                                  ? employee.travelHours.toStringAsFixed(1)
                                  : '-',
                                style: context.textStyles.body,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                employee.meal > 0 
                                  ? employee.meal.toStringAsFixed(1)
                                  : '-',
                                style: context.textStyles.body,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                          SizedBox(
                            width: 28,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Transform.translate(
                                offset: Offset(4, 0), // Move closer to edge
                                child: PopupMenuButton<String>(
                                  icon: Icon(
                                    Icons.more_vert,
                                    size: 18,
                                    color: context.colors.textSecondary,
                                  ),
                                onSelected: (value) {
                                  switch (value) {
                                    case 'edit':
                                      _editEmployee(index, employee);
                                      break;
                                    case 'delete':
                                      ref.read(timesheetFormStateProvider.notifier).removeEmployee(index);
                                      break;
                                  }
                                },
                                itemBuilder: (BuildContext context) => [
                                  PopupMenuItem<String>(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          size: 16,
                                          color: context.colors.textSecondary,
                                        ),
                                        SizedBox(width: context.dimensions.spacingS),
                                        Text('Edit'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          size: 16,
                                          color: context.colors.error,
                                        ),
                                        SizedBox(width: context.dimensions.spacingS),
                                        Text(
                                          'Delete',
                                          style: TextStyle(color: context.colors.error),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(
                                  minWidth: 24,
                                  minHeight: 24,
                                ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                      ],
                    );
                  },
                ),
              
            ],
          ),
        ),
      ),
    );
  }
}