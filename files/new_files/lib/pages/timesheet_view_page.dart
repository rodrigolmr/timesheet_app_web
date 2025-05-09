// lib/pages/timesheet_view_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/timesheet_provider.dart';
import '../repositories/timesheet_repository.dart';
import '../widgets/base_layout.dart';
import '../widgets/buttons.dart';

class TimesheetViewPage extends ConsumerWidget {
  const TimesheetViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
        {};
    final docId = args['docId'] as String? ?? '';

    if (docId.isEmpty) {
      return BaseLayout(
        title: 'Invalid Timesheet',
        showTitleBox: true,
        child: const Center(
          child: Text('Invalid ID. Please provide a valid document ID.'),
        ),
      );
    }

    final asyncData = ref.watch(timesheetByIdProvider(docId));
    return asyncData.when(
      data: (data) {
        if (data == null) {
          return BaseLayout(
            title: 'Not Found',
            showTitleBox: true,
            child: const Center(child: Text('Timesheet not found')),
          );
        }
        return BaseLayout(
          title: 'Timesheet',
          showTitleBox: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppButton(
                        config: ButtonType.backButton.config,
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 20),
                      AppButton(
                        config: ButtonType.editButton.config,
                        onPressed: () {
                          // Carregando os dados atuais para o provider antes de navegar
                          ref
                              .read(timesheetProvider.notifier)
                              .loadFromData(data);
                          // Navegando para a página de cabeçalho com modo de edição
                          Navigator.pushNamed(
                            context,
                            '/new-timesheet', // Corrigindo o nome da rota
                            arguments: {'editMode': true, 'docId': docId},
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 280,
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
                        _buildLineDateTmRow(
                          DateFormat('M/d/yy, EEEE').format(data.date!),
                          data.tm,
                        ),
                        _drawLine(),
                        _buildLineJobSize('JOB SIZE:', data.jobSize),
                        _drawLine(),
                        _buildLineMaterial('MATERIAL:', data.material),
                        _drawLine(),
                        _buildLineJobDesc('JOB DESC.:', data.jobDesc),
                        _drawLine(),
                        _buildLineForemanVehicle(data.foreman, data.vehicle),
                        _drawLine(),
                        if (data.workers.isEmpty)
                          _buildSingleLineText('No Workers added.')
                        else
                          _buildWorkersTable(data.workers),
                      ],
                    ),
                  ),
                  if (data.notes.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildNotesRow('Note:', data.notes),
                  ],
                  const SizedBox(height: 20),
                  AppButton(
                    config: MiniButtonType.deleteMiniButton.config,
                    onPressed: () async {
                      await ref
                          .read(timesheetRepositoryProvider)
                          .deleteTimesheet(docId);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading:
          () => BaseLayout(
            title: 'Loading Timesheet',
            showTitleBox: true,
            child: const Center(child: CircularProgressIndicator()),
          ),
      error:
          (e, _) => BaseLayout(
            title: 'Error',
            showTitleBox: true,
            child: Center(child: Text('Error: $e')),
          ),
    );
  }

  Widget _buildTitleRow(String text) => Container(
    width: double.infinity,
    height: 24,
    alignment: Alignment.center,
    child: Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );

  Widget _drawLine() => Container(height: 0.5, color: Colors.black);

  Widget _buildLineJobName(String label, String value) => Container(
    height: 18,
    padding: const EdgeInsets.only(left: 5),
    child: Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );

  Widget _buildLineDateTmRow(String dateVal, String tmVal) => Container(
    height: 18,
    padding: const EdgeInsets.only(left: 5),
    child: Row(
      children: [
        SizedBox(
          width: 30,
          child: Text(
            'DATE:',
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          width: 105,
          child: Text(
            dateVal,
            style: const TextStyle(fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(width: 0.5, color: Colors.black),
        SizedBox(
          width: 28,
          child: Text(
            'T.M.:',
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          child: Text(
            tmVal,
            style: const TextStyle(fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );

  Widget _buildLineJobSize(String label, String value) => Container(
    height: 18,
    padding: const EdgeInsets.only(left: 5),
    child: Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );

  Widget _buildLineMaterial(String label, String value) => Padding(
    padding: const EdgeInsets.only(left: 5, top: 2, bottom: 2),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 11))),
      ],
    ),
  );

  Widget _buildLineJobDesc(String label, String value) => Padding(
    padding: const EdgeInsets.only(left: 5, top: 2, bottom: 2),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 11))),
      ],
    ),
  );

  Widget _buildLineForemanVehicle(String foreman, String vehicle) => Container(
    height: 18,
    padding: const EdgeInsets.only(left: 5),
    child: Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            'FOREMAN:',
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          width: 88,
          child: Text(
            foreman,
            style: const TextStyle(fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(width: 0.5, color: Colors.black),
        SizedBox(
          width: 40,
          child: Text(
            'VEHICLE:',
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          child: Text(
            vehicle,
            style: const TextStyle(fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );

  Widget _buildSingleLineText(String text) => SizedBox(
    height: 18,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(text, style: const TextStyle(fontSize: 11)),
    ),
  );

  Widget _buildWorkersTable(List<Map<String, String>> workers) {
    final rows = <TableRow>[];

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

    for (int i = 0; i < 4; i++) {
      rows.add(TableRow(children: List.generate(6, (_) => _buildDataCell(''))));
    }

    return Container(
      width: 280,
      child: Table(
        border: TableBorder(
          horizontalInside: const BorderSide(width: 0.5, color: Colors.black),
          verticalInside: const BorderSide(width: 0.5, color: Colors.black),
        ),
        columnWidths: const {
          0: FixedColumnWidth(108),
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

  Widget _buildHeaderCell(String text) => SizedBox(
    height: 20,
    child: Center(
      child: Text(
        text,
        style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    ),
  );

  Widget _buildDataCell(String text, {bool bold = false}) => SizedBox(
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

  Widget _buildNotesRow(String label, String value) {
    return Container(
      width: 280,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 11))),
        ],
      ),
    );
  }
}
