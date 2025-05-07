import 'package:hive_flutter/hive_flutter.dart';

import '../../models/card.dart';
import '../../models/receipt.dart';
import '../../models/timesheet_draft.dart';
import '../../models/timesheet.dart';
import '../../models/user.dart';
import '../../models/worker.dart';

Future<void> initHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(CardModelAdapter());
  Hive.registerAdapter(ReceiptModelAdapter());
  Hive.registerAdapter(TimesheetDraftModelAdapter());
  Hive.registerAdapter(TimesheetModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(WorkerModelAdapter());

  await Hive.openBox<CardModel>('cardsBox');
  await Hive.openBox<ReceiptModel>('receiptsBox');
  await Hive.openBox<TimesheetDraftModel>('timesheetDraftsBox');
  await Hive.openBox<TimesheetModel>('timesheetsBox');
  await Hive.openBox<UserModel>('usersBox');
  await Hive.openBox<WorkerModel>('workersBox');
  await Hive.openBox('prefs');
  await Hive.openBox<DateTime>('syncMetadataBox');
}
