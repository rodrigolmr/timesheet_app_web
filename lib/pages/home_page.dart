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
  
  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
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
      body: _isSyncing
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Welcome Section
                      Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.green, size: 48),
                              const SizedBox(height: 16),
                              Text(
                                'Bem-vindo ao Timesheet App!',
                                style: Theme.of(context).textTheme.titleLarge,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Sincronização concluída com sucesso',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Menu Options
                      const Text(
                        'O que você gostaria de fazer?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Timesheets Card
                      _buildMenuCard(
                        context,
                        title: 'Visualizar Timesheets',
                        icon: Icons.assignment,
                        color: Colors.blue,
                        onTap: () => context.go('/timesheets'),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Other Menu Options (to be implemented later)
                      _buildMenuCard(
                        context,
                        title: 'Gerenciar Trabalhadores',
                        icon: Icons.people,
                        color: Colors.orange,
                        onTap: () {
                          // Implementar navegação futura
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Funcionalidade em desenvolvimento'))
                          );
                        },
                      ),
                      
                      const SizedBox(height: 12),
                      
                      _buildMenuCard(
                        context,
                        title: 'Gerenciar Cartões',
                        icon: Icons.credit_card,
                        color: Colors.purple,
                        onTap: () {
                          // Implementar navegação futura
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Funcionalidade em desenvolvimento'))
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}
