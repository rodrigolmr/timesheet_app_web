// lib/widgets/toast_message.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timesheet_app_web/core/theme/app_theme.dart';

/// Define os diferentes tipos de toast
enum ToastType {
  success,
  error,
  warning,
  info,
}

/// Configuração para o toast
class ToastConfig {
  final String message;
  final ToastType type;
  final Duration duration;
  final bool dismissible;

  const ToastConfig({
    required this.message,
    required this.type,
    this.duration = const Duration(seconds: 3),
    this.dismissible = true,
  });

  Color get backgroundColor {
    switch (type) {
      case ToastType.success:
        return AppTheme.primaryGreen;
      case ToastType.error:
        return AppTheme.primaryRed;
      case ToastType.warning:
        return AppTheme.primaryYellow;
      case ToastType.info:
        return AppTheme.primaryBlue;
    }
  }

  IconData get icon {
    switch (type) {
      case ToastType.success:
        return FontAwesomeIcons.checkCircle;
      case ToastType.error:
        return FontAwesomeIcons.exclamationCircle;
      case ToastType.warning:
        return FontAwesomeIcons.exclamationTriangle;
      case ToastType.info:
        return FontAwesomeIcons.infoCircle;
    }
  }
}

/// Classe para exibir mensagens de toast
class ToastMessage {
  static const double _verticalMargin = 16.0;
  static const double _horizontalMargin = 16.0;
  static const double _toastMaxWidth = 400.0;

  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;
  static BuildContext? _previousContext;

  /// Mostra um toast na parte inferior da tela
  static void show(
    BuildContext context,
    String message, {
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
    bool dismissible = true,
  }) {
    final config = ToastConfig(
      message: message,
      type: type,
      duration: duration,
      dismissible: dismissible,
    );

    _show(context, config);
  }

  /// Mostra um toast de sucesso
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    bool dismissible = true,
  }) {
    final config = ToastConfig(
      message: message,
      type: ToastType.success,
      duration: duration,
      dismissible: dismissible,
    );

    _show(context, config);
  }

  /// Mostra um toast de erro
  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    bool dismissible = true,
  }) {
    final config = ToastConfig(
      message: message,
      type: ToastType.error,
      duration: duration,
      dismissible: dismissible,
    );

    _show(context, config);
  }

  /// Mostra um toast de aviso
  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    bool dismissible = true,
  }) {
    final config = ToastConfig(
      message: message,
      type: ToastType.warning,
      duration: duration,
      dismissible: dismissible,
    );

    _show(context, config);
  }

  /// Mostra um toast informativo
  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
    bool dismissible = true,
  }) {
    final config = ToastConfig(
      message: message,
      type: ToastType.info,
      duration: duration,
      dismissible: dismissible,
    );

    _show(context, config);
  }

  /// Implementação interna para mostrar o toast
  static void _show(BuildContext context, ToastConfig config) {
    // Certifica-se de que o contexto não foi descartado
    if (_previousContext != context) {
      dismiss();
      _previousContext = context;
    }

    // Remove qualquer toast existente
    if (_isVisible) {
      dismiss();
    }

    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => _ToastWidget(
        config: config,
        onDismiss: dismiss,
      ),
    );

    _isVisible = true;
    overlay.insert(_overlayEntry!);

    if (config.duration != Duration.zero) {
      Future.delayed(config.duration, () {
        if (_isVisible) {
          dismiss();
        }
      });
    }
  }

  /// Remove o toast atual
  static void dismiss() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      _isVisible = false;
    }
  }
}

/// Widget interno que renderiza o toast
class _ToastWidget extends StatefulWidget {
  final ToastConfig config;
  final VoidCallback onDismiss;

  const _ToastWidget({
    required this.config,
    required this.onDismiss,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutQuint,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismiss() {
    _animationController.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: ToastMessage._verticalMargin,
      left: ToastMessage._horizontalMargin,
      right: ToastMessage._horizontalMargin,
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: ToastMessage._toastMaxWidth,
                  ),
                  child: Card(
                    margin: EdgeInsets.zero,
                    color: widget.config.backgroundColor,
                    elevation: 6.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
                    ),
                    child: InkWell(
                      onTap: widget.config.dismissible ? _dismiss : null,
                      borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              widget.config.icon,
                              color: AppTheme.textLightColor,
                              size: 24.0,
                            ),
                            const SizedBox(width: 12.0),
                            Flexible(
                              child: Text(
                                widget.config.message,
                                style: const TextStyle(
                                  color: AppTheme.textLightColor,
                                  fontSize: AppTheme.bodyTextSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (widget.config.dismissible) ...[
                              const SizedBox(width: 12.0),
                              InkWell(
                                onTap: _dismiss,
                                borderRadius: BorderRadius.circular(20.0),
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Icon(
                                    FontAwesomeIcons.times,
                                    color: Colors.white,
                                    size: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}