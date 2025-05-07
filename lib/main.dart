import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart';
import 'core/hive/hive_init.dart';
import 'services/sync_service.dart';
import 'repositories/card_repository.dart';
import 'repositories/receipt_repository.dart';
import 'repositories/timesheet_draft_repository.dart';
import 'repositories/timesheet_repository.dart';
import 'repositories/user_repository.dart';
import 'repositories/worker_repository.dart';
import 'core/network/firestore_fetch.dart';
import 'core/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    print('Firebase inicializado com sucesso');
  } catch (e) {
    print('Erro ao inicializar Firebase: $e');
  }

  // Inicializar Hive para armazenamento local
  try {
    await initHive();
    print('Hive inicializado com sucesso');
  } catch (e) {
    print('Erro ao inicializar Hive: $e');
  }

  // Configurar o serviço de sincronização
  final syncService = SyncService(
    cardRepository: CardRepository(),
    receiptRepository: ReceiptRepository(),
    draftRepository: TimesheetDraftRepository(),
    timesheetRepository: TimesheetRepository(),
    userRepository: UserRepository(),
    workerRepository: WorkerRepository(),
  );

  // Sincronizar dados do Firestore com o armazenamento local
  try {
    await syncService.syncAll(
      remoteCards: await fetchCardsFromFirestore(),
      remoteReceipts: await fetchReceiptsFromFirestore(),
      remoteDrafts: await fetchDraftsFromFirestore(),
      remoteTimesheets: await fetchTimesheetsFromFirestore(),
      remoteUsers: await fetchUsersFromFirestore(),
      remoteWorkers: await fetchWorkersFromFirestore(),
    );
    print('Sincronização concluída com sucesso');
  } catch (e) {
    print('Erro durante a sincronização: $e');
    // Continuar mesmo com erro na sincronização
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Timesheet App',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: appRouter,
    );
  }
}
