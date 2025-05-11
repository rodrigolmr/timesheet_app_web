import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import 'firebase_options.dart';
import 'core/hive/hive_init.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'services/firestore_live_sync_service.dart';
import 'providers.dart';

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

  // Não iniciar os listeners de sincronização até o login
  // A sincronização será ativada após autenticação

  // Iniciar aplicação em modo produção
  runApp(const ProviderScope(child: AppWithInitialSync()));
}

class AppWithInitialSync extends ConsumerStatefulWidget {
  const AppWithInitialSync({super.key});

  @override
  ConsumerState<AppWithInitialSync> createState() => _AppWithInitialSyncState();
}

class _AppWithInitialSyncState extends ConsumerState<AppWithInitialSync> {
  @override
  void initState() {
    super.initState();

    // Agendar a verificação de autenticação e sincronização para depois que o widget for construído
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthAndSync();
    });
  }

  Future<void> _checkAuthAndSync() async {
    // Verificar se o usuário está autenticado
    final isAuthenticated = ref.read(authStateProvider);

    if (isAuthenticated) {
      print('Usuário já autenticado. Iniciando listeners de sincronização...');

      // Iniciar os listeners do FirestoreLiveSyncService
      ref.read(firestoreLiveSyncServiceProvider).startAllListeners();
      print('✅ FirestoreLiveSyncService ativado após detecção de autenticação existente');

      // Se um usuário já estiver logado, iniciar a sincronização
      // A sincronização ocorre em background e o router lidará com
      // eventuais telas de carregamento se necessário
      ref.read(syncManagerProvider).performInitialSync().then((success) {
        if (success) {
          print('Sincronização inicial realizada com sucesso');
        } else {
          print('Sincronização inicial falhou, mas o app continuará a funcionar no modo offline');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usar o router provider que observa o estado de autenticação
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Timesheet App',
      theme: AppTheme.lightTheme(),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Usar o router provider que observa o estado de autenticação
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Timesheet App',
      theme: AppTheme.lightTheme(),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}