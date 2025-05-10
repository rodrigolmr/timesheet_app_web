// lib/widgets/feedback_overlay.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timesheet_app_web/core/theme/app_theme.dart';

/// Define os diferentes tipos de feedback visual
enum FeedbackType {
  success,
  error,
  warning,
  info,
  loading,
}

/// Define a posição do feedback na tela
enum FeedbackPosition {
  top,
  center,
  bottom,
}

/// Configuração para o widget de feedback visual
class FeedbackConfig {
  final String message;
  final FeedbackType type;
  final Duration duration;
  final FeedbackPosition position;
  final IconData? icon;
  final VoidCallback? onClose;
  final bool isDismissible;

  const FeedbackConfig({
    required this.message,
    required this.type,
    this.duration = const Duration(seconds: 3),
    this.position = FeedbackPosition.bottom,
    this.icon,
    this.onClose,
    this.isDismissible = true,
  });

  /// Obtém a cor de fundo com base no tipo de feedback
  Color get backgroundColor {
    switch (type) {
      case FeedbackType.success:
        return AppTheme.primaryGreen;
      case FeedbackType.error:
        return AppTheme.primaryRed;
      case FeedbackType.warning:
        return AppTheme.primaryYellow;
      case FeedbackType.info:
        return AppTheme.primaryBlue;
      case FeedbackType.loading:
        return AppTheme.darkGrayColor;
    }
  }

  /// Obtém o ícone padrão com base no tipo de feedback
  IconData get defaultIcon {
    switch (type) {
      case FeedbackType.success:
        return FontAwesomeIcons.checkCircle;
      case FeedbackType.error:
        return FontAwesomeIcons.exclamationCircle;
      case FeedbackType.warning:
        return FontAwesomeIcons.exclamationTriangle;
      case FeedbackType.info:
        return FontAwesomeIcons.infoCircle;
      case FeedbackType.loading:
        return FontAwesomeIcons.spinner;
    }
  }

  /// Obtém o ícone efetivo (personalizado ou padrão)
  IconData get effectiveIcon => icon ?? defaultIcon;
}

/// Controlador para gerenciar o feedback visual
class FeedbackController {
  static OverlayEntry? _currentEntry;
  static bool _isVisible = false;

  /// Mostra um feedback visual na tela
  static void show(
    BuildContext context,
    FeedbackConfig config,
  ) {
    // Remove qualquer feedback existente
    hide();

    final overlay = Overlay.of(context);
    _currentEntry = OverlayEntry(
      builder: (context) => FeedbackOverlay(config: config),
    );

    _isVisible = true;
    overlay.insert(_currentEntry!);

    // Fecha automaticamente após a duração especificada, a menos que seja um loading
    if (config.type != FeedbackType.loading) {
      Future.delayed(config.duration, () {
        if (_isVisible) {
          hide();
        }
      });
    }
  }

  /// Esconde o feedback atualmente visível
  static void hide() {
    if (_currentEntry != null) {
      _currentEntry!.remove();
      _currentEntry = null;
      _isVisible = false;
    }
  }

  /// Mostra um feedback de sucesso
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    FeedbackPosition position = FeedbackPosition.bottom,
    IconData? icon,
    VoidCallback? onClose,
  }) {
    show(
      context,
      FeedbackConfig(
        message: message,
        type: FeedbackType.success,
        duration: duration,
        position: position,
        icon: icon,
        onClose: onClose,
      ),
    );
  }

  /// Mostra um feedback de erro
  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
    FeedbackPosition position = FeedbackPosition.bottom,
    IconData? icon,
    VoidCallback? onClose,
  }) {
    show(
      context,
      FeedbackConfig(
        message: message,
        type: FeedbackType.error,
        duration: duration,
        position: position,
        icon: icon,
        onClose: onClose,
      ),
    );
  }

  /// Mostra um feedback de aviso
  static void showWarning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    FeedbackPosition position = FeedbackPosition.bottom,
    IconData? icon,
    VoidCallback? onClose,
  }) {
    show(
      context,
      FeedbackConfig(
        message: message,
        type: FeedbackType.warning,
        duration: duration,
        position: position,
        icon: icon,
        onClose: onClose,
      ),
    );
  }

  /// Mostra um feedback informativo
  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    FeedbackPosition position = FeedbackPosition.bottom,
    IconData? icon,
    VoidCallback? onClose,
  }) {
    show(
      context,
      FeedbackConfig(
        message: message,
        type: FeedbackType.info,
        duration: duration,
        position: position,
        icon: icon,
        onClose: onClose,
      ),
    );
  }

  /// Mostra um indicador de carregamento com mensagem
  static void showLoading(
    BuildContext context, {
    required String message,
    FeedbackPosition position = FeedbackPosition.center,
    bool isDismissible = false,
  }) {
    show(
      context,
      FeedbackConfig(
        message: message,
        type: FeedbackType.loading,
        position: position,
        isDismissible: isDismissible,
      ),
    );
  }
}

/// Widget de sobreposição que mostra o feedback visual
class FeedbackOverlay extends StatefulWidget {
  final FeedbackConfig config;

  const FeedbackOverlay({
    Key? key,
    required this.config,
  }) : super(key: key);

  @override
  State<FeedbackOverlay> createState() => _FeedbackOverlayState();
}

class _FeedbackOverlayState extends State<FeedbackOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Configurar animações
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Configurar animação de slide baseada na posição
    final beginOffset = _getBeginOffset(widget.config.position);
    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  Offset _getBeginOffset(FeedbackPosition position) {
    switch (position) {
      case FeedbackPosition.top:
        return const Offset(0.0, -1.0); // Desliza de cima
      case FeedbackPosition.center:
        return const Offset(0.0, 0.5); // Desliza do meio para cima
      case FeedbackPosition.bottom:
        return const Offset(0.0, 1.0); // Desliza de baixo
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determinar alinhamento com base na posição
    Alignment alignment;
    switch (widget.config.position) {
      case FeedbackPosition.top:
        alignment = Alignment.topCenter;
        break;
      case FeedbackPosition.center:
        alignment = Alignment.center;
        break;
      case FeedbackPosition.bottom:
        alignment = Alignment.bottomCenter;
        break;
    }

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Overlay escuro para feedback de carregamento
          if (widget.config.type == FeedbackType.loading)
            GestureDetector(
              onTap: widget.config.isDismissible
                  ? () => FeedbackController.hide()
                  : null,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          
          // Container do feedback
          Positioned.fill(
            child: Align(
              alignment: alignment,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: _buildFeedbackContent(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackContent() {
    final config = widget.config;
    
    // Estilo especial para loading
    if (config.type == FeedbackType.loading) {
      return Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.largeRadius),
          boxShadow: AppTheme.defaultShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                color: config.backgroundColor,
                strokeWidth: 5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              config.message,
              style: const TextStyle(
                fontSize: AppTheme.bodyTextSize,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Estilo padrão para outros tipos de feedback
    return GestureDetector(
      onTap: config.isDismissible ? () => FeedbackController.hide() : null,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: AppTheme.maxContainerWidth * 0.8,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        decoration: BoxDecoration(
          color: config.backgroundColor,
          borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
          boxShadow: AppTheme.defaultShadow,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              config.effectiveIcon,
              color: AppTheme.textLightColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                config.message,
                style: const TextStyle(
                  color: AppTheme.textLightColor,
                  fontSize: AppTheme.bodyTextSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (config.isDismissible) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  FeedbackController.hide();
                  if (config.onClose != null) {
                    config.onClose!();
                  }
                },
                child: const Icon(
                  FontAwesomeIcons.times,
                  color: AppTheme.textLightColor,
                  size: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}