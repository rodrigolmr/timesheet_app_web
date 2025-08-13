import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive_grid.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/input/input.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/job_record_create_providers.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';

class Step1HeaderForm extends ConsumerStatefulWidget {
  const Step1HeaderForm({super.key});

  @override
  ConsumerState<Step1HeaderForm> createState() => Step1HeaderFormState();
}

class Step1HeaderFormState extends ConsumerState<Step1HeaderForm> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _jobNameController;
  late TextEditingController _territorialManagerController;
  late TextEditingController _jobSizeController;
  late TextEditingController _materialController;
  late TextEditingController _jobDescriptionController;
  late TextEditingController _foremanController;
  late TextEditingController _vehicleController;
  
  DateTime? _selectedDate;
  bool _dateWasModified = false; // Track if user selected a date
  bool _initialized = false;
  
  // Validation states
  bool _jobNameHasError = false;
  bool _dateHasError = false;
  bool _jobDescriptionHasError = false;

  @override
  void initState() {
    super.initState();
    
    developer.log('=== Step1HeaderForm initState ===', name: 'Step1HeaderForm');
    
    _jobNameController = TextEditingController();
    _territorialManagerController = TextEditingController();
    _jobSizeController = TextEditingController();
    _materialController = TextEditingController();
    _jobDescriptionController = TextEditingController();
    _foremanController = TextEditingController();
    _vehicleController = TextEditingController();
  }
  
  bool validateForm() {
    setState(() {
      _jobNameHasError = _jobNameController.text.trim().isEmpty;
      _dateHasError = _selectedDate == null;
      _jobDescriptionHasError = _jobDescriptionController.text.trim().isEmpty;
    });
    
    return !_jobNameHasError && !_dateHasError && !_jobDescriptionHasError;
  }
  
  void clearErrors() {
    setState(() {
      _jobNameHasError = false;
      _dateHasError = false;
      _jobDescriptionHasError = false;
      _dateWasModified = false;
    });
  }

  void _loadFormData(JobRecordModel formState) {
    developer.log('=== Loading form data ===', name: 'Step1HeaderForm');
    developer.log('JobName: "${formState.jobName}", Date: "${formState.date}"', name: 'Step1HeaderForm');
    
    _jobNameController.text = formState.jobName;
    _territorialManagerController.text = formState.territorialManager;
    _jobSizeController.text = formState.jobSize;
    _materialController.text = formState.material;
    _jobDescriptionController.text = formState.jobDescription;
    _foremanController.text = formState.foreman;
    _vehicleController.text = formState.vehicle;
    // Only load date if we're in edit mode or if user already selected a date
    final isEditMode = ref.read(isEditModeProvider);
    if (isEditMode || _dateWasModified) {
      _selectedDate = formState.date;
      _dateWasModified = true;
    } else {
      _selectedDate = null;
      _dateWasModified = false;
    }
    
    // Clear errors when reloading data (like after Clear button)
    clearErrors();
    
    developer.log('Form data loaded successfully', name: 'Step1HeaderForm');
    
    // Force rebuild to ensure UI reflects the loaded data
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _jobNameController.dispose();
    _territorialManagerController.dispose();
    _jobSizeController.dispose();
    _materialController.dispose();
    _jobDescriptionController.dispose();
    _foremanController.dispose();
    _vehicleController.dispose();
    
    super.dispose();
  }

  void _updateFormData(String field, dynamic value) {
    try {
      // Validate required fields
      setState(() {
        if (field == 'jobName') {
          _jobNameHasError = (value as String).trim().isEmpty;
        } else if (field == 'jobDescription') {
          _jobDescriptionHasError = (value as String).trim().isEmpty;
        } else if (field == 'date') {
          _dateHasError = value == null;
        }
      });
      
      final currentFormState = ref.read(jobRecordFormStateProvider);
      final headerData = {
        'jobName': _jobNameController.text,
        'date': _selectedDate ?? currentFormState.date, // Keep existing date if none selected
        'territorialManager': _territorialManagerController.text,
        'jobSize': _jobSizeController.text,
        'material': _materialController.text,
        'jobDescription': _jobDescriptionController.text,
        'foreman': _foremanController.text,
        'vehicle': _vehicleController.text,
      };
      
      headerData[field] = value;
      ref.read(jobRecordFormStateProvider.notifier).updateHeader(headerData);
      
      developer.log('Updated form field: $field with value: $value', name: 'Step1HeaderForm');
      developer.log('Full header data: $headerData', name: 'Step1HeaderForm');
      
      // Read back the state to verify it was saved
      final savedState = ref.read(jobRecordFormStateProvider);
      developer.log('Saved state - JobName: ${savedState.jobName}, Date: ${savedState.date}', name: 'Step1HeaderForm');
    } catch (e, stackTrace) {
      developer.log('Error updating form', error: e, stackTrace: stackTrace, name: 'Step1HeaderForm');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating form. Please try again.'),
            backgroundColor: context.colors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(jobRecordFormStateProvider);
    
    // Load form data whenever the provider changes (for editing mode)
    // But avoid unnecessary reloads by checking if data actually changed
    if (!_initialized || 
        _jobNameController.text != formState.jobName ||
        _territorialManagerController.text != formState.territorialManager ||
        _jobDescriptionController.text != formState.jobDescription) {
      developer.log('Loading form data - initialized: $_initialized', name: 'Step1HeaderForm');
      _loadFormData(formState);
      _initialized = true;
    }
    
    return Center(
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
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.dimensions.spacingM,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                // Grid layout for form fields
                ResponsiveGrid(
                  spacing: context.dimensions.spacingM > 8 ? context.dimensions.spacingM - 8 : 0, // Compensar o padding do glow apenas se maior que 8
                  xsColumns: 1,
                  mdColumns: 2,
                  children: [
                    // Job Name (required)
                    AppTextField(
                      label: 'Job Name',
                      hintText: 'Enter job name',
                      controller: _jobNameController,
                      textCapitalization: TextCapitalization.words,
                      hasError: _jobNameHasError,
                      errorText: null,
                      onClearError: () {
                        setState(() {
                          _jobNameHasError = false;
                        });
                      },
                      onChanged: (value) {
                        _updateFormData('jobName', value);
                      },
                    ),
                    
                    // Date (required)
                    AppDatePickerField(
                      label: 'Date',
                      hintText: 'Select date',
                      initialDate: _selectedDate,
                      dateFormat: intl.DateFormat('M/d/yy, EEEE'),
                      hasError: _dateHasError,
                      errorText: null,
                      onClearError: () {
                        setState(() {
                          _dateHasError = false;
                        });
                      },
                      onDateSelected: (date) {
                        // Ensure we store the date with noon time for timezone safety
                        final safeDate = date != null 
                            ? DateTime(date.year, date.month, date.day, 12, 0, 0)
                            : null;
                        setState(() {
                          _selectedDate = safeDate;
                          _dateWasModified = true;
                        });
                        _updateFormData('date', safeDate);
                      },
                    ),
                    
                    // Territorial Manager
                    AppTextField(
                      label: 'Territorial Manager',
                      hintText: 'Enter territorial manager name',
                      controller: _territorialManagerController,
                      textCapitalization: TextCapitalization.words,
                      onChanged: (value) {
                        _updateFormData('territorialManager', value);
                      },
                    ),
                    
                    // Job Size
                    AppTextField(
                      label: 'Job Size',
                      hintText: 'Enter job size',
                      controller: _jobSizeController,
                      textCapitalization: TextCapitalization.none,
                      onChanged: (value) {
                        _updateFormData('jobSize', value);
                      },
                    ),
                    
                    // Foreman
                    AppTextField(
                      label: 'Foreman',
                      hintText: 'Enter foreman name',
                      controller: _foremanController,
                      textCapitalization: TextCapitalization.words,
                      onChanged: (value) {
                        _updateFormData('foreman', value);
                      },
                    ),
                    
                    // Vehicle
                    AppTextField(
                      label: 'Vehicle',
                      hintText: 'Enter vehicle information',
                      controller: _vehicleController,
                      onChanged: (value) {
                        _updateFormData('vehicle', value);
                      },
                    ),
                  ],
                ),
                
                SizedBox(height: context.dimensions.spacingS),
                
                // Material - Full width multiline
                AppMultilineTextField(
                  label: 'Material',
                  hintText: 'Enter material type and details',
                  controller: _materialController,
                  minLines: 3,
                  maxLines: 5,
                  onChanged: (value) {
                    _updateFormData('material', value);
                  },
                ),
                
                SizedBox(height: context.dimensions.spacingS),
                
                // Job Description (required) - Full width multiline
                AppMultilineTextField(
                  label: 'Job Description',
                  hintText: 'Describe the work performed in detail',
                  controller: _jobDescriptionController,
                  minLines: 4,
                  maxLines: 10,
                  hasError: _jobDescriptionHasError,
                  errorText: null,
                  onClearError: () {
                    setState(() {
                      _jobDescriptionHasError = false;
                    });
                  },
                  onChanged: (value) {
                    _updateFormData('jobDescription', value);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}