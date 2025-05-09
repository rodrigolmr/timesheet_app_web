import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../widgets/base_layout.dart';
import '../widgets/buttons.dart';
import '../providers/timesheet_provider.dart';
import '../models/timesheet_data.dart';
import '../repositories/timesheet_repository.dart';

class TimesheetReviewPage extends ConsumerStatefulWidget {
  const TimesheetReviewPage({Key? key}) : super(key: key);

  @override
  ConsumerState<TimesheetReviewPage> createState() =>
      _TimesheetReviewPageState();
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
      if (data.notes.isNotEmpty) {
        _noteController.text = data.notes;
      }
    });
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

      if (_isEditMode && _docId.isNotEmpty) {
        // Atualiza um timesheet existente
        await repo.updateTimesheet(_docId, data);
      } else {
        // Cria um novo timesheet
        await repo.createTimesheet(data);
      }
      
      // Após salvar com sucesso, excluir o rascunho
      await notifier.deleteDraft();
      
      // Reset the provider data to clear the form for next use
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
      
      Navigator.pushNamedAndRemoveUntil(context, '/timesheets', (_) => false);
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

    return BaseLayout(
      title: _isEditMode ? 'Edit Review' : 'Review',
      showTitleBox: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Botão BACK central
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppButton(
                  config: ButtonType.backButton.config,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Layout de revisão (inclui o "Time Sheet" e tabela)
            _buildReviewLayout(data),

            // Se já existe alguma nota e não estamos editando
            if (_noteController.text.isNotEmpty && !_showNoteField)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 292,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Note: ', style: TextStyle(fontSize: 11)),
                          Expanded(
                            child: Text(
                              _noteController.text,
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // Botão NOTE ou campo de edição da nota
            if (!_showNoteField)
              AppButton(
                config: MiniButtonType.noteMiniButton.config,
                onPressed: () {
                  setState(() {
                    _showNoteField = true;
                    if (_noteController.text.isEmpty) {
                      _noteController.text = '';
                    }
                  });
                },
              )
            else
              Column(
                children: [
                  Container(
                    width: 290,
                    height: 90,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFD0),
                      border: Border.all(
                        color: const Color(0xFF0205D3),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: TextField(
                      controller: _noteController,
                      maxLines: null,
                      expands: true,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Add a note',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppButton(
                        config: MiniButtonType.cancelMiniButton.config,
                        onPressed: () => setState(() => _showNoteField = false),
                      ),
                      const SizedBox(width: 8),
                      AppButton(
                        config: MiniButtonType.clearMiniButton.config,
                        onPressed: () => _noteController.clear(),
                      ),
                      const SizedBox(width: 8),
                      AppButton(
                        config: MiniButtonType.saveMiniButton.config,
                        onPressed: () {
                          // Salvar a nota no provider quando o botão Save é clicado
                          ref
                              .read(timesheetProvider.notifier)
                              .updateField('notes', _noteController.text);
                          setState(() => _showNoteField = false);
                        },
                      ),
                    ],
                  ),
                ],
              ),

            const SizedBox(height: 20),

            // Botão SUBMIT (no canto direito)
            SizedBox(
              width: 330,
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
                              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                            )
                          ),
                          const SizedBox(width: 10),
                          const Text('Submitting...', 
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0205D3),
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

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Monta todo o cartão de "review" (TIME SHEET + tabela)
  Widget _buildReviewLayout(TimesheetData data) {
    return Container(
      width: 292,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleRow('TIME SHEET'),
          _drawLine(),
          _buildLineJobName('JOB NAME:', data.jobName),
          _drawLine(),
          _buildLineDateTm(_displayDate(data.date), data.tm),
          _drawLine(),
          _buildLineJobSize('JOB SIZE:', data.jobSize),
          _drawLine(),
          // Material com altura ajustável
          _buildLineMaterial('MATERIAL:', data.material),
          _drawLine(),
          // Job desc. também ajustável
          _buildLineJobDesc('JOB DESC.:', data.jobDesc),
          _drawLine(),
          _buildLineForemanVehicle(data.foreman, data.vehicle),
          _drawLine(),

          // Se não houver workers
          if (data.workers.isEmpty)
            _buildSingleLineText('No Workers added.')
          else
            _buildWorkersTable(data.workers),
        ],
      ),
    );
  }

  Widget _buildTitleRow(String text) {
    return Container(
      width: 290,
      height: 24,
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _drawLine() => Container(height: 0.5, color: Colors.black);

  Widget _buildLineJobName(String label, String value) {
    return SizedBox(
      height: 18,
      child: Row(
        children: [
          SizedBox(
            width: 64,
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 227,
            child: Text(
              value,
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineDateTm(String dateValue, String tmValue) {
    return SizedBox(
      height: 18,
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              'DATE:',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 133,
            child: Text(
              dateValue,
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(width: 0.5, color: Colors.black),
          SizedBox(
            width: 31,
            child: Text(
              'T.M.:',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 90,
            child: Text(
              tmValue,
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineJobSize(String label, String value) {
    return SizedBox(
      height: 18,
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 234,
            child: Text(
              value,
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Material -> altura automática
  Widget _buildLineMaterial(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // para crescer vertical
        children: [
          SizedBox(
            width: 66,
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 224,
            child: Text(
              value,
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  /// Job Desc -> altura automática
  Widget _buildLineJobDesc(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 66,
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 224,
            child: Text(
              value,
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineForemanVehicle(String foreman, String vehicle) {
    return SizedBox(
      height: 18,
      child: Row(
        children: [
          SizedBox(
            width: 64,
            child: Text(
              'FOREMAN:',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 118,
            child: Text(
              foreman,
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(width: 0.5, color: Colors.black),
          SizedBox(
            width: 52,
            child: Text(
              'VEHICLE:',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 56,
            child: Text(
              vehicle,
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleLineText(String text) {
    return SizedBox(
      height: 18,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(text, style: const TextStyle(fontSize: 11)),
      ),
    );
  }

  Widget _buildWorkersTable(List<Map<String, String>> workers) {
    final rows = <TableRow>[];

    // Cabeçalho
    rows.add(
      TableRow(
        decoration: const BoxDecoration(color: Color(0xFFEFEFEF)),
        children: [
          _buildHeaderCell('NAME'),
          _buildHeaderCell('START'),
          _buildHeaderCell('FINISH'),
          _buildHeaderCell('HOUR'),
          _buildHeaderCell('T'),
          _buildHeaderCell('M'),
        ],
      ),
    );

    // Linhas de dados
    for (final w in workers) {
      rows.add(
        TableRow(
          children: [
            _buildDataCell(w['name'] ?? '', bold: true),
            _buildDataCell(w['start'] ?? ''),
            _buildDataCell(w['finish'] ?? ''),
            _buildDataCell(w['hours'] ?? '', bold: true),
            _buildDataCell(w['travel'] ?? ''),
            _buildDataCell(w['meal'] ?? ''),
          ],
        ),
      );
    }

    // Linhas extras vazias (4 no total)
    for (int i = 0; i < 4; i++) {
      rows.add(TableRow(children: List.generate(6, (_) => _buildDataCell(''))));
    }

    return Container(
      width: 290,
      child: Table(
        border: TableBorder(
          horizontalInside: const BorderSide(width: 0.5, color: Colors.black),
          verticalInside: const BorderSide(width: 0.5, color: Colors.black),
        ),
        columnWidths: const {
          0: FixedColumnWidth(120),
          1: FixedColumnWidth(40),
          2: FixedColumnWidth(40),
          3: FixedColumnWidth(40),
          4: FixedColumnWidth(25),
          5: FixedColumnWidth(25),
        },
        children: rows,
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return SizedBox(
      height: 20,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDataCell(String text, {bool bold = false}) {
    return SizedBox(
      height: 20,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  String _displayDate(DateTime? dt) {
    if (dt == null) return '';
    return DateFormat('M/d/yy, EEEE').format(dt);
  }
}
