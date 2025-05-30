import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';
import 'package:timesheet_app_web/src/features/employee/data/models/employee_model.dart';
import 'package:timesheet_app_web/src/features/user/domain/enums/user_role.dart';

class TimeSheetPdfService {
  static final _dateFormat = DateFormat('MM/dd/yyyy');
  static final _dayFormat = DateFormat('d');
  static final _dayNameFormat = DateFormat('E');
  
  static Future<Uint8List> generateTimeSheet({
    required DateTime startDate,
    required DateTime endDate,
    required List<JobRecordModel> jobRecords,
    required List<EmployeeModel> employees,
    UserRole? userRole,
  }) async {
    // Security check - only admin and manager can generate timesheets
    if (userRole != null && userRole != UserRole.admin && userRole != UserRole.manager) {
      throw Exception('Unauthorized: Only managers and administrators can generate timesheets');
    }
    final pdf = pw.Document();
    
    // Calculate data for each employee
    final employeeData = _aggregateEmployeeData(
      startDate: startDate,
      endDate: endDate,
      jobRecords: jobRecords,
      employees: employees,
    );
    
    // Generate list of dates in the period
    final dates = _generateDateList(startDate, endDate);
    
    // Determine if we need multiple pages based on date count
    // Typically 14-15 days fit well on one page in landscape
    const maxDaysPerPage = 14;
    
    if (dates.length <= maxDaysPerPage) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.letter.landscape,
          margin: const pw.EdgeInsets.all(20),
          build: (context) => _buildFullPage(
            startDate: startDate,
            endDate: endDate,
            dates: dates,
            employeeData: employeeData,
          ),
        ),
      );
    } else {
      // Split into multiple pages if needed
      for (var i = 0; i < dates.length; i += maxDaysPerPage) {
        final pageDates = dates.sublist(
          i,
          (i + maxDaysPerPage < dates.length) ? i + maxDaysPerPage : dates.length,
        );
        
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.letter.landscape,
            margin: const pw.EdgeInsets.all(20),
            build: (context) => _buildFullPage(
              startDate: pageDates.first,
              endDate: pageDates.last,
              dates: pageDates,
              employeeData: employeeData,
            ),
          ),
        );
      }
    }
    
    return pdf.save();
  }
  
  static pw.Widget _buildFullPage({
    required DateTime startDate,
    required DateTime endDate,
    required List<DateTime> dates,
    required Map<String, EmployeeTimeData> employeeData,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildHeader(startDate, endDate),
        pw.SizedBox(height: 15),
        _buildTable(dates, employeeData),
        pw.Spacer(),
        _buildFooter(),
      ],
    );
  }
  
  static pw.Widget _buildHeader(DateTime startDate, DateTime endDate) {
    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'TIMESHEET',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey800,
              ),
            ),
            pw.Text(
              'Central Island Floor, Inc.',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey800,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: const pw.BoxDecoration(
            color: PdfColors.grey100,
            border: pw.Border(
              bottom: pw.BorderSide(color: PdfColors.grey400, width: 1),
            ),
          ),
          child: pw.Text(
            'Period: ${_dateFormat.format(startDate)} - ${_dateFormat.format(endDate)}',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey700,
            ),
            textAlign: pw.TextAlign.center,
          ),
        ),
      ],
    );
  }
  
  static pw.Widget _buildTable(
    List<DateTime> dates,
    Map<String, EmployeeTimeData> employeeData,
  ) {
    // Create date headers with day name and number
    final dateHeaders = dates.map((date) {
      final dayName = _dayNameFormat.format(date).substring(0, 3).toUpperCase();
      final dayNumber = _dayFormat.format(date);
      return '$dayName\n$dayNumber';
    }).toList();
    
    // Table headers - first row
    final headers = [
      'EMPLOYEE NAME',
      ...dateHeaders,
      'TOTAL\nHOURS',
      'TRAVEL\nHOURS',
      'MEAL\nALLOWANCE',
    ];
    
    // Table data
    final data = employeeData.entries.map((entry) {
      final employee = entry.key;
      final timeData = entry.value;
      
      return [
        employee,
        ...dates.map((date) {
          final hours = timeData.dailyHours[date];
          if (hours == null || hours == 0) {
            return '-';
          }
          // Format hours without decimal if whole number
          return hours % 1 == 0 ? hours.toInt().toString() : hours.toStringAsFixed(1);
        }),
        timeData.totalHours == 0 ? '-' : 
          (timeData.totalHours % 1 == 0 ? timeData.totalHours.toInt().toString() : timeData.totalHours.toStringAsFixed(1)),
        timeData.totalTravel == 0 ? '-' : 
          (timeData.totalTravel % 1 == 0 ? timeData.totalTravel.toInt().toString() : timeData.totalTravel.toStringAsFixed(1)),
        timeData.totalMeal == 0 ? '-' : '\$${timeData.totalMeal.toStringAsFixed(2)}',
      ];
    }).toList();
    
    // Add totals row
    final totalsRow = _calculateTotalsRow(dates, employeeData);
    data.add(totalsRow);
    
    // Definição do esquema de cores otimizado
    const headerBgColor = PdfColors.grey300; // Cinza claro para cabeçalho
    const headerTextColor = PdfColors.black; // Texto preto no cabeçalho
    const borderColor = PdfColors.grey400;
    const evenRowColor = PdfColors.grey200; // Cinza claro para linhas pares
    const oddRowColor = PdfColors.white; // Branco para linhas ímpares
    const totalsRowBgColor = PdfColors.grey300; // Cinza claro para linha de totais
    const totalsRowTextColor = PdfColors.black; // Texto preto nos totais
    const dataTextColor = PdfColors.black; // Texto preto para máxima legibilidade
    
    return pw.Table(
      border: pw.TableBorder.all(color: borderColor, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(3), // Employee name column wider
        for (int i = 1; i <= dates.length; i++)
          i: const pw.FlexColumnWidth(1), // Date columns
        dates.length + 1: const pw.FlexColumnWidth(1.2), // Total hours
        dates.length + 2: const pw.FlexColumnWidth(1.2), // Travel
        dates.length + 3: const pw.FlexColumnWidth(1.5), // Meal
      },
      children: [
        // Header row
        pw.TableRow(
          decoration: const pw.BoxDecoration(
            color: headerBgColor,
          ),
          children: headers.map((header) => pw.Container(
            alignment: pw.Alignment.center,
            padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: pw.Text(
              header,
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: headerTextColor,
              ),
              textAlign: pw.TextAlign.center,
            ),
          )).toList(),
        ),
        // Data rows
        ...data.asMap().entries.map((entry) {
          final index = entry.key;
          final row = entry.value;
          final isLastRow = index == data.length - 1;
          final isEvenRow = index % 2 == 0;
          
          return pw.TableRow(
            decoration: pw.BoxDecoration(
              color: isLastRow 
                ? totalsRowBgColor 
                : (isEvenRow ? evenRowColor : oddRowColor),
            ),
            children: row.asMap().entries.map((cellEntry) {
              final cellIndex = cellEntry.key;
              final cell = cellEntry.value;
              final isEmployeeName = cellIndex == 0;
              final isTotalColumn = cellIndex >= dates.length + 1;
              
              return pw.Container(
                alignment: isEmployeeName ? pw.Alignment.centerLeft : pw.Alignment.center,
                padding: pw.EdgeInsets.symmetric(
                  horizontal: isEmployeeName ? 8 : 4,
                  vertical: 5,
                ),
                child: pw.Text(
                  cell,
                  style: pw.TextStyle(
                    fontSize: isEmployeeName ? 10 : 9,
                    fontWeight: isLastRow || isTotalColumn 
                      ? pw.FontWeight.bold 
                      : pw.FontWeight.normal,
                    color: isLastRow ? totalsRowTextColor : dataTextColor,
                  ),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }
  
  static List<String> _calculateTotalsRow(
    List<DateTime> dates,
    Map<String, EmployeeTimeData> employeeData,
  ) {
    final row = ['TOTALS'];
    
    // Calculate daily totals
    for (final date in dates) {
      double dayTotal = 0;
      for (final timeData in employeeData.values) {
        dayTotal += timeData.dailyHours[date] ?? 0;
      }
      row.add(dayTotal == 0 ? '-' : 
        (dayTotal % 1 == 0 ? dayTotal.toInt().toString() : dayTotal.toStringAsFixed(1)));
    }
    
    // Calculate grand totals
    double totalHours = 0;
    double totalTravel = 0;
    double totalMeal = 0;
    
    for (final timeData in employeeData.values) {
      totalHours += timeData.totalHours;
      totalTravel += timeData.totalTravel;
      totalMeal += timeData.totalMeal;
    }
    
    row.add(totalHours == 0 ? '-' : 
      (totalHours % 1 == 0 ? totalHours.toInt().toString() : totalHours.toStringAsFixed(1)));
    row.add(totalTravel == 0 ? '-' : 
      (totalTravel % 1 == 0 ? totalTravel.toInt().toString() : totalTravel.toStringAsFixed(1)));
    row.add(totalMeal == 0 ? '-' : '\$${totalMeal.toStringAsFixed(2)}');
    
    return row;
  }
  
  static pw.Widget _buildFooter() {
    return pw.SizedBox.shrink();
  }
  
  static Map<String, EmployeeTimeData> _aggregateEmployeeData({
    required DateTime startDate,
    required DateTime endDate,
    required List<JobRecordModel> jobRecords,
    required List<EmployeeModel> employees,
  }) {
    final employeeData = <String, EmployeeTimeData>{};
    
    // Initialize data for all active employees
    for (final employee in employees) {
      if (employee.isActive) {
        final fullName = '${employee.firstName} ${employee.lastName}';
        employeeData[fullName] = EmployeeTimeData();
      }
    }
    
    // Process job records
    for (final record in jobRecords) {
      final recordDate = record.date;
      
      // Skip if outside date range
      if (recordDate.isBefore(startDate) || recordDate.isAfter(endDate)) {
        continue;
      }
      
      // Process each employee in the record
      for (final jobEmployee in record.employees) {
        var data = employeeData[jobEmployee.employeeName];
        
        // If employee not in list (possibly inactive), add them anyway if they have hours
        if (data == null) {
          employeeData[jobEmployee.employeeName] = EmployeeTimeData();
          data = employeeData[jobEmployee.employeeName];
        }
        
        if (data != null) {
          // Add hours for this date - normalize to just the date part
          final normalizedDate = DateTime(recordDate.year, recordDate.month, recordDate.day);
          data.dailyHours[normalizedDate] = 
              (data.dailyHours[normalizedDate] ?? 0) + jobEmployee.hours;
          
          // Add to totals
          data.totalHours += jobEmployee.hours;
          data.totalTravel += jobEmployee.travelHours;
          data.totalMeal += jobEmployee.meal;
        }
      }
    }
    
    // Sort employees alphabetically
    final sortedData = Map.fromEntries(
      employeeData.entries.toList()..sort((a, b) => a.key.compareTo(b.key))
    );
    
    return sortedData;
  }
  
  static List<DateTime> _generateDateList(DateTime start, DateTime end) {
    final dates = <DateTime>[];
    var current = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);
    
    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      dates.add(current);
      current = current.add(const Duration(days: 1));
    }
    
    return dates;
  }
}

class EmployeeTimeData {
  final Map<DateTime, double> dailyHours = {};
  double totalHours = 0;
  double totalTravel = 0;
  double totalMeal = 0;
}