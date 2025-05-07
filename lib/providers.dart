import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'repositories/card_repository.dart';
import 'repositories/receipt_repository.dart';
import 'repositories/timesheet_draft_repository.dart';
import 'repositories/timesheet_repository.dart';
import 'repositories/user_repository.dart';
import 'repositories/worker_repository.dart';
import 'repositories/prefs_repository.dart';

import 'services/sync_service.dart';
import 'services/firestore_write_service.dart';

// Repositórios
final cardRepositoryProvider = Provider((ref) => CardRepository());
final receiptRepositoryProvider = Provider((ref) => ReceiptRepository());
final draftRepositoryProvider = Provider((ref) => TimesheetDraftRepository());
final timesheetRepositoryProvider = Provider((ref) => TimesheetRepository());
final userRepositoryProvider = Provider((ref) => UserRepository());
final workerRepositoryProvider = Provider((ref) => WorkerRepository());
final prefsRepositoryProvider = Provider((ref) => PrefsRepository());

// Serviços
final syncServiceProvider = Provider((ref) => SyncService(
  cardRepository: ref.read(cardRepositoryProvider),
  receiptRepository: ref.read(receiptRepositoryProvider),
  draftRepository: ref.read(draftRepositoryProvider),
  timesheetRepository: ref.read(timesheetRepositoryProvider),
  userRepository: ref.read(userRepositoryProvider),
  workerRepository: ref.read(workerRepositoryProvider),
));

final firestoreWriteServiceProvider = Provider((ref) => FirestoreWriteService(
  cardRepository: ref.read(cardRepositoryProvider),
  workerRepository: ref.read(workerRepositoryProvider),
  timesheetRepository: ref.read(timesheetRepositoryProvider),
  draftRepository: ref.read(draftRepositoryProvider),
  receiptRepository: ref.read(receiptRepositoryProvider),
  userRepository: ref.read(userRepositoryProvider),
));
