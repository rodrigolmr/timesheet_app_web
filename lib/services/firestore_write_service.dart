import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/card.dart';
import '../models/worker.dart';
import '../models/timesheet.dart';
import '../models/timesheet_draft.dart';
import '../models/receipt.dart';
import '../models/user.dart';
import '../repositories/card_repository.dart';
import '../repositories/worker_repository.dart';
import '../repositories/timesheet_repository.dart';
import '../repositories/timesheet_draft_repository.dart';
import '../repositories/receipt_repository.dart';
import '../repositories/user_repository.dart';

class FirestoreWriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CardRepository _cardRepo;
  final WorkerRepository _workerRepo;
  final TimesheetRepository _timesheetRepo;
  final TimesheetDraftRepository _draftRepo;
  final ReceiptRepository _receiptRepo;
  final UserRepository _userRepo;

  FirestoreWriteService({
    required CardRepository cardRepository,
    required WorkerRepository workerRepository,
    required TimesheetRepository timesheetRepository,
    required TimesheetDraftRepository draftRepository,
    required ReceiptRepository receiptRepository,
    required UserRepository userRepository,
  })  : _cardRepo = cardRepository,
        _workerRepo = workerRepository,
        _timesheetRepo = timesheetRepository,
        _draftRepo = draftRepository,
        _receiptRepo = receiptRepository,
        _userRepo = userRepository;

  Future<void> saveCard(CardModel card) async {
    await _firestore.collection('cards').doc(card.uniqueId).set(card.toMap());
    await _cardRepo.saveCard(card);
  }

  Future<void> saveWorker(WorkerModel worker) async {
    await _firestore.collection('workers').doc(worker.uniqueId).set(worker.toMap());
    await _workerRepo.saveWorker(worker);
  }

  Future<void> saveTimesheet(TimesheetModel timesheet) async {
    final id = '${timesheet.userId}-${timesheet.timestamp.toIso8601String()}';
    await _firestore.collection('timesheets').doc(id).set(timesheet.toMap());
    await _timesheetRepo.saveTimesheet(timesheet);
  }

  Future<void> saveDraft(TimesheetDraftModel draft) async {
    final id = '${draft.userId}-${draft.date.toIso8601String()}';
    await _firestore.collection('timesheet_drafts').doc(id).set(draft.toMap());
    await _draftRepo.saveDraft(draft);
  }

  Future<void> saveReceipt(ReceiptModel receipt) async {
    final id = '${receipt.userId}-${receipt.timestamp.toIso8601String()}';
    await _firestore.collection('receipts').doc(id).set(receipt.toMap());
    await _receiptRepo.saveReceipt(receipt);
  }

  Future<void> saveUser(UserModel user) async {
    await _firestore.collection('users').doc(user.userId).set(user.toMap());
    await _userRepo.saveUser(user);
  }

  Future<void> deleteCard(String uniqueId) async {
    await _firestore.collection('cards').doc(uniqueId).delete();
    await _cardRepo.deleteCard(uniqueId);
  }

  Future<void> deleteWorker(String uniqueId) async {
    await _firestore.collection('workers').doc(uniqueId).delete();
    await _workerRepo.deleteWorker(uniqueId);
  }

  Future<void> deleteTimesheet(String id) async {
    await _firestore.collection('timesheets').doc(id).delete();
    await _timesheetRepo.deleteTimesheet(id);
  }

  Future<void> deleteDraft(String id) async {
    await _firestore.collection('timesheet_drafts').doc(id).delete();
    await _draftRepo.deleteDraft(id);
  }

  Future<void> deleteReceipt(String id) async {
    await _firestore.collection('receipts').doc(id).delete();
    await _receiptRepo.deleteReceipt(id);
  }

  Future<void> deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
    await _userRepo.deleteUser(userId);
  }
}