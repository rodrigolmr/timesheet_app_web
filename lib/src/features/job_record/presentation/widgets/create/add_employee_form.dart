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

// Custom TextInputFormatter for 12-hour time format (HH:MM)
class TimeTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final buffer = StringBuffer();
    
    // For 4 digits, format as HH:MM
    if (newText.length >= 4) {
      buffer.write(newText.substring(0, 2));
      buffer.write(':');
      buffer.write(newText.substring(2, 4));
    }
    // For 3 digits
    else if (newText.length == 3) {
      final firstTwoDigits = int.parse(newText.substring(0, 2));
      
      // If first two digits make a valid hour (10-12), format as HH:M (no zero padding)
      if (firstTwoDigits >= 10 && firstTwoDigits <= 12) {
        buffer.write(newText.substring(0, 2));
        buffer.write(':');
        buffer.write(newText[2]);
      }
      // Otherwise format as H:MM
      else {
        buffer.write(newText[0]);
        buffer.write(':');
        buffer.write(newText.substring(1, 3));
      }
    }
    // For 1-2 digits
    else {
      for (int i = 0; i < newText.length; i++) {
        if (i == 2) {
          buffer.write(':');
        }
        buffer.write(newText[i]);
      }
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
  bool _startTimeHasError = false;
  bool _finishTimeHasError = false;
  
  // Focus nodes for time fields
  final _startTimeFocusNode = FocusNode();
  final _finishTimeFocusNode = FocusNode();
  
  @override
  void initState() {
    super.initState();
    if (widget.employeeToEdit != null) {
      _initializeEditForm();
    }
    
    // Add listeners for auto-complete
    _startTimeFocusNode.addListener(_onStartTimeFocusChange);
    _finishTimeFocusNode.addListener(_onFinishTimeFocusChange);
  }
  
  void _onStartTimeFocusChange() {
    if (!_startTimeFocusNode.hasFocus) {
      _autoCompleteTime(_startTimeController);
    }
  }
  
  void _onFinishTimeFocusChange() {
    if (!_finishTimeFocusNode.hasFocus) {
      _autoCompleteTime(_finishTimeController);
    }
  }
  
  void _autoCompleteTime(TextEditingController controller) {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    
    // Remove any non-digit characters
    final digitsOnly = text.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Auto-complete single or double digit entries
    if (digitsOnly.length == 1 || digitsOnly.length == 2) {
      final hour = int.tryParse(digitsOnly);
      if (hour != null && hour >= 1 && hour <= 12) {
        controller.text = '$hour:00';
      }
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
  }
  
  @override
  void dispose() {
    _startTimeController.dispose();
    _finishTimeController.dispose();
    _hoursController.dispose();
    _travelHoursController.dispose();
    _mealController.dispose();
    _startTimeFocusNode.dispose();
    _finishTimeFocusNode.dispose();
    super.dispose();
  }
  
  void _handleSubmit() {
    // Validate all fields
    final startTimeValid = _validateTime(_startTimeController.text) == null;
    final finishTimeValid = _validateTime(_finishTimeController.text) == null;
    
    setState(() {
      _employeeHasError = _selectedEmployee == null;
      _hoursHasError = _hoursController.text.trim().isEmpty;
      _startTimeHasError = _startTimeController.text.isNotEmpty && !startTimeValid;
      _finishTimeHasError = _finishTimeController.text.isNotEmpty && !finishTimeValid;
    });
    
    if (_formKey.currentState?.validate() ?? false) {
      if (_employeeHasError || _hoursHasError || _startTimeHasError || _finishTimeHasError) {
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
      _startTimeHasError = false;
      _finishTimeHasError = false;
      // Keep the showOptionalFields state as is
    });
    // Don't clear time and hour fields - keep them for the next employee
  }
  
  String? _validateTime(String? value) {
    if (value == null || value.isEmpty) return null;
    
    // Validate 12-hour format (1-12:00-59)
    final regex = RegExp(r'^(0?[1-9]|1[0-2]):[0-5][0-9]$');
    if (!regex.hasMatch(value)) {
      return 'Invalid time (use 1-12 format)';
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
    FocusNode? focusNode,
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
          focusNode: focusNode,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            TimeTextInputFormatter(),
          ],
          validator: (value) => null, // Don't show error text
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
                        
                        // Find the employee to edit if we're in edit mode and haven't selected one yet
                        if (widget.employeeToEdit != null && _selectedEmployee == null) {
                          final employee = widget.employeeToEdit!;
                          _selectedEmployee = activeEmployees.firstWhere(
                            (e) => e.id == employee.employeeId,
                            orElse: () => EmployeeModel(
                              id: employee.employeeId,
                              firstName: employee.employeeName.split(' ').first,
                              lastName: employee.employeeName.split(' ').skip(1).join(' '),
                              isActive: true,
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now(),
                            ),
                          );
                        }
                        
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
                              focusNode: _startTimeFocusNode,
                              hasError: _startTimeHasError,
                              onClearError: () {
                                setState(() {
                                  _startTimeHasError = false;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: context.responsive<double>(
                            xs: context.dimensions.spacingXS,
                            sm: context.dimensions.spacingXS,
                            md: context.dimensions.spacingS,
                          )),
                          Expanded(
                            child: _buildTimeField(
                              label: 'Finish',
                              controller: _finishTimeController,
                              validator: _validateTime,
                              focusNode: _finishTimeFocusNode,
                              hasError: _finishTimeHasError,
                              onClearError: () {
                                setState(() {
                                  _finishTimeHasError = false;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: context.responsive<double>(
                            xs: context.dimensions.spacingXS,
                            sm: context.dimensions.spacingXS,
                            md: context.dimensions.spacingS,
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
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _handleSubmit,
                            borderRadius: BorderRadius.circular(100),
                            child: Tooltip(
                              message: widget.employeeToEdit != null ? 'Update' : 'Add Employee',
                              child: Container(
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
                                decoration: BoxDecoration(
                                  color: context.colors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    widget.employeeToEdit != null ? Icons.save : Icons.add_circle,
                                    color: context.colors.onPrimary,
                                    size: context.responsive<double>(
                                      xs: 26,
                                      sm: 28,
                                      md: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
          ],
        ),
      ),
    );
  }
}