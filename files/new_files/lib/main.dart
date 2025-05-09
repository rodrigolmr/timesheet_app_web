import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart'; // Importação para kIsWeb

import 'firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/settings_page.dart';
import 'pages/timesheet_page.dart';
import 'pages/timesheet_header_page.dart';
import 'pages/timesheet_workers_page.dart';
import 'pages/timesheet_review_page.dart';
import 'pages/timesheet_view_page.dart';
import 'pages/workers_page.dart';
import 'pages/users_page.dart';
import 'pages/cards_page.dart'; // Importação da Cards Page
import 'pages/test_page.dart'; // Importação da Test Page
import 'pages/receipt_page.dart'; // Importação da Receipt Page

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configuração para evitar problemas com Google Fonts
  GoogleFonts.config.allowRuntimeFetching = true;

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(const ProviderScope(child: TimesheetWebApp()));
}

class TimesheetWebApp extends StatelessWidget {
  const TimesheetWebApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF0205D3);

    // Configuração do tema com fallback para fontes do sistema
    final textTheme = Theme.of(context).textTheme;
    final appTextTheme = kIsWeb 
        ? textTheme // No ambiente web, usar fonte padrão do sistema se houver problema
        : GoogleFonts.robotoTextTheme(textTheme);

    return MaterialApp(
      title: 'Timesheet Web',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryBlue,
        colorScheme: const ColorScheme.light(primary: primaryBlue),
        textTheme: appTextTheme,
        fontFamily: kIsWeb ? null : GoogleFonts.roboto().fontFamily,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/home': (_) => const HomePage(),
        '/settings': (_) => const SettingsPage(),
        '/timesheets': (_) => const TimesheetPage(),
        '/new-timesheet': (_) => const TimesheetHeaderPage(),
        '/timesheet-workers': (_) => const TimesheetWorkersPage(),
        '/timesheet-review': (_) => const TimesheetReviewPage(),
        '/timesheet-view': (_) => const TimesheetViewPage(),
        '/workers': (_) => const WorkersPage(),
        '/users': (_) => const UsersPage(),
        '/cards': (_) => const CardsPage(), // Nova rota para Cards Page
        '/test': (_) => const TestPage(), // Nova rota para Test Page
      },
    );
  }
}
