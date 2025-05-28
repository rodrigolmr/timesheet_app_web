import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timesheet_app_web/src/core/errors/auth_exceptions.dart';
import 'package:timesheet_app_web/src/features/company_card/data/models/company_card_model.dart';
import 'package:timesheet_app_web/src/features/database/domain/models/backup_data.dart';
import 'package:timesheet_app_web/src/features/employee/data/models/employee_model.dart';
import 'package:timesheet_app_web/src/features/expense/data/models/expense_model.dart';
import 'package:timesheet_app_web/src/features/expense/domain/enums/expense_status.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_employee_model.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';
import 'package:timesheet_app_web/src/features/user/data/models/user_model.dart';

enum ImportMode {
  merge, // Update existing records
  skip,  // Skip existing records
}

class ImportReport {
  final Map<String, int> imported = {};
  final Map<String, int> updated = {};
  final Map<String, int> skipped = {};
  final Map<String, int> failed = {};
  final List<String> errors = [];
  final DateTime startTime = DateTime.now();
  DateTime? endTime;

  void addSuccess(String collection, {bool wasUpdate = false}) {
    if (wasUpdate) {
      updated[collection] = (updated[collection] ?? 0) + 1;
    } else {
      imported[collection] = (imported[collection] ?? 0) + 1;
    }
  }

  void addSkipped(String collection) {
    skipped[collection] = (skipped[collection] ?? 0) + 1;
  }

  void addFailure(String collection, String error) {
    failed[collection] = (failed[collection] ?? 0) + 1;
    errors.add('[$collection] $error');
  }

  void complete() {
    endTime = DateTime.now();
  }

  String get summary {
    final duration = endTime?.difference(startTime) ?? Duration.zero;
    final buffer = StringBuffer();
    
    buffer.writeln('Import Report');
    buffer.writeln('=============');
    buffer.writeln('Duration: ${duration.inSeconds} seconds');
    
    if (imported.isNotEmpty) {
      buffer.writeln('\nNew Records:');
      imported.forEach((key, value) {
        buffer.writeln('  $key: $value records');
      });
    }
    
    if (updated.isNotEmpty) {
      buffer.writeln('\nUpdated:');
      updated.forEach((key, value) {
        buffer.writeln('  $key: $value records');
      });
    }
    
    if (skipped.isNotEmpty) {
      buffer.writeln('\nSkipped (already exists):');
      skipped.forEach((key, value) {
        buffer.writeln('  $key: $value records');
      });
    }
    
    if (failed.isNotEmpty) {
      buffer.writeln('\nFailed:');
      failed.forEach((key, value) {
        buffer.writeln('  $key: $value records');
      });
    }
    
    if (errors.isNotEmpty) {
      buffer.writeln('\nErrors (first 10):');
      errors.take(10).forEach((error) {
        buffer.writeln('  $error');
      });
    }
    
    return buffer.toString();
  }
}

class DataImporterService {
  final FirebaseFirestore _firestore;
  final Map<String, String> _employeeNameToIdMap = {};
  final Map<String, String> _cardLast4ToIdMap = {};
  
  DataImporterService(this._firestore);

  Future<ImportReport> importFromJson(String jsonContent, {ImportMode mode = ImportMode.merge}) async {
    final report = ImportReport();
    
    try {
      final Map<String, dynamic> jsonData = json.decode(jsonContent);
      final backupData = BackupData.fromJson(jsonData);
      
      // Import in correct order for dependencies
      await _importWorkers(backupData, report, mode);
      await _importCards(backupData, report, mode);
      await _importUsers(backupData, report, mode);
      await _importReceipts(backupData, report, mode);
      await _importTimesheets(backupData, report, mode);
      
      report.complete();
    } catch (e) {
      report.errors.add('Fatal error: $e');
      report.complete();
    }
    
    return report;
  }

  DateTime _parseDate(dynamic dateValue) {
    if (dateValue == null) return DateTime.now();
    
    if (dateValue is String) {
      try {
        return DateTime.parse(dateValue);
      } catch (e) {
        return DateTime.now();
      }
    }
    
    if (dateValue is Map && dateValue['_seconds'] != null) {
      return DateTime.fromMillisecondsSinceEpoch(
        dateValue['_seconds'] * 1000,
      );
    }
    
    return DateTime.now();
  }

  double _parseDouble(String? value) {
    if (value == null || value.isEmpty) return 0.0;
    
    // Remove $ and any other non-numeric characters except . and -
    final cleaned = value.replaceAll(RegExp(r'[^\d.-]'), '');
    
    try {
      return double.parse(cleaned);
    } catch (e) {
      return 0.0;
    }
  }

  Future<void> _importWorkers(BackupData backup, ImportReport report, ImportMode mode) async {
    final workers = backup.getCollection('workers');
    
    for (final workerData in workers) {
      try {
        final oldWorker = OldWorker.fromJson(workerData);
        
        // Check if employee already exists
        final docRef = _firestore.collection('employees').doc(oldWorker.uniqueId);
        final existingDoc = await docRef.get();
        
        if (existingDoc.exists && mode == ImportMode.skip) {
          report.addSkipped('employees');
          
          // Still build the map for later use
          final fullName = '${oldWorker.firstName} ${oldWorker.lastName}'.trim();
          _employeeNameToIdMap[fullName] = oldWorker.uniqueId;
          _employeeNameToIdMap[fullName.toLowerCase()] = oldWorker.uniqueId;
          continue;
        }
        
        final employee = EmployeeModel(
          id: oldWorker.uniqueId,
          firstName: oldWorker.firstName,
          lastName: oldWorker.lastName,
          isActive: oldWorker.status.toLowerCase() == 'ativo',
          createdAt: _parseDate(oldWorker.createdAt),
          updatedAt: existingDoc.exists ? DateTime.now() : _parseDate(oldWorker.createdAt),
        );
        
        await docRef.set(employee.toFirestore());
        
        // Build name to ID map for later use
        final fullName = '${employee.firstName} ${employee.lastName}'.trim();
        _employeeNameToIdMap[fullName] = employee.id;
        _employeeNameToIdMap[fullName.toLowerCase()] = employee.id;
        
        report.addSuccess('employees', wasUpdate: existingDoc.exists);
      } catch (e) {
        report.addFailure('employees', 'Worker ${workerData['uniqueId']}: $e');
      }
    }
  }

  Future<void> _importCards(BackupData backup, ImportReport report, ImportMode mode) async {
    final cards = backup.getCollection('cards');
    
    for (final cardData in cards) {
      try {
        final oldCard = OldCard.fromJson(cardData);
        
        // Check if card already exists
        final docRef = _firestore.collection('company_cards').doc(oldCard.uniqueId);
        final existingDoc = await docRef.get();
        
        if (existingDoc.exists && mode == ImportMode.skip) {
          report.addSkipped('company_cards');
          _cardLast4ToIdMap[oldCard.last4Digits] = oldCard.uniqueId;
          continue;
        }
        
        final companyCard = CompanyCardModel(
          id: oldCard.uniqueId,
          holderName: oldCard.cardholderName,
          lastFourDigits: oldCard.last4Digits,
          isActive: oldCard.status.toLowerCase() == 'ativo',
          createdAt: _parseDate(oldCard.createdAt),
          updatedAt: existingDoc.exists ? DateTime.now() : _parseDate(oldCard.createdAt),
        );
        
        await docRef.set(companyCard.toFirestore());
        
        // Build last4 to ID map for later use
        _cardLast4ToIdMap[oldCard.last4Digits] = companyCard.id;
        
        report.addSuccess('company_cards', wasUpdate: existingDoc.exists);
      } catch (e) {
        report.addFailure('company_cards', 'Card ${cardData['uniqueId']}: $e');
      }
    }
  }

  Future<void> _importUsers(BackupData backup, ImportReport report, ImportMode mode) async {
    final users = backup.getCollection('users');
    
    for (final userData in users) {
      try {
        final oldUser = OldUser.fromJson(userData);
        
        // Check if user already exists by authUid
        final existingQuery = await _firestore
            .collection('users')
            .where('auth_uid', isEqualTo: oldUser.userId)
            .limit(1)
            .get();
        
        if (existingQuery.docs.isNotEmpty && mode == ImportMode.skip) {
          report.addSkipped('users');
          continue;
        }
        
        String userId;
        bool isUpdate = false;
        
        if (existingQuery.docs.isNotEmpty) {
          // Update existing user
          userId = existingQuery.docs.first.id;
          isUpdate = true;
        } else {
          // Create new user
          userId = _firestore.collection('users').doc().id;
        }
        
        final user = UserModel(
          id: userId,
          authUid: oldUser.userId,
          email: oldUser.email,
          firstName: oldUser.firstName,
          lastName: oldUser.lastName,
          role: oldUser.role,
          isActive: true,
          themePreference: null,
          forcedTheme: null,
          createdAt: isUpdate ? existingQuery.docs.first.data()['created_at'].toDate() : _parseDate(oldUser.createdAt),
          updatedAt: isUpdate ? DateTime.now() : _parseDate(oldUser.createdAt),
        );
        
        await _firestore
            .collection('users')
            .doc(user.id)
            .set(user.toFirestore());
        
        report.addSuccess('users', wasUpdate: isUpdate);
      } catch (e) {
        report.addFailure('users', 'User ${userData['userId']}: $e');
      }
    }
  }

  Future<void> _importReceipts(BackupData backup, ImportReport report, ImportMode mode) async {
    final receipts = backup.getCollection('receipts');
    
    for (final receiptData in receipts) {
      try {
        final oldReceipt = OldReceipt.fromJson(receiptData);
        
        // Check if expense already exists
        final docRef = _firestore.collection('expenses').doc(oldReceipt.docId);
        final existingDoc = await docRef.get();
        
        if (existingDoc.exists && mode == ImportMode.skip) {
          report.addSkipped('expenses');
          continue;
        }
        
        // Find card ID from last 4 digits
        final cardId = _cardLast4ToIdMap[oldReceipt.cardLast4];
        if (cardId == null) {
          throw Exception('Card not found for last4: ${oldReceipt.cardLast4}');
        }
        
        final expense = ExpenseModel(
          id: oldReceipt.docId,
          userId: oldReceipt.userId,
          cardId: cardId,
          amount: _parseDouble(oldReceipt.amount),
          date: _parseDate(oldReceipt.date),
          description: oldReceipt.description,
          imageUrl: oldReceipt.imageUrl,
          status: existingDoc.exists ? 
            ExpenseStatus.values.firstWhere(
              (e) => e.name == existingDoc.data()!['status'],
              orElse: () => ExpenseStatus.pending
            ) : ExpenseStatus.pending,
          reviewerNote: existingDoc.exists ? existingDoc.data()!['reviewer_note'] : null,
          reviewedAt: existingDoc.exists && existingDoc.data()!['reviewed_at'] != null ? 
            (existingDoc.data()!['reviewed_at'] as Timestamp).toDate() : null,
          createdAt: _parseDate(oldReceipt.timestamp),
          updatedAt: existingDoc.exists ? DateTime.now() : _parseDate(oldReceipt.timestamp),
        );
        
        await docRef.set(expense.toFirestore());
        
        report.addSuccess('expenses', wasUpdate: existingDoc.exists);
      } catch (e) {
        report.addFailure('expenses', 'Receipt ${receiptData['docId']}: $e');
      }
    }
  }

  Future<void> _importTimesheets(BackupData backup, ImportReport report, ImportMode mode) async {
    final timesheets = backup.getCollection('timesheets');
    
    for (final timesheetData in timesheets) {
      try {
        final oldTimesheet = OldTimesheet.fromJson(timesheetData);
        
        // Check if job record already exists
        final docRef = _firestore.collection('job_records').doc(oldTimesheet.docId);
        final existingDoc = await docRef.get();
        
        if (existingDoc.exists && mode == ImportMode.skip) {
          report.addSkipped('job_records');
          continue;
        }
        
        // Convert workers array
        final employees = <JobEmployeeModel>[];
        for (final oldWorker in oldTimesheet.workers) {
          // Try to find employee ID by name
          String? employeeId = _employeeNameToIdMap[oldWorker.name] ??
                              _employeeNameToIdMap[oldWorker.name.toLowerCase()];
          
          if (employeeId == null) {
            // Try splitting first and last name
            final nameParts = oldWorker.name.split(' ');
            if (nameParts.isNotEmpty) {
              for (final entry in _employeeNameToIdMap.entries) {
                if (entry.key.toLowerCase().contains(nameParts[0].toLowerCase()) ||
                    (nameParts.length > 1 && 
                     entry.key.toLowerCase().contains(nameParts.last.toLowerCase()))) {
                  employeeId = entry.value;
                  break;
                }
              }
            }
          }
          
          if (employeeId == null) {
            report.errors.add('Employee not found: ${oldWorker.name} in timesheet ${oldTimesheet.docId}');
            continue;
          }
          
          employees.add(JobEmployeeModel(
            employeeId: employeeId,
            employeeName: oldWorker.name,
            startTime: oldWorker.start,
            finishTime: oldWorker.finish,
            hours: _parseDouble(oldWorker.hours),
            travelHours: _parseDouble(oldWorker.travel),
            meal: _parseDouble(oldWorker.meal),
          ));
        }
        
        final jobRecord = JobRecordModel(
          id: oldTimesheet.docId,
          userId: oldTimesheet.userId,
          jobName: oldTimesheet.jobName,
          date: _parseDate(oldTimesheet.date),
          territorialManager: oldTimesheet.tm,
          jobSize: oldTimesheet.jobSize,
          material: oldTimesheet.material,
          jobDescription: oldTimesheet.jobDesc,
          foreman: oldTimesheet.foreman,
          vehicle: oldTimesheet.vehicle,
          notes: oldTimesheet.notes,
          employees: employees,
          createdAt: _parseDate(oldTimesheet.timestamp),
          updatedAt: existingDoc.exists ? DateTime.now() : _parseDate(oldTimesheet.timestamp),
        );
        
        await docRef.set(jobRecord.toFirestore());
        
        report.addSuccess('job_records', wasUpdate: existingDoc.exists);
      } catch (e) {
        report.addFailure('job_records', 'Timesheet ${timesheetData['docId']}: $e');
      }
    }
  }
}