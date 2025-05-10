import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/firestore_fetch.dart';
import '../widgets/feedback_overlay.dart';
import '../widgets/toast_message.dart';
import 'sync_service.dart';
import 'connectivity_service.dart';

enum SyncStatus {
  initial,
  syncing,
  completed,
  error,
}

class SyncManager {
  final SyncService _syncService;
  final StateController<SyncStatus> _statusController;
  final StateController<String?> _errorController;
  final StateController<DateTime?> _lastSyncController;

  // Flag para garantir que a sincronização inicial seja executada apenas uma vez por sessão
  bool _initialSyncPerformed = false;

  // Serviço de conectividade
  ConnectivityService? _connectivityService;

  SyncManager({
    required SyncService syncService,
    required StateController<SyncStatus> statusController,
    required StateController<String?> errorController,
    required StateController<DateTime?> lastSyncController,
    ConnectivityService? connectivityService,
  })  : _syncService = syncService,
        _statusController = statusController,
        _errorController = errorController,
        _lastSyncController = lastSyncController,
        _connectivityService = connectivityService;

  SyncStatus get currentStatus => _statusController.state;
  String? get currentError => _errorController.state;
  DateTime? get lastSyncTime => _lastSyncController.state;
  bool get isInitialSyncPerformed => _initialSyncPerformed;

  /// Verifica se o dispositivo está online antes de tentar sincronizar
  Future<bool> _checkConnectivity(BuildContext? context) async {
    if (_connectivityService == null) {
      return true; // Se não tiver serviço de conectividade, assumir online
    }

    final isOnline = await _connectivityService!.isOnline();

    if (!isOnline && context != null && context.mounted) {
      // Mostrar aviso de que está offline
      ToastMessage.showWarning(
        context,
        'You are offline. Sync will be performed when online.',
      );
    }

    return isOnline;
  }

  /// Realiza a sincronização inicial quando o app é aberto silenciosamente
  /// Retorna true se a sincronização foi bem-sucedida ou se já foi executada antes
  Future<bool> performInitialSync({BuildContext? context}) async {
    // Se a sincronização já foi executada nesta sessão, não executar novamente
    if (_initialSyncPerformed) {
      return true;
    }

    // Verificar conectividade antes de tentar sincronizar (sem mostrar feedback)
    final isOnline = await _checkConnectivity(null);
    if (!isOnline) {
      // Se estiver offline, marcar como concluído com erro para não bloquear o app
      _statusController.state = SyncStatus.completed;
      _errorController.state = "Offline - sync pending";
      _initialSyncPerformed = true; // Marcar como executada para não tentar repetidamente
      return true; // Retorna true para não bloquear o fluxo do app
    }

    _statusController.state = SyncStatus.syncing;
    _errorController.state = null;

    try {
      // Buscar dados do Firestore
      final cardsData = await fetchCardsFromFirestore();
      final receiptsData = await fetchReceiptsFromFirestore();
      final draftsData = await fetchDraftsFromFirestore();
      final timesheetsData = await fetchTimesheetsFromFirestore();
      final usersData = await fetchUsersFromFirestore();
      final workersData = await fetchWorkersFromFirestore();

      // Executar sincronização silenciosamente (sem passar context)
      await _syncService.syncAll(
        remoteCards: cardsData,
        remoteReceipts: receiptsData,
        remoteDrafts: draftsData,
        remoteTimesheets: timesheetsData,
        remoteUsers: usersData,
        remoteWorkers: workersData,
        // Não passamos context para evitar feedback visual
      );

      // Atualizar estado após sincronização bem-sucedida
      _statusController.state = SyncStatus.completed;
      _lastSyncController.state = DateTime.now();
      _initialSyncPerformed = true;

      return true;
    } catch (e) {
      // Em caso de erro, atualizar estado silenciosamente
      _statusController.state = SyncStatus.error;
      _errorController.state = e.toString();

      // Apenas logar o erro, sem mostrar ao usuário
      print('Erro na sincronização inicial em segundo plano: ${e.toString()}');

      return false;
    }
  }

  /// Força uma nova sincronização completa
  Future<bool> forceSyncAll({BuildContext? context}) async {
    // Verificar conectividade antes de tentar sincronizar
    final isOnline = await _checkConnectivity(context);
    if (!isOnline) {
      _statusController.state = SyncStatus.error;
      _errorController.state = "Cannot sync while offline";
      return false;
    }

    _statusController.state = SyncStatus.syncing;
    _errorController.state = null;

    try {
      await _syncService.syncAll(context: context);

      _statusController.state = SyncStatus.completed;
      _lastSyncController.state = DateTime.now();
      _initialSyncPerformed = true;

      return true;
    } catch (e) {
      _statusController.state = SyncStatus.error;
      _errorController.state = e.toString();
      return false;
    }
  }

  /// Sincroniza apenas uma coleção específica
  Future<bool> syncCollection(String collection, BuildContext context) async {
    // Verificar conectividade antes de tentar sincronizar
    final isOnline = await _checkConnectivity(context);
    if (!isOnline) {
      _statusController.state = SyncStatus.error;
      _errorController.state = "Cannot sync while offline";
      return false;
    }

    _statusController.state = SyncStatus.syncing;

    try {
      await _syncService.syncCollection(collection, context);

      _statusController.state = SyncStatus.completed;
      _lastSyncController.state = DateTime.now();

      return true;
    } catch (e) {
      _statusController.state = SyncStatus.error;
      _errorController.state = e.toString();
      return false;
    }
  }

  /// Reseta o estado de sincronização inicial (útil para logout)
  void resetSyncState() {
    _initialSyncPerformed = false;
    _statusController.state = SyncStatus.initial;
    _errorController.state = null;
  }
}