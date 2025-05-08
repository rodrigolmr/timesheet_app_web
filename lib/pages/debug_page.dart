import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../providers.dart';
import '../models/card.dart';
import '../models/worker.dart';
import '../models/timesheet.dart';
import '../models/timesheet_draft.dart';
import '../models/receipt.dart';
import '../models/user.dart';
import '../core/hive/sync_metadata.dart';
import '../core/network/firestore_fetch.dart';

class DebugPage extends ConsumerStatefulWidget {
  const DebugPage({super.key});

  @override
  ConsumerState<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends ConsumerState<DebugPage> {
  String _statusMessage = '';

  Future<void> _forceSync() async {
    setState(() => _statusMessage = '🔄 Sincronizando...');
    try {
      final syncService = ref.read(syncServiceProvider);

      final results = await Future.wait([
        fetchCardsFromFirestore(),
        fetchReceiptsFromFirestore(),
        fetchDraftsFromFirestore(),
        fetchTimesheetsFromFirestore(),
        fetchUsersFromFirestore(),
        fetchWorkersFromFirestore(),
      ]);

      await syncService.syncAll(
        remoteCards: results[0],
        remoteReceipts: results[1],
        remoteDrafts: results[2],
        remoteTimesheets: results[3],
        remoteUsers: results[4],
        remoteWorkers: results[5],
      );

      setState(() => _statusMessage = '✅ Sync manual concluído');
    } catch (e) {
      setState(() => _statusMessage = '❌ Erro no sync: $e');
    }
  }

  Future<void> _clearHive() async {
    await Hive.box<CardModel>('cardsBox').clear();
    await Hive.box<WorkerModel>('workersBox').clear();
    await Hive.box<TimesheetModel>('timesheetsBox').clear();
    await Hive.box<TimesheetDraftModel>('timesheetDraftsBox').clear();
    await Hive.box<ReceiptModel>('receiptsBox').clear();
    await Hive.box<UserModel>('usersBox').clear();
    setState(() => _statusMessage = '✅ Hive limpo');
  }

  @override
  Widget build(BuildContext context) {
    final cardsCount = Hive.box<CardModel>('cardsBox').length;
    final workersCount = Hive.box<WorkerModel>('workersBox').length;
    final timesheetsCount = Hive.box<TimesheetModel>('timesheetsBox').length;
    final draftsCount =
        Hive.box<TimesheetDraftModel>('timesheetDraftsBox').length;
    final receiptsCount = Hive.box<ReceiptModel>('receiptsBox').length;
    final usersCount = Hive.box<UserModel>('usersBox').length;

    final lastCardSync = SyncMetadata.getLastSync('cards');
    final lastWorkerSync = SyncMetadata.getLastSync('workers');
    final lastTimesheetSync = SyncMetadata.getLastSync('timesheets');

    return Scaffold(
      appBar: AppBar(title: const Text('🔧 Debug Page')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('📦 Cards: $cardsCount'),
            Text('📦 Workers: $workersCount'),
            Text('📦 Timesheets: $timesheetsCount'),
            Text('📦 Drafts: $draftsCount'),
            Text('📦 Receipts: $receiptsCount'),
            Text('📦 Users: $usersCount'),
            const SizedBox(height: 10),
            Text('🕑 Último sync cards: ${lastCardSync ?? "nunca"}'),
            Text('🕑 Último sync workers: ${lastWorkerSync ?? "nunca"}'),
            Text('🕑 Último sync timesheets: ${lastTimesheetSync ?? "nunca"}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _forceSync,
              child: const Text('🔄 Forçar Sync Manual'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _clearHive,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('🗑 Limpar Hive'),
            ),
            const SizedBox(height: 20),
            Text(
              '📣 Status: $_statusMessage',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
