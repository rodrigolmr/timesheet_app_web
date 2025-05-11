import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import '../core/hive/sync_metadata.dart';
import '../models/card.dart';
import '../models/receipt.dart';
import '../models/timesheet_draft.dart';
import '../models/timesheet.dart';
import '../models/user.dart';
import '../models/worker.dart';

class FirestoreLiveSyncService {
  final _firestore = FirebaseFirestore.instance;

  // Lista para armazenar os canceladores de stream para poder parar os listeners
  final List<StreamSubscription> _subscriptions = [];

  void startAllListeners() {
    try {
      // Primeiro garantir que não há listeners ativos
      stopAllListeners();

      print('🔄 Live sync: iniciando listeners para todas as coleções');

      _listenCollection<CardModel>(
        collectionName: 'cards',
        boxName: 'cardsBox',
        fromMap: (data, id) => CardModel.fromMap({...data, 'uniqueId': id}),
        getId: (item) => item.uniqueId,
      );

      _listenCollection<ReceiptModel>(
        collectionName: 'receipts',
        boxName: 'receiptsBox',
        fromMap: (data, id) => ReceiptModel.fromMap({...data, 'id': id}),
        getId: (item) => '${item.userId}-${item.timestamp.toIso8601String()}',
      );

      _listenCollection<TimesheetDraftModel>(
        collectionName: 'timesheet_drafts',
        boxName: 'timesheetDraftsBox',
        fromMap: (data, id) => TimesheetDraftModel.fromMap({...data, 'id': id}),
        getId: (item) => '${item.userId}-${item.date.toIso8601String()}',
      );

      _listenCollection<TimesheetModel>(
        collectionName: 'timesheets',
        boxName: 'timesheetsBox',
        fromMap: (data, id) => TimesheetModel.fromMap({...data, 'id': id}),
        getId: (item) => '${item.userId}-${item.timestamp.toIso8601String()}',
        checkDeletedKeys: true,
      );

      _listenCollection<UserModel>(
        collectionName: 'users',
        boxName: 'usersBox',
        fromMap: (data, id) => UserModel.fromMap({...data, 'userId': id}),
        getId: (item) => item.userId,
      );

      _listenCollection<WorkerModel>(
        collectionName: 'workers',
        boxName: 'workersBox',
        fromMap: (data, id) => WorkerModel.fromMap({...data, 'uniqueId': id}),
        getId: (item) => item.uniqueId,
      );

      print('✅ Live sync: todos os listeners inicializados');
    } catch (e) {
      print('⚠️ Live sync: erro ao inicializar listeners - ${e.toString()}');
      // Não interrompe a execução do app, apenas loga o erro
    }
  }

  // Método para parar todos os listeners ativos
  void stopAllListeners() {
    if (_subscriptions.isNotEmpty) {
      print('🛑 Live sync: cancelando ${_subscriptions.length} listeners ativos');

      for (var subscription in _subscriptions) {
        subscription.cancel();
      }

      _subscriptions.clear();
      print('✅ Live sync: todos os listeners foram cancelados');
    }
  }

  void _listenCollection<T>({
    required String collectionName,
    required String boxName,
    required T Function(Map<String, dynamic> data, String id) fromMap,
    required String Function(T item) getId,
    bool checkDeletedKeys = false,
  }) {
    final box = Hive.box<T>(boxName);

    try {
      // Criar a subscription e armazená-la para poder cancelá-la depois
      final subscription = _firestore.collection(collectionName).snapshots().listen(
        (snapshot) {
          print('🔄 Live sync: recebido evento para $collectionName com ${snapshot.docChanges.length} alterações');

          for (var change in snapshot.docChanges) {
            final data = change.doc.data();
            final id = change.doc.id;

            if (data != null) {
              final item = fromMap(data, id);
              final key = getId(item);

              // Verificar se este item foi marcado como excluído localmente
              bool isDeleted = false;
              if (checkDeletedKeys) {
                final deletedKeys = SyncMetadata.getDeletedKeys(collectionName) ?? <String>[];
                isDeleted = deletedKeys.contains(key);
                if (isDeleted) {
                  print('⚠️ Live sync: ignorando item $id em $collectionName pois foi excluído localmente');
                }
              }

              if (!isDeleted) {
                if (change.type == DocumentChangeType.added) {
                  print('➕ Live sync: adicionando item em $collectionName, id: $id, key: $key');
                  box.put(key, item);
                } else if (change.type == DocumentChangeType.modified) {
                  print('✏️ Live sync: modificando item em $collectionName, id: $id, key: $key');
                  box.put(key, item);
                } else if (change.type == DocumentChangeType.removed) {
                  print('❌ Live sync: removendo item em $collectionName, id: $id, key: $key');
                  box.delete(key);

                  // Se o item foi removido remotamente, também remover da lista de exclusões locais
                  if (checkDeletedKeys) {
                    final deletedKeys = SyncMetadata.getDeletedKeys(collectionName) ?? <String>[];
                    if (deletedKeys.contains(key)) {
                      deletedKeys.remove(key);
                      SyncMetadata.setDeletedKeys(collectionName, deletedKeys);
                      print('🧹 Live sync: removido $id da lista de exclusões locais');
                    }
                  }
                }
              }
            }
          }
        },
        onError: (error) {
          print('⚠️ Live sync: erro ao escutar $collectionName - ${error.toString()}');
          // Não lançar exceção, apenas logar o erro para não quebrar a aplicação
        },
      );

      // Adicionar a subscription à lista para poder cancelá-la depois
      _subscriptions.add(subscription);
      print('📝 Live sync: adicionado listener para $collectionName (total: ${_subscriptions.length})');

    } catch (e) {
      print('⚠️ Live sync: erro ao iniciar listener para $collectionName - ${e.toString()}');
      // Não lançar exceção, apenas logar o erro para não quebrar a aplicação
    }
  }
}
