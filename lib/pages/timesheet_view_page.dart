import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../core/responsive/responsive.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_theme.dart';
import '../models/timesheet.dart';
import '../providers.dart';
import '../widgets/app_button.dart';
import '../widgets/base_layout.dart';
import '../widgets/feedback_overlay.dart';
import '../widgets/toast_message.dart';

/// Provider para carregar um timesheet específico pelo ID
final timesheetByIdProvider = FutureProvider.family<TimesheetModel?, String>((ref, id) {
  final repository = ref.read(timesheetRepositoryProvider);
  return Future.value(repository.getTimesheet(id));
});

class TimesheetViewPage extends ConsumerWidget {
  const TimesheetViewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = GoRouterState.of(context).pathParameters['id'] ?? '';

    if (id.isEmpty) {
      return BaseLayout(
        title: "Invalid Timesheet",
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Invalid ID. Please provide a valid document ID.'),
              const SizedBox(height: 20),
              AppButton(
                config: ButtonType.backButton.config,
                onPressed: () => context.goNamed(AppRoutes.timesheetsName),
              ),
            ],
          ),
        ),
      );
    }

    final asyncData = ref.watch(timesheetByIdProvider(id));
    
    return asyncData.when(
      data: (data) {
        if (data == null) {
          return BaseLayout(
            title: "Timesheet Not Found",
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('The requested timesheet could not be found.'),
                  const SizedBox(height: 20),
                  AppButton(
                    config: ButtonType.backButton.config,
                    onPressed: () => context.goNamed(AppRoutes.timesheetsName),
                  ),
                ],
              ),
            ),
          );
        }
        
        return _buildTimesheetView(context, ref, data);
      },
      loading: () => BaseLayout(
        title: "Loading Timesheet",
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => BaseLayout(
        title: "Error",
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error loading timesheet: ${error.toString()}'),
              const SizedBox(height: 20),
              AppButton(
                config: ButtonType.backButton.config,
                onPressed: () => context.goNamed(AppRoutes.timesheetsName),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimesheetView(BuildContext context, WidgetRef ref, TimesheetModel timesheet) {
    final responsive = ResponsiveSizing(context);
    
    return BaseLayout(
      title: "Timesheet Details",
      child: ResponsiveContainer(
        center: true,
        padding: EdgeInsets.symmetric(
          horizontal: responsive.responsiveValue(
            mobile: 8.0,
            tablet: 16.0,
            desktop: 24.0,
          ),
          vertical: responsive.responsiveValue(
            mobile: 16.0,
            tablet: 20.0,
            desktop: 24.0,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Barra de ações superior
              _buildActionBar(context, ref, timesheet),
              
              SizedBox(height: responsive.responsiveValue(
                mobile: 20.0,
                tablet: 24.0,
                desktop: 32.0,
              )),
              
              // Container principal do timesheet
              Container(
                width: responsive.responsiveValue(
                  mobile: 320.0,
                  tablet: 400.0,
                  desktop: 450.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 0.5),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleRow('TIME SHEET'),
                    _drawLine(),
                    _buildLineJobName('JOB NAME:', timesheet.jobName),
                    _drawLine(),
                    _buildLineDateTmRow(
                      DateFormat('M/d/yy, EEEE').format(timesheet.date),
                      timesheet.tm,
                    ),
                    _drawLine(),
                    _buildLineJobSize('JOB SIZE:', timesheet.jobSize),
                    _drawLine(),
                    _buildLineMaterial('MATERIAL:', timesheet.material),
                    _drawLine(),
                    _buildLineJobDesc('JOB DESC.:', timesheet.jobDesc),
                    _drawLine(),
                    _buildLineForemanVehicle(timesheet.foreman, timesheet.vehicle),
                    _drawLine(),
                    if (timesheet.workers.isEmpty)
                      _buildSingleLineText('No Workers added.')
                    else
                      _buildWorkersTable(timesheet.workers),
                  ],
                ),
              ),
              
              // Notas (se houver)
              if (timesheet.notes.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildNotesRow('Note:', timesheet.notes),
              ],
              
              // Barra de ações inferior
              SizedBox(height: responsive.responsiveValue(
                mobile: 24.0,
                tablet: 30.0,
                desktop: 36.0,
              )),
              
              _buildBottomActionBar(context, ref, timesheet),
            ],
          ),
        ),
      ),
    );
  }
  
  // Barra de ações superior
  Widget _buildActionBar(BuildContext context, WidgetRef ref, TimesheetModel timesheet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppButton(
          config: ButtonType.backButton.config,
          onPressed: () => context.goNamed(AppRoutes.timesheetsName),
        ),
        const SizedBox(width: 16),
        AppButton(
          config: ButtonType.editButton.config,
          onPressed: () => context.goNamed(
            AppRoutes.timesheetEditName,
            pathParameters: {'id': timesheet.documentId},
          ),
        ),
        const SizedBox(width: 16),
        AppButton(
          config: ButtonType.pdfButton.config,
          onPressed: () => _printTimesheet(context, ref, timesheet),
        ),
      ],
    );
  }
  
  // Barra de ações inferior
  Widget _buildBottomActionBar(BuildContext context, WidgetRef ref, TimesheetModel timesheet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppButton(
          config: MiniButtonType.deleteMiniButton.config,
          onPressed: () => _showDeleteConfirmation(context, ref, timesheet),
        ),
      ],
    );
  }
  
  // Título principal
  Widget _buildTitleRow(String text) => Container(
    width: double.infinity,
    height: 32,
    alignment: Alignment.center,
    color: AppTheme.primaryBlue.withOpacity(0.1),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 18, 
        fontWeight: FontWeight.bold,
        color: AppTheme.primaryBlue,
      ),
    ),
  );

  // Linha divisória
  Widget _drawLine() => Container(height: 0.5, color: Colors.black);

  // Campo: Nome do trabalho
  Widget _buildLineJobName(String label, String value) => Container(
    height: 24,
    padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
    child: Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );

  // Campo: Data e TM
  Widget _buildLineDateTmRow(String dateVal, String tmVal) => Container(
    height: 24,
    padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
    child: Row(
      children: [
        SizedBox(
          width: 48,
          child: Text(
            'DATE:',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          width: 140,
          child: Text(
            dateVal,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(width: 0.5, color: Colors.black),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: SizedBox(
            width: 40,
            child: Text(
              'T.M.:',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Expanded(
          child: Text(
            tmVal,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );

  // Campo: Tamanho do trabalho
  Widget _buildLineJobSize(String label, String value) => Container(
    height: 24,
    padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
    child: Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );

  // Campo: Material
  Widget _buildLineMaterial(String label, String value) => Padding(
    padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value, 
            style: const TextStyle(fontSize: 12)
          ),
        ),
      ],
    ),
  );

  // Campo: Descrição do trabalho
  Widget _buildLineJobDesc(String label, String value) => Padding(
    padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value, 
            style: const TextStyle(fontSize: 12)
          ),
        ),
      ],
    ),
  );

  // Campo: Capataz e veículo
  Widget _buildLineForemanVehicle(String foreman, String vehicle) => Container(
    height: 24,
    padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
    child: Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            'FOREMAN:',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          width: 100,
          child: Text(
            foreman,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(width: 0.5, color: Colors.black),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: SizedBox(
            width: 65,
            child: Text(
              'VEHICLE:',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Expanded(
          child: Text(
            vehicle,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );

  // Texto de linha única
  Widget _buildSingleLineText(String text) => SizedBox(
    height: 24,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        text, 
        style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)
      ),
    ),
  );

  // Tabela de trabalhadores
  Widget _buildWorkersTable(List<Map<String, dynamic>> workers) {
    final rows = <TableRow>[];

    // Cabeçalho da tabela
    rows.add(
      TableRow(
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue.withOpacity(0.1),
        ),
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
    for (final worker in workers) {
      rows.add(
        TableRow(
          children: [
            _buildDataCell(worker['name']?.toString() ?? '', bold: true),
            _buildDataCell(worker['start']?.toString() ?? ''),
            _buildDataCell(worker['finish']?.toString() ?? ''),
            _buildDataCell(worker['hours']?.toString() ?? '', bold: true),
            _buildDataCell(worker['travel']?.toString() ?? ''),
            _buildDataCell(worker['meal']?.toString() ?? ''),
          ],
        ),
      );
    }

    // Linhas vazias para preencher a tabela
    final emptyRowsNeeded = workers.length < 3 ? 3 - workers.length : 0;
    for (int i = 0; i < emptyRowsNeeded; i++) {
      rows.add(TableRow(children: List.generate(6, (_) => _buildDataCell(''))));
    }

    return Table(
      border: TableBorder(
        horizontalInside: const BorderSide(width: 0.5, color: Colors.black54),
        verticalInside: const BorderSide(width: 0.5, color: Colors.black54),
      ),
      columnWidths: const {
        0: FlexColumnWidth(3),  // Nome (mais largo)
        1: FlexColumnWidth(1.2),  // Start
        2: FlexColumnWidth(1.2),  // Finish
        3: FlexColumnWidth(1),  // Hour
        4: FlexColumnWidth(0.8),  // T
        5: FlexColumnWidth(0.8),  // M
      },
      children: rows,
    );
  }

  // Célula de cabeçalho da tabela
  Widget _buildHeaderCell(String text) => SizedBox(
    height: 24,
    child: Center(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10, 
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryBlue,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );

  // Célula de dados da tabela
  Widget _buildDataCell(String text, {bool bold = false}) => SizedBox(
    height: 28,
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );

  // Linha de notas
  Widget _buildNotesRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value, 
              style: const TextStyle(fontSize: 12)
            ),
          ),
        ],
      ),
    );
  }

  // Função para mostrar o diálogo de confirmação de exclusão
  Future<void> _showDeleteConfirmation(BuildContext context, WidgetRef ref, TimesheetModel timesheet) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Timesheet'),
        content: Text('Are you sure you want to delete the timesheet for "${timesheet.jobName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await _deleteTimesheet(context, ref, timesheet);
    }
  }

  // Função para excluir um timesheet
  Future<void> _deleteTimesheet(BuildContext context, WidgetRef ref, TimesheetModel timesheet) async {
    try {
      FeedbackController.showLoading(context, message: 'Deleting timesheet...');
      
      final firestoreService = ref.read(firestoreWriteServiceProvider);
      final docId = timesheet.documentId;
      
      // Excluir tanto no Firestore quanto no repositório local
      await firestoreService.deleteTimesheet(docId);
      
      // Esconder o overlay de carregamento
      FeedbackController.hide();
      
      if (context.mounted) {
        // Mostrar mensagem de sucesso
        ToastMessage.showSuccess(
          context,
          'Timesheet deleted successfully',
        );
        
        // Navegar de volta para a lista de timesheets
        context.goNamed(AppRoutes.timesheetsName);
      }
    } catch (e) {
      // Esconder o overlay de carregamento
      FeedbackController.hide();
      
      if (context.mounted) {
        // Mostrar mensagem de erro
        ToastMessage.showError(
          context,
          'Error deleting timesheet: ${e.toString()}',
        );
      }
    }
  }

  // Função para imprimir um timesheet
  Future<void> _printTimesheet(BuildContext context, WidgetRef ref, TimesheetModel timesheet) async {
    try {
      FeedbackController.showLoading(
        context, 
        message: 'Generating PDF...'
      );
      
      // Simular processamento de PDF
      await Future.delayed(const Duration(seconds: 2));
      
      // Esconder overlay de carregamento
      FeedbackController.hide();
      
      if (context.mounted) {
        // Mostrar mensagem informativa (implementação futura)
        ToastMessage.showInfo(
          context,
          'PDF generation not implemented yet',
        );
      }
    } catch (e) {
      // Esconder overlay de carregamento
      FeedbackController.hide();
      
      if (context.mounted) {
        // Mostrar mensagem de erro
        ToastMessage.showError(
          context,
          'Error generating PDF: ${e.toString()}',
        );
      }
    }
  }
}