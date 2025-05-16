import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timesheet_app_web/src/core/config/firebase_options.dart';
import 'package:timesheet_app_web/src/core/theme/theme.dart';
import 'package:timesheet_app_web/src/core/navigation/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Inicializa o SharedPreferences para persistência de tema
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    // Envolve o aplicativo com o ProviderScope para habilitar o Riverpod
    ProviderScope(
      overrides: [
        // Disponibiliza o SharedPreferences para os providers que precisam dele
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observa o tema atual
    final themeData = ref.watch(themeControllerProvider).toThemeData();
    
    // Obtém o GoRouter
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Timesheet App',
      debugShowCheckedModeBanner: false,
      theme: themeData,
      routerConfig: goRouter,
    );
  }
}