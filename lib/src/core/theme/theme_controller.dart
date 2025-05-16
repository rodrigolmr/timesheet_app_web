import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timesheet_app_web/src/features/user/presentation/providers/user_providers.dart';
import 'app_theme_data.dart';
import 'theme_variant.dart';

part 'theme_controller.g.dart';

/// Provider para compartilhar as preferências em toda a aplicação
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  throw UnimplementedError('Inicialize este provider em main.dart');
}

/// Chave usada para salvar e recuperar a preferência de tema do usuário localmente
const _themePreferenceKey = 'selected_theme_variant';

/// Controller para gerenciar o tema atual da aplicação
@Riverpod(keepAlive: true)
class ThemeController extends _$ThemeController {
  /// Constrói o estado inicial do tema
  @override
  AppThemeData build() {
    _setupThemeListener();
    
    // Inicialmente retorna o tema light como padrão
    // O tema correto será definido quando o listener reagir às mudanças
    return AppThemeData.light();
  }

  /// Configura os listeners para mudanças de tema baseadas no usuário
  void _setupThemeListener() {
    // Observe o tema preferido do usuário atual
    ref.listen(userPreferredThemeProvider, (previous, next) {
      next.whenData((themeVariant) {
        if (themeVariant != null) {
          // Se o usuário tem uma preferência de tema definida no Firestore, use-a
          state = AppThemeData.fromVariant(themeVariant);
        } else {
          // Se não, tente carregar do armazenamento local
          _loadLocalTheme();
        }
      });
    });
  }

  /// Carrega o tema salvo localmente
  Future<void> _loadLocalTheme() async {
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      final savedTheme = prefs.getString(_themePreferenceKey);
      
      if (savedTheme != null) {
        final variant = _stringToThemeVariant(savedTheme);
        state = AppThemeData.fromVariant(variant);
      }
      // Removemos a detecção do tema do sistema para evitar o "piscar" entre telas
      // Sempre mantemos o tema light como padrão quando não há preferência explícita
    } catch (e) {
      // Se houver erro ao acessar SharedPreferences, mantém o tema atual
      print('Erro ao carregar tema local: $e');
    }
  }

  /// Altera o tema atual para a variante especificada
  void setTheme(ThemeVariant variant) async {
    // Verifica se o usuário tem permissão para alterar o tema
    final canChange = await ref.read(canUserChangeThemeProvider.future);
    
    if (!canChange) {
      print('Usuário não tem permissão para alterar o tema');
      return;
    }
    
    // Altera o tema localmente
    state = AppThemeData.fromVariant(variant);
    
    // Salva a preferência local
    _saveLocalThemePreference(variant);
    
    // Salva a preferência no Firestore (se o usuário estiver logado)
    _saveUserThemePreference(variant);
  }

  /// Alterna entre temas claros e escuros
  void toggleLightDark() async {
    final canChange = await ref.read(canUserChangeThemeProvider.future);
    
    if (!canChange) {
      print('Usuário não tem permissão para alterar o tema');
      return;
    }
    
    final newVariant = state.brightness == Brightness.light 
        ? ThemeVariant.dark 
        : ThemeVariant.light;
        
    setTheme(newVariant);
  }

  /// Salva a preferência de tema do usuário localmente
  Future<void> _saveLocalThemePreference(ThemeVariant variant) async {
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      await prefs.setString(_themePreferenceKey, variant.toString().split('.').last);
    } catch (e) {
      print('Erro ao salvar preferência de tema local: $e');
    }
  }
  
  /// Salva a preferência de tema do usuário no Firestore
  Future<void> _saveUserThemePreference(ThemeVariant variant) async {
    try {
      // Converte o enum para string
      final themeString = variant.toString().split('.').last;
      
      // Tenta atualizar no Firestore se o usuário estiver logado
      ref.read(updateCurrentUserThemeProvider(themeString).future).then(
        (_) => print('Tema atualizado no Firestore com sucesso'),
        onError: (e) => print('Erro ao atualizar tema no Firestore: $e'),
      );
    } catch (e) {
      print('Erro ao salvar preferência de tema no Firestore: $e');
    }
  }
  
  /// Converte uma string para uma variante de tema
  ThemeVariant _stringToThemeVariant(String value) {
    return ThemeVariant.values.firstWhere(
      (variant) => variant.toString().split('.').last == value,
      orElse: () => ThemeVariant.light, // Fallback para light se não encontrar
    );
  }
}