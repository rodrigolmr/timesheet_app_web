import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

enum NetworkStatus {
  online,
  offline,
}

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<NetworkStatus> _networkStatusController = 
      StreamController<NetworkStatus>.broadcast();

  Stream<NetworkStatus> get networkStatusStream => _networkStatusController.stream;
  
  ConnectivityService() {
    // Verificar status inicial
    _init();

    // Ouvir mudanças de conectividade
    _connectivity.onConnectivityChanged.listen((results) {
      // A nova versão retorna uma lista de resultados
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      _networkStatusController.add(_getNetworkStatus(result));
    });
  }

  Future<void> _init() async {
    List<ConnectivityResult> results;
    try {
      results = await _connectivity.checkConnectivity();
    } catch (e) {
      // Em caso de erro, assumir offline
      results = [ConnectivityResult.none];
    }

    final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
    _networkStatusController.add(_getNetworkStatus(result));
  }

  NetworkStatus _getNetworkStatus(ConnectivityResult result) {
    return result == ConnectivityResult.none 
        ? NetworkStatus.offline 
        : NetworkStatus.online;
  }

  Future<bool> isOnline() async {
    final results = await _connectivity.checkConnectivity();
    if (results.isEmpty) {
      return false;
    }
    final result = results.first;
    return result != ConnectivityResult.none;
  }

  void dispose() {
    _networkStatusController.close();
  }
}