// lib/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/routes/app_routes.dart';
import '../core/theme/app_theme.dart';
import '../core/responsive/responsive.dart';
import '../providers.dart';
import '../core/network/firestore_fetch.dart';
import '../widgets/base_layout.dart';
import '../widgets/logo_text.dart';
import '../widgets/app_button.dart';
import '../widgets/loading_button.dart';
import '../widgets/toast_message.dart';
import '../widgets/feedback_overlay.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String _fullName = '';
  bool _isLoading = true;
  bool _isSyncing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Não realizar sincronização durante o carregamento inicial
      // await _syncData();

      // Obter o usuário atual logado
      final auth = ref.read(authServiceProvider);
      final currentUserId = auth.currentUser?.uid;
      print("ID do usuário atual: $currentUserId");

      if (currentUserId != null) {
        final userRepository = ref.read(userRepositoryProvider);

        // Verificar todos os usuários no repositório
        final allUsers = userRepository.getLocalUsers();
        print("Total de usuários no repositório: ${allUsers.length}");
        for (var user in allUsers) {
          print("Usuário cadastrado: ${user.id} - ${user.firstName} ${user.lastName} - ${user.email}");
        }

        final currentUser = await userRepository.getUser(currentUserId);

        if (currentUser != null) {
          print("Usuário encontrado: ${currentUser.firstName} ${currentUser.lastName}");
          setState(() {
            _fullName = '${currentUser.firstName} ${currentUser.lastName}'.trim();
            if (_fullName.isEmpty) {
              _fullName = currentUser.email.split('@').first;
            }
          });
          print("Nome completo definido: $_fullName");
        } else {
          print("Usuário não encontrado no repositório: $currentUserId");

          // Tentar encontrar manualmente na lista
          final matchingUsers = allUsers.where((u) => u.id == currentUserId).toList();
          if (matchingUsers.isNotEmpty) {
            final user = matchingUsers.first;
            print("Usuário encontrado manualmente: ${user.firstName} ${user.lastName}");
            setState(() {
              _fullName = '${user.firstName} ${user.lastName}'.trim();
              if (_fullName.isEmpty) {
                _fullName = user.email.split('@').first;
              }
            });
          }
        }
      } else {
        print("Nenhum usuário autenticado encontrado");
      }
    } catch (e) {
      setState(() {
        _error = 'Error loading data: $e';
      });
      print("Erro ao carregar dados do usuário: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> _syncData() async {
    if (!mounted) return false;

    setState(() {
      _isSyncing = true;
      _error = null;
    });

    try {
      // Utilizaremos o SyncManager para gerenciar a sincronização silenciosa
      final syncManager = ref.read(syncManagerProvider);
      // Não passamos o contexto para evitar feedback visual
      final success = await syncManager.forceSyncAll();

      // Não mostramos mensagens de sincronização bem-sucedida
      return success;
    } catch (e) {
      // Apenas registramos o erro no console, sem mostrar ao usuário
      print('Erro ao atualizar dados: ${e.toString()}');
      return false;
    } finally {
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Inicializar responsividade
    final responsive = ResponsiveSizing(context);

    return BaseLayout(
      title: 'Central Island Floors',
      showTitleBox: false, // Desabilita TitleBox conforme referência
      verticalAlignment: LayoutAlignment.center, // Alinhamento centralizado para home page
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : ResponsiveContainer(
                  mobileMaxWidth: double.infinity,
                  tabletMaxWidth: 800,
                  desktopMaxWidth: 1000,
                  padding: responsive.screenPadding,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: responsive.responsiveValue(
                          mobile: AppTheme.defaultSpacing, // 16px para telas pequenas (320px)
                          tablet: AppTheme.largeSpacing, // 24px para tablets
                          desktop: AppTheme.extraLargeSpacing, // 32px para desktop
                        )),
                        const LogoText(),
                        SizedBox(height: responsive.responsiveValue(
                          mobile: AppTheme.defaultSpacing, // 16px para telas pequenas (320px)
                          tablet: AppTheme.mediumSpacing, // 20px para tablets
                          desktop: AppTheme.largeSpacing, // 24px para desktop
                        )),
                        if (_fullName.isNotEmpty)
                          Text(
                            'Welcome, $_fullName',
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                        SizedBox(height: responsive.responsiveValue(
                          mobile: AppTheme.largeSpacing + AppTheme.defaultSpacing, // 40px para telas pequenas
                          tablet: AppTheme.extraLargeSpacing + AppTheme.mediumSmallSpacing, // 44px para tablets
                          desktop: AppTheme.extraLargeSpacing + AppTheme.mediumSpacing, // 52px para desktop
                        )),
                        Wrap(
                          spacing: responsive.spacing,
                          runSpacing: responsive.responsiveValue(
                            mobile: AppTheme.defaultSpacing, // 16px para telas pequenas (320px)
                            tablet: AppTheme.mediumSpacing, // 20px para tablets
                            desktop: AppTheme.largeSpacing, // 24px para desktop
                          ),
                          alignment: WrapAlignment.center,
                          children: [
                            AppButton(
                              config: ButtonType.sheetsButton.config,
                              onPressed: () => context.goNamed(AppRoutes.timesheetsName),
                            ),
                            AppButton(
                              config: ButtonType.settingsButton.config,
                              onPressed: () => context.go('/settings'),
                            ),
                          ],
                        ),
                        SizedBox(height: responsive.responsiveValue(
                          mobile: AppTheme.largeSpacing + AppTheme.defaultSpacing, // 40px para telas pequenas
                          tablet: AppTheme.extraLargeSpacing + AppTheme.mediumSmallSpacing, // 44px para tablets
                          desktop: AppTheme.extraLargeSpacing + AppTheme.mediumSpacing, // 52px para desktop
                        )),
                      ],
                    ),
                  ),
                ),
    );
  }
}