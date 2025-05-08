import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import '../models/card.dart';
import '../models/receipt.dart';
import '../models/timesheet_draft.dart';
import '../models/timesheet.dart';
import '../models/user.dart';
import '../models/worker.dart';

class FirestoreLiveSyncService {
  final _firestore = FirebaseFirestore.instance;

  void startAllListeners() {
    _listenCollection<CardModel>(
      collectionName: 'cards',
      boxName: 'cardsBox',
      fromMap: (data, id) => CardModel.fromMap({...data, 'uniqueId': id}),
      getId: (item) => item.uniqueId,
    );

    _listenCollection<ReceiptModel>(
      collectionName: 'receipts',
      boxName: 'receiptsBox',
      fromMap: (data, id) => ReceiptModel.fromMap({...data, 'id': id}),
      getId: (item) => '${item.userId}-${item.timestamp.toIso8601String()}',
    );

    _listenCollection<TimesheetDraftModel>(
      collectionName: 'timesheet_drafts',
      boxName: 'timesheetDraftsBox',
      fromMap: (data, id) => TimesheetDraftModel.fromMap({...data, 'id': id}),
      getId: (item) => '${item.userId}-${item.date.toIso8601String()}',
    );

    _listenCollection<TimesheetModel>(
      collectionName: 'timesheets',
      boxName: 'timesheetsBox',
      fromMap: (data, id) => TimesheetModel.fromMap({...data, 'id': id}),
      getId: (item) => '${item.userId}-${item.timestamp.toIso8601String()}',
    );

    _listenCollection<UserModel>(
      collectionName: 'users',
      boxName: 'usersBox',
      fromMap: (data, id) => UserModel.fromMap({...data, 'userId': id}),
      getId: (item) => item.userId,
    );

    _listenCollection<WorkerModel>(
      collectionName: 'workers',
      boxName: 'workersBox',
      fromMap: (data, id) => WorkerModel.fromMap({...data, 'uniqueId': id}),
      getId: (item) => item.uniqueId,
    );
  }

  void _listenCollection<T>({
    required String collectionName,
    required String boxName,
    required T Function(Map<String, dynamic> data, String id) fromMap,
    required String Function(T item) getId,
  }) {
    final box = Hive.box<T>(boxName);

    _firestore.collection(collectionName).snapshots().listen((snapshot) {
      for (var change in snapshot.docChanges) {
        final data = change.doc.data();
        final id = change.doc.id;

        if (data != null) {
          final item = fromMap(data, id);
          final key = getId(item);

          if (change.type == DocumentChangeType.added ||
              change.type == DocumentChangeType.modified) {
            box.put(key, item);
          } else if (change.type == DocumentChangeType.removed) {
            box.delete(key);
          }
        }
      }
    });
  }
}
