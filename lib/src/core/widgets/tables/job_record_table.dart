import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';

/// Widget that displays the job record table with all the details
/// This is the exact table structure used in the timesheet printout
class JobRecordTable extends StatelessWidget {
  final JobRecordModel record;
  final double? width;

  const JobRecordTable({
    super.key,
    required this.record,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate base width if not provided
    final baseWidth = width ?? context.responsive<double>(
      xs: 280,  // Mobile pequeno
      sm: 292,  // Mobile
      md: 340,  // Tablet
      lg: 400,  // Desktop pequeno
      xl: 450,  // Desktop grande
    );
    
    return Container(
      width: baseWidth,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleTimeSheet(context, "JOB RECORD"),
          _drawHorizontalLine(),
          _buildLineJobName(context, "JOB NAME:", record.jobName),
          _drawHorizontalLine(),
          _buildLineDateTmRow(
            context,
            _getDateDisplay(record.date),
            record.territorialManager,
          ),
          _drawHorizontalLine(),
          _buildLineJobSize(context, "JOB SIZE:", record.jobSize),
          _drawHorizontalLine(),
          _buildLineMaterialRow(context, "MATERIAL:", record.material),
          _drawHorizontalLine(),
          _buildLineJobDesc(context, "JOB DESC.:", record.jobDescription),
          _drawHorizontalLine(),
          _buildLineForemanVehicle(context, record.foreman, record.vehicle),
          _drawHorizontalLine(),
          if (record.employees.isEmpty)
            _buildLineText(context, "No Workers added.", "")
          else
            _buildWorkersTable(context, record.employees),
        ],
      ),
    );
  }

  // Utility methods
  String _getDateDisplay(DateTime date) {
    return intl.DateFormat("M/d/yy, EEEE").format(date);
  }

  String _formatNumber(double value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }

  // UI Building methods
  Widget _buildTitleTimeSheet(BuildContext context, String text) {
    return Container(
      width: double.infinity,
      height: context.responsive<double>(
        xs: 22,
        sm: 24,
        md: 26,
        lg: 28,
        xl: 30,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: context.responsive<double>(
            xs: 16,
            sm: 18,
            md: 20,
            lg: 22,
            xl: 24,
          ),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _drawHorizontalLine() => Container(height: 0.5, color: Colors.black);

  Widget _buildLineJobName(BuildContext context, String label, String value) {
    return SizedBox(
      height: context.responsive<double>(
        xs: 16,
        sm: 18,
        md: 20,
        lg: 22,
        xl: 24,
      ),
      child: Row(
        children: [
          SizedBox(
            width: context.responsive<double>(
              xs: 60,
              sm: 64,
              md: 70,
              lg: 80,
              xl: 90,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: context.responsive<double>(
                  xs: 10,
                  sm: 11,
                  md: 12,
                  lg: 13,
                  xl: 14,
                ),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: context.responsive<double>(
                  xs: 10,
                  sm: 11,
                  md: 12,
                  lg: 13,
                  xl: 14,
                ),
              ),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineDateTmRow(BuildContext context, String dateValue, String tmValue) {
    final fontSize = context.responsive<double>(
      xs: 10,
      sm: 11,
      md: 12,
      lg: 13,
      xl: 14,
    );
    
    return SizedBox(
      height: context.responsive<double>(
        xs: 16,
        sm: 18,
        md: 20,
        lg: 22,
        xl: 24,
      ),
      child: Row(
        children: [
          SizedBox(
            width: context.responsive<double>(
              xs: 34,
              sm: 36,
              md: 40,
              lg: 45,
              xl: 50,
            ),
            child: Text(
              "DATE:",
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              dateValue,
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(width: 0.5, color: Colors.black),
          SizedBox(
            width: context.responsive<double>(
              xs: 28,
              sm: 31,
              md: 35,
              lg: 40,
              xl: 45,
            ),
            child: Text(
              "T.M.:",
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
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

  Widget _buildLineJobSize(BuildContext context, String label, String value) {
    return SizedBox(
      height: context.responsive<double>(
        xs: 16,
        sm: 18,
        md: 20,
        lg: 22,
        xl: 24,
      ),
      child: Row(
        children: [
          SizedBox(
            width: context.responsive<double>(
              xs: 52,
              sm: 56,
              md: 62,
              lg: 70,
              xl: 80,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: context.responsive<double>(
                  xs: 10,
                  sm: 11,
                  md: 12,
                  lg: 13,
                  xl: 14,
                ),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: context.responsive<double>(
                  xs: 10,
                  sm: 11,
                  md: 12,
                  lg: 13,
                  xl: 14,
                ),
              ),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineMaterialRow(BuildContext context, String label, String value) {
    final fontSize = context.responsive<double>(
      xs: 10,
      sm: 11,
      md: 12,
      lg: 13,
      xl: 14,
    );
    
    final lineHeight = context.responsive<double>(
      xs: 16,
      sm: 18,
      md: 20,
      lg: 22,
      xl: 24,
    );
    
    // Adiciona padding vertical quando tem múltiplas linhas
    final verticalPadding = value.contains('\n') ? 4.0 : 0.0;
    
    return Container(
      constraints: BoxConstraints(minHeight: lineHeight),
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: context.responsive<double>(
              xs: 62,
              sm: 66,
              md: 72,
              lg: 80,
              xl: 90,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: fontSize,
              ),
              textAlign: TextAlign.left,
              overflow: TextOverflow.visible,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineJobDesc(BuildContext context, String label, String value) {
    final fontSize = context.responsive<double>(
      xs: 10,
      sm: 11,
      md: 12,
      lg: 13,
      xl: 14,
    );
    
    final lineHeight = context.responsive<double>(
      xs: 16,
      sm: 18,
      md: 20,
      lg: 22,
      xl: 24,
    );
    
    // Adiciona padding vertical quando tem múltiplas linhas
    final verticalPadding = value.contains('\n') ? 4.0 : 0.0;
    
    return Container(
      constraints: BoxConstraints(minHeight: lineHeight),
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: context.responsive<double>(
              xs: 62,
              sm: 66,
              md: 72,
              lg: 80,
              xl: 90,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: fontSize,
              ),
              textAlign: TextAlign.left,
              overflow: TextOverflow.visible,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineForemanVehicle(BuildContext context, String foreman, String vehicle) {
    final fontSize = context.responsive<double>(
      xs: 10,
      sm: 11,
      md: 12,
      lg: 13,
      xl: 14,
    );
    
    return SizedBox(
      height: context.responsive<double>(
        xs: 16,
        sm: 18,
        md: 20,
        lg: 22,
        xl: 24,
      ),
      child: Row(
        children: [
          SizedBox(
            width: context.responsive<double>(
              xs: 56,
              sm: 60,
              md: 66,
              lg: 75,
              xl: 85,
            ),
            child: Text(
              "FOREMAN:",
              style: TextStyle(fontSize: fontSize * 0.9, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              foreman.isEmpty ? '' : foreman,
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(width: 0.5, color: Colors.black),
          SizedBox(
            width: context.responsive<double>(
              xs: 46,
              sm: 50,
              md: 56,
              lg: 65,
              xl: 75,
            ),
            child: Text(
              "VEHICLE:",
              style: TextStyle(fontSize: fontSize * 0.9, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              vehicle.isEmpty ? '' : vehicle,
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineText(BuildContext context, String label, String value, {bool multiLine = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      constraints: const BoxConstraints(minHeight: 18),
      child: Row(
        crossAxisAlignment:
            multiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(width: 6),
          Expanded(
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

  Widget _buildWorkersTable(BuildContext context, List<dynamic> employees) {
    final baseFontSize = context.responsive<double>(
      xs: 10,
      sm: 11,
      md: 12,
      lg: 13,
      xl: 14,
    );
    
    final rows = <TableRow>[
      TableRow(
        decoration: const BoxDecoration(color: Color(0xFFEFEFEF)),
        children: [
          _buildHeaderCell("NAME", fontSize: baseFontSize, textAlign: TextAlign.center),
          _buildHeaderCell("START", fontSize: baseFontSize * 0.75, textAlign: TextAlign.center),
          _buildHeaderCell("FINISH", fontSize: baseFontSize * 0.75, textAlign: TextAlign.center),
          _buildHeaderCell("HOUR", fontSize: baseFontSize * 0.75, textAlign: TextAlign.center),
          _buildHeaderCell("TRAVEL", fontSize: baseFontSize * 0.65, textAlign: TextAlign.center),
          _buildHeaderCell("MEAL", fontSize: baseFontSize * 0.75, textAlign: TextAlign.center),
        ],
      ),
      for (final employee in employees)
        TableRow(
          children: [
            _buildDataCell(employee.employeeName,
                fontSize: baseFontSize, textAlign: TextAlign.left),
            _buildDataCell(employee.startTime,
                fontSize: baseFontSize, textAlign: TextAlign.center),
            _buildDataCell(employee.finishTime,
                fontSize: baseFontSize, textAlign: TextAlign.center),
            _buildDataCell(_formatNumber(employee.hours),
                fontSize: baseFontSize, textAlign: TextAlign.center),
            _buildDataCell(employee.travelHours > 0 ? _formatNumber(employee.travelHours) : '',
                fontSize: baseFontSize, textAlign: TextAlign.center),
            _buildDataCell(employee.meal > 0 ? _formatNumber(employee.meal) : '',
                fontSize: baseFontSize, textAlign: TextAlign.center),
          ],
        ),
    ];

    return SizedBox(
      width: double.infinity,
      child: Table(
        border: TableBorder(
          top: const BorderSide(width: 0, color: Colors.transparent),
          left: const BorderSide(width: 0, color: Colors.transparent),
          right: const BorderSide(width: 0, color: Colors.transparent),
          bottom: const BorderSide(width: 0, color: Colors.transparent),
          horizontalInside: const BorderSide(width: 0.5, color: Colors.black),
          verticalInside: const BorderSide(width: 0.5, color: Colors.black),
        ),
        columnWidths: {
          0: FlexColumnWidth(context.responsive<double>(
            xs: 2.5,
            sm: 3,
            md: 3.5,
            lg: 4,
            xl: 4.5,
          )),
          1: const FlexColumnWidth(1),
          2: const FlexColumnWidth(1),
          3: const FlexColumnWidth(0.8),
          4: const FlexColumnWidth(0.9),
          5: const FlexColumnWidth(0.8),
        },
        children: rows,
      ),
    );
  }

  Widget _buildHeaderCell(String text,
      {required double fontSize, required TextAlign textAlign}) {
    return Container(
      alignment: Alignment.center,
      height: 18,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF3B3B3B),
        ),
        textAlign: textAlign,
      ),
    );
  }

  Widget _buildDataCell(String text,
      {required double fontSize, required TextAlign textAlign}) {
    return Container(
      alignment: Alignment.center,
      height: 18,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: const Color(0xFF3B3B3B),
        ),
        textAlign: textAlign,
      ),
    );
  }
}