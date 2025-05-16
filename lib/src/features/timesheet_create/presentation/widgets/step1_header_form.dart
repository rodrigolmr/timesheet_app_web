import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive_grid.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/input/input.dart';
import 'package:timesheet_app_web/src/features/timesheet_create/presentation/providers/timesheet_draft_providers.dart';

class Step1HeaderForm extends ConsumerStatefulWidget {
  const Step1HeaderForm({super.key});

  @override
  ConsumerState<Step1HeaderForm> createState() => _Step1HeaderFormState();
}

class _Step1HeaderFormState extends ConsumerState<Step1HeaderForm> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _jobNameController;
  late TextEditingController _territorialManagerController;
  late TextEditingController _jobSizeController;
  late TextEditingController _materialController;
  late TextEditingController _jobDescriptionController;
  late TextEditingController _foremanController;
  late TextEditingController _vehicleController;
  
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    
    _jobNameController = TextEditingController();
    _territorialManagerController = TextEditingController();
    _jobSizeController = TextEditingController();
    _materialController = TextEditingController();
    _jobDescriptionController = TextEditingController();
    _foremanController = TextEditingController();
    _vehicleController = TextEditingController();
    
    // Carregar dados existentes do draft
    Future.microtask(() {
      final draft = ref.read(timesheetDraftProvider).valueOrNull;
      if (draft != null) {
        _jobNameController.text = draft.jobName;
        _territorialManagerController.text = draft.territorialManager;
        _jobSizeController.text = draft.jobSize;
        _materialController.text = draft.material;
        _jobDescriptionController.text = draft.jobDescription;
        _foremanController.text = draft.foreman;
        _vehicleController.text = draft.vehicle;
        _selectedDate = draft.date;
      }
    });
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

  void _updateDraft(String field, dynamic value) {
    final headerData = {
      'jobName': _jobNameController.text,
      'date': _selectedDate,
      'territorialManager': _territorialManagerController.text,
      'jobSize': _jobSizeController.text,
      'material': _materialController.text,
      'jobDescription': _jobDescriptionController.text,
      'foreman': _foremanController.text,
      'vehicle': _vehicleController.text,
    };
    
    headerData[field] = value;
    ref.read(timesheetDraftProvider.notifier).updateHeader(headerData);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.dimensions.spacingL),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'General Information',
                style: context.textStyles.headline,
              ),
              SizedBox(height: context.dimensions.spacingL),
              
              // Grid layout for form fields
              ResponsiveGrid(
                spacing: context.dimensions.spacingM,
                xsColumns: 1,
                mdColumns: 2,
                children: [
                  // Job Name (required)
                  AppTextField(
                    label: 'Job Name *',
                    hintText: 'Enter job name',
                    controller: _jobNameController,
                    onChanged: (_) => _updateDraft('jobName', _jobNameController.text),
                  ),
                  
                  // Date (required)
                  AppDatePickerField(
                    label: 'Date *',
                    hintText: 'Select date',
                    initialDate: _selectedDate,
                    onDateSelected: (date) {
                      if (date != null) {
                        setState(() {
                          _selectedDate = date;
                        });
                        _updateDraft('date', date);
                      }
                    },
                    dateFormat: intl.DateFormat('MMM-dd-yyyy, EEEE'),
                  ),
                  
                  // Territorial Manager
                  AppTextField(
                    label: 'Territorial Manager',
                    hintText: 'Enter territorial manager name',
                    controller: _territorialManagerController,
                    onChanged: (_) => _updateDraft('territorialManager', _territorialManagerController.text),
                  ),
                  
                  // Job Size
                  AppTextField(
                    label: 'Job Size',
                    hintText: 'Enter job size',
                    controller: _jobSizeController,
                    onChanged: (_) => _updateDraft('jobSize', _jobSizeController.text),
                  ),
                  
                  // Material
                  AppTextField(
                    label: 'Material',
                    hintText: 'Enter material type',
                    controller: _materialController,
                    onChanged: (_) => _updateDraft('material', _materialController.text),
                  ),
                  
                  // Foreman
                  AppTextField(
                    label: 'Foreman',
                    hintText: 'Enter foreman name',
                    controller: _foremanController,
                    onChanged: (_) => _updateDraft('foreman', _foremanController.text),
                  ),
                  
                  // Vehicle
                  AppTextField(
                    label: 'Vehicle',
                    hintText: 'Enter vehicle information',
                    controller: _vehicleController,
                    onChanged: (_) => _updateDraft('vehicle', _vehicleController.text),
                  ),
                ],
              ),
              
              SizedBox(height: context.dimensions.spacingM),
              
              // Job Description (required) - Full width
              AppMultilineTextField(
                label: 'Job Description *',
                hintText: 'Enter job description',
                controller: _jobDescriptionController,
                maxLines: 5,
                onChanged: (_) => _updateDraft('jobDescription', _jobDescriptionController.text),
              ),
              
              SizedBox(height: context.dimensions.spacingL),
              
              // Instructions
              Container(
                padding: EdgeInsets.all(context.dimensions.spacingM),
                decoration: BoxDecoration(
                  color: context.colors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: context.colors.primary,
                    ),
                    SizedBox(width: context.dimensions.spacingS),
                    Expanded(
                      child: Text(
                        'Fields marked with * are required. Changes are saved automatically.',
                        style: context.textStyles.body.copyWith(
                          color: context.colors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}