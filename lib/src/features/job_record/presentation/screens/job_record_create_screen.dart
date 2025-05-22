import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timesheet_app_web/src/core/navigation/routes.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/app_header.dart';
import 'package:timesheet_app_web/src/core/widgets/buttons/buttons.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/job_record_create_providers.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/job_record_providers.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/widgets/create/job_record_stepper.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/widgets/create/step1_header_form.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/widgets/create/step2_employees_form.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/widgets/create/step3_review_form.dart';

class JobRecordCreateScreen extends ConsumerStatefulWidget {
  final String? editRecordId;
  
  const JobRecordCreateScreen({
    super.key,
    this.editRecordId,
  });

  @override
  ConsumerState<JobRecordCreateScreen> createState() => _JobRecordCreateScreenState();
}

class _JobRecordCreateScreenState extends ConsumerState<JobRecordCreateScreen> {
  bool _isInitialized = false;
  
  @override
  void initState() {
    super.initState();
    // Initialize form with existing data if editing
    if (widget.editRecordId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(isEditModeProvider.notifier).setEditMode(true);
        _loadExistingRecord();
      });
    } else {
      // Ensure we're not in edit mode for new records
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(isEditModeProvider.notifier).setEditMode(false);
      });
    }
  }
  
  void _loadExistingRecord() {
    final recordAsync = ref.read(jobRecordByIdProvider(widget.editRecordId!));
    recordAsync.when(
      data: (record) {
        if (record != null && !_isInitialized) {
          ref.read(jobRecordFormStateProvider.notifier).loadFromExistingRecord(record);
          _isInitialized = true;
        }
      },
      loading: () {},
      error: (error, stack) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading job record: $error'),
            backgroundColor: context.colors.error,
          ),
        );
      },
    );
  }
  
  Widget _buildCurrentStep(int currentStep) {
    switch (currentStep) {
      case 0:
        return Step1HeaderForm(key: ref.watch(step1FormKeyProvider));
      case 1:
        return const Step2EmployeesForm();
      case 2:
        return const Step3ReviewForm();
      default:
        return Step1HeaderForm(key: ref.watch(step1FormKeyProvider));
    }
  }
  
  void _handlePrevious() {
    ref.read(currentStepNotifierProvider.notifier).previousStep();
  }
  
  void _handleNext() async {
    final currentStep = ref.read(currentStepNotifierProvider);
    final formState = ref.read(jobRecordFormStateProvider);
    
    developer.log('=== HANDLE NEXT - Step $currentStep ===', name: 'JobRecordCreateScreen');
    
    if (currentStep == 2) {
      // Validate before submit
      if (formState.jobName.isEmpty || formState.jobDescription.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please complete all required fields'),
            backgroundColor: context.colors.error,
          ),
        );
        return;
      }
      
      if (formState.employees.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please add at least one employee'),
            backgroundColor: context.colors.error,
          ),
        );
        return;
      }
      
      // Submit the job record
      await _submitJobRecord();
    } else {
      // Validate current step
      bool canProceed = false;
      
      if (currentStep == 0) {
        // Use the GlobalKey to access Step1HeaderForm and validate
        final step1FormKey = ref.read(step1FormKeyProvider);
        canProceed = step1FormKey.currentState?.validateForm() ?? false;
        
        if (canProceed) {
          // Add small delay to ensure state is saved
          await Future.delayed(Duration(milliseconds: 100));
          
          // Verify state before navigation
          final savedState = ref.read(jobRecordFormStateProvider);
          developer.log('State before navigation - JobName: "${savedState.jobName}", Date: "${savedState.date}"', 
            name: 'JobRecordCreateScreen');
        }
      } else if (currentStep == 1) {
        // Validate employees
        canProceed = formState.employees.isNotEmpty;
        
        if (!canProceed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please add at least one employee'),
              backgroundColor: context.colors.error,
            ),
          );
        }
      }
      
      if (canProceed) {
        ref.read(currentStepNotifierProvider.notifier).nextStep();
        developer.log('Moving to step ${currentStep + 1}', name: 'JobRecordCreateScreen');
      }
    }
  }
  
  Future<void> _submitJobRecord() async {
    // Show confirmation dialog first
    final shouldSubmit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
        ),
        title: Text(
          'Submit Job Record',
          style: context.textStyles.title,
        ),
        content: Text(
          widget.editRecordId != null 
            ? 'Are you ready to save changes to this job record?'
            : 'Are you ready to submit this job record? Once submitted, it cannot be edited.',
          style: context.textStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: context.colors.textSecondary,
            ),
            child: Text(widget.editRecordId != null ? 'Review Again' : 'Review Again'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.primary,
              foregroundColor: context.colors.onPrimary,
            ),
            child: Text(widget.editRecordId != null ? 'Save' : 'Submit'),
          ),
        ],
      ),
    );
    
    if (shouldSubmit != true) return;
    
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          backgroundColor: context.colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
          ),
          child: Padding(
            padding: EdgeInsets.all(context.dimensions.spacingL),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: context.colors.primary,
                ),
                SizedBox(height: context.dimensions.spacingM),
                Text(
                  widget.editRecordId != null 
                    ? 'Saving changes...' 
                    : 'Submitting job record...',
                  style: context.textStyles.body,
                ),
                SizedBox(height: context.dimensions.spacingS),
                Text(
                  'Please wait',
                  style: context.textStyles.caption.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      
      final success = await ref.read(jobRecordFormStateProvider.notifier).submitJobRecord(
        editRecordId: widget.editRecordId,
      );
      
      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }
      
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.editRecordId != null 
                ? 'Job record updated successfully!' 
                : 'Job record submitted successfully!'),
              backgroundColor: context.colors.success,
            ),
          );
          
          // Reset edit mode and navigate back to home
          ref.read(isEditModeProvider.notifier).setEditMode(false);
          context.go(AppRoute.home.path);
        }
      }
    } catch (e, stackTrace) {
      developer.log('Error submitting job record', error: e, stackTrace: stackTrace, name: 'JobRecordCreateScreen');
      
      // Close loading dialog if still open
      if (mounted) {
        Navigator.of(context).pop();
      }
      
      if (mounted) {
        final errorMessage = _getErrorMessage(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: context.colors.error,
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Retry',
              textColor: context.colors.onError,
              onPressed: () => _submitJobRecord(),
            ),
          ),
        );
      }
    }
  }
  
  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('permission')) {
      return 'You do not have permission to submit job records';
    } else if (error.toString().contains('network')) {
      return 'Network error. Please check your connection';
    } else if (error.toString().contains('required fields')) {
      return 'Please fill all required fields';
    } else {
      return 'Failed to submit job record. Please try again';
    }
  }
  
  void _handleCancel() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
        ),
        title: Text(
          'Cancel Job Record',
          style: context.textStyles.title,
        ),
        content: Text(
          'Are you sure you want to cancel? All data will be lost.',
          style: context.textStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: context.colors.textSecondary,
            ),
            child: Text('No, Continue'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(jobRecordFormStateProvider.notifier).resetForm();
              ref.read(isEditModeProvider.notifier).setEditMode(false);
              context.go(AppRoute.home.path);
            },
            style: TextButton.styleFrom(
              foregroundColor: context.colors.error,
            ),
            child: Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
  
  void _handleClearHeader() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Form'),
        content: Text('Are you sure you want to clear all fields?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('No, Keep'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(jobRecordFormStateProvider.notifier).clearHeaderData();
              
              // Clear error states in the form
              final step1FormKey = ref.read(step1FormKeyProvider);
              step1FormKey.currentState?.clearErrors();
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Form cleared'),
                  backgroundColor: context.colors.primary,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Text('Yes, Clear'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final currentStep = ref.watch(currentStepNotifierProvider);
    
    // If editing, show loading while data loads
    if (widget.editRecordId != null && !_isInitialized) {
      final recordAsync = ref.watch(jobRecordByIdProvider(widget.editRecordId!));
      return recordAsync.when(
        data: (record) {
          if (record != null && !_isInitialized) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(jobRecordFormStateProvider.notifier).loadFromExistingRecord(record);
              _isInitialized = true;
            });
          }
          return _buildContent(context, currentStep);
        },
        loading: () => Scaffold(
          appBar: AppHeader(
            title: 'Loading Job Record',
            showBackButton: true,
            onBackPressed: () => context.go(AppRoute.home.path),
          ),
          body: const Center(child: CircularProgressIndicator()),
        ),
        error: (error, stack) => Scaffold(
          appBar: AppHeader(
            title: 'Error',
            showBackButton: true,
            onBackPressed: () => context.go(AppRoute.home.path),
          ),
          body: Center(
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
                  'Error loading job record',
                  style: context.textStyles.title,
                ),
                SizedBox(height: context.dimensions.spacingS),
                Text(
                  error.toString(),
                  style: context.textStyles.body.copyWith(
                    color: context.colors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: context.dimensions.spacingL),
                ElevatedButton(
                  onPressed: () => context.go(AppRoute.home.path),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return _buildContent(context, currentStep);
  }
  
  Widget _buildContent(BuildContext context, int currentStep) {
    return Scaffold(
      appBar: AppHeader(
        title: widget.editRecordId != null ? 'Edit Job Record' : 'Create Job Record',
        showBackButton: true,
        onBackPressed: () => context.go(AppRoute.home.path),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Stepper - wrapped in ResponsiveContainer for better alignment
              Padding(
                padding: EdgeInsets.only(
                  top: context.dimensions.spacingXS, // Reduzido
                  bottom: 2, // Reduzido ao mínimo
                ),
                child: ResponsiveContainer(
                  child: JobRecordStepper(
                    currentStep: currentStep,
                    onStepTapped: (step) {
                      ref.read(currentStepNotifierProvider.notifier).setStep(step);
                    },
                  ),
                ),
              ),
              
              // Current step content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    top: 0, // Removido completamente o espaço superior
                    // Adicionado padding inferior que corresponde à altura dos botões + seu espaçamento
                    bottom: currentStep == 0 ? context.responsive<double>(
                      xs: 56.0 + context.dimensions.spacingS * 2, // Altura do FAB (56) + espaçamento acima e abaixo
                      sm: 56.0 + context.dimensions.spacingM * 2,
                      md: 36.0 + context.dimensions.spacingM * 2, // Altura aproximada do ElevatedButton + espaçamento
                      lg: 36.0 + context.dimensions.spacingM * 2,
                    ) : 0,
                  ),
                  child: ResponsiveContainer(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.responsive<double>(
                        xs: context.dimensions.spacingS,
                        sm: context.dimensions.spacingS,
                        md: context.dimensions.spacingM,
                        lg: context.dimensions.spacingM,
                      ),
                    ),
                    child: _buildCurrentStep(currentStep),
                  ),
                ),
              ),
            ],
          ),
          
          // Floating buttons (realmente flutuantes, sem barra ao redor)
          Positioned(
            bottom: context.responsive<double>(
              xs: context.dimensions.spacingS, // Ajustado para ficar mais próximo da borda em mobile
              sm: context.dimensions.spacingM,
              md: context.dimensions.spacingM,
            ),
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.responsive<double>(
                  xs: context.dimensions.spacingM,
                  sm: context.dimensions.spacingM,
                  md: context.dimensions.spacingL,
                  lg: context.dimensions.spacingL,
                ),
              ),
              child: ResponsiveContainer(
                padding: EdgeInsets.zero,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Área de botões à esquerda
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Previous button (flutuante) - apenas nos steps > 1
                        if (currentStep > 0)
                          if (!context.isMobile)
                            ElevatedButton.icon(
                              icon: Icon(Icons.arrow_back, size: 16),
                              label: Text('Previous'),
                              onPressed: _handlePrevious,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: context.colors.surface,
                                foregroundColor: context.colors.primary,
                                elevation: 3,
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.dimensions.spacingM,
                                  vertical: context.dimensions.spacingS,
                                ),
                              ),
                            )
                          else
                            FloatingActionButton.small(
                              heroTag: 'prevBtn',
                              onPressed: _handlePrevious,
                              tooltip: 'Previous',
                              elevation: 3,
                              backgroundColor: context.colors.surface,
                              foregroundColor: context.colors.primary,
                              child: Icon(Icons.arrow_back, size: 16),
                            ),
                            
                        // Clear button para o Step 1 com ícone de vassoura amarelo
                        if (currentStep == 0)
                          if (!context.isMobile)
                            ElevatedButton.icon(
                              icon: Icon(Icons.cleaning_services, size: 16, color: Colors.amber),
                              label: Text('Clear'),
                              onPressed: _handleClearHeader,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: context.colors.surface,
                                foregroundColor: context.colors.secondary,
                                elevation: 3,
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.dimensions.spacingM,
                                  vertical: context.dimensions.spacingS,
                                ),
                              ),
                            )
                          else
                            FloatingActionButton.small(
                              heroTag: 'clearBtn',
                              onPressed: _handleClearHeader,
                              tooltip: 'Clear',
                              elevation: 3,
                              backgroundColor: context.colors.surface,
                              foregroundColor: Colors.amber,
                              child: Icon(Icons.cleaning_services, size: 16),
                            ),
                      ],
                    ),
                    
                    // Spacing otimizado
                    const Spacer(),
                    
                    // Action buttons - Desktop (flutuantes)
                    if (!context.isMobile)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Cancel button - flutuante
                          ElevatedButton(
                            onPressed: _handleCancel,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.colors.surface,
                              foregroundColor: context.colors.error,
                              elevation: 2,
                              padding: EdgeInsets.symmetric(
                                horizontal: context.dimensions.spacingM,
                                vertical: context.dimensions.spacingS,
                              ),
                            ),
                            child: Text('Cancel'),
                          ),
                          SizedBox(width: context.dimensions.spacingL),
                          
                          // Next/Submit button - flutuante e destacado
                          ElevatedButton.icon(
                            onPressed: _handleNext,
                            icon: Icon(
                              currentStep == 2 ? Icons.check : Icons.arrow_forward,
                              size: 18,
                            ),
                            label: Text(currentStep == 2 ? 'Submit' : 'Next'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.colors.primary,
                              foregroundColor: context.colors.onPrimary,
                              elevation: 4,
                              padding: EdgeInsets.symmetric(
                                horizontal: context.dimensions.spacingM,
                                vertical: context.dimensions.spacingS,
                              ),
                            ),
                          ),
                        ],
                      ),
                    
                    // Action buttons - Mobile (botões flutuantes)
                    if (context.isMobile)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Cancel button - flutuante pequeno
                          FloatingActionButton.small(
                            heroTag: 'cancelBtn',
                            onPressed: _handleCancel,
                            tooltip: 'Cancel',
                            elevation: 2,
                            backgroundColor: context.colors.surface,
                            foregroundColor: context.colors.error,
                            child: Icon(Icons.close, size: 16),
                          ),
                          SizedBox(width: context.dimensions.spacingL),
                          
                          // Next/Submit button - flutuante destacado
                          FloatingActionButton(
                            heroTag: 'nextBtn',
                            onPressed: _handleNext,
                            tooltip: currentStep == 2 ? 'Submit' : 'Next',
                            elevation: 4,
                            backgroundColor: context.colors.primary,
                            child: Icon(
                              currentStep == 2 ? Icons.check : Icons.arrow_forward,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}