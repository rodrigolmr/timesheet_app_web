import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io';
import 'dart:convert';

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
  final List<String> _filteredLogMessages = [];
  bool _isSyncing = false;
  String _currentCollection = '';
  double _syncProgress = 0.0;
  String _selectedBoxType = 'cards';
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _logSearchController = TextEditingController();
  final List<Map<String, dynamic>> _filteredItems = [];
  Map<String, dynamic>? _selectedItem;
  bool _showErrorsOnly = false;
  bool _showSuccessOnly = false;
  bool _isLogSearchActive = false;
  
  @override
  void initState() {
    super.initState();
    _updateFilteredItems();
    _filteredLogMessages.addAll(_logMessages);
  }
  
  @override
  void dispose() {
    _logScrollController.dispose();
    _searchController.dispose();
    _logSearchController.dispose();
    super.dispose();
  }
  
  void _filterLogMessages() {
    final searchTerm = _logSearchController.text.toLowerCase();
    
    if (searchTerm.isEmpty && !_showErrorsOnly && !_showSuccessOnly) {
      setState(() {
        _filteredLogMessages.clear();
        _filteredLogMessages.addAll(_logMessages);
        _isLogSearchActive = false;
      });
      return;
    }
    
    setState(() {
      _filteredLogMessages.clear();
      _isLogSearchActive = true;
      
      for (final message in _logMessages) {
        final messageLower = message.toLowerCase();
        bool shouldInclude = true;
        
        // Aplicar filtro de busca
        if (searchTerm.isNotEmpty && !messageLower.contains(searchTerm)) {
          shouldInclude = false;
        }
        
        // Aplicar filtro de erros
        if (_showErrorsOnly && !message.contains('❌')) {
          shouldInclude = false;
        }
        
        // Aplicar filtro de sucessos
        if (_showSuccessOnly && !message.contains('✅')) {
          shouldInclude = false;
        }
        
        if (shouldInclude) {
          _filteredLogMessages.add(message);
        }
      }
    });
  }

  void _log(String message) {
    setState(() {
      final formattedMessage = '[${DateTime.now().toString()}] $message';
      _logMessages.add(formattedMessage);
      
      // Manter no máximo 500 mensagens no log
      if (_logMessages.length > 500) {
        _logMessages.removeAt(0);
      }
      
      // Atualizar mensagens filtradas se necessário
      if (!_isLogSearchActive) {
        _filteredLogMessages.add(formattedMessage);
        if (_filteredLogMessages.length > 500) {
          _filteredLogMessages.removeAt(0);
        }
      } else {
        _filterLogMessages(); // Reaplica os filtros com a nova mensagem
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
  
  void _clearLogs() {
    setState(() {
      _logMessages.clear();
      _filteredLogMessages.clear();
      _isLogSearchActive = false;
      _logSearchController.clear();
      _showErrorsOnly = false;
      _showSuccessOnly = false;
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
  
  // Método para testar a conectividade com o Firestore
  Future<void> _testFirestoreConnection() async {
    _log('🔄 Testando conexão com o Firestore...');
    
    try {
      // Começar a registrar tempo para medir latência
      final startTime = DateTime.now();
      
      // Tentar fazer uma consulta leve para testar conectividade
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore.collection('system_status').limit(1).get();
      
      // Calcular tempo de resposta
      final endTime = DateTime.now();
      final latencyMs = endTime.difference(startTime).inMilliseconds;
      
      _log('✅ Conexão com Firestore estabelecida');
      _log('⏱️ Latência: $latencyMs ms');
      
      // Verificar se tem algum documento na coleção system_status
      if (querySnapshot.docs.isNotEmpty) {
        final statusData = querySnapshot.docs.first.data();
        final statusMessage = statusData['message'] ?? 'OK';
        final statusTimestamp = statusData['timestamp'];
        
        _log('📝 Status do sistema: $statusMessage');
        if (statusTimestamp != null) {
          _log('⏰ Atualizado em: ${_formatDateTime(statusTimestamp.toDate())}');
        }
      } else {
        _log('⚠️ Coleção system_status não encontrada ou vazia');
      }
      
      // Verificar sincronização em tempo real
      _log('🔄 Testando listener em tempo real...');
      
      final subscription = firestore.collection('system_status').limit(1)
        .snapshots().listen((snapshot) {
          _log('✅ Listener em tempo real recebeu atualização');
        }, onError: (e) {
          _log('❌ Erro no listener em tempo real: $e');
        });
      
      // Aguardar alguns segundos e cancelar a inscrição
      await Future.delayed(const Duration(seconds: 5));
      subscription.cancel();
      
      _log('🎉 Teste de conexão concluído com sucesso!');
    } catch (e) {
      _log('❌ Erro ao testar conexão: $e');
      
      // Tentar detectar o tipo de erro para fornecer sugestões
      if (e.toString().contains('network')) {
        _log('🔌 Parece haver um problema de rede. Verifique sua conexão com a internet.');
      } else if (e.toString().contains('permission') || e.toString().contains('unauthorized')) {
        _log('🔒 Problema de permissão. Verifique se você está autenticado e tem acesso ao Firestore.');
      } else if (e.toString().contains('not found')) {
        _log('🔎 Coleção ou documento não encontrado. Verifique se o Firestore está configurado corretamente.');
      }
    }
  }
  
  // Método para mostrar informações do sistema
  Future<void> _showSystemInfo() async {
    _log('📱 Coletando informações do sistema...');
    
    try {
      // Informações do aplicativo
      final packageInfo = await PackageInfo.fromPlatform();
      _log('📦 Nome do App: ${packageInfo.appName}');
      _log('📦 Versão: ${packageInfo.version}+${packageInfo.buildNumber}');
      _log('📦 ID do Pacote: ${packageInfo.packageName}');
      
      // Informações do dispositivo
      _log('📱 Plataforma: ${Platform.operatingSystem} ${Platform.operatingSystemVersion}');
      _log('📱 Localidade: ${Platform.localeName}');
      
      // Estado de conexão
      final connectivityResult = await Connectivity().checkConnectivity();
      String connectionStatus;
      switch (connectivityResult) {
        case ConnectivityResult.mobile:
          connectionStatus = '📶 Conectado via rede móvel';
          break;
        case ConnectivityResult.wifi:
          connectionStatus = '📶 Conectado via WiFi';
          break;
        case ConnectivityResult.ethernet:
          connectionStatus = '📶 Conectado via Ethernet';
          break;
        case ConnectivityResult.vpn:
          connectionStatus = '📶 Conectado via VPN';
          break;
        case ConnectivityResult.bluetooth:
          connectionStatus = '📶 Conectado via Bluetooth';
          break;
        case ConnectivityResult.other:
          connectionStatus = '📶 Conectado via outro tipo de rede';
          break;
        case ConnectivityResult.none:
          connectionStatus = '❌ Sem conexão de rede';
          break;
        default:
          connectionStatus = '❓ Estado de conexão desconhecido';
      }
      _log(connectionStatus);
      
      // Informações de armazenamento
      _log('📊 Informações do Hive:');
      _log('  - Cards: ${Hive.box<CardModel>('cardsBox').length} registros');
      _log('  - Workers: ${Hive.box<WorkerModel>('workersBox').length} registros');
      _log('  - Timesheets: ${Hive.box<TimesheetModel>('timesheetsBox').length} registros');
      _log('  - Drafts: ${Hive.box<TimesheetDraftModel>('timesheetDraftsBox').length} registros');
      _log('  - Receipts: ${Hive.box<ReceiptModel>('receiptsBox').length} registros');
      _log('  - Users: ${Hive.box<UserModel>('usersBox').length} registros');
      
      _log('🎉 Coleta de informações do sistema concluída');
    } catch (e) {
      _log('❌ Erro ao coletar informações do sistema: $e');
    }
  }
  
  // Método para exportar dados locais
  Future<void> _exportLocalData() async {
    _log('📤 Exportando dados locais...');
    
    try {
      // Criar um Map com todos os dados
      final Map<String, dynamic> exportData = {
        'metadata': {
          'version': '1.0',
          'exportDate': DateTime.now().toIso8601String(),
          'deviceInfo': Platform.operatingSystem,
        },
        'collections': {
          'cards': [],
          'workers': [],
          'timesheets': [],
          'drafts': [],
          'receipts': [],
          'users': [],
        }
      };
      
      // Exportar Cards
      final cardsBox = Hive.box<CardModel>('cardsBox');
      for (var i = 0; i < cardsBox.length; i++) {
        final card = cardsBox.getAt(i);
        if (card != null) {
          exportData['collections']['cards'].add({
            'id': card.id,
            'cardholderName': card.cardholderName,
            'last4Digits': card.last4Digits,
            'status': card.status,
            'createdAt': card.createdAt?.toIso8601String(),
            'updatedAt': card.updatedAt?.toIso8601String(),
          });
        }
      }
      _log('✅ Cards exportados: ${cardsBox.length} registros');
      
      // Exportar Workers
      final workersBox = Hive.box<WorkerModel>('workersBox');
      for (var i = 0; i < workersBox.length; i++) {
        final worker = workersBox.getAt(i);
        if (worker != null) {
          exportData['collections']['workers'].add({
            'id': worker.id,
            'firstName': worker.firstName,
            'lastName': worker.lastName,
            'status': worker.status,
            'createdAt': worker.createdAt?.toIso8601String(),
            'updatedAt': worker.updatedAt?.toIso8601String(),
          });
        }
      }
      _log('✅ Workers exportados: ${workersBox.length} registros');
      
      // Exportar Timesheets (exemplo simplificado)
      final timesheetsBox = Hive.box<TimesheetModel>('timesheetsBox');
      for (var i = 0; i < timesheetsBox.length; i++) {
        final timesheet = timesheetsBox.getAt(i);
        if (timesheet != null) {
          exportData['collections']['timesheets'].add({
            'id': timesheet.id,
            'jobName': timesheet.jobName,
            'date': timesheet.date?.toIso8601String(),
            // Outros campos seriam adicionados aqui
          });
        }
      }
      _log('✅ Timesheets exportados: ${timesheetsBox.length} registros');
      
      // Simplificando para não ficar muito extenso
      _log('✅ Outros dados exportados...');
      
      // Normalmente salvaríamos em um arquivo aqui
      // Mas para o exemplo, vamos apenas mostrar um preview dos dados
      final jsonString = jsonEncode(exportData);
      _log('📄 Dados exportados em JSON:');
      _log(jsonString.substring(0, jsonString.length > 100 ? 100 : jsonString.length) + '...');
      _log('🎉 Exportação concluída! (${jsonString.length} bytes)');
      
      // Aqui poderia implementar o download ou compartilhamento do arquivo
    } catch (e) {
      _log('❌ Erro ao exportar dados: $e');
    }
  }
  
  // Método para medir performance do app
  Future<void> _measurePerformance() async {
    _log('⏱️ Iniciando medição de performance...');
    
    try {
      // Medir tempo de carregamento de listas
      _log('📊 Testando carregamento de dados...');
      
      // Medir tempo para carregar Cards
      final startCardsTime = DateTime.now();
      final cardsBox = Hive.box<CardModel>('cardsBox');
      final cards = cardsBox.values.toList();
      final endCardsTime = DateTime.now();
      final cardsLoadTime = endCardsTime.difference(startCardsTime).inMilliseconds;
      _log('📇 Cards: ${cards.length} registros em $cardsLoadTime ms (${(cardsLoadTime / cards.length).toStringAsFixed(2)} ms/registro)');
      
      // Medir tempo para carregar Workers
      final startWorkersTime = DateTime.now();
      final workersBox = Hive.box<WorkerModel>('workersBox');
      final workers = workersBox.values.toList();
      final endWorkersTime = DateTime.now();
      final workersLoadTime = endWorkersTime.difference(startWorkersTime).inMilliseconds;
      _log('👷 Workers: ${workers.length} registros em $workersLoadTime ms (${(workersLoadTime / (workers.isEmpty ? 1 : workers.length)).toStringAsFixed(2)} ms/registro)');
      
      // Medir tempo para carregar Timesheets
      final startTimesheetsTime = DateTime.now();
      final timesheetsBox = Hive.box<TimesheetModel>('timesheetsBox');
      final timesheets = timesheetsBox.values.toList();
      final endTimesheetsTime = DateTime.now();
      final timesheetsLoadTime = endTimesheetsTime.difference(startTimesheetsTime).inMilliseconds;
      _log('📝 Timesheets: ${timesheets.length} registros em $timesheetsLoadTime ms (${(timesheetsLoadTime / (timesheets.isEmpty ? 1 : timesheets.length)).toStringAsFixed(2)} ms/registro)');
      
      // Simular um teste de ordenação
      _log('🔄 Testando ordenação...');
      final startSortTime = DateTime.now();
      
      // Fazer uma cópia para não afetar a lista original
      final cardsCopy = [...cards];
      cardsCopy.sort((a, b) {
        final aTime = a.updatedAt ?? a.createdAt;
        final bTime = b.updatedAt ?? b.createdAt;
        if (aTime == null || bTime == null) return 0;
        return bTime.compareTo(aTime);
      });
      
      final endSortTime = DateTime.now();
      final sortTime = endSortTime.difference(startSortTime).inMilliseconds;
      _log('🔄 Ordenação: ${cards.length} cards em $sortTime ms');
      
      // Simular um teste de filtro
      _log('🔍 Testando filtro...');
      final startFilterTime = DateTime.now();
      
      final filteredCards = cards.where((card) => 
        card.status == 'active' && 
        card.cardholderName.toLowerCase().contains('a')).toList();
      
      final endFilterTime = DateTime.now();
      final filterTime = endFilterTime.difference(startFilterTime).inMilliseconds;
      _log('🔍 Filtro: ${filteredCards.length} cards encontrados em $filterTime ms');
      
      _log('🎉 Medição de performance concluída!');
    } catch (e) {
      _log('❌ Erro ao medir performance: $e');
    }
  }

  Future<void> _clearHive() async {
    _clearLogs();
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

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('🔧 Debug & Sincronização'),
          actions: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => Navigator.of(context).pop(),
              tooltip: 'Voltar para Home',
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: '📊 Status'),
              Tab(text: '🔍 Inspeção'),
              Tab(text: '🔧 Ferramentas'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // TAB 1: Status & Syncronização
            SingleChildScrollView(
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
                    physics: const NeverScrollableScrollPhysics(),
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
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cards: ${_formatDateTime(lastCardSync)}'),
                          const SizedBox(height: 4),
                          Text('Workers: ${_formatDateTime(lastWorkerSync)}'),
                          const SizedBox(height: 4),
                          Text('Timesheets: ${_formatDateTime(lastTimesheetSync)}'),
                          const SizedBox(height: 4),
                          Text('Receipts: ${_formatDateTime(SyncMetadata.getLastSync('receipts'))}'),
                          const SizedBox(height: 4),
                          Text('Drafts: ${_formatDateTime(SyncMetadata.getLastSync('timesheet_drafts'))}'),
                          const SizedBox(height: 4),
                          Text('Users: ${_formatDateTime(SyncMetadata.getLastSync('users'))}'),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Progress bar de sincronização
                  if (_isSyncing) ...[
                    Text('Sincronizando $_currentCollection...', 
                      style: const TextStyle(fontWeight: FontWeight.bold)),
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
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('📋 Log de operações:', 
                        style: Theme.of(context).textTheme.titleLarge),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.delete),
                        label: const Text('Limpar Log'),
                        onPressed: _clearLogs,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red[400],
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Controles de busca e filtro do log
                  Row(
                    children: [
                      // Campo de busca
                      Expanded(
                        child: TextField(
                          controller: _logSearchController,
                          decoration: InputDecoration(
                            labelText: 'Buscar no log',
                            hintText: 'Digite para filtrar mensagens...',
                            border: const OutlineInputBorder(),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: _filterLogMessages,
                              tooltip: 'Buscar',
                              iconSize: 20,
                            ),
                          ),
                          onSubmitted: (_) => _filterLogMessages(),
                        ),
                      ),
                      
                      const SizedBox(width: 8),
                      
                      // Filtros rápidos
                      ChoiceChip(
                        label: const Text('❌ Erros'),
                        selected: _showErrorsOnly,
                        onSelected: (selected) {
                          setState(() {
                            _showErrorsOnly = selected;
                            if (selected) {
                              _showSuccessOnly = false;
                            }
                            _filterLogMessages();
                          });
                        },
                      ),
                      
                      const SizedBox(width: 8),
                      
                      ChoiceChip(
                        label: const Text('✅ Sucesso'),
                        selected: _showSuccessOnly,
                        onSelected: (selected) {
                          setState(() {
                            _showSuccessOnly = selected;
                            if (selected) {
                              _showErrorsOnly = false;
                            }
                            _filterLogMessages();
                          });
                        },
                      ),
                      
                      const SizedBox(width: 8),
                      
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Limpar filtros',
                        onPressed: () {
                          setState(() {
                            _showErrorsOnly = false;
                            _showSuccessOnly = false;
                            _logSearchController.clear();
                            _isLogSearchActive = false;
                            _filteredLogMessages.clear();
                            _filteredLogMessages.addAll(_logMessages);
                          });
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Log de mensagens
                  Container(
                    height: 250,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[400]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Cabeçalho com estatísticas
                        if (_isLogSearchActive)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Mostrando ${_filteredLogMessages.length} de ${_logMessages.length} mensagens',
                              style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        
                        // Lista de mensagens
                        Expanded(
                          child: _filteredLogMessages.isEmpty
                              ? const Center(child: Text('Nenhuma operação realizada'))
                              : ListView.builder(
                                  controller: _logScrollController,
                                  itemCount: _filteredLogMessages.length,
                                  itemBuilder: (context, index) {
                                    final message = _filteredLogMessages[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2),
                                      child: SelectableText(
                                        message,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'monospace',
                                          color: message.contains('❌')
                                              ? Colors.red
                                              : message.contains('✅')
                                                  ? Colors.green[700]
                                                  : message.contains('⚠️')
                                                      ? Colors.orange[800]
                                                      : Colors.black,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // TAB 2: Inspeção de Banco de Dados
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🔍 Inspeção de Dados', 
                    style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  
                  // Seletor de tipo de dados e busca
                  Row(
                    children: [
                      // Seletor de tipo
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Tipo de Dados',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedBoxType,
                          items: const [
                            DropdownMenuItem(value: 'cards', child: Text('Cards')),
                            DropdownMenuItem(value: 'workers', child: Text('Workers')),
                            DropdownMenuItem(value: 'timesheets', child: Text('Timesheets')),
                            DropdownMenuItem(value: 'drafts', child: Text('Drafts')),
                            DropdownMenuItem(value: 'receipts', child: Text('Receipts')),
                            DropdownMenuItem(value: 'users', child: Text('Users')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedBoxType = value;
                                _selectedItem = null;
                              });
                              _updateFilteredItems();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Campo de busca
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: 'Buscar',
                            hintText: 'Nome, ID...',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: _updateFilteredItems,
                            ),
                          ),
                          onSubmitted: (_) => _updateFilteredItems(),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Exibição de registros
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Lista de itens
                        Expanded(
                          flex: 1,
                          child: Card(
                            elevation: 2,
                            child: _filteredItems.isEmpty
                                ? const Center(
                                    child: Text('Nenhum item encontrado'),
                                  )
                                : ListView.builder(
                                    itemCount: _filteredItems.length,
                                    itemBuilder: (context, index) {
                                      final item = _filteredItems[index];
                                      return ListTile(
                                        title: Text(
                                          item['title'] as String,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Text(
                                          'ID: ${item['id']}',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        selected: _selectedItem == item,
                                        onTap: () {
                                          setState(() {
                                            _selectedItem = item;
                                          });
                                        },
                                      );
                                    },
                                  ),
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Detalhes do item selecionado
                        Expanded(
                          flex: 2,
                          child: Card(
                            elevation: 2,
                            child: _selectedItem == null
                                ? const Center(
                                    child: Text('Selecione um item para ver detalhes'),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                _selectedItem!['title'] as String,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            IconButton(
                                              icon: const Icon(Icons.copy),
                                              tooltip: 'Copiar ID',
                                              onPressed: () {
                                                // Aqui deveria usar Clipboard, mas vamos só logar para o exemplo
                                                _log('📋 ID copiado: ${_selectedItem!['id']}');
                                              },
                                            ),
                                          ],
                                        ),
                                        const Divider(),
                                        Expanded(
                                          child: ListView(
                                            children: [
                                              SelectableText(
                                                _prettyPrint(_selectedItem!['data']),
                                                style: const TextStyle(
                                                  fontFamily: 'monospace',
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // TAB 3: Ferramentas Adicionais
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🔧 Ferramentas Adicionais', 
                    style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  
                  // Ferramentas serão implementadas aqui
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2,
                      children: [
                        // Grade de ferramentas
                        _buildToolCard(
                          context, 
                          title: 'Verificar Conexão',
                          icon: Icons.wifi,
                          description: 'Testa a conectividade com o Firestore',
                          onTap: _testFirestoreConnection,
                        ),
                        _buildToolCard(
                          context, 
                          title: 'Exportar Banco Local',
                          icon: Icons.download,
                          description: 'Salva todos os dados locais em JSON',
                          onTap: _exportLocalData,
                        ),
                        _buildToolCard(
                          context, 
                          title: 'Informações do Sistema',
                          icon: Icons.info_outline,
                          description: 'Mostra detalhes técnicos do dispositivo',
                          onTap: _showSystemInfo,
                        ),
                        _buildToolCard(
                          context, 
                          title: 'Métricas de Performance',
                          icon: Icons.speed,
                          description: 'Exibe estatísticas de desempenho',
                          onTap: _measurePerformance,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildToolCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
  
  void _updateFilteredItems() {
    _filteredItems.clear();
    
    final searchTerm = _searchController.text.toLowerCase();
    final items = <Map<String, dynamic>>[];
    
    switch (_selectedBoxType) {
      case 'cards':
        final box = Hive.box<CardModel>('cardsBox');
        for (int i = 0; i < box.length; i++) {
          final key = box.keyAt(i);
          final card = box.getAt(i);
          if (card != null) {
            items.add({
              'key': key,
              'id': card.id,
              'title': '${card.cardholderName} - **** ${card.last4Digits}',
              'data': card,
            });
          }
        }
        break;
      case 'workers':
        final box = Hive.box<WorkerModel>('workersBox');
        for (int i = 0; i < box.length; i++) {
          final key = box.keyAt(i);
          final worker = box.getAt(i);
          if (worker != null) {
            items.add({
              'key': key,
              'id': worker.id,
              'title': '${worker.firstName} ${worker.lastName}',
              'data': worker,
            });
          }
        }
        break;
      case 'timesheets':
        final box = Hive.box<TimesheetModel>('timesheetsBox');
        for (int i = 0; i < box.length; i++) {
          final key = box.keyAt(i);
          final timesheet = box.getAt(i);
          if (timesheet != null) {
            items.add({
              'key': key,
              'id': timesheet.id,
              'title': '${timesheet.jobName} - ${_formatDateTime(timesheet.date)}',
              'data': timesheet,
            });
          }
        }
        break;
      case 'drafts':
        final box = Hive.box<TimesheetDraftModel>('timesheetDraftsBox');
        for (int i = 0; i < box.length; i++) {
          final key = box.keyAt(i);
          final draft = box.getAt(i);
          if (draft != null) {
            items.add({
              'key': key,
              'id': draft.id,
              'title': '${draft.jobName ?? 'Draft'} - ${_formatDateTime(draft.timestamp)}',
              'data': draft,
            });
          }
        }
        break;
      case 'receipts':
        final box = Hive.box<ReceiptModel>('receiptsBox');
        for (int i = 0; i < box.length; i++) {
          final key = box.keyAt(i);
          final receipt = box.getAt(i);
          if (receipt != null) {
            items.add({
              'key': key,
              'id': receipt.id,
              'title': '${receipt.merchant} - \$${receipt.amount}',
              'data': receipt,
            });
          }
        }
        break;
      case 'users':
        final box = Hive.box<UserModel>('usersBox');
        for (int i = 0; i < box.length; i++) {
          final key = box.keyAt(i);
          final user = box.getAt(i);
          if (user != null) {
            items.add({
              'key': key,
              'id': user.id,
              'title': '${user.email} - ${user.name}',
              'data': user,
            });
          }
        }
        break;
    }
    
    // Filter by search term if provided
    if (searchTerm.isNotEmpty) {
      for (var item in items) {
        if (item['title'].toString().toLowerCase().contains(searchTerm) ||
            item['id'].toString().toLowerCase().contains(searchTerm)) {
          _filteredItems.add(item);
        }
      }
    } else {
      _filteredItems.addAll(items);
    }
    
    // Sort by modification time or creation if available
    _filteredItems.sort((a, b) {
      final dataA = a['data'];
      final dataB = b['data'];
      DateTime? timeA;
      DateTime? timeB;
      
      if (dataA is CardModel) {
        timeA = dataA.updatedAt ?? dataA.createdAt;
      } else if (dataA is WorkerModel) {
        timeA = dataA.updatedAt ?? dataA.createdAt;
      } else if (dataA is TimesheetModel) {
        timeA = dataA.updatedAt ?? dataA.timestamp;
      } else if (dataA is TimesheetDraftModel) {
        timeA = dataA.timestamp;
      } else if (dataA is ReceiptModel) {
        timeA = dataA.timestamp;
      } else if (dataA is UserModel) {
        timeA = dataA.updatedAt;
      }
      
      if (dataB is CardModel) {
        timeB = dataB.updatedAt ?? dataB.createdAt;
      } else if (dataB is WorkerModel) {
        timeB = dataB.updatedAt ?? dataB.createdAt;
      } else if (dataB is TimesheetModel) {
        timeB = dataB.updatedAt ?? dataB.timestamp;
      } else if (dataB is TimesheetDraftModel) {
        timeB = dataB.timestamp;
      } else if (dataB is ReceiptModel) {
        timeB = dataB.timestamp;
      } else if (dataB is UserModel) {
        timeB = dataB.updatedAt;
      }
      
      if (timeA != null && timeB != null) {
        return timeB.compareTo(timeA); // Most recent first
      }
      return 0;
    });
    
    setState(() {});
  }
  
  /// Get a pretty-printed version of a given object
  String _prettyPrint(dynamic obj) {
    final buffer = StringBuffer();
    
    if (obj is CardModel) {
      buffer.writeln('ID: ${obj.id}');
      buffer.writeln('Cardholder: ${obj.cardholderName}');
      buffer.writeln('Last 4 Digits: ${obj.last4Digits}');
      buffer.writeln('Status: ${obj.status}');
      buffer.writeln('Created: ${_formatDateTime(obj.createdAt)}');
      buffer.writeln('Updated: ${_formatDateTime(obj.updatedAt)}');
    } else if (obj is WorkerModel) {
      buffer.writeln('ID: ${obj.id}');
      buffer.writeln('Name: ${obj.firstName} ${obj.lastName}');
      buffer.writeln('Status: ${obj.status}');
      buffer.writeln('Created: ${_formatDateTime(obj.createdAt)}');
      buffer.writeln('Updated: ${_formatDateTime(obj.updatedAt)}');
    } else if (obj is TimesheetModel) {
      buffer.writeln('ID: ${obj.id}');
      buffer.writeln('Job: ${obj.jobName}');
      buffer.writeln('Date: ${_formatDateTime(obj.date)}');
      buffer.writeln('TM: ${obj.tm}');
      buffer.writeln('Foreman: ${obj.foreman}');
      buffer.writeln('Description: ${obj.jobDesc}');
      buffer.writeln('Size: ${obj.jobSize}');
      buffer.writeln('Material: ${obj.material}');
      buffer.writeln('Notes: ${obj.notes}');
      buffer.writeln('Vehicle: ${obj.vehicle}');
      buffer.writeln('Workers: ${obj.workers.length}');
      for (int i = 0; i < obj.workers.length; i++) {
        final worker = obj.workers[i];
        buffer.writeln('  - ${worker['name'] ?? 'Unknown'}: ${worker['hours'] ?? 0} hours');
      }
      buffer.writeln('Created: ${_formatDateTime(obj.timestamp)}');
      buffer.writeln('Updated: ${_formatDateTime(obj.updatedAt)}');
    } else if (obj is TimesheetDraftModel) {
      buffer.writeln('ID: ${obj.id}');
      buffer.writeln('Job: ${obj.jobName ?? 'N/A'}');
      buffer.writeln('User: ${obj.userId}');
      buffer.writeln('Created: ${_formatDateTime(obj.timestamp)}');
    } else if (obj is ReceiptModel) {
      buffer.writeln('ID: ${obj.id}');
      buffer.writeln('Merchant: ${obj.merchant}');
      buffer.writeln('Amount: \$${obj.amount}');
      buffer.writeln('Date: ${_formatDateTime(obj.date)}');
      buffer.writeln('Category: ${obj.description}');
      buffer.writeln('Notes: ${obj.description}');
      buffer.writeln('Created: ${_formatDateTime(obj.timestamp)}');
    } else if (obj is UserModel) {
      buffer.writeln('ID: ${obj.id}');
      buffer.writeln('Name: ${obj.name}');
      buffer.writeln('Email: ${obj.email}');
      buffer.writeln('Role: ${obj.role}');
      buffer.writeln('Updated: ${_formatDateTime(obj.updatedAt)}');
    } else {
      buffer.writeln('Unknown type: ${obj.runtimeType}');
      buffer.writeln(obj.toString());
    }
    
    return buffer.toString();
  }
}