// lib/pages/timesheet_header_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timesheet_app_web/core/responsive/responsive.dart';
import 'package:timesheet_app_web/core/responsive/responsive_layout.dart';
import 'package:timesheet_app_web/core/theme/app_theme.dart';
import 'package:timesheet_app_web/core/routes/app_routes.dart';
import '../widgets/base_layout.dart';
import '../widgets/input_field.dart';
import '../widgets/input_field_multiline.dart';
import '../widgets/date_picker_field.dart';
import '../widgets/app_button.dart';
import '../providers/timesheet_provider.dart';
import '../repositories/timesheet_draft_repository.dart';
import '../repositories/user_repository.dart';
import '../providers.dart';

class TimesheetHeaderPage extends ConsumerStatefulWidget {
  const TimesheetHeaderPage({Key? key}) : super(key: key);

  @override
  _TimesheetHeaderPageState createState() => _TimesheetHeaderPageState();
}

class _TimesheetHeaderPageState extends ConsumerState<TimesheetHeaderPage> {
  final _jobNameController = TextEditingController();
  final _tmController = TextEditingController();
  final _jobSizeController = TextEditingController();
  final _materialController = TextEditingController();
  final _jobDescController = TextEditingController();
  final _foremanController = TextEditingController();
  final _vehicleController = TextEditingController();
  DateTime? _selectedDate;
  bool _isEditMode = false;
  String _docId = '';

  // Variáveis para controlar erros de validação
  bool _showJobNameError = false;
  bool _showDateError = false;
  bool _showJobDescError = false;
  
  // Flag para controle de verificação de rascunho
  bool _hasCheckedForDraft = false;

  @override
  void initState() {
    super.initState();
    final data = ref.read(timesheetProvider);
    _jobNameController.text = data.jobName ?? '';
    _tmController.text = data.tm ?? '';
    _jobSizeController.text = data.jobSize ?? '';
    _materialController.text = data.material ?? '';
    _jobDescController.text = data.jobDesc ?? '';
    _foremanController.text = data.foreman ?? '';
    _vehicleController.text = data.vehicle ?? '';
    _selectedDate = data.date != null ? DateTime.tryParse(data.date!) : null;

    // Apenas definimos um novo userId se NÃO estivermos em modo de edição
    Future(() {
      if (mounted) {
        // Verificar se estamos em modo de edição (argumento é verificado em didChangeDependencies)
        // No modo didChangeDependencies ainda não foi chamado, então verificamos novamente via ModalRoute
        final args =
            ModalRoute.of(context)?.settings.arguments
                as Map<String, dynamic>? ??
            {};
        final isEdit = args['editMode'] as bool? ?? false;

        // Se não estiver em modo de edição, define o userId atual
        if (!isEdit && (data.userId?.isEmpty ?? true)) {
          final userRepository = ref.read(userRepositoryProvider);
          final currentUser = userRepository.getCurrentUser();
          
          if (currentUser != null) {
            ref.read(timesheetProvider.notifier).updateField('userId', currentUser.id);
            
            // Verificar se há rascunho para recuperar
            if (!_hasCheckedForDraft && !isEdit) {
              _checkForDraft();
            }
          } else {
            // Se o usuário não estiver autenticado, redireciona para a página de login
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          }
        }
      }
    });
  }
  
  // Verifica se existe um rascunho para o usuário atual
  Future<void> _checkForDraft() async {
    if (_hasCheckedForDraft || _isEditMode) return;
    
    _hasCheckedForDraft = true;
    final draftRepository = ref.read(timesheetDraftRepositoryProvider);
    final userRepository = ref.read(userRepositoryProvider);
    final currentUser = userRepository.getCurrentUser();
    
    if (currentUser == null) return;
    
    final draft = draftRepository.loadDraft(currentUser.id);
    final hasDraft = draft != null;
    
    if (hasDraft && mounted) {
      // Mostra diálogo perguntando se o usuário quer recuperar o rascunho
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Resume Timesheet'),
          content: const Text('We saved your previous timesheet as a draft. Would you like to continue working on it?'),
          actions: [
            TextButton(
              onPressed: () {
                // Descarta o rascunho
                draftRepository.deleteDraft(currentUser.id);
                ref.read(timesheetProvider.notifier).reset();
                ref.read(timesheetProvider.notifier).updateField('userId', currentUser.id);
                
                // Limpa os campos
                _jobNameController.clear();
                _tmController.clear();
                _jobSizeController.clear();
                _materialController.clear();
                _jobDescController.clear();
                _foremanController.clear();
                _vehicleController.clear();
                setState(() {
                  _selectedDate = null;
                });
                
                Navigator.of(context).pop();
              },
              child: const Text('Create New'),
            ),
            TextButton(
              onPressed: () {
                // Recupera o rascunho e atualiza os campos
                if (draft != null) {
                  ref.read(timesheetProvider.notifier).loadDraftData(draft);
                  
                  // Atualiza os campos do formulário
                  final data = ref.read(timesheetProvider);
                  _jobNameController.text = data.jobName ?? '';
                  _tmController.text = data.tm ?? '';
                  _jobSizeController.text = data.jobSize ?? '';
                  _materialController.text = data.material ?? '';
                  _jobDescController.text = data.jobDesc ?? '';
                  _foremanController.text = data.foreman ?? '';
                  _vehicleController.text = data.vehicle ?? '';
                  setState(() {
                    _selectedDate = data.date != null ? DateTime.tryParse(data.date!) : null;
                  });
                }
                
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppTheme.primaryBlue,
              ),
              child: const Text('Resume Draft'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Lê os argumentos passados na navegação
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
        {};
    _isEditMode = args['editMode'] as bool? ?? false;
    _docId = args['docId'] as String? ?? '';
  }

  @override
  void dispose() {
    _jobNameController.dispose();
    _tmController.dispose();
    _jobSizeController.dispose();
    _materialController.dispose();
    _jobDescController.dispose();
    _foremanController.dispose();
    _vehicleController.dispose();
    super.dispose();
  }

  void _clearAll() {
    _jobNameController.clear();
    _tmController.clear();
    _jobSizeController.clear();
    _materialController.clear();
    _jobDescController.clear();
    _foremanController.clear();
    _vehicleController.clear();
    setState(() {
      _selectedDate = null;
      // Resetar os erros também
      _showJobNameError = false;
      _showDateError = false;
      _showJobDescError = false;
    });

    // Salvar o userId atual antes de limpar
    final userId = ref.read(timesheetProvider).userId;

    // Atrasar a atualização do provider para depois que a árvore de widgets terminar de ser atualizada
    Future(() {
      if (mounted) {
        // Resetar o timesheet
        ref.read(timesheetProvider.notifier).reset();

        // Se estiver em modo de edição, garantir que o userId permaneça o mesmo
        if (_isEditMode && userId != null && userId.isNotEmpty) {
          ref.read(timesheetProvider.notifier).updateField('userId', userId);
        }
        // Se não estiver em modo de edição, usar o userId atual ou obter um novo
        else if (!_isEditMode) {
          if (userId != null && userId.isNotEmpty) {
            ref.read(timesheetProvider.notifier).updateField('userId', userId);
          } else {
            // Se não tiver userId salvo, tenta obter do usuário autenticado
            final userRepository = ref.read(userRepositoryProvider);
            final currentUser = userRepository.getCurrentUser();
            if (currentUser != null) {
              ref.read(timesheetProvider.notifier).updateField('userId', currentUser.id);
            }
          }
        }
      }
    });
  }

  // Show confirmation dialog before cancelling timesheet creation
  void _showCancelConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Timesheet'),
        content: const Text('Are you sure you want to cancel? All data entered will be lost.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            child: const Text('No, Continue'),
          ),
          TextButton(
            onPressed: () {
              // Clean up the timesheet state
              final notifier = ref.read(timesheetProvider.notifier);
              notifier.reset();
              
              final userRepository = ref.read(userRepositoryProvider);
              final currentUser = userRepository.getCurrentUser();
              if (currentUser != null) {
                notifier.updateField('userId', currentUser.id);
              }
              
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Return to previous screen
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red[700],
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  // Função para validar campos obrigatórios antes de avançar
  bool _validateRequiredFields() {
    final jobNameEmpty = _jobNameController.text.trim().isEmpty;
    final dateEmpty = _selectedDate == null;
    final jobDescEmpty = _jobDescController.text.trim().isEmpty;

    setState(() {
      _showJobNameError = jobNameEmpty;
      _showDateError = dateEmpty;
      _showJobDescError = jobDescEmpty;
    });

    return !(jobNameEmpty || dateEmpty || jobDescEmpty);
  }
  
  void _onNextPressed() {
    if (_validateRequiredFields()) {
      // Salva o rascunho atual antes de avançar
      final data = ref.read(timesheetProvider);
      final draftRepository = ref.read(timesheetDraftRepositoryProvider);
      if (data.userId != null && data.userId!.isNotEmpty) {
        draftRepository.saveDraft(data);
      }
      
      // Passa informações de edição para a próxima página usando GoRouter
      context.pushNamed(
        AppRoutes.timesheetWorkersName,
        extra: {'editMode': _isEditMode, 'docId': _docId},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveSizing(context);
    
    return BaseLayout(
      title: _isEditMode ? 'Edit Job Info' : 'Job Info',
      showTitleBox: true,
      verticalAlignment: LayoutAlignment.top,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: responsive.responsiveValue(
          mobile: AppTheme.defaultSpacing,
          tablet: AppTheme.mediumSpacing,
          desktop: AppTheme.largeSpacing,
        )),
        child: ResponsiveContainer(
          mobileMaxWidth: 500.0,
          tabletMaxWidth: 600.0,
          desktopMaxWidth: 700.0,
          padding: EdgeInsets.symmetric(
            horizontal: responsive.responsiveValue(
              mobile: AppTheme.defaultSpacing,
              tablet: AppTheme.mediumSpacing,
              desktop: AppTheme.largeSpacing,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InputField(
                label: 'Job Name',
                hintText: 'Job Name',
                controller: _jobNameController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                error: _showJobNameError,
                onChanged: (v) => ref.read(timesheetProvider.notifier).updateField('jobName', v),
              ),

              SizedBox(height: responsive.responsiveValue(
                mobile: AppTheme.defaultSpacing,
                tablet: AppTheme.mediumSpacing,
                desktop: AppTheme.largeSpacing,
              )),

              DatePickerField(
                key: ValueKey(_selectedDate),
                label: 'Date',
                hintText: 'Pick a date',
                initialDate: _selectedDate,
                onDateSelected: (d) {
                  setState(() => _selectedDate = d);
                  ref.read(timesheetProvider.notifier).updateField('date', d.toIso8601String());
                },
                error: _showDateError,
                onClearError: () => setState(() => _showDateError = false),
              ),

              SizedBox(height: responsive.responsiveValue(
                mobile: AppTheme.defaultSpacing,
                tablet: AppTheme.mediumSpacing,
                desktop: AppTheme.largeSpacing,
              )),

              InputField(
                label: 'T.M.',
                hintText: 'Territorial Manager',
                controller: _tmController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                onChanged: (v) => ref.read(timesheetProvider.notifier).updateField('tm', v),
              ),

              SizedBox(height: responsive.responsiveValue(
                mobile: AppTheme.defaultSpacing,
                tablet: AppTheme.mediumSpacing,
                desktop: AppTheme.largeSpacing,
              )),

              InputField(
                label: 'Job Size',
                hintText: 'Job Size',
                controller: _jobSizeController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                onChanged: (v) => ref.read(timesheetProvider.notifier).updateField('jobSize', v),
              ),

              SizedBox(height: responsive.responsiveValue(
                mobile: AppTheme.defaultSpacing,
                tablet: AppTheme.mediumSpacing,
                desktop: AppTheme.largeSpacing,
              )),

              InputFieldMultiline(
                label: 'Material',
                hintText: 'Material',
                controller: _materialController,
                minHeight: 80.0, // Menor altura para espaçamento mais consistente
                textCapitalization: TextCapitalization.sentences,
                onChanged: (v) => ref.read(timesheetProvider.notifier).updateField('material', v),
              ),

              SizedBox(height: responsive.responsiveValue(
                mobile: AppTheme.defaultSpacing,
                tablet: AppTheme.mediumSpacing,
                desktop: AppTheme.largeSpacing,
              )),

              InputFieldMultiline(
                label: 'Job Desc.',
                hintText: 'Job Description',
                controller: _jobDescController,
                minHeight: 80.0, // Menor altura para espaçamento mais consistente
                textCapitalization: TextCapitalization.sentences,
                error: _showJobDescError,
                onClearError: () => setState(() => _showJobDescError = false),
                onChanged: (v) => ref.read(timesheetProvider.notifier).updateField('jobDesc', v),
              ),

              SizedBox(height: responsive.responsiveValue(
                mobile: AppTheme.defaultSpacing,
                tablet: AppTheme.mediumSpacing,
                desktop: AppTheme.largeSpacing,
              )),

              InputField(
                label: 'Foreman',
                hintText: 'Foreman',
                controller: _foremanController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                onChanged: (v) => ref.read(timesheetProvider.notifier).updateField('foreman', v),
              ),

              SizedBox(height: responsive.responsiveValue(
                mobile: AppTheme.defaultSpacing,
                tablet: AppTheme.mediumSpacing,
                desktop: AppTheme.largeSpacing,
              )),

              InputField(
                label: 'Vehicle',
                hintText: "Vehicle's Number",
                controller: _vehicleController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                onChanged: (v) => ref.read(timesheetProvider.notifier).updateField('vehicle', v),
              ),

              // Espaçamento extra antes dos botões
              SizedBox(height: responsive.responsiveValue(
                mobile: AppTheme.defaultSpacing * 0.5,
                tablet: AppTheme.mediumSpacing * 0.5,
                desktop: AppTheme.largeSpacing * 0.5,
              )),

              ResponsiveLayout(
                mobile: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppButton(
                      config: ButtonType.cancelButton.config,
                      onPressed: _showCancelConfirmation,
                    ),
                    AppButton(
                      config: MiniButtonType.clearMiniButton.config,
                      onPressed: _clearAll,
                    ),
                    AppButton(
                      config: ButtonType.nextButton.config,
                      onPressed: _onNextPressed,
                    ),
                  ],
                ),
                tablet: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppButton(
                      config: ButtonType.cancelButton.config,
                      onPressed: _showCancelConfirmation,
                    ),
                    AppButton(
                      config: MiniButtonType.clearMiniButton.config,
                      onPressed: _clearAll,
                    ),
                    AppButton(
                      config: ButtonType.nextButton.config,
                      onPressed: _onNextPressed,
                    ),
                  ],
                ),
                desktop: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 120, child: AppButton(
                      config: ButtonType.cancelButton.config,
                      onPressed: _showCancelConfirmation,
                    )),
                    const SizedBox(width: 20),
                    SizedBox(width: 120, child: AppButton(
                      config: MiniButtonType.clearMiniButton.config,
                      onPressed: _clearAll,
                    )),
                    const SizedBox(width: 20),
                    SizedBox(width: 120, child: AppButton(
                      config: ButtonType.nextButton.config,
                      onPressed: _onNextPressed,
                    )),
                  ],
                ),
              ),
              SizedBox(height: responsive.responsiveValue(
                mobile: AppTheme.defaultSpacing,
                tablet: AppTheme.mediumSpacing,
                desktop: AppTheme.largeSpacing,
              )),
            ],
          ),
        ),
      ),
    );
  }
}