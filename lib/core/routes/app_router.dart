import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../pages/home_page.dart';
import '../../pages/login_page.dart';
import 'app_routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  redirect: (context, state) {
    // Verificar se o usuário está autenticado com tratamento de exceções
    bool isLoggedIn = false;
    
    try {
      isLoggedIn = FirebaseAuth.instance.currentUser != null;
      debugPrint('Estado de autenticação: ${isLoggedIn ? 'Logado' : 'Não logado'}');
    } catch (e) {
      debugPrint('Erro ao verificar autenticação: $e');
      // Em caso de erro, consideramos o usuário como não autenticado
    }
    
    final isLoggingIn = state.matchedLocation == '/login';

    // Se não estiver logado e não estiver na tela de login, redireciona para login
    if (!isLoggedIn && !isLoggingIn) {
      debugPrint('Redirecionando para login');
      return '/login';
    }

    // Se estiver logado e estiver na tela de login, redireciona para home
    if (isLoggedIn && isLoggingIn) {
      debugPrint('Redirecionando para home');
      return '/';
    }

    // Caso contrário, não redireciona
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/workers',
      name: 'workers',
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Workers')),
        body: const Center(child: Text('Workers page - Em construção')),
      ),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Erro')),
    body: Center(
      child: Text('Página não encontrada: ${state.matchedLocation}'),
    ),
  ),
);