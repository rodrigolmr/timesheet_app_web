import 'package:flutter/material.dart';
import 'theme_variant.dart';

/// Classe que define todas as cores usadas no aplicativo.
///
/// Esta classe oferece variantes de tema (light, dark, feminine) que podem
/// ser facilmente trocadas pelo usuário. Todas as referências a cores no aplicativo
/// devem usar esta classe, garantindo consistência visual.
class AppColors {
  /// Cor primária principal do tema
  final Color primary;
  
  /// Cor para texto/ícones sobre a cor primária
  final Color onPrimary;
  
  /// Cor secundária para ações/botões secundários
  final Color secondary;
  
  /// Cor para texto/ícones sobre a cor secundária
  final Color onSecondary;
  
  /// Cor de fundo principal do aplicativo
  final Color background;
  
  /// Cor de superfície (cards, inputs, etc)
  final Color surface;
  
  /// Cor de superfície com destaque (usado para inputs)
  final Color surfaceAccent;
  
  /// Cor principal para texto
  final Color textPrimary;
  
  /// Cor secundária para texto menos importante
  final Color textSecondary;
  
  /// Cor para indicar sucesso
  final Color success;
  
  /// Cor para texto/ícones sobre cor de sucesso
  final Color onSuccess;
  
  /// Cor para indicar erro
  final Color error;
  
  /// Cor para texto/ícones sobre cor de erro
  final Color onError;
  
  /// Cor para indicar alerta
  final Color warning;
  
  /// Cor para texto/ícones sobre cor de alerta
  final Color onWarning;
  
  /// Cor para informações
  final Color info;
  
  /// Cor para texto/ícones sobre cor de informação
  final Color onInfo;
  
  /// Mapa contendo cores específicas para cada categoria do aplicativo
  final Map<CategoryType, Color> categoryColors;
  
  /// Brightness do tema (light ou dark)
  final Brightness brightness;

  /// Construtor principal da classe AppColors
  const AppColors({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.background,
    required this.surface,
    required this.surfaceAccent,
    required this.textPrimary,
    required this.textSecondary,
    required this.success,
    required this.onSuccess,
    required this.error,
    required this.onError,
    required this.warning,
    required this.onWarning,
    required this.info,
    required this.onInfo,
    required this.categoryColors,
    required this.brightness,
  });
  
  // Material compatibility properties
  Color get onSurface => textPrimary;
  Color get onSurfaceVariant => textSecondary;
  Color get surfaceVariant => surfaceAccent;
  Color get outline => textSecondary.withOpacity(0.5);

  /// Cria o tema light padrão com a identidade visual do aplicativo
  /// Usando a paleta Azul Corporativo (Palette4CorporateAmber)
  factory AppColors.light() {
    return AppColors(
      // Cores principais - Azul Corporativo da Palette4CorporateAmber
      primary: const Color(0xFF1565C0),      // Azul principal
      onPrimary: Colors.white,
      secondary: const Color(0xFF1E88E5),    // Azul mais claro (primaryLight)
      onSecondary: Colors.white,
      
      // Cores de fundo da Palette4CorporateAmber
      background: const Color(0xFFFAFAFA),     // Cinza muito claro
      surface: Colors.white,
      surfaceAccent: const Color(0xFFFFF8E1),  // Âmbar pálido (cardBackground)
      
      // Cores de texto da Palette4CorporateAmber
      textPrimary: const Color(0xFF212121),    // onBackground
      textSecondary: const Color(0xFF757575),  // onBackgroundMuted
      
      // Cores de status da Palette4CorporateAmber
      success: const Color(0xFF388E3C),        // Verde
      onSuccess: Colors.white,
      error: const Color(0xFFD32F2F),          // Vermelho
      onError: Colors.white,
      warning: const Color(0xFFFFA000),        // Âmbar médio
      onWarning: Colors.white,
      info: const Color(0xFF0277BD),           // Azul informativo
      onInfo: Colors.white,
      
      // Cores específicas por categoria usando a paleta completa
      categoryColors: {
        CategoryType.timesheet: const Color(0xFF0D47A1),  // primaryDark
        CategoryType.receipt: const Color(0xFFFFA000),    // warning
        CategoryType.settings: const Color(0xFF546E7A),   // Azul acinzentado
        CategoryType.add: const Color(0xFF388E3C),        // success
        CategoryType.cancel: const Color(0xFFD32F2F),     // error
        CategoryType.navigation: const Color(0xFF1565C0), // primary
        CategoryType.user: const Color(0xFF0288D1),       // info
        CategoryType.worker: const Color(0xFF5D4037),     // Marrom
        CategoryType.card: const Color(0xFF7B1FA2),       // Roxo
        CategoryType.pdf: const Color(0xFFC62828),        // Vermelho escuro
      },
      
      brightness: Brightness.light,
    );
  }

  /// Cria o tema dark com cores adaptadas para uso noturno
  /// Mantendo a identidade visual do azul corporativo em modo escuro
  factory AppColors.dark() {
    return AppColors(
      // Cores principais - Azul Corporativo (Versão escura)
      primary: const Color(0xFF0D47A1),         // Azul mais escuro para dark mode
      onPrimary: Colors.white,
      secondary: const Color(0xFF1976D2),       // Azul médio
      onSecondary: Colors.white,
      
      // Cores de fundo
      background: const Color(0xFF121212),      // Cinza escuro padrão material dark
      surface: const Color(0xFF212121),         // Cinza mais claro que o background
      surfaceAccent: const Color(0xFF2C2C1A),   // Âmbar escurecido
      
      // Cores de texto
      textPrimary: Colors.white,
      textSecondary: Colors.white70,
      
      // Cores de status
      success: const Color(0xFF2E7D32),         // Verde mais escuro
      onSuccess: Colors.white,
      error: const Color(0xFFC62828),           // Vermelho mais escuro
      onError: Colors.white,
      warning: const Color(0xFFFF8F00),         // Âmbar mais escuro
      onWarning: Colors.white,
      info: const Color(0xFF0277BD),            // Azul mais escuro
      onInfo: Colors.white,
      
      // Cores específicas por categoria (ajustadas para dark mode)
      categoryColors: {
        CategoryType.timesheet: const Color(0xFF1565C0),  // Azul principal
        CategoryType.receipt: const Color(0xFFFFB300),    // Âmbar
        CategoryType.settings: const Color(0xFF78909C),   // Azul acinzentado claro
        CategoryType.add: const Color(0xFF4CAF50),        // Verde
        CategoryType.cancel: const Color(0xFFEF5350),     // Vermelho
        CategoryType.navigation: const Color(0xFF42A5F5), // Azul claro
        CategoryType.user: const Color(0xFF29B6F6),       // Azul claro
        CategoryType.worker: const Color(0xFF8D6E63),     // Marrom claro
        CategoryType.card: const Color(0xFFAB47BC),       // Roxo claro
        CategoryType.pdf: const Color(0xFFEF5350),        // Vermelho
      },
      
      brightness: Brightness.dark,
    );
  }

  /// Cria o tema feminine com cores em tons de rosa
  /// Usando a paleta Rosa Suave (Palette5PinkSoft)
  factory AppColors.feminine() {
    return AppColors(
      // Cores principais - Rosa Suave da Palette5PinkSoft
      primary: const Color(0xFFE91E63),         // Rosa principal
      onPrimary: Colors.white,
      secondary: const Color(0xFFF06292),       // Rosa mais claro (primaryLight)
      onSecondary: Colors.white,
      
      // Cores de fundo da Palette5PinkSoft
      background: const Color(0xFFFCFAFF),      // Quase branco com tom rosado
      surface: Colors.white,
      surfaceAccent: const Color(0xFFFCE4EC),   // Rosa muito pálido (surfaceVariant)
      
      // Cores de texto da Palette5PinkSoft
      textPrimary: const Color(0xFF212121),     // onBackground
      textSecondary: const Color(0xFF757575),   // onBackgroundMuted
      
      // Cores de status da Palette5PinkSoft
      success: const Color(0xFF4CAF50),         // Verde médio
      onSuccess: Colors.white,
      error: const Color(0xFFF44336),           // Vermelho
      onError: Colors.white,
      warning: const Color(0xFFFF9800),         // Laranja
      onWarning: Colors.white,
      info: const Color(0xFF2196F3),            // Azul informativo
      onInfo: Colors.white,
      
      // Cores específicas por categoria usando a paleta completa
      categoryColors: {
        CategoryType.timesheet: const Color(0xFFC2185B),  // primaryDark
        CategoryType.receipt: const Color(0xFFFF9800),    // warning
        CategoryType.settings: const Color(0xFF9E9E9E),   // Cinza médio
        CategoryType.add: const Color(0xFF4CAF50),        // success
        CategoryType.cancel: const Color(0xFFF44336),     // error
        CategoryType.navigation: const Color(0xFFE91E63), // primary
        CategoryType.user: const Color(0xFF9C27B0),       // Roxo
        CategoryType.worker: const Color(0xFF795548),     // Marrom
        CategoryType.card: const Color(0xFFF06292),       // primaryLight
        CategoryType.pdf: const Color(0xFF880E4F),        // primaryDarker
      },
      
      brightness: Brightness.light,
    );
  }
  
  /// Cria o tema verde usando a paleta Verde Fresco (Palette6GreenFresh)
  factory AppColors.green() {
    return AppColors(
      // Cores principais - Verde Fresco da Palette6GreenFresh
      primary: const Color(0xFF00897B),         // Verde teal principal
      onPrimary: Colors.white,
      secondary: const Color(0xFF4DB6AC),       // Verde mais claro (primaryLight)
      onSecondary: Colors.white,
      
      // Cores de fundo da Palette6GreenFresh
      background: const Color(0xFFF5F9F6),      // Quase branco com tom verde
      surface: Colors.white,
      surfaceAccent: const Color(0xFFE0F2F1),   // Verde muito pálido (surfaceVariant)
      
      // Cores de texto da Palette6GreenFresh
      textPrimary: const Color(0xFF1B5E20),     // Verde escuro para texto (onBackground)
      textSecondary: const Color(0xFF558B2F),   // Verde médio para texto secundário (onBackgroundMuted)
      
      // Cores de status da Palette6GreenFresh
      success: const Color(0xFF4CAF50),         // Verde médio
      onSuccess: Colors.white,
      error: const Color(0xFFE53935),           // Vermelho
      onError: Colors.white,
      warning: const Color(0xFFFFB300),         // Âmbar
      onWarning: Colors.white,
      info: const Color(0xFF03A9F4),            // Azul claro
      onInfo: Colors.white,
      
      // Cores específicas por categoria usando a paleta completa
      categoryColors: {
        CategoryType.timesheet: const Color(0xFF00695C),  // primaryDark
        CategoryType.receipt: const Color(0xFFFFB300),    // warning
        CategoryType.settings: const Color(0xFF607D8B),   // Azul acinzentado
        CategoryType.add: const Color(0xFF388E3C),        // Verde escuro
        CategoryType.cancel: const Color(0xFFE53935),     // error
        CategoryType.navigation: const Color(0xFF00897B), // primary
        CategoryType.user: const Color(0xFF00ACC1),       // Ciano
        CategoryType.worker: const Color(0xFF795548),     // Marrom
        CategoryType.card: const Color(0xFFB2DFDB),       // primaryLighter
        CategoryType.pdf: const Color(0xFF004D40),        // primaryDarker
      },
      
      brightness: Brightness.light,
    );
  }

  /// Factory para criar a cor baseada na variante de tema
  factory AppColors.fromThemeVariant(ThemeVariant variant) {
    switch (variant) {
      case ThemeVariant.light:
        return AppColors.light();
      case ThemeVariant.dark:
        return AppColors.dark();
      case ThemeVariant.feminine:
        return AppColors.feminine();
      case ThemeVariant.green:
        return AppColors.green();
    }
  }
}

/// Enum que define as categorias de funcionalidades no aplicativo.
///
/// Cada categoria possui uma cor específica para manter consistência visual
/// entre os botões e ícones relacionados à mesma funcionalidade.
enum CategoryType {
  /// Categoria para timesheets/folhas de horas
  timesheet,
  
  /// Categoria para recibos/despesas
  receipt,
  
  /// Categoria para configurações
  settings,
  
  /// Categoria para ações de adicionar
  add,
  
  /// Categoria para ações de cancelar
  cancel,
  
  /// Categoria para navegação
  navigation,
  
  /// Categoria para usuários
  user,
  
  /// Categoria para trabalhadores
  worker,
  
  /// Categoria para cartões
  card,
  
  /// Categoria para PDF
  pdf,
}