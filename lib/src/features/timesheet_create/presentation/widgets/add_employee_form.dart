import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/input/input.dart';
import 'package:timesheet_app_web/src/features/employee/data/models/employee_model.dart';
import 'package:timesheet_app_web/src/features/employee/presentation/providers/employee_providers.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_employee_model.dart';

// Custom TextInputFormatter for time format (HH:MM)
class TimeTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final buffer = StringBuffer();
    
    for (int i = 0; i < newText.length && i < 4; i++) {
      if (i == 2) {
        buffer.write(':');
      }
      buffer.write(newText[i]);
    }
    
    final formattedText = buffer.toString();
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

// Custom TextInputFormatter for decimal numbers (0.0)
class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalPlaces;
  
  DecimalTextInputFormatter({this.decimalPlaces = 1});
  
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final regex = RegExp(r'^\d*\.?\d{0,' + decimalPlaces.toString() + r'}');
    final match = regex.firstMatch(newValue.text);
    
    if (match == null) {
      return oldValue;
    }
    
    return TextEditingValue(
      text: match.group(0)!,
      selection: TextSelection.collapsed(offset: match.group(0)!.length),
    );
  }
}

class AddEmployeeForm extends ConsumerStatefulWidget {
  final JobEmployeeModel? employeeToEdit;
  final Function(JobEmployeeModel) onSave;
  final VoidCallback onCancel;
  
  const AddEmployeeForm({
    super.key,
    this.employeeToEdit,
    required this.onSave,
    required this.onCancel,
  });

  @override
  ConsumerState<AddEmployeeForm> createState() => _AddEmployeeFormState();
}

class _AddEmployeeFormState extends ConsumerState<AddEmployeeForm> {
  final _formKey = GlobalKey<FormState>();
  EmployeeModel? _selectedEmployee;
  final _startTimeController = TextEditingController();
  final _finishTimeController = TextEditingController();
  final _hoursController = TextEditingController();
  final _travelHoursController = TextEditingController();
  final _mealController = TextEditingController();
  
  bool _showOptionalFields = false;
  String? _employeeError;
  
  // Validation states
  bool _employeeHasError = false;
  bool _hoursHasError = false;
  
  @override
  void initState() {
    super.initState();
    if (widget.employeeToEdit != null) {
      _initializeEditForm();
    }
  }
  
  void _initializeEditForm() {
    final employee = widget.employeeToEdit!;
    _startTimeController.text = employee.startTime;
    _finishTimeController.text = employee.finishTime;
    _hoursController.text = employee.hours.toStringAsFixed(1);
    _travelHoursController.text = employee.travelHours.toStringAsFixed(1);
    _mealController.text = employee.meal.toStringAsFixed(1);
    
    // Show optional fields if they have values
    if (employee.travelHours > 0 || employee.meal > 0) {
      _showOptionalFields = true;
    }
    
    // Set selected employee
    Future.microtask(() {
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
    });
  }
  
  @override
  void dispose() {
    _startTimeController.dispose();
    _finishTimeController.dispose();
    _hoursController.dispose();
    _travelHoursController.dispose();
    _mealController.dispose();
    super.dispose();
  }
  
  void _handleSubmit() {
    setState(() {
      _employeeHasError = _selectedEmployee == null;
      _hoursHasError = _hoursController.text.trim().isEmpty;
    });
    
    if (_formKey.currentState?.validate() ?? false) {
      if (_employeeHasError || _hoursHasError) {
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

      widget.onSave(employee);
      
      // Clear form if not editing
      if (widget.employeeToEdit == null) {
        _clearForm();
      }
    }
  }
  
  void _clearForm() {
    setState(() {
      _selectedEmployee = null; // Clear only the employee selection
      _employeeError = null;
      _employeeHasError = false;
      // Keep the showOptionalFields state as is
    });
    // Don't clear time and hour fields - keep them for the next employee
  }
  
  String? _validateTime(String? value) {
    if (value == null || value.isEmpty) return null;
    
    final regex = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
    if (!regex.hasMatch(value)) {
      return 'Invalid time format (HH:MM)';
    }
    return null;
  }
  
  String? _validateHours(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Don't return error text
    }
    
    final number = double.tryParse(value);
    if (number == null) {
      return null;
    }
    
    if (number < 0 || number > 24) {
      return null;
    }
    
    return null;
  }
  
  String? _validateDecimal(String? value) {
    if (value == null || value.isEmpty) return null;
    
    final number = double.tryParse(value);
    if (number == null) {
      return 'Invalid number';
    }
    
    if (number < 0) {
      return 'Cannot be negative';
    }
    
    return null;
  }
  
  Widget _buildTimeField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        TimeTextInputFormatter(),
      ],
      validator: validator,
      style: context.textStyles.input,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: context.textStyles.inputLabel,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        floatingLabelAlignment: FloatingLabelAlignment.center,
        floatingLabelStyle: context.textStyles.inputFloatingLabel.copyWith(
          color: context.colors.primary,
        ),
        hintText: 'HH:MM',
        hintStyle: context.textStyles.inputHint.copyWith(
          color: context.colors.onSurfaceVariant.withOpacity(0.6),
        ),
        filled: true,
        fillColor: context.colors.surfaceAccent.withOpacity(0.85),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
          borderSide: BorderSide(
            color: context.colors.outline,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
          borderSide: BorderSide(
            color: context.colors.outline,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
          borderSide: BorderSide(
            color: context.colors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
          borderSide: BorderSide(
            color: context.colors.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
          borderSide: BorderSide(
            color: context.colors.error,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.responsive<double>(
            xs: context.dimensions.spacingS,
            sm: context.dimensions.spacingS,
            md: context.dimensions.spacingM,
          ),
          vertical: context.responsive<double>(
            xs: context.dimensions.spacingS,
            sm: context.dimensions.spacingS,
            md: context.dimensions.spacingS,
          ),
        ),
        isDense: true,
      ),
    );
  }
  
  Widget _buildDecimalField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    bool hasError = false,
    VoidCallback? onClearError,
  }) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: hasError
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                boxShadow: [
                  BoxShadow(
                    color: context.colors.error.withOpacity(0.5),
                    blurRadius: 6,
                    spreadRadius: 0,
                    offset: const Offset(0, 0),
                  ),
                ],
              )
            : null,
        child: TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            DecimalTextInputFormatter(decimalPlaces: 1),
          ],
          validator: validator,
          style: context.textStyles.input,
          textAlign: TextAlign.center,
          onChanged: (_) {
            if (hasError && onClearError != null) {
              onClearError();
            }
          },
          decoration: InputDecoration(
            labelText: label,
            labelStyle: context.textStyles.inputLabel.copyWith(
              color: hasError ? context.colors.error : null,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            floatingLabelAlignment: FloatingLabelAlignment.center,
            floatingLabelStyle: context.textStyles.inputFloatingLabel.copyWith(
              color: hasError ? context.colors.error : context.colors.primary,
            ),
            hintText: '0.0',
            hintStyle: context.textStyles.inputHint.copyWith(
              color: context.colors.onSurfaceVariant.withOpacity(0.6),
            ),
            filled: true,
            fillColor: context.colors.surfaceAccent.withOpacity(0.85),
            errorText: null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
              borderSide: BorderSide(
                color: context.colors.outline,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
              borderSide: BorderSide(
                color: hasError ? context.colors.error : context.colors.outline,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
              borderSide: BorderSide(
                color: hasError ? context.colors.error : context.colors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
              borderSide: BorderSide(
                color: context.colors.error,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
              borderSide: BorderSide(
                color: context.colors.error,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.responsive<double>(
                xs: context.dimensions.spacingS,
                sm: context.dimensions.spacingS,
                md: context.dimensions.spacingM,
              ),
              vertical: context.responsive<double>(
                xs: context.dimensions.spacingS,
                sm: context.dimensions.spacingS,
                md: context.dimensions.spacingS,
              ),
            ),
            isDense: true,
          ),
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final employeesAsync = ref.watch(employeesStreamProvider);
    final isMobile = context.screenWidth < 600;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
        color: context.colors.primary.withOpacity(0.15),
      ),
      padding: context.responsive<EdgeInsets>(
        xs: EdgeInsets.symmetric(horizontal: context.dimensions.spacingS, vertical: context.dimensions.spacingS),
        sm: EdgeInsets.symmetric(horizontal: context.dimensions.spacingM, vertical: context.dimensions.spacingS),
        md: EdgeInsets.symmetric(horizontal: context.dimensions.spacingM, vertical: context.dimensions.spacingM),
      ),
      child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Form Content
              Column(
                  children: [
                    // Employee Dropdown
                    employeesAsync.when(
                      data: (employees) {
                        // Mock data for testing
                        final mockEmployees = [
                          EmployeeModel(
                            id: '1',
                            firstName: 'John',
                            lastName: 'Doe',
                            isActive: true,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                          ),
                          EmployeeModel(
                            id: '2',
                            firstName: 'Jane',
                            lastName: 'Smith',
                            isActive: true,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                          ),
                          EmployeeModel(
                            id: '3',
                            firstName: 'Mike',
                            lastName: 'Johnson',
                            isActive: true,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                          ),
                          EmployeeModel(
                            id: '4',
                            firstName: 'Sarah',
                            lastName: 'Williams',
                            isActive: true,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                          ),
                        ];
                        
                        // Use mock data if no real employees
                        final activeEmployees = employees.isEmpty 
                            ? mockEmployees 
                            : employees.where((e) => e.isActive).toList();
                        
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppDropdownField<EmployeeModel>(
                              label: 'Employee Name',
                              hintText: 'Select an employee',
                              value: _selectedEmployee,
                              items: activeEmployees,
                              itemLabelBuilder: (employee) => employee.name,
                              hasError: _employeeHasError,
                              errorText: null,
                              onClearError: () {
                                setState(() {
                                  _employeeHasError = false;
                                });
                              },
                              onChanged: (employee) {
                                setState(() {
                                  _selectedEmployee = employee;
                                  _employeeHasError = false;
                                });
                              },
                            ),
                          ],
                        );
                      },
                      loading: () => SizedBox(
                        height: 56,
                        child: Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: context.colors.primary,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ),
                      error: (error, stack) => Text(
                        'Error loading employees',
                        style: TextStyle(
                          color: context.colors.error,
                          fontSize: 12,
                        ),
                      ),
                    ),

                    SizedBox(height: context.responsive<double>(
                      xs: context.dimensions.spacingXS,
                      sm: context.dimensions.spacingXS,
                      md: context.dimensions.spacingS,
                    )),

                    // Main Fields - Always in Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildTimeField(
                            label: 'Start',
                            controller: _startTimeController,
                            validator: _validateTime,
                          ),
                        ),
                        SizedBox(width: context.responsive<double>(
                          xs: math.max(0, context.dimensions.spacingXS - 8),
                          sm: math.max(0, context.dimensions.spacingXS - 8),
                          md: math.max(0, context.dimensions.spacingS - 8),
                        )),
                        Expanded(
                          child: _buildTimeField(
                            label: 'Finish',
                            controller: _finishTimeController,
                            validator: _validateTime,
                          ),
                        ),
                        SizedBox(width: context.responsive<double>(
                          xs: math.max(0, context.dimensions.spacingXS - 8),
                          sm: math.max(0, context.dimensions.spacingXS - 8),
                          md: math.max(0, context.dimensions.spacingS - 8),
                        )),
                        Expanded(
                          child: _buildDecimalField(
                            label: 'Hours',
                            controller: _hoursController,
                            validator: _validateHours,
                            hasError: _hoursHasError,
                            onClearError: () {
                              setState(() {
                                _hoursHasError = false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: context.responsive<double>(
                      xs: context.dimensions.spacingXS,
                      sm: context.dimensions.spacingXS,
                      md: context.dimensions.spacingS,
                    )),

                    // Optional Fields - Show if toggle is on
                    if (_showOptionalFields) ...[
                      Row(
                        children: [
                          Expanded(
                            child: _buildDecimalField(
                              label: 'Travel',
                              controller: _travelHoursController,
                              validator: _validateDecimal,
                            ),
                          ),
                          SizedBox(width: context.responsive<double>(
                            xs: context.dimensions.spacingXS,
                            sm: context.dimensions.spacingXS,
                            md: context.dimensions.spacingS,
                          )),
                          Expanded(
                            child: _buildDecimalField(
                              label: 'Meal',
                              controller: _mealController,
                              validator: _validateDecimal,
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: context.responsive<double>(
                        xs: context.dimensions.spacingS,
                        sm: context.dimensions.spacingS,
                        md: context.dimensions.spacingM,
                      )),
                    ] else ...[
                      SizedBox(height: context.responsive<double>(
                        xs: context.dimensions.spacingXS,
                        sm: context.dimensions.spacingXS,
                        md: context.dimensions.spacingS,
                      )),
                    ],

                    // Action Buttons
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Full width row with left and right buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Left - Close button
                            IconButton(
                              onPressed: widget.onCancel,
                              tooltip: 'Close',
                              iconSize: context.responsive<double>(
                                xs: 18,
                                sm: 20,
                                md: 22,
                              ),
                              icon: Icon(
                                Icons.close,
                                color: context.categoryColorByName("cancel"),
                              ),
                              style: IconButton.styleFrom(
                                shape: CircleBorder(
                                  side: BorderSide(
                                    color: context.categoryColorByName("cancel"),
                                    width: 1,
                                  ),
                                ),
                                padding: EdgeInsets.all(context.dimensions.spacingXS),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              constraints: BoxConstraints.tightFor(
                                width: context.responsive<double>(
                                  xs: 32,
                                  sm: 36,
                                  md: 40,
                                ),
                                height: context.responsive<double>(
                                  xs: 32,
                                  sm: 36,
                                  md: 40,
                                ),
                              ),
                            ),
                            
                            // Right - Add Travel & Meal button
                            !_showOptionalFields
                              ? TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _showOptionalFields = true;
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4, 
                                      horizontal: 8,
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Travel & Meal',
                                    style: TextStyle(
                                      color: context.colors.primary,
                                      fontSize: context.textStyles.caption.fontSize,
                                    ),
                                  ),
                                )
                              : const SizedBox(
                                  width: 100, // Keep consistent width when hidden
                                ),
                          ],
                        ),
                        
                        // Center - Absolute positioned Add button
                        IconButton(
                          onPressed: _handleSubmit,
                          tooltip: widget.employeeToEdit != null ? 'Update' : 'Add Employee',
                          iconSize: context.responsive<double>(
                            xs: 26,
                            sm: 28,
                            md: 30,
                          ),
                          icon: Icon(
                            widget.employeeToEdit != null ? Icons.save : Icons.add_circle,
                            color: context.colors.onPrimary,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: context.colors.primary,
                            padding: EdgeInsets.all(context.dimensions.spacingXS),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          constraints: BoxConstraints.tightFor(
                            width: context.responsive<double>(
                              xs: 44,
                              sm: 48,
                              md: 52,
                            ),
                            height: context.responsive<double>(
                              xs: 44,
                              sm: 48,
                              md: 52,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
      ),
    );
  }
}