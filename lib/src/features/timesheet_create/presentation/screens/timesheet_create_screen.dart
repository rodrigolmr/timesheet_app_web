import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timesheet_app_web/src/core/navigation/routes.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/app_header.dart';
import 'package:timesheet_app_web/src/features/timesheet_create/presentation/providers/timesheet_draft_providers.dart';
import 'package:timesheet_app_web/src/features/timesheet_create/presentation/widgets/timesheet_stepper.dart';
import 'package:timesheet_app_web/src/features/timesheet_create/presentation/widgets/step1_header_form.dart';
import 'package:timesheet_app_web/src/features/timesheet_create/presentation/widgets/step2_employees_form.dart';
import 'package:timesheet_app_web/src/features/timesheet_create/presentation/widgets/step3_review_form.dart';

class TimesheetCreateScreen extends ConsumerStatefulWidget {
  const TimesheetCreateScreen({super.key});

  @override
  ConsumerState<TimesheetCreateScreen> createState() => _TimesheetCreateScreenState();
}

class _TimesheetCreateScreenState extends ConsumerState<TimesheetCreateScreen> {
  @override
  void initState() {
    super.initState();
    // Carregar draft existente ao iniciar
    Future.microtask(() {
      ref.read(timesheetDraftProvider.notifier).build();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = ref.watch(currentStepNotifierProvider);
    final draftAsync = ref.watch(timesheetDraftProvider);
    
    return Scaffold(
      appBar: AppHeader(
        title: 'Create Timesheet',
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Stepper
          TimesheetStepper(
            currentStep: currentStep,
            onStepTapped: (step) {
              // Validar antes de mudar de step
              if (step > currentStep && !_validateCurrentStep()) {
                return;
              }
              ref.read(currentStepNotifierProvider.notifier).setStep(step);
            },
          ),
          
          Divider(height: 1),
          
          // Content
          Expanded(
            child: draftAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: context.colors.error,
                    ),
                    SizedBox(height: context.dimensions.spacingM),
                    Text(
                      'Error loading draft',
                      style: context.textStyles.title,
                    ),
                    SizedBox(height: context.dimensions.spacingS),
                    Text(
                      error.toString(),
                      style: context.textStyles.body.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              data: (_) => _buildStepContent(currentStep),
            ),
          ),
          
          // Navigation Buttons
          Container(
            padding: EdgeInsets.all(context.dimensions.spacingM),
            decoration: BoxDecoration(
              color: context.colors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: _buildNavigationButtons(currentStep),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(int step) {
    switch (step) {
      case 0:
        return const Step1HeaderForm();
      case 1:
        return const Step2EmployeesForm();
      case 2:
        return const Step3ReviewForm();
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildNavigationButtons(int currentStep) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back Button
        if (currentStep > 0)
          OutlinedButton.icon(
            onPressed: () {
              ref.read(currentStepNotifierProvider.notifier).previousStep();
            },
            icon: Icon(Icons.arrow_back),
            label: Text('Back'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: context.dimensions.spacingL,
                vertical: context.dimensions.spacingM,
              ),
            ),
          )
        else
          SizedBox.shrink(),

        // Action Buttons
        Row(
          children: [
            if (currentStep == 2) ...[
              // Cancel button only on last step
              TextButton(
                onPressed: () => _handleCancel(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: context.colors.error),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.dimensions.spacingL,
                    vertical: context.dimensions.spacingM,
                  ),
                ),
              ),
              SizedBox(width: context.dimensions.spacingM),
            ],
            
            // Next/Submit Button
            ElevatedButton.icon(
              onPressed: () => _handleNext(currentStep),
              icon: Icon(
                currentStep == 2 ? Icons.check : Icons.arrow_forward,
              ),
              label: Text(currentStep == 2 ? 'Submit' : 'Next'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: context.dimensions.spacingL,
                  vertical: context.dimensions.spacingM,
                ),
                backgroundColor: context.colors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  bool _validateCurrentStep() {
    final currentStep = ref.read(currentStepNotifierProvider);
    final draft = ref.read(timesheetDraftProvider).valueOrNull;
    
    switch (currentStep) {
      case 0:
        // Validar campos obrigatórios do header
        if (draft == null) return false;
        if (draft.jobName.isEmpty || 
            draft.jobDescription.isEmpty) {
          _showValidationError('Please fill in all required fields');
          return false;
        }
        return true;
        
      case 1:
        // Validar que tem pelo menos um funcionário
        if (draft == null || draft.employees.isEmpty) {
          _showValidationError('Please add at least one employee');
          return false;
        }
        return true;
        
      case 2:
        // Step de revisão sempre pode avançar
        return true;
        
      default:
        return false;
    }
  }

  void _handleNext(int currentStep) async {
    if (!_validateCurrentStep()) return;
    
    if (currentStep < 2) {
      ref.read(currentStepNotifierProvider.notifier).nextStep();
    } else {
      // Submit
      _handleSubmit();
    }
  }

  void _handleCancel() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Timesheet?'),
        content: Text('Are you sure you want to cancel? All unsaved changes will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(timesheetDraftProvider.notifier).cancelDraft();
              if (mounted) {
                context.go(AppRoute.home.path);
              }
            },
            child: Text(
              'Yes, Cancel',
              style: TextStyle(color: context.colors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Submit Timesheet?'),
        content: Text('Are you sure you want to submit this timesheet? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await ref.read(timesheetDraftProvider.notifier).submitTimesheet();
              
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Timesheet submitted successfully'),
                    backgroundColor: context.colors.success,
                  ),
                );
                context.go(AppRoute.home.path);
              } else if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error submitting timesheet'),
                    backgroundColor: context.colors.error,
                  ),
                );
              }
            },
            child: Text(
              'Submit',
              style: TextStyle(color: context.colors.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: context.colors.error,
      ),
    );
  }
}