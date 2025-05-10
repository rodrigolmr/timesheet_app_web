import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';
import '../services/sync_manager.dart';
import '../services/connectivity_service.dart';
import '../providers.dart';
import '../widgets/logo_text.dart';

class SyncPage extends ConsumerStatefulWidget {
  final String nextRoute;

  const SyncPage({
    Key? key,
    required this.nextRoute,
  }) : super(key: key);

  @override
  ConsumerState<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends ConsumerState<SyncPage> {
  bool _isManualSync = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _performInitialSync();
  }

  Future<void> _performInitialSync() async {
    final syncManager = ref.read(syncManagerProvider);
    
    try {
      final success = await syncManager.performInitialSync(context: context);
      
      if (success && mounted) {
        // Navegar para a próxima rota
        context.go(widget.nextRoute);
      } else if (mounted) {
        // Se falhou, permitir tentativa manual
        setState(() {
          _errorMessage = 'Erro na sincronização. Tente novamente.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Erro: ${e.toString()}';
        });
      }
    }
  }

  Future<void> _manualSync() async {
    setState(() {
      _isManualSync = true;
      _errorMessage = null;
    });

    try {
      final syncManager = ref.read(syncManagerProvider);
      final success = await syncManager.forceSyncAll(context: context);
      
      if (success && mounted) {
        // Navegar para a próxima rota
        context.go(widget.nextRoute);
      } else if (mounted) {
        setState(() {
          _errorMessage = 'Erro na sincronização. Tente novamente ou continue offline.';
          _isManualSync = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Erro: ${e.toString()}';
          _isManualSync = false;
        });
      }
    }
  }

  void _skipSync() {
    // Definir o status como completo mesmo sem sincronizar
    ref.read(syncStatusProvider.notifier).state = SyncStatus.completed;
    
    // Navegar para a próxima rota
    context.go(widget.nextRoute);
  }

  @override
  Widget build(BuildContext context) {
    final syncStatus = ref.watch(syncStatusProvider);
    final networkStatusAsyncValue = ref.watch(networkStatusProvider);

    // Verificar conectividade
    final isOnline = networkStatusAsyncValue.when(
      data: (status) => status == NetworkStatus.online,
      loading: () => true, // Assumir online durante o carregamento
      error: (_, __) => false, // Assumir offline em caso de erro
    );

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LogoText(),
              const SizedBox(height: 32),
              Text(
                'Sincronizando Dados',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Indicador de status de rede
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: BoxDecoration(
                  color: isOnline ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isOnline ? Icons.wifi : Icons.wifi_off,
                      size: 16,
                      color: isOnline ? Colors.green.shade800 : Colors.red.shade800,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isOnline ? 'Online' : 'Offline',
                      style: TextStyle(
                        color: isOnline ? Colors.green.shade800 : Colors.red.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (syncStatus == SyncStatus.syncing || _isManualSync)
                const Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Baixando dados...',
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ElevatedButton(
                      onPressed: isOnline ? _manualSync : null, // Desativar se offline
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        disabledBackgroundColor: Colors.grey.shade300,
                      ),
                      child: const Text('Sincronizar Agora'),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _skipSync,
                      child: Text(
                        isOnline ? 'Continuar Sem Sincronizar' : 'Continuar Offline',
                        style: TextStyle(
                          color: isOnline ? Colors.blue : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}