// lib/pages/settings_page.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';
import '../core/responsive/responsive.dart';
import '../widgets/base_layout.dart';
import '../widgets/app_button.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  String _fullName = "";
  String _email = "";
  String _role = "User";
  bool _isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _isLoadingUser = false);
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        final firstName = data["firstName"] as String? ?? "";
        final lastName = data["lastName"] as String? ?? "";
        final fullName = (firstName + " " + lastName).trim();
        final email = data["email"] as String? ?? user.email ?? "";
        final role = data["role"] as String? ?? "User";

        setState(() {
          _fullName = fullName.isNotEmpty ? fullName : "Unknown user";
          _email = email;
          _role = role;
          _isLoadingUser = false;
        });
      } else {
        setState(() {
          _fullName = user.email ?? "Unknown";
          _email = user.email ?? "";
          _role = "User";
          _isLoadingUser = false;
        });
      }
    } catch (_) {
      setState(() {
        _fullName = "Error loading user";
        _email = "";
        _role = "";
        _isLoadingUser = false;
      });
    }
  }

  Widget _buildProfileInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundYellow,
        border: Border.all(color: AppTheme.primaryBlue, width: AppTheme.mediumBorder),
        borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _fullName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _email,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          Text(
            _role,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Inicializar responsividade
    final responsive = ResponsiveSizing(context);

    return BaseLayout(
      title: 'Settings',
      showTitleBox: true,
      child: ResponsiveContainer(
        mobileMaxWidth: double.infinity,
        tabletMaxWidth: 800,
        desktopMaxWidth: 1000,
        center: false, // Desativar centralização para manter alinhamento top
        padding: responsive.screenPadding,
        // Aplicar espaçamento automático entre elementos
        childSpacing: responsive.responsiveValue(
          mobile: AppTheme.defaultSpacing, // 16px para telas pequenas (320px)
          tablet: AppTheme.mediumSpacing, // 20px para tablets
          desktop: AppTheme.largeSpacing, // 24px para desktop
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start, // Alinhamento principal no topo
            mainAxisSize: MainAxisSize.min, // Minimizar o tamanho vertical
            children: [
              // Sem espaçamento manual - o childSpacing e o padding do BaseLayout cuidarão disso

              if (_isLoadingUser)
                const Center(child: CircularProgressIndicator())
              else
                _buildProfileInfo(),

              // Only show the admin buttons if the user is an admin
              if (_role.toLowerCase() == "admin")
                Wrap(
                  spacing: responsive.spacing,
                  runSpacing: responsive.responsiveValue(
                    mobile: 16.0,
                    tablet: 20.0,
                    desktop: 24.0,
                  ),
                  alignment: WrapAlignment.center,
                  children: [
                    AppButton(
                      config: ButtonType.usersButton.config,
                      onPressed: () => context.go('/users'),
                    ),
                    AppButton(
                      config: ButtonType.workersButton.config,
                      onPressed: () => context.go('/workers'),
                    ),
                    AppButton(
                      config: ButtonType.cardsButton.config,
                      onPressed: () => context.go('/cards'),
                    ),
                  ],
                ),
              // Não é mais necessário SizedBox aqui, o childSpacing cuidará disso
            ],
          ),
        ),
      ),
    );
  }
}