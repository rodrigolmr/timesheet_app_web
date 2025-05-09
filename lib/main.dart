import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import 'firebase_options.dart';
import 'core/hive/hive_init.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'services/firestore_live_sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Inicializar Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase inicializado com sucesso');
  } catch (e) {
    print('❌ Erro ao inicializar Firebase: $e');
  }

  try {
    // Inicializar Hive
    await initHive();
    print('✅ Hive inicializado com sucesso');
  } catch (e) {
    print('❌ Erro ao inicializar Hive: $e');
  }

  // Iniciar listeners de sincronização em tempo real
  FirestoreLiveSyncService().startAllListeners();
  print('✅ FirestoreLiveSyncService iniciado');

  runApp(const ProviderScope(child: MyApp()));
}


class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Timesheet App',
      theme: AppTheme.lightTheme(),
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}