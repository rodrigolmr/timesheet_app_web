import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/job_record_providers.dart';
import 'package:timesheet_app_web/src/features/job_record/data/services/timesheet_pdf_service.dart';
import 'package:timesheet_app_web/src/features/employee/presentation/providers/employee_providers.dart';
import 'package:universal_html/html.dart' as html;

part 'timesheet_providers.g.dart';

@riverpod
class TimeSheetGenerator extends _$TimeSheetGenerator {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  Future<void> generateTimeSheet({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    state = const AsyncLoading();
    
    try {
      // Get all job records
      final jobRecords = await ref.read(jobRecordsProvider.future);
      
      // Filter by date range
      final filteredRecords = jobRecords.where((record) {
        return record.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
               record.date.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();
      
      // Get all employees
      final employees = await ref.read(employeesProvider.future);
      
      // Generate PDF
      final pdfBytes = await TimeSheetPdfService.generateTimeSheet(
        startDate: startDate,
        endDate: endDate,
        jobRecords: filteredRecords,
        employees: employees,
      );
      
      // Save/share the PDF
      await _savePdf(pdfBytes, startDate, endDate);
      
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
  
  Future<void> _savePdf(
    Uint8List bytes,
    DateTime startDate,
    DateTime endDate,
  ) async {
    if (kIsWeb) {
      // Create blob
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      
      // Create filename in the format: TIMESHEET TABLE PERIOD MM-DD-YYYY TO MM-DD-YYYY.pdf
      final startDateStr = '${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}-${startDate.year}';
      final endDateStr = '${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}-${endDate.year}';
      final fileName = 'TIMESHEET TABLE PERIOD $startDateStr TO $endDateStr.pdf';
      
      // Try Web Share API first (for mobile)
      try {
        // Check if Web Share API is available
        if (html.window.navigator.userAgent.contains('Mobile')) {
          // For mobile devices, open in new tab for better experience
          html.window.open(url, '_blank');
        } else {
          // For desktop, trigger download
          final anchor = html.AnchorElement()
            ..href = url
            ..download = fileName
            ..click();
          
          // Clean up
          html.Url.revokeObjectUrl(url);
        }
      } catch (e) {
        // Fallback to download
        final anchor = html.AnchorElement()
          ..href = url
          ..download = fileName
          ..click();
        
        // Clean up
        html.Url.revokeObjectUrl(url);
      }
    }
  }
}