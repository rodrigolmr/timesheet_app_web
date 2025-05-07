import '../repositories/card_repository.dart';
import '../repositories/receipt_repository.dart';
import '../repositories/timesheet_draft_repository.dart';
import '../repositories/timesheet_repository.dart';
import '../repositories/user_repository.dart';
import '../repositories/worker_repository.dart';

class SyncService {
  final CardRepository _cardRepo;
  final ReceiptRepository _receiptRepo;
  final TimesheetDraftRepository _draftRepo;
  final TimesheetRepository _timesheetRepo;
  final UserRepository _userRepo;
  final WorkerRepository _workerRepo;

  SyncService({
    required CardRepository cardRepository,
    required ReceiptRepository receiptRepository,
    required TimesheetDraftRepository draftRepository,
    required TimesheetRepository timesheetRepository,
    required UserRepository userRepository,
    required WorkerRepository workerRepository,
  })  : _cardRepo = cardRepository,
        _receiptRepo = receiptRepository,
        _draftRepo = draftRepository,
        _timesheetRepo = timesheetRepository,
        _userRepo = userRepository,
        _workerRepo = workerRepository;

  Future<void> syncAll({
    required List<Map<String, dynamic>> remoteCards,
    required List<Map<String, dynamic>> remoteReceipts,
    required List<Map<String, dynamic>> remoteDrafts,
    required List<Map<String, dynamic>> remoteTimesheets,
    required List<Map<String, dynamic>> remoteUsers,
    required List<Map<String, dynamic>> remoteWorkers,
  }) async {
    await _cardRepo.syncCards(remoteCards);
    await _receiptRepo.syncReceipts(remoteReceipts);
    await _draftRepo.syncDrafts(remoteDrafts);
    await _timesheetRepo.syncTimesheets(remoteTimesheets);
    await _userRepo.syncUsers(remoteUsers);
    await _workerRepo.syncWorkers(remoteWorkers);
  }
}