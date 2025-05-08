import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final ScrollController _logScrollController = ScrollController();
  final List<String> _logMessages = [];
  bool _isSyncing = false;
  String _currentCollection = '';
  double _syncProgress = 0.0;
  
  @override
  void dispose() {
    _logScrollController.dispose();
    super.dispose();
  }

  void _log(String message) {
    setState(() {
      _logMessages.add('[${DateTime.now().toString()}] $message');
      
      // Manter no máximo 100 mensagens no log
      if (_logMessages.length > 100) {
        _logMessages.removeAt(0);
      }
    });
    
    // Rolar para o final do log
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_logScrollController.hasClients) {
        _logScrollController.animateTo(
          _logScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<List<Map<String, dynamic>>> _safeFirestoreFetch(
    String collectionName,
    Future<List<Map<String, dynamic>>> Function() fetchFunction
  ) async {
    _log('🔍 Buscando coleção: $collectionName');
    setState(() {
      _currentCollection = collectionName;
    });
    
    try {
      final result = await fetchFunction();
      _log('✅ $collectionName: ${result.length} documentos encontrados');
      return result;
    } catch (e) {
      _log('❌ Erro ao buscar $collectionName: $e');
      // Retorna lista vazia em caso de erro para não quebrar a sincronização
      return [];
    }
  }

  Future<void> _syncSingleCollection(
    String name,
    List<Map<String, dynamic>> data,
    Future<void> Function(List<Map<String, dynamic>>) syncFunction
  ) async {
    _log('🔄 Sincronizando: $name (${data.length} itens)');
    
    try {
      await syncFunction(data);
      _log('✅ $name: sincronização concluída');
    } catch (e) {
      _log('❌ Erro ao sincronizar $name: $e');
      _log('📝 Stack trace: ${StackTrace.current}');
    }
  }

  Future<void> _forceSyncDetailed() async {
    if (_isSyncing) return;
    
    setState(() {
      _isSyncing = true;
      _syncProgress = 0.0;
      _logMessages.clear();
    });
    
    _log('🚀 Iniciando sincronização detalhada...');
    
    try {
      final syncService = ref.read(syncServiceProvider);
      
      // 1. Buscar dados do Firestore com tratamento de erro por coleção
      _log('📥 Buscando dados do Firestore...');
      
      final cardsData = await _safeFirestoreFetch('cards', fetchCardsFromFirestore);
      setState(() => _syncProgress = 0.15);
      
      final receiptsData = await _safeFirestoreFetch('receipts', fetchReceiptsFromFirestore);
      setState(() => _syncProgress = 0.3);
      
      final draftsData = await _safeFirestoreFetch('timesheet_drafts', fetchDraftsFromFirestore);
      setState(() => _syncProgress = 0.45);
      
      final timesheetsData = await _safeFirestoreFetch('timesheets', fetchTimesheetsFromFirestore);
      setState(() => _syncProgress = 0.6);
      
      final usersData = await _safeFirestoreFetch('users', fetchUsersFromFirestore);
      setState(() => _syncProgress = 0.75);
      
      final workersData = await _safeFirestoreFetch('workers', fetchWorkersFromFirestore);
      setState(() => _syncProgress = 0.9);
      
      // 2. Sincronizar cada coleção individualmente para facilitar o debug
      _log('🔄 Iniciando sincronização de dados...');
      
      // Sincronizar Cards
      await _syncSingleCollection('Cards', cardsData, 
          (data) => ref.read(cardRepositoryProvider).syncCards(data));
      
      // Sincronizar Receipts
      await _syncSingleCollection('Receipts', receiptsData,
          (data) => ref.read(receiptRepositoryProvider).syncReceipts(data));
      
      // Sincronizar Drafts
      await _syncSingleCollection('Drafts', draftsData,
          (data) => ref.read(draftRepositoryProvider).syncDrafts(data));
      
      // Sincronizar Timesheets
      await _syncSingleCollection('Timesheets', timesheetsData,
          (data) => ref.read(timesheetRepositoryProvider).syncTimesheets(data));
      
      // Sincronizar Users
      await _syncSingleCollection('Users', usersData,
          (data) => ref.read(userRepositoryProvider).syncUsers(data));
      
      // Sincronizar Workers
      await _syncSingleCollection('Workers', workersData,
          (data) => ref.read(workerRepositoryProvider).syncWorkers(data));
      
      _log('🎉 Sincronização manual completa!');
    } catch (e) {
      _log('❌ Erro geral na sincronização: $e');
      _log('📝 Stack trace: ${StackTrace.current}');
    } finally {
      setState(() {
        _isSyncing = false;
        _syncProgress = 1.0;
        _currentCollection = '';
      });
    }
  }

  // Método para adicionar dados de teste ao Firestore
  Future<void> _addTestData() async {
    setState(() {
      _isSyncing = true;
      _logMessages.clear();
    });
    
    _log('🧪 Adicionando dados de teste...');
    
    try {
      final firestore = FirebaseFirestore.instance;
      final now = DateTime.now();
      
      // Adicionar um trabalhador de teste
      final workerId = 'worker_${now.millisecondsSinceEpoch}';
      await firestore.collection('workers').doc(workerId).set({
        'firstName': 'João',
        'lastName': 'Silva',
        'status': 'active',
        'createdAt': now,
        'updatedAt': now,
      });
      _log('✅ Worker de teste adicionado');
      
      // Adicionar um cartão de teste
      final cardId = 'card_${now.millisecondsSinceEpoch}';
      await firestore.collection('cards').doc(cardId).set({
        'cardholderName': 'João Silva',
        'last4Digits': '1234',
        'status': 'active',
        'createdAt': now,
        'updatedAt': now,
      });
      _log('✅ Card de teste adicionado');
      
      // Adicionar uma timesheet de teste
      final timesheetId = 'timesheet_${now.millisecondsSinceEpoch}';
      await firestore.collection('timesheets').doc(timesheetId).set({
        'userId': 'test_user',
        'jobName': 'Projeto Teste',
        'date': now,
        'tm': 'TM1',
        'foreman': 'Supervisor',
        'jobDesc': 'Descrição do trabalho',
        'jobSize': 'Médio',
        'material': 'Material de teste',
        'notes': 'Notas de teste',
        'vehicle': 'Carro 01',
        'workers': [{'id': workerId, 'name': 'João Silva', 'hours': 8}],
        'timestamp': now,
        'updatedAt': now,
      });
      _log('✅ Timesheet de teste adicionada');
      
      _log('🎉 Dados de teste criados com sucesso!');
    } catch (e) {
      _log('❌ Erro ao adicionar dados de teste: $e');
    } finally {
      setState(() {
        _isSyncing = false;
      });
    }
  }

  Future<void> _clearHive() async {
    _log('🗑️ Limpando dados locais do Hive...');
    
    try {
      await Hive.box<CardModel>('cardsBox').clear();
      _log('✅ Cards limpos');
      
      await Hive.box<WorkerModel>('workersBox').clear();
      _log('✅ Workers limpos');
      
      await Hive.box<TimesheetModel>('timesheetsBox').clear();
      _log('✅ Timesheets limpos');
      
      await Hive.box<TimesheetDraftModel>('timesheetDraftsBox').clear();
      _log('✅ Drafts limpos');
      
      await Hive.box<ReceiptModel>('receiptsBox').clear();
      _log('✅ Receipts limpos');
      
      await Hive.box<UserModel>('usersBox').clear();
      _log('✅ Users limpos');
      
      await Hive.box<DateTime>('syncMetadataBox').clear();
      _log('✅ Metadata de sincronização limpa');
      
      _log('🎉 Todos os dados Hive foram limpos com sucesso!');
    } catch (e) {
      _log('❌ Erro ao limpar Hive: $e');
    }
    
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Contar itens nas boxes
    final cardsCount = Hive.box<CardModel>('cardsBox').length;
    final workersCount = Hive.box<WorkerModel>('workersBox').length;
    final timesheetsCount = Hive.box<TimesheetModel>('timesheetsBox').length;
    final draftsCount = Hive.box<TimesheetDraftModel>('timesheetDraftsBox').length;
    final receiptsCount = Hive.box<ReceiptModel>('receiptsBox').length;
    final usersCount = Hive.box<UserModel>('usersBox').length;

    // Pegar últimas sincronizações
    final lastCardSync = SyncMetadata.getLastSync('cards');
    final lastWorkerSync = SyncMetadata.getLastSync('workers');
    final lastTimesheetSync = SyncMetadata.getLastSync('timesheets');

    return Scaffold(
      appBar: AppBar(
        title: const Text('🔧 Debug & Sincronização'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Voltar para Home',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status das caixas de dados
            Text('📊 Status do banco de dados local:', 
              style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            
            // Grid de estatísticas
            GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              childAspectRatio: 3,
              children: [
                _buildStatCard(context, 'Cards', cardsCount),
                _buildStatCard(context, 'Workers', workersCount),
                _buildStatCard(context, 'Timesheets', timesheetsCount),
                _buildStatCard(context, 'Drafts', draftsCount),
                _buildStatCard(context, 'Receipts', receiptsCount),
                _buildStatCard(context, 'Users', usersCount),
              ],
            ),
            
            const SizedBox(height: 16),
            Text('🕒 Última sincronização:', 
              style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            
            // Informações de sincronização
            Text('Cards: ${_formatDateTime(lastCardSync)}'),
            Text('Workers: ${_formatDateTime(lastWorkerSync)}'),
            Text('Timesheets: ${_formatDateTime(lastTimesheetSync)}'),
            
            const SizedBox(height: 16),
            
            // Progress bar de sincronização
            if (_isSyncing) ...[
              Text('Sincronizando $_currentCollection...'),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: _syncProgress),
              const SizedBox(height: 16),
            ],
            
            // Botões de ação
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.sync),
                    label: const Text('Sincronizar'),
                    onPressed: _isSyncing ? null : _forceSyncDetailed,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Dados de Teste'),
                    onPressed: _isSyncing ? null : _addTestData,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.delete),
                    label: const Text('Limpar Hive'),
                    onPressed: _isSyncing ? null : _clearHive,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            Text('📋 Log de operações:', 
              style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            
            // Log de mensagens
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _logMessages.isEmpty
                    ? const Center(child: Text('Nenhuma operação realizada'))
                    : ListView.builder(
                        controller: _logScrollController,
                        itemCount: _logMessages.length,
                        itemBuilder: (context, index) {
                          final message = _logMessages[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              message,
                              style: TextStyle(
                                fontSize: 12,
                                color: message.contains('❌')
                                    ? Colors.red
                                    : message.contains('✅')
                                        ? Colors.green
                                        : Colors.black,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, int count) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              _getIconForType(title),
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('$count itens'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'Cards':
        return Icons.credit_card;
      case 'Workers':
        return Icons.people;
      case 'Timesheets':
        return Icons.assignment;
      case 'Drafts':
        return Icons.edit_document;
      case 'Receipts':
        return Icons.receipt;
      case 'Users':
        return Icons.person;
      default:
        return Icons.question_mark;
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Nunca';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}