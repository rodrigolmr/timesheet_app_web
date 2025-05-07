import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../core/routes/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home - ${user?.email ?? ''}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // O GoRouter redirecionará automaticamente para a tela de login
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bem-vindo ao Timesheet App!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Usando GoRouter para navegação
                context.go(AppRoutes.workers);
                
                // Alternativa: navegação por nome
                // context.goNamed(AppRoutes.workersName);
              },
              child: const Text('Ir para Workers Page'),
            ),
          ],
        ),
      ),
    );
  }
}
