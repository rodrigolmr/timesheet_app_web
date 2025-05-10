import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/user.dart';
import 'repositories/card_repository.dart';
import 'repositories/receipt_repository.dart';
import 'repositories/timesheet_draft_repository.dart';
import 'repositories/timesheet_repository.dart';
import 'repositories/user_repository.dart';
import 'repositories/worker_repository.dart';
import 'repositories/prefs_repository.dart';

import 'services/sync_service.dart';
import 'services/sync_manager.dart';
import 'services/firestore_write_service.dart';
import 'services/firestore_live_sync_service.dart';
import 'services/connectivity_service.dart';

// Repositórios
final cardRepositoryProvider = Provider((ref) => CardRepository());
final receiptRepositoryProvider = Provider((ref) => ReceiptRepository());
final draftRepositoryProvider = Provider((ref) => TimesheetDraftRepository());
final timesheetRepositoryProvider = Provider((ref) => TimesheetRepository());
final userRepositoryProvider = Provider((ref) => UserRepository());
final workerRepositoryProvider = Provider((ref) => WorkerRepository());
final prefsRepositoryProvider = Provider((ref) => PrefsRepository());

// Serviços
final syncServiceProvider = Provider(
  (ref) => SyncService(
    cardRepository: ref.read(cardRepositoryProvider),
    receiptRepository: ref.read(receiptRepositoryProvider),
    draftRepository: ref.read(draftRepositoryProvider),
    timesheetRepository: ref.read(timesheetRepositoryProvider),
    userRepository: ref.read(userRepositoryProvider),
    workerRepository: ref.read(workerRepositoryProvider),
  ),
);

final firestoreWriteServiceProvider = Provider(
  (ref) => FirestoreWriteService(
    cardRepository: ref.read(cardRepositoryProvider),
    workerRepository: ref.read(workerRepositoryProvider),
    timesheetRepository: ref.read(timesheetRepositoryProvider),
    draftRepository: ref.read(draftRepositoryProvider),
    receiptRepository: ref.read(receiptRepositoryProvider),
    userRepository: ref.read(userRepositoryProvider),
  ),
);

final firestoreLiveSyncServiceProvider = Provider(
  (ref) => FirestoreLiveSyncService(),
);

// Provider para o serviço de conectividade
final connectivityServiceProvider = Provider((ref) {
  final service = ConnectivityService();
  ref.onDispose(() => service.dispose());
  return service;
});

// Provider para o status de rede atual
final networkStatusProvider = StreamProvider<NetworkStatus>((ref) {
  final connectivityService = ref.watch(connectivityServiceProvider);
  return connectivityService.networkStatusStream;
});

// Provider para verificar se o dispositivo está online
final isOnlineProvider = Provider<bool>((ref) {
  final networkStatus = ref.watch(networkStatusProvider);
  return networkStatus.when(
    data: (status) => status == NetworkStatus.online,
    loading: () => true, // Assume online durante o carregamento
    error: (_, __) => false, // Assume offline em caso de erro
  );
});

// Providers para o SyncManager
final syncStatusProvider = StateProvider<SyncStatus>((ref) => SyncStatus.initial);
final syncErrorProvider = StateProvider<String?>((ref) => null);
final lastSyncTimeProvider = StateProvider<DateTime?>((ref) => null);

// SyncManager Provider
final syncManagerProvider = Provider((ref) {
  return SyncManager(
    syncService: ref.read(syncServiceProvider),
    statusController: ref.read(syncStatusProvider.notifier),
    errorController: ref.read(syncErrorProvider.notifier),
    lastSyncController: ref.read(lastSyncTimeProvider.notifier),
    connectivityService: ref.read(connectivityServiceProvider),
  );
});

// Provider para verificar se a sincronização inicial já foi feita
final isInitialSyncDoneProvider = Provider((ref) {
  final syncStatus = ref.watch(syncStatusProvider);
  return syncStatus == SyncStatus.completed;
});

// Auth Service Provider
final authServiceProvider = Provider((ref) {
  return FirebaseAuth.instance;
});

// Provider para o estado de autenticação (logado ou não)
final authStateProvider = StateProvider<bool>((ref) {
  // Verificar se está logado através do Firebase Auth
  final auth = ref.watch(authServiceProvider);
  return auth.currentUser != null;
});

// Login e Logout Callbacks
typedef LoginCallback = Future<void> Function({required String email, required String password});
typedef LogoutCallback = Future<void> Function();

final loginCallbackProvider = Provider<LoginCallback>((ref) {
  final auth = ref.watch(authServiceProvider);
  final userRepository = ref.read(userRepositoryProvider);

  return ({required String email, required String password}) async {
    try {
      print("Tentando login com email: $email");

      // Fazer login via Firebase Auth (encapsulado no serviço)
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );

      if (userCredential.user != null) {
        print("Login bem-sucedido no Firebase. UID: ${userCredential.user!.uid}");

        // Verificar todos os usuários no repositório
        final allUsers = userRepository.getLocalUsers();
        print("Usuários existentes no repositório: ${allUsers.length}");
        for (var user in allUsers) {
          print("Usuário no repositório: ${user.id} - ${user.firstName} ${user.lastName} - ${user.email}");
        }

        // Após autenticação bem-sucedida, verificar se o usuário já existe no repositório
        final existingUser = userRepository.getUser(userCredential.user!.uid);
        print("Usuário existe no repositório? ${existingUser != null}");

        if (existingUser == null) {
          // Se o usuário não existe no repositório local, criar um usuário básico
          final timestamp = DateTime.now();
          final newUser = UserModel(
            userId: userCredential.user!.uid,
            email: email,
            firstName: userCredential.user!.displayName?.split(" ").first ?? "Rodrigo",
            lastName: userCredential.user!.displayName?.split(" ").last ?? "Rocha",
            role: "admin",
            status: "active",
            createdAt: timestamp,
            updatedAt: timestamp,
          );

          print("Criando novo usuário: ${newUser.id} - ${newUser.firstName} ${newUser.lastName}");

          // Salvar o usuário no repositório local
          await userRepository.saveUser(newUser);

          // Verificar se o usuário foi salvo corretamente
          final savedUser = userRepository.getUser(newUser.id);
          print("Usuário salvo corretamente? ${savedUser != null}");
          if (savedUser != null) {
            print("Usuário salvo: ${savedUser.firstName} ${savedUser.lastName}");
          }
        } else {
          print("Usuário existente: ${existingUser.firstName} ${existingUser.lastName}");
        }

        // Atualizar o estado de autenticação após salvar o usuário
        ref.read(authStateProvider.notifier).state = true;

        // Realizar a sincronização inicial após o login, mas não bloquear o login esperando por ela
        ref.read(syncManagerProvider).performInitialSync().then((success) {
          if (!success) {
            print("Aviso: Sincronização inicial após login falhou, mas o login foi bem-sucedido");
          }
        });
      }
    } catch (e) {
      print("Erro no login: $e");
      throw Exception('Invalid email or password: $e');
    }
  };
});

final logoutCallbackProvider = Provider<LogoutCallback>((ref) {
  final auth = ref.watch(authServiceProvider);
  return () async {
    // Efetuar logout no Firebase Auth
    await auth.signOut();

    // Atualizar o estado de autenticação no provider
    ref.read(authStateProvider.notifier).state = false;

    // Resetar o estado de sincronização
    ref.read(syncManagerProvider).resetSyncState();
  };
});
