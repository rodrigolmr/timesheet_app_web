import 'package:flutter/material.dart';
import '../repositories/card_repository.dart';
import '../repositories/receipt_repository.dart';
import '../repositories/timesheet_draft_repository.dart';
import '../repositories/timesheet_repository.dart';
import '../repositories/user_repository.dart';
import '../repositories/worker_repository.dart';
import '../widgets/feedback_overlay.dart';
import '../core/network/firestore_fetch.dart';

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
    List<Map<String, dynamic>> remoteCards = const [],
    List<Map<String, dynamic>> remoteReceipts = const [],
    List<Map<String, dynamic>> remoteDrafts = const [],
    List<Map<String, dynamic>> remoteTimesheets = const [],
    List<Map<String, dynamic>> remoteUsers = const [],
    List<Map<String, dynamic>> remoteWorkers = const [],
    BuildContext? context,
  }) async {
    if (context != null) {
      FeedbackController.showLoading(
        context,
        message: 'Synchronizing data...',
        position: FeedbackPosition.center,
      );
    }

    try {
      // Fetch data from Firestore if not provided
      if (remoteCards.isEmpty &&
          remoteReceipts.isEmpty &&
          remoteDrafts.isEmpty &&
          remoteTimesheets.isEmpty &&
          remoteUsers.isEmpty &&
          remoteWorkers.isEmpty) {

        if (context != null) {
          FeedbackController.showLoading(
            context,
            message: 'Fetching cards...',
            position: FeedbackPosition.center,
          );
        }
        final cardsData = await fetchCardsFromFirestore();
        await _cardRepo.syncCards(cardsData);

        if (context != null) {
          FeedbackController.showLoading(
            context,
            message: 'Fetching receipts...',
            position: FeedbackPosition.center,
          );
        }
        final receiptsData = await fetchReceiptsFromFirestore();
        await _receiptRepo.syncReceipts(receiptsData);

        if (context != null) {
          FeedbackController.showLoading(
            context,
            message: 'Fetching drafts...',
            position: FeedbackPosition.center,
          );
        }
        final draftsData = await fetchDraftsFromFirestore();
        await _draftRepo.syncDrafts(draftsData);

        if (context != null) {
          FeedbackController.showLoading(
            context,
            message: 'Fetching timesheets...',
            position: FeedbackPosition.center,
          );
        }
        final timesheetsData = await fetchTimesheetsFromFirestore();
        await _timesheetRepo.syncTimesheets(timesheetsData);

        if (context != null) {
          FeedbackController.showLoading(
            context,
            message: 'Fetching users...',
            position: FeedbackPosition.center,
          );
        }
        final usersData = await fetchUsersFromFirestore();
        await _userRepo.syncUsers(usersData);

        if (context != null) {
          FeedbackController.showLoading(
            context,
            message: 'Fetching workers...',
            position: FeedbackPosition.center,
          );
        }
        final workersData = await fetchWorkersFromFirestore();
        await _workerRepo.syncWorkers(workersData);
      } else {
        // Use provided data
        await _cardRepo.syncCards(remoteCards);
        await _receiptRepo.syncReceipts(remoteReceipts);
        await _draftRepo.syncDrafts(remoteDrafts);
        await _timesheetRepo.syncTimesheets(remoteTimesheets);
        await _userRepo.syncUsers(remoteUsers);
        await _workerRepo.syncWorkers(remoteWorkers);
      }

      // Show success message
      if (context != null) {
        FeedbackController.hide();
        FeedbackController.showSuccess(
          context,
          message: 'Data synchronized successfully!',
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      // Show error message
      if (context != null) {
        FeedbackController.hide();
        FeedbackController.showError(
          context,
          message: 'Error synchronizing data: ${e.toString()}',
          duration: const Duration(seconds: 3),
        );
      }
      rethrow; // Re-throw to allow calling code to handle the error
    }
  }

  /// Sync only a specific collection with visual feedback
  Future<void> syncCollection(
    String collection,
    BuildContext context
  ) async {
    try {
      FeedbackController.showLoading(
        context,
        message: 'Synchronizing $collection...',
        position: FeedbackPosition.center,
      );

      switch (collection) {
        case 'cards':
          final data = await fetchCardsFromFirestore();
          await _cardRepo.syncCards(data);
          break;
        case 'receipts':
          final data = await fetchReceiptsFromFirestore();
          await _receiptRepo.syncReceipts(data);
          break;
        case 'drafts':
          final data = await fetchDraftsFromFirestore();
          await _draftRepo.syncDrafts(data);
          break;
        case 'timesheets':
          final data = await fetchTimesheetsFromFirestore();
          await _timesheetRepo.syncTimesheets(data);
          break;
        case 'users':
          final data = await fetchUsersFromFirestore();
          await _userRepo.syncUsers(data);
          break;
        case 'workers':
          final data = await fetchWorkersFromFirestore();
          await _workerRepo.syncWorkers(data);
          break;
        default:
          throw Exception('Unknown collection: $collection');
      }

      // Show success message
      FeedbackController.hide();
      FeedbackController.showSuccess(
        context,
        message: '$collection synchronized successfully!',
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      // Show error message
      FeedbackController.hide();
      FeedbackController.showError(
        context,
        message: 'Error synchronizing $collection: ${e.toString()}',
        duration: const Duration(seconds: 3),
      );
      rethrow;
    }
  }
}