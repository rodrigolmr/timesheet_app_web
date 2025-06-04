import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../models/job_record_model.dart';

class JobRecordPrintService {
  static Future<void> printJobRecords(List<JobRecordModel> jobRecords) async {
    if (jobRecords.isEmpty) {
      throw Exception("No job records selected for printing!");
    }

    try {
      final pdf = pw.Document();

      for (var jobRecord in jobRecords) {
        // Format date
        final dateStr = DateFormat("M/d/yy, EEEE").format(jobRecord.date);

        // Prepare employee data for table
        final employees = jobRecord.employees.map((e) {
          return {
            'name': e.employeeName,
            'start': e.startTime,
            'finish': e.finishTime,
            'hours': e.hours.toString(),
            'travel': e.travelHours == 0 ? '' : e.travelHours.toString(),
            'meal': e.meal == 0 ? '' : e.meal.toString(),
          };
        }).toList();

        // Build PDF page
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.letter,
            margin: const pw.EdgeInsets.all(20),
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Column(
                  children: [
                    _buildTitle(),
                    _buildJobDetails(
                      jobRecord.jobName,
                      dateStr,
                      jobRecord.territorialManager,
                      jobRecord.jobSize,
                      jobRecord.material,
                      jobRecord.jobDescription,
                      jobRecord.foreman,
                      jobRecord.vehicle,
                    ),
                    _buildTable(employees),
                    if (jobRecord.notes.isNotEmpty) _buildNotes(jobRecord.notes),
                  ],
                ),
              );
            },
          ),
        );
      }

      // For web, we'll open the print dialog directly
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'Job_Records_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
    } catch (e) {
      throw Exception("Error generating PDF: $e");
    }
  }

  static pw.Widget _buildTitle() {
    return pw.Container(
      width: 500,
      height: 50,
      alignment: pw.Alignment.center,
      decoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.black, width: 0.5),
        ),
      ),
      child: pw.Text(
        'TIMESHEET',
        style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _buildJobDetails(
    String jobName,
    String date,
    String territorialManager,
    String jobSize,
    String material,
    String jobDescription,
    String foreman,
    String vehicle,
  ) {
    return pw.Container(
      width: 500,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 0.5),
      ),
      child: pw.Column(
        children: [
          _buildRow1Col("Job name:", jobName),
          _buildRow2Cols("Date:", date, "T. M.:", territorialManager),
          _buildRow1Col("Job size:", jobSize),
          _buildRow1ColExpandable("Material:", material),
          _buildRow1ColExpandable("Job description:", jobDescription),
          _buildRow2Cols("Foreman:", foreman, "Vehicle:", vehicle),
        ],
      ),
    );
  }

  static pw.Widget _buildRow1Col(String label, String value) {
    return pw.Container(
      height: 22,
      decoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.black, width: 0.5),
        ),
      ),
      child: pw.Row(
        children: [
          pw.Container(
            width: 500,
            padding: const pw.EdgeInsets.symmetric(horizontal: 8),
            child: pw.Row(
              children: [
                pw.Text(label,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(width: 4),
                pw.Text(value),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildRow1ColExpandable(String label, String value) {
    return pw.Container(
      constraints: const pw.BoxConstraints(minHeight: 22),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.black, width: 0.5),
        ),
      ),
      padding: const pw.EdgeInsets.symmetric(horizontal: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(width: 4),
          pw.Expanded(child: pw.Text(value)),
        ],
      ),
    );
  }

  static pw.Widget _buildRow2Cols(
      String label1, String value1, String label2, String value2) {
    return pw.Container(
      height: 22,
      decoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.black, width: 0.5),
        ),
      ),
      child: pw.Row(
        children: [
          pw.Container(
            width: 250,
            padding: const pw.EdgeInsets.symmetric(horizontal: 8),
            child: pw.Row(
              children: [
                pw.Text(label1,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(width: 4),
                pw.Text(value1),
              ],
            ),
          ),
          pw.Container(
            width: 250,
            padding: const pw.EdgeInsets.symmetric(horizontal: 8),
            decoration: pw.BoxDecoration(
              border: pw.Border(
                left: pw.BorderSide(color: PdfColors.black, width: 0.5),
              ),
            ),
            child: pw.Row(
              children: [
                pw.Text(label2,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(width: 4),
                pw.Text(value2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTable(List<Map<String, dynamic>> employees) {
    final headers = ['Name', 'Start', 'Finish', 'Hours', 'Travel', 'Meal'];
    final data = employees.map((employee) {
      return [
        employee['name'] ?? '',
        employee['start'] ?? '',
        employee['finish'] ?? '',
        employee['hours'] ?? '',
        employee['travel'] ?? '',
        employee['meal'] ?? '',
      ];
    }).toList();

    // Add 4 empty rows after employees
    for (int i = 0; i < 4; i++) {
      data.add(['', '', '', '', '', '']);
    }

    return pw.Container(
      width: 500,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 0.5),
      ),
      child: pw.Table(
        border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
        columnWidths: {
          0: const pw.FixedColumnWidth(200),
          1: const pw.FixedColumnWidth(60),
          2: const pw.FixedColumnWidth(60),
          3: const pw.FixedColumnWidth(60),
          4: const pw.FixedColumnWidth(60),
          5: const pw.FixedColumnWidth(60),
        },
        children: [
          pw.TableRow(
            children: headers.map((header) {
              return pw.Container(
                height: 22,
                alignment: pw.Alignment.center,
                child: pw.Text(
                  header,
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              );
            }).toList(),
          ),
          ...data.map((row) {
            return pw.TableRow(
              children: row.map((cell) {
                return pw.Container(
                  height: 22,
                  alignment: pw.Alignment.center,
                  child: pw.Text(cell),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  static pw.Widget _buildNotes(String notes) {
    return pw.Container(
      width: 500,
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: PdfColors.black, width: 0.5),
        ),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Note:',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(width: 4),
          pw.Expanded(
            child: pw.Text(notes),
          ),
        ],
      ),
    );
  }
}