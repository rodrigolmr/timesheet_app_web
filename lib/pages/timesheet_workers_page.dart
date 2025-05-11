// lib/pages/timesheet_workers_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

import '../core/responsive/responsive.dart';
import '../core/theme/app_theme.dart';
import '../core/routes/app_routes.dart';
import '../widgets/app_button.dart';
import '../widgets/base_layout.dart';
import '../widgets/input_worker_hours.dart';
import '../providers/timesheet_provider.dart';

// Diferentes layouts para os botões baseados no tamanho da tela
enum ButtonRowLayout { compact, expanded }

class TimesheetWorkersPage extends ConsumerStatefulWidget {
  const TimesheetWorkersPage({Key? key}) : super(key: key);

  @override
  ConsumerState<TimesheetWorkersPage> createState() => _TimesheetWorkersPageState();
}

class _TimesheetWorkersPageState extends ConsumerState<TimesheetWorkersPage> {
  final _nameController = TextEditingController();
  final _startController = TextEditingController();
  final _finishController = TextEditingController();
  final _hoursController = TextEditingController();
  final _travelController = TextEditingController();
  final _mealController = TextEditingController();

  bool _showWorkerSection = false;
  bool _showMissingWorkerMessage = false;
  int? _selectedWorkerIndex;
  bool _isEditMode = false;
  String _docId = '';

  final List<String> _workerOptions = [];

  @override
  void initState() {
    super.initState();
    _loadWorkersFromFirebase();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Lê os argumentos passados na navegação via GoRouter
    // Não estamos usando GoRouter no exemplo, mas mantemos para compatibilidade futura
    final GoRouterState? goState = GoRouterState.of(context);
    final Map<String, dynamic> params = goState?.extra as Map<String, dynamic>? ?? {};
    
    _isEditMode = params['editMode'] as bool? ?? false;
    _docId = params['docId'] as String? ?? '';
  }

  Future<void> _loadWorkersFromFirebase() async {
    try {
      final snap = await FirebaseFirestore.instance.collection('workers').get();
      final names = snap.docs
          .map((doc) {
            final data = doc.data();
            final firstName = data['firstName'] ?? '';
            final lastName = data['lastName'] ?? '';
            return '$firstName $lastName'.trim();
          })
          .where((name) => name.isNotEmpty)
          .toList();
      
      names.sort();
      
      setState(() {
        _workerOptions.clear();
        _workerOptions.addAll(names);
      });
    } catch (e) {
      debugPrint('Erro ao carregar trabalhadores: $e');
      // Não mostramos erro na UI, mas poderíamos adicionar um feedback visual aqui
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _startController.dispose();
    _finishController.dispose();
    _hoursController.dispose();
    _travelController.dispose();
    _mealController.dispose();
    super.dispose();
  }

  void _handleNext() {
    final workers = ref.read(timesheetProvider).workers;
    setState(() {
      _showMissingWorkerMessage = workers.isEmpty;
    });
    
    if (workers.isEmpty) return;

    // Navegar para a próxima página usando o GoRouter
    context.pushNamed(
      AppRoutes.timesheetReviewName,
      extra: {'editMode': _isEditMode, 'docId': _docId},
    );
  }

  void _handleBack() {
    // Voltar para a página anterior mantendo o estado do timesheet
    context.pop();
  }

  void _editWorker(Map<String, dynamic> worker, int index) {
    _nameController.text = worker['name'] ?? '';
    _startController.text = worker['start'] ?? '';
    _finishController.text = worker['finish'] ?? '';
    _hoursController.text = worker['hours'] ?? '';
    _travelController.text = worker['travel'] ?? '';
    _mealController.text = worker['meal'] ?? '';
    
    setState(() {
      _showWorkerSection = true;
      _selectedWorkerIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final workers = ref.watch(timesheetProvider).workers;
    final responsive = ResponsiveSizing(context);

    // Definir espaçamentos responsivos
    final spacing = responsive.responsiveValue(
      mobile: AppTheme.defaultSpacing,
      tablet: AppTheme.mediumSpacing,
      desktop: AppTheme.largeSpacing,
    );

    return BaseLayout(
      title: _isEditMode ? 'Edit Workers' : 'Add Workers',
      showTitleBox: true,
      verticalAlignment: LayoutAlignment.top,
      child: ResponsiveContainer(
        mobileMaxWidth: 500,
        tabletMaxWidth: 700,
        desktopMaxWidth: 900,
        padding: EdgeInsets.all(responsive.responsiveValue(
          mobile: AppTheme.smallSpacing,
          tablet: AppTheme.defaultSpacing,
          desktop: AppTheme.mediumSpacing,
        )),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Botões superiores com layout responsivo
              ResponsiveLayout(
                mobile: _buildButtonRow(ButtonRowLayout.compact, spacing),
                tablet: _buildButtonRow(ButtonRowLayout.expanded, spacing),
                desktop: _buildButtonRow(ButtonRowLayout.expanded, spacing),
              ),
              
              // Mensagem de erro quando não há trabalhadores
              if (_showMissingWorkerMessage)
                Padding(
                  padding: EdgeInsets.only(top: spacing / 2),
                  child: const Center(
                    child: Text(
                      'Add a worker first.',
                      style: TextStyle(
                        color: AppTheme.primaryRed,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              
              // Espaço após os botões
              SizedBox(height: spacing),
              
              // Seção para adicionar/editar trabalhador
              if (_showWorkerSection)
                InputWorkerHours(
                  workerOptions: _workerOptions,
                  nameController: _nameController,
                  startController: _startController,
                  finishController: _finishController,
                  hoursController: _hoursController,
                  travelController: _travelController,
                  mealController: _mealController,
                  selectedIndex: _selectedWorkerIndex,
                  onCancel: () => setState(() => _showWorkerSection = false),
                ),
              
              // Espaço entre a seção de input e a lista
              SizedBox(height: spacing),
              
              // Tabela de trabalhadores adicionados
              if (workers.isNotEmpty) ...[
                Text(
                  'Added Workers',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: responsive.responsiveValue(
                      mobile: 16.0,
                      tablet: 18.0,
                      desktop: 20.0,
                    ),
                  ),
                ),
                SizedBox(height: spacing / 2),
                _buildWorkersTable(workers, context, responsive),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Método para construir a linha de botões com diferentes layouts

  Widget _buildButtonRow(ButtonRowLayout layout, double spacing) {
    // Layout compacto para dispositivos móveis (botões menores e mais próximos)
    if (layout == ButtonRowLayout.compact) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppButton(
            config: ButtonType.backButton.config,
            onPressed: _handleBack,
          ),
          AppButton(
            config: ButtonType.addWorkerButton.config,
            onPressed: _handleAddWorker,
          ),
          AppButton(
            config: ButtonType.nextButton.config,
            onPressed: _handleNext,
          ),
        ],
      );
    } 
    
    // Layout expandido para tablets e desktop (mais espaço entre botões)
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: AppTheme.buttonWidth * 1.2,
            child: AppButton(
              config: ButtonType.backButton.config,
              onPressed: _handleBack,
            ),
          ),
          SizedBox(
            width: AppTheme.buttonWidth * 1.5,
            child: AppButton(
              config: ButtonType.addWorkerButton.config,
              onPressed: _handleAddWorker,
            ),
          ),
          SizedBox(
            width: AppTheme.buttonWidth * 1.2,
            child: AppButton(
              config: ButtonType.nextButton.config,
              onPressed: _handleNext,
            ),
          ),
        ],
      ),
    );
  }

  void _handleAddWorker() {
    setState(() {
      _showWorkerSection = true;
      _showMissingWorkerMessage = false;
      _selectedWorkerIndex = null;
      _nameController.clear();
      _startController.clear();
      _finishController.clear();
      _hoursController.clear();
      _travelController.clear();
      _mealController.clear();
    });
  }

  Widget _buildWorkersTable(List<Map<String, dynamic>> workers, BuildContext context, ResponsiveSizing responsive) {
    // Tamanhos responsivos para a tabela
    final headerFontSize = responsive.responsiveValue(
      mobile: 12.0,
      tablet: 13.0,
      desktop: 14.0,
    );
    
    final cellFontSize = responsive.responsiveValue(
      mobile: 13.0,
      tablet: 14.0,
      desktop: 15.0,
    );
    
    final cellHeight = responsive.responsiveValue(
      mobile: 35.0,
      tablet: 40.0,
      desktop: 45.0,
    );

    // Use LayoutBuilder para obter largura disponível para a tabela
    return LayoutBuilder(
      builder: (context, constraints) {
        // Defina larguras proporcionais das colunas
        final tableWidth = constraints.maxWidth;
        final nameWidth = tableWidth * 0.25; // 25% para o nome
        final otherWidth = (tableWidth - nameWidth) / 5; // Restante dividido entre as 5 colunas
        
        return Semantics(
          label: 'Workers table',
          child: Table(
            border: TableBorder.all(color: Colors.black12),
            columnWidths: {
              0: FixedColumnWidth(nameWidth),
              1: FixedColumnWidth(otherWidth),
              2: FixedColumnWidth(otherWidth),
              3: FixedColumnWidth(otherWidth),
              4: FixedColumnWidth(otherWidth),
              5: FixedColumnWidth(otherWidth),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              // Cabeçalho da tabela
              TableRow(
                decoration: const BoxDecoration(
                  color: Color(0xFFE0E0E0),
                ),
                children: [
                  for (final label in [
                    'Name',
                    'Start',
                    'Finish',
                    'Hours',
                    'Travel',
                    'Meal',
                  ])
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Center(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: headerFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              
              // Linhas de dados
              for (int i = 0; i < workers.length; i++)
                TableRow(
                  decoration: BoxDecoration(
                    color: i.isEven
                        ? const Color(0xFFF7F7F7)
                        : Colors.white,
                  ),
                  children: [
                    for (final key in [
                      'name',
                      'start',
                      'finish',
                      'hours',
                      'travel',
                      'meal',
                    ])
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => _editWorker(workers[i], i),
                        child: SizedBox(
                          height: cellHeight,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                workers[i][key] ?? '',
                                style: TextStyle(fontSize: cellFontSize),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        );
      }
    );
  }
}