// lib/pages/timesheet_review_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/responsive/responsive.dart';
import '../core/theme/app_theme.dart';
import '../core/routes/app_routes.dart';
import '../widgets/app_button.dart';
import '../widgets/base_layout.dart';
import '../providers/timesheet_provider.dart';
import '../repositories/timesheet_repository.dart';
import '../providers.dart';
import '../models/timesheet.dart';

class TimesheetReviewPage extends ConsumerStatefulWidget {
  const TimesheetReviewPage({Key? key}) : super(key: key);

  @override
  ConsumerState<TimesheetReviewPage> createState() => _TimesheetReviewPageState();
}

class _TimesheetReviewPageState extends ConsumerState<TimesheetReviewPage> {
  bool _showNoteField = false;
  bool _submitting = false;
  bool _isEditMode = false;
  String _docId = '';
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicializar o controlador de notas com o valor do provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final data = ref.read(timesheetProvider);
      if (data.notes?.isNotEmpty ?? false) {
        _noteController.text = data.notes ?? '';
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Lê os argumentos passados na navegação via GoRouter
    final GoRouterState? goState = GoRouterState.of(context);
    final Map<String, dynamic> params = goState?.extra as Map<String, dynamic>? ?? {};
    
    _isEditMode = params['editMode'] as bool? ?? false;
    _docId = params['docId'] as String? ?? '';

    // Se estiver no modo de edição, mostra automaticamente o campo de notas
    if (_isEditMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _showNoteField = true;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submitTimesheet() async {
    try {
      setState(() => _submitting = true);

      // Salvar as notas no provider antes de enviar
      final notifier = ref.read(timesheetProvider.notifier);
      notifier.updateField('notes', _noteController.text);

      final data = ref.read(timesheetProvider);
      final repo = ref.read(timesheetRepositoryProvider);

      // Converter data para TimesheetModel
      final timesheet = TimesheetModel(
        userId: data.userId ?? '',
        jobName: data.jobName ?? '',
        jobSize: data.jobSize ?? '',
        material: data.material ?? '',
        jobDesc: data.jobDesc ?? '',
        foreman: data.foreman ?? '',
        vehicle: data.vehicle ?? '',
        notes: data.notes ?? '',
        tm: data.tm ?? '',
        timestamp: DateTime.now(),
        updatedAt: DateTime.now(),
        date: data.date != null ? DateTime.parse(data.date!) : DateTime.now(),
        workers: data.workers.map((w) => Map<String, dynamic>.from(w)).toList(),
      );

      if (_isEditMode && _docId.isNotEmpty) {
        // Atualiza um timesheet existente
        await repo.saveTimesheet(timesheet);
      } else {
        // Cria um novo timesheet
        await repo.addTimesheet(timesheet);
      }
      
      // Reset do provider data para limpar o formulário para uso futuro
      notifier.reset();

      if (!mounted) return;
      
      // Mostrar mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green[700],
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _isEditMode
                      ? 'Timesheet updated successfully!'
                      : 'Timesheet created successfully!',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
      
      // Navegar para a lista de timesheets e remover todas as telas anteriores da pilha
      context.go(AppRoutes.timesheets);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red[700],
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Error submitting timesheet. Please try again.',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(timesheetProvider);
    final responsive = ResponsiveSizing(context);

    // Definir espaçamentos responsivos
    final spacing = responsive.responsiveValue(
      mobile: AppTheme.defaultSpacing,
      tablet: AppTheme.mediumSpacing,
      desktop: AppTheme.largeSpacing,
    );

    return BaseLayout(
      title: _isEditMode ? 'Edit Review' : 'Review',
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Botões de navegação
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppButton(
                    config: ButtonType.backButton.config,
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
              
              SizedBox(height: spacing),

              // Layout de revisão (inclui o "Time Sheet" e tabela)
              _buildReviewLayout(data, responsive),

              // Se já existe alguma nota e não estamos editando
              if (_noteController.text.isNotEmpty && !_showNoteField)
                Padding(
                  padding: EdgeInsets.only(top: spacing / 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: responsive.responsiveValue(
                          mobile: 292.0,
                          tablet: 400.0,
                          desktop: 500.0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Note: ', 
                              style: TextStyle(
                                fontSize: responsive.responsiveValue(
                                  mobile: 11.0,
                                  tablet: 12.0,
                                  desktop: 14.0,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                _noteController.text,
                                style: TextStyle(
                                  fontSize: responsive.responsiveValue(
                                    mobile: 11.0,
                                    tablet: 12.0,
                                    desktop: 14.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: spacing),

              // Botão NOTE ou campo de edição da nota
              if (!_showNoteField)
                AppButton.mini(
                  type: MiniButtonType.noteMiniButton,
                  onPressed: () {
                    setState(() {
                      _showNoteField = true;
                    });
                  },
                )
              else
                _buildNoteEditor(responsive, spacing),

              SizedBox(height: spacing),

              // Botão SUBMIT com indicador de carregamento
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: responsive.responsiveValue(
                      mobile: 330.0,
                      tablet: 400.0,
                      desktop: 500.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _submitting 
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Submitting...', 
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryBlue,
                                    fontSize: responsive.responsiveValue(
                                      mobile: 14.0,
                                      tablet: 16.0,
                                      desktop: 18.0,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : AppButton(
                              config: ButtonType.submitButton.config,
                              onPressed: _submitTimesheet,
                            ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: spacing),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para o editor de notas
  Widget _buildNoteEditor(ResponsiveSizing responsive, double spacing) {
    final noteWidth = responsive.responsiveValue(
      mobile: 290.0,
      tablet: 400.0,
      desktop: 500.0,
    );
    
    final noteHeight = responsive.responsiveValue(
      mobile: 90.0,
      tablet: 120.0,
      desktop: 150.0,
    );

    return Column(
      children: [
        Container(
          width: noteWidth,
          height: noteHeight,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFD0),
            border: Border.all(
              color: AppTheme.primaryBlue,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: TextField(
            controller: _noteController,
            maxLines: null,
            expands: true,
            style: TextStyle(
              fontSize: responsive.responsiveValue(
                mobile: 14.0,
                tablet: 16.0,
                desktop: 18.0,
              ),
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Add a note',
            ),
          ),
        ),
        SizedBox(height: spacing / 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppButton.mini(
              type: MiniButtonType.cancelMiniButton,
              onPressed: () => setState(() => _showNoteField = false),
            ),
            SizedBox(width: spacing / 2),
            AppButton.mini(
              type: MiniButtonType.clearMiniButton,
              onPressed: () => _noteController.clear(),
            ),
            SizedBox(width: spacing / 2),
            AppButton.mini(
              type: MiniButtonType.saveMiniButton,
              onPressed: () {
                // Salvar a nota no provider quando o botão Save é clicado
                ref.read(timesheetProvider.notifier).updateField('notes', _noteController.text);
                setState(() => _showNoteField = false);
              },
            ),
          ],
        ),
      ],
    );
  }

  // Monta todo o cartão de "review" (TIME SHEET + tabela)
  Widget _buildReviewLayout(TimesheetData data, ResponsiveSizing responsive) {
    final containerWidth = responsive.responsiveValue(
      mobile: 292.0,
      tablet: 400.0, 
      desktop: 500.0,
    );
    
    return Container(
      width: containerWidth,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleRow('TIME SHEET', responsive),
          _drawLine(),
          _buildLineJobName('JOB NAME:', data.jobName ?? '', responsive),
          _drawLine(),
          _buildLineDateTm(_displayDate(data.date), data.tm ?? '', responsive),
          _drawLine(),
          _buildLineJobSize('JOB SIZE:', data.jobSize ?? '', responsive),
          _drawLine(),
          // Material com altura ajustável
          _buildLineMaterial('MATERIAL:', data.material ?? '', responsive),
          _drawLine(),
          // Job desc. também ajustável
          _buildLineJobDesc('JOB DESC.:', data.jobDesc ?? '', responsive),
          _drawLine(),
          _buildLineForemanVehicle(data.foreman ?? '', data.vehicle ?? '', responsive),
          _drawLine(),

          // Se não houver workers
          if (data.workers.isEmpty)
            _buildSingleLineText('No Workers added.', responsive)
          else
            _buildWorkersTable(data.workers, responsive, containerWidth),
        ],
      ),
    );
  }

  Widget _buildTitleRow(String text, ResponsiveSizing responsive) {
    return Container(
      width: double.infinity,
      height: responsive.responsiveValue(
        mobile: 24.0,
        tablet: 28.0,
        desktop: 32.0,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: responsive.responsiveValue(
            mobile: 18.0,
            tablet: 20.0,
            desktop: 22.0,
          ),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _drawLine() => Container(height: 0.5, color: Colors.black);

  Widget _buildLineJobName(String label, String value, ResponsiveSizing responsive) {
    final fontSize = responsive.responsiveValue(
      mobile: 11.0,
      tablet: 12.0,
      desktop: 14.0,
    );

    return SizedBox(
      height: responsive.responsiveValue(
        mobile: 18.0,
        tablet: 22.0, 
        desktop: 26.0,
      ),
      child: Row(
        children: [
          SizedBox(
            width: responsive.responsiveValue(
              mobile: 64.0,
              tablet: 80.0,
              desktop: 100.0,
            ),
            child: Text(
              label,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineDateTm(String dateValue, String tmValue, ResponsiveSizing responsive) {
    final fontSize = responsive.responsiveValue(
      mobile: 11.0,
      tablet: 12.0,
      desktop: 14.0,
    );

    return SizedBox(
      height: responsive.responsiveValue(
        mobile: 18.0,
        tablet: 22.0,
        desktop: 26.0,
      ),
      child: Row(
        children: [
          SizedBox(
            width: responsive.responsiveValue(
              mobile: 36.0,
              tablet: 46.0,
              desktop: 56.0,
            ),
            child: Text(
              'DATE:',
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              dateValue,
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(width: 0.5, color: Colors.black),
          SizedBox(
            width: responsive.responsiveValue(
              mobile: 31.0,
              tablet: 41.0,
              desktop: 51.0,
            ),
            child: Text(
              'T.M.:',
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              tmValue,
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineJobSize(String label, String value, ResponsiveSizing responsive) {
    final fontSize = responsive.responsiveValue(
      mobile: 11.0,
      tablet: 12.0,
      desktop: 14.0,
    );

    return SizedBox(
      height: responsive.responsiveValue(
        mobile: 18.0,
        tablet: 22.0,
        desktop: 26.0,
      ),
      child: Row(
        children: [
          SizedBox(
            width: responsive.responsiveValue(
              mobile: 56.0,
              tablet: 66.0,
              desktop: 76.0,
            ),
            child: Text(
              label,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineMaterial(String label, String value, ResponsiveSizing responsive) {
    final fontSize = responsive.responsiveValue(
      mobile: 11.0,
      tablet: 12.0,
      desktop: 14.0,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: responsive.responsiveValue(
              mobile: 66.0,
              tablet: 76.0,
              desktop: 86.0,
            ),
            child: Text(
              label,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineJobDesc(String label, String value, ResponsiveSizing responsive) {
    final fontSize = responsive.responsiveValue(
      mobile: 11.0,
      tablet: 12.0,
      desktop: 14.0,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: responsive.responsiveValue(
              mobile: 66.0,
              tablet: 76.0,
              desktop: 86.0,
            ),
            child: Text(
              label,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineForemanVehicle(String foreman, String vehicle, ResponsiveSizing responsive) {
    final fontSize = responsive.responsiveValue(
      mobile: 11.0,
      tablet: 12.0,
      desktop: 14.0,
    );

    return SizedBox(
      height: responsive.responsiveValue(
        mobile: 18.0,
        tablet: 22.0,
        desktop: 26.0,
      ),
      child: Row(
        children: [
          SizedBox(
            width: responsive.responsiveValue(
              mobile: 64.0,
              tablet: 74.0,
              desktop: 84.0,
            ),
            child: Text(
              'FOREMAN:',
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              foreman,
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(width: 0.5, color: Colors.black),
          SizedBox(
            width: responsive.responsiveValue(
              mobile: 52.0,
              tablet: 62.0,
              desktop: 72.0,
            ),
            child: Text(
              'VEHICLE:',
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              vehicle,
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleLineText(String text, ResponsiveSizing responsive) {
    return SizedBox(
      height: responsive.responsiveValue(
        mobile: 18.0,
        tablet: 22.0,
        desktop: 26.0,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          text, 
          style: TextStyle(
            fontSize: responsive.responsiveValue(
              mobile: 11.0,
              tablet: 12.0,
              desktop: 14.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkersTable(List<Map<String, dynamic>> workers, ResponsiveSizing responsive, double containerWidth) {
    final headerFontSize = responsive.responsiveValue(
      mobile: 8.0,
      tablet: 9.0,
      desktop: 10.0,
    );
    
    final dataFontSize = responsive.responsiveValue(
      mobile: 11.0,
      tablet: 12.0,
      desktop: 14.0,
    );
    
    final rowHeight = responsive.responsiveValue(
      mobile: 20.0,
      tablet: 24.0,
      desktop: 28.0,
    );
    
    final nameWidth = containerWidth * 0.4; // Nome ocupa 40% da largura
    final otherWidth = (containerWidth - nameWidth) / 5; // Outras colunas dividem o resto

    final rows = <TableRow>[];

    // Cabeçalho
    rows.add(
      TableRow(
        decoration: const BoxDecoration(color: Color(0xFFEFEFEF)),
        children: [
          _buildHeaderCell('NAME', headerFontSize, rowHeight),
          _buildHeaderCell('START', headerFontSize, rowHeight),
          _buildHeaderCell('FINISH', headerFontSize, rowHeight),
          _buildHeaderCell('HOUR', headerFontSize, rowHeight),
          _buildHeaderCell('T', headerFontSize, rowHeight),
          _buildHeaderCell('M', headerFontSize, rowHeight),
        ],
      ),
    );

    // Linhas de dados
    for (final w in workers) {
      rows.add(
        TableRow(
          children: [
            _buildDataCell(w['name'] ?? '', dataFontSize, rowHeight, bold: true),
            _buildDataCell(w['start'] ?? '', dataFontSize, rowHeight),
            _buildDataCell(w['finish'] ?? '', dataFontSize, rowHeight),
            _buildDataCell(w['hours'] ?? '', dataFontSize, rowHeight, bold: true),
            _buildDataCell(w['travel'] ?? '', dataFontSize, rowHeight),
            _buildDataCell(w['meal'] ?? '', dataFontSize, rowHeight),
          ],
        ),
      );
    }

    // Linhas extras vazias (3 no total)
    final emptyRowsCount = responsive.isMobile ? 3 : (responsive.isTablet ? 2 : 1);
    for (int i = 0; i < emptyRowsCount; i++) {
      rows.add(
        TableRow(
          children: List.generate(
            6, 
            (_) => _buildDataCell('', dataFontSize, rowHeight),
          ),
        ),
      );
    }

    return SizedBox(
      width: containerWidth,
      child: Table(
        border: TableBorder(
          horizontalInside: const BorderSide(width: 0.5, color: Colors.black),
          verticalInside: const BorderSide(width: 0.5, color: Colors.black),
        ),
        columnWidths: {
          0: FixedColumnWidth(nameWidth),
          1: FixedColumnWidth(otherWidth),
          2: FixedColumnWidth(otherWidth),
          3: FixedColumnWidth(otherWidth),
          4: FixedColumnWidth(otherWidth * 0.6),
          5: FixedColumnWidth(otherWidth * 0.6),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: rows,
      ),
    );
  }

  Widget _buildHeaderCell(String text, double fontSize, double height) {
    return SizedBox(
      height: height,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize, 
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDataCell(String text, double fontSize, double height, {bool bold = false}) {
    return SizedBox(
      height: height,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  String _displayDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('M/d/yy, EEEE').format(dt);
    } catch (e) {
      return dateStr; // Retorna a string original se não conseguir fazer o parse
    }
  }
}