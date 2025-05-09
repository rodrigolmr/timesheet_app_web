import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../pages/home_page.dart';
import '../../pages/login_page.dart';
import '../../pages/debug_page.dart';
import '../../pages/timesheet_list_page.dart';
import '../../pages/test_page.dart'; // <-- Import da página de teste
import 'app_routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  redirect: (context, state) {
    bool isLoggedIn = false;

    // Não requer autenticação para a página de teste
    if (state.matchedLocation == '/test') {
      return null;
    }

    try {
      isLoggedIn = FirebaseAuth.instance.currentUser != null;
      debugPrint(
        'Estado de autenticação: ${isLoggedIn ? 'Logado' : 'Não logado'}',
      );
    } catch (e) {
      debugPrint('Erro ao verificar autenticação: $e');
    }

    final isLoggingIn = state.matchedLocation == '/login';

    if (!isLoggedIn && !isLoggingIn) {
      debugPrint('Redirecionando para login');
      return '/login';
    }

    if (isLoggedIn && isLoggingIn) {
      debugPrint('Redirecionando para home');
      return '/';
    }

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
      path: '/debug',
      name: 'debug',
      builder: (context, state) => const DebugPage(),
    ),
    GoRoute(
      path: '/timesheets',
      name: 'timesheets',
      builder: (context, state) => const TimesheetListPage(),
    ),
    GoRoute(
      path: '/test',
      name: 'test',
      builder: (context, state) => const TestPage(),
    ),
  ],
  errorBuilder:
      (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Erro')),
        body: Center(
          child: Text('Página não encontrada: ${state.matchedLocation}'),
        ),
      ),
);
