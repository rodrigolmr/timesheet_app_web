import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/timesheet_data.dart';

class TimesheetRepository {
  final CollectionReference _col = FirebaseFirestore.instance.collection(
    'timesheets',
  );

  // Coleção separada para rascunhos
  final CollectionReference _draftsCol = FirebaseFirestore.instance.collection(
    'timesheet_drafts',
  );

  Stream<List<TimesheetData>> watchTimesheets({int limit = 0}) {
    Query query = _col.orderBy('date', descending: true);
    if (limit > 0) query = query.limit(limit);

    return query.snapshots().map((snap) {
      return snap.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        final rawWorkers = (data['workers'] as List<dynamic>?) ?? [];
        final convertedWorkers =
            rawWorkers.map((item) {
              final itemMap = Map<String, dynamic>.from(item as Map);
              return itemMap.map((k, v) => MapEntry(k, v?.toString() ?? ''));
            }).toList();

        return TimesheetData(
          id: doc.id,
          userId: data['userId'] as String? ?? '',
          jobName: data['jobName'] ?? '',
          date: (data['date'] as Timestamp?)?.toDate(),
          tm: data['tm'] ?? '',
          jobSize: data['jobSize'] ?? '',
          material: data['material'] ?? '',
          jobDesc: data['jobDesc'] ?? '',
          foreman: data['foreman'] ?? '',
          vehicle: data['vehicle'] ?? '',
          notes: data['notes'] ?? '',
          workers: convertedWorkers,
        );
      }).toList();
    });
  }

  Future<String> createTimesheet(TimesheetData sheet) async {
    final doc = await _col.add(_toMap(sheet));
    return doc.id;
  }

  Future<void> updateTimesheet(String id, TimesheetData sheet) async {
    await _col.doc(id).update(_toMap(sheet));
  }

  Future<void> deleteTimesheet(String id) async {
    await _col.doc(id).delete();
  }

  Future<TimesheetData?> getTimesheetById(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) return null;
    final data = doc.data() as Map<String, dynamic>;

    final rawWorkers = (data['workers'] as List<dynamic>?) ?? [];
    final convertedWorkers =
        rawWorkers.map((item) {
          final itemMap = Map<String, dynamic>.from(item as Map);
          return itemMap.map((k, v) => MapEntry(k, v?.toString() ?? ''));
        }).toList();

    return TimesheetData(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      jobName: data['jobName'] ?? '',
      date: (data['date'] as Timestamp?)?.toDate(),
      tm: data['tm'] ?? '',
      jobSize: data['jobSize'] ?? '',
      material: data['material'] ?? '',
      jobDesc: data['jobDesc'] ?? '',
      foreman: data['foreman'] ?? '',
      vehicle: data['vehicle'] ?? '',
      notes: data['notes'] ?? '',
      workers: convertedWorkers,
    );
  }

  Map<String, dynamic> _toMap(TimesheetData sheet) => {
    'userId': sheet.userId,
    'jobName': sheet.jobName,
    'date': sheet.date != null ? Timestamp.fromDate(sheet.date!) : null,
    'tm': sheet.tm,
    'jobSize': sheet.jobSize,
    'material': sheet.material,
    'jobDesc': sheet.jobDesc,
    'foreman': sheet.foreman,
    'vehicle': sheet.vehicle,
    'notes': sheet.notes,
    'workers': sheet.workers,
  };

  // Métodos para manipulação de rascunhos
  
  // Salva um rascunho para o usuário atual
  Future<void> saveDraft(String userId, TimesheetData sheet) async {
    // Verificamos se já existe um rascunho para este usuário
    final docRef = _draftsCol.doc(userId);
    
    await docRef.set({
      'userId': sheet.userId,
      'jobName': sheet.jobName,
      'date': sheet.date != null ? Timestamp.fromDate(sheet.date!) : null,
      'tm': sheet.tm,
      'jobSize': sheet.jobSize,
      'material': sheet.material,
      'jobDesc': sheet.jobDesc,
      'foreman': sheet.foreman,
      'vehicle': sheet.vehicle,
      'notes': sheet.notes,
      'workers': sheet.workers,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }
  
  // Carrega o rascunho do usuário, se existir
  Future<TimesheetData?> loadDraft(String userId) async {
    final doc = await _draftsCol.doc(userId).get();
    if (!doc.exists) return null;
    
    final data = doc.data() as Map<String, dynamic>;
    
    final rawWorkers = (data['workers'] as List<dynamic>?) ?? [];
    final convertedWorkers = rawWorkers.map((item) {
      final itemMap = Map<String, dynamic>.from(item as Map);
      return itemMap.map((k, v) => MapEntry(k, v?.toString() ?? ''));
    }).toList();
    
    return TimesheetData(
      id: '', // Rascunhos não têm ID próprio, usam o userId
      userId: data['userId'] as String? ?? '',
      jobName: data['jobName'] ?? '',
      date: (data['date'] as Timestamp?)?.toDate(),
      tm: data['tm'] ?? '',
      jobSize: data['jobSize'] ?? '',
      material: data['material'] ?? '',
      jobDesc: data['jobDesc'] ?? '',
      foreman: data['foreman'] ?? '',
      vehicle: data['vehicle'] ?? '',
      notes: data['notes'] ?? '',
      workers: convertedWorkers,
    );
  }
  
  // Deleta o rascunho do usuário
  Future<void> deleteDraft(String userId) async {
    await _draftsCol.doc(userId).delete();
  }
}

final timesheetRepositoryProvider = Provider<TimesheetRepository>((ref) {
  return TimesheetRepository();
});
