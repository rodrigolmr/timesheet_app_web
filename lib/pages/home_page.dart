import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../providers.dart';
import '../core/network/firestore_fetch.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _isSyncing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _syncData();
  }

  Future<void> _syncData() async {
    setState(() {
      _isSyncing = true;
      _error = null;
    });

    try {
      final syncService = ref.read(syncServiceProvider);
      await syncService.syncAll(
        remoteCards: await fetchCardsFromFirestore(),
        remoteReceipts: await fetchReceiptsFromFirestore(),
        remoteDrafts: await fetchDraftsFromFirestore(),
        remoteTimesheets: await fetchTimesheetsFromFirestore(),
        remoteUsers: await fetchUsersFromFirestore(),
        remoteWorkers: await fetchWorkersFromFirestore(),
      );
      print('✅ Sincronização concluída');
    } catch (e) {
      setState(() {
        _error = 'Erro na sincronização: $e';
      });
      print('❌ Erro na sincronização: $e');
    } finally {
      setState(() {
        _isSyncing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home - ${user?.email ?? ''}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.build), // 🔧 botão para debug
            onPressed: () {
              context.go('/debug');
            },
            tooltip: 'Abrir Debug Page',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Center(
        child:
            _isSyncing
                ? const CircularProgressIndicator()
                : _error != null
                ? Text(_error!, style: const TextStyle(color: Colors.red))
                : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Bem-vindo ao Timesheet App!'),
                    SizedBox(height: 20),
                    Icon(Icons.check_circle, color: Colors.green, size: 48),
                    SizedBox(height: 10),
                    Text('Sincronização concluída com sucesso'),
                  ],
                ),
      ),
    );
  }
}
