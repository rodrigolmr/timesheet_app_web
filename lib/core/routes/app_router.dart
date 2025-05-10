import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../pages/home_page.dart';
import '../../pages/login_page.dart';
import '../../pages/debug_page.dart';
import '../../pages/test_page.dart'; // <-- Import da página de teste
import '../../pages/layout_test_page.dart'; // <-- Import da página de teste de layout
import '../../pages/button_showcase_page.dart'; // <-- Import da página de showcase de botões
import '../../pages/feedback_showcase_page.dart'; // <-- Import da página de showcase de feedback
import '../../pages/timesheet_list_page.dart'; // <-- Import da página de lista de timesheets
import '../../pages/sync_page.dart'; // <-- Import da página de sincronização
import '../../services/sync_manager.dart'; // <-- Import para acesso ao SyncStatus
// Import da página de showcase de variantes removido
import '../../providers.dart';
import 'app_routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final syncStatus = ref.watch(syncStatusProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // Verificar se está autenticado
      final isLoggedIn = authState;

      // Não redirecionar para páginas de teste e desenvolvimento
      if (state.matchedLocation == '/test' ||
          state.matchedLocation == '/layout-test' ||
          state.matchedLocation == '/button-showcase' ||
          state.matchedLocation == '/feedback-showcase' ||
          state.matchedLocation == '/sync') {
        return null;
      }

      // Verificar se está tentando acessar a página de login
      final isLoggingIn = state.matchedLocation == '/login';

      // Se não está logado e não está indo para a página de login, redirecionar para a página de login
      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      // Se está logado e tentando acessar a página de login, redirecionar para a página inicial
      if (isLoggedIn && isLoggingIn) {
        return '/';
      }

      // A sincronização acontecerá em segundo plano sem redirecionar o usuário
      // Não redirecionamos para a página de sincronização
      // permitindo que a navegação normal aconteça

      // Caso contrário, não fazer redirecionamento
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
        path: '/test',
        name: 'test',
        builder: (context, state) => const TestPage(),
      ),
      GoRoute(
        path: '/layout-test',
        name: 'layout-test',
        builder: (context, state) => const LayoutTestPage(),
      ),
      GoRoute(
        path: '/button-showcase',
        name: 'button-showcase',
        builder: (context, state) => const ButtonShowcasePage(),
      ),
      GoRoute(
        path: '/feedback-showcase',
        name: 'feedback-showcase',
        builder: (context, state) => const FeedbackShowcasePage(),
      ),
      GoRoute(
        path: '/timesheets',
        name: AppRoutes.timesheetsName,
        builder: (context, state) => const TimesheetListPage(),
      ),
      GoRoute(
        path: '/timesheets/view/:id',
        name: AppRoutes.timesheetViewName,
        builder: (context, state) {
          // final id = state.pathParameters['id'] ?? '';
          return const Scaffold(
            body: Center(child: Text('Timesheet View - Implementação pendente')),
          );
        },
      ),
      GoRoute(
        path: '/timesheets/new',
        name: AppRoutes.timesheetNewName,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('New Timesheet - Implementação pendente')),
        ),
      ),
      GoRoute(
        path: '/timesheets/edit/:id',
        name: AppRoutes.timesheetEditName,
        builder: (context, state) {
          // final id = state.pathParameters['id'] ?? '';
          return const Scaffold(
            body: Center(child: Text('Edit Timesheet - Implementação pendente')),
          );
        },
      ),
      // Rota de showcase de variantes removida
    ],
    errorBuilder:
        (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Erro')),
          body: Center(
            child: Text('Página não encontrada: ${state.matchedLocation}'),
          ),
        ),
  );
});

// Para compatibilidade com o código existente
final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
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
      path: '/test',
      name: 'test',
      builder: (context, state) => const TestPage(),
    ),
    GoRoute(
      path: '/layout-test',
      name: 'layout-test',
      builder: (context, state) => const LayoutTestPage(),
    ),
    GoRoute(
      path: '/button-showcase',
      name: 'button-showcase',
      builder: (context, state) => const ButtonShowcasePage(),
    ),
    GoRoute(
      path: '/feedback-showcase',
      name: 'feedback-showcase',
      builder: (context, state) => const FeedbackShowcasePage(),
    ),
    GoRoute(
      path: '/timesheets',
      name: AppRoutes.timesheetsName,
      builder: (context, state) => const TimesheetListPage(),
    ),
    GoRoute(
      path: '/timesheets/view/:id',
      name: AppRoutes.timesheetViewName,
      builder: (context, state) {
        // final id = state.pathParameters['id'] ?? '';
        return const Scaffold(
          body: Center(child: Text('Timesheet View - Implementação pendente')),
        );
      },
    ),
    GoRoute(
      path: '/timesheets/new',
      name: AppRoutes.timesheetNewName,
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('New Timesheet - Implementação pendente')),
      ),
    ),
    GoRoute(
      path: '/timesheets/edit/:id',
      name: AppRoutes.timesheetEditName,
      builder: (context, state) {
        // final id = state.pathParameters['id'] ?? '';
        return const Scaffold(
          body: Center(child: Text('Edit Timesheet - Implementação pendente')),
        );
      },
    ),
  ],
);
