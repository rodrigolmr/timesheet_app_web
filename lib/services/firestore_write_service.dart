import 'dart:math' as Math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

    // Salvar localmente no repositório
    // Note: Precisamos usar diretamente o método do repositório
    final box = Hive.box<TimesheetDraftModel>('timesheetDraftsBox');
    await box.put(id, draft);
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
    // Excluir primeiro do repositório local para garantir que o item seja marcado como excluído
    try {
      print('🗑️ FirestoreWriteService: Excluindo timesheet do repositório local: $id');
      await _timesheetRepo.deleteTimesheet(id);
      print('✅ FirestoreWriteService: Timesheet excluído com sucesso do repositório local: $id');
    } catch (e) {
      print('❌ FirestoreWriteService: Erro ao excluir timesheet do repositório local: $e');
      throw Exception('Falha ao excluir timesheet do repositório local: $e');
    }

    // Verificar se estamos autenticados
    if (_auth.currentUser == null) {
      print('⚠️ FirestoreWriteService: Usuário não autenticado, não é possível excluir do Firestore');
      return;
    }

    // Para depuração: exibir ID token do usuário autenticado
    try {
      final token = await _auth.currentUser!.getIdToken();
      if (token != null && token.isNotEmpty) {
        print('🔑 Token do usuário atual (primeiros 20 caracteres): ${token.substring(0, Math.min(20, token.length))}...');
      } else {
        print('⚠️ Token vazio ou nulo');
      }
    } catch (e) {
      print('⚠️ Erro ao obter token: $e');
    }

    // Forçar exclusão no Firebase com tentativas sistemáticas
    int retryCount = 0;
    const maxRetries = 5; // Aumentando o número de tentativas
    const methodsToTry = ['default', 'batch', 'transaction', 'runTransaction']; // Diferentes formas de exclusão para tentar

    for (final method in methodsToTry) {
      retryCount = 0;
      while (retryCount < maxRetries) {
        try {
          print('🗑️ FirestoreWriteService: Excluindo timesheet do Firestore ($method, tentativa ${retryCount + 1}): $id');

          switch (method) {
            case 'default':
              // Método padrão de exclusão
              await _firestore.collection('timesheets').doc(id).delete();
              break;

            case 'batch':
              // Tentativa com WriteBatch
              final batch = _firestore.batch();
              batch.delete(_firestore.collection('timesheets').doc(id));
              await batch.commit();
              break;

            case 'transaction':
              // Tentativa com Transaction
              await _firestore.runTransaction((transaction) async {
                transaction.delete(_firestore.collection('timesheets').doc(id));
              });
              break;

            case 'runTransaction':
              // Alternativa usando runTransaction como método específico
              await _firestore.runTransaction((transaction) async {
                final docRef = _firestore.collection('timesheets').doc(id);
                transaction.delete(docRef);
                return true;
              });
              break;
          }

          print('✅ FirestoreWriteService: Documento $id excluído com sucesso usando método $method');
          // Verificar se o documento foi realmente excluído
          try {
            final docRef = await _firestore.collection('timesheets').doc(id).get();
            if (!docRef.exists) {
              print('✅ FirestoreWriteService: Verificado! Documento não existe mais no Firestore');
              return; // Sucesso, sair do método
            } else {
              print('⚠️ FirestoreWriteService: Documento ainda existe após tentativa de exclusão!');
              // Continuar tentando
            }
          } catch (e) {
            print('⚠️ FirestoreWriteService: Erro ao verificar exclusão: $e');
          }

        } catch (e) {
          retryCount++;
          print('❌ FirestoreWriteService: Erro ao excluir timesheet do Firestore (método $method, tentativa $retryCount): $e');

          if (retryCount >= maxRetries) {
            print('⚠️ FirestoreWriteService: Número máximo de tentativas atingido para método $method.');
            // Tentar próximo método
            break;
          } else {
            // Aguardar mais tempo entre as tentativas (backoff exponencial ampliado)
            await Future.delayed(Duration(milliseconds: 500 * (retryCount * retryCount)));
          }
        }
      }
    }

    print('⚠️ FirestoreWriteService: Não foi possível excluir do Firestore após tentar todos os métodos, mas a exclusão local foi concluída');
  }

  Future<bool> checkTimesheetExists(String id) async {
    try {
      final docSnapshot = await _firestore.collection('timesheets').doc(id).get();
      return docSnapshot.exists;
    } catch (e) {
      print('❌ FirestoreWriteService: Erro ao verificar se o timesheet existe: $e');
      return false;
    }
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