// lib/widgets/loading_button.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timesheet_app_web/core/theme/app_theme.dart';
import 'package:timesheet_app_web/widgets/app_button.dart';

/// Botão com estado de carregamento que estende o AppButton
class LoadingButton extends StatefulWidget {
  final ButtonConfig config;
  final Future<void> Function() onPressed;
  final bool semanticsLabel;
  final AppButtonStyle buttonStyle;
  final double? minWidth;
  final bool isExpanded;
  final String? loadingText;
  final Widget? loadingIcon;
  final Color? loadingColor;
  final Duration pulseDuration;
  final bool showProgressIndicator;

  /// Cria um botão que exibe um indicador de carregamento enquanto a ação está em andamento.
  ///
  /// O [config] define a aparência do botão.
  /// O [onPressed] é chamado quando o botão é pressionado e deve retornar um Future.
  /// O [semanticsLabel] adiciona um rótulo para acessibilidade.
  /// O [buttonStyle] define o estilo visual do botão.
  /// O [minWidth] define a largura mínima para botões flexíveis.
  /// O [isExpanded] expande o botão para ocupar todo o espaço disponível.
  /// O [loadingText] substitui o texto do botão durante o carregamento.
  /// O [loadingIcon] substitui o ícone do botão durante o carregamento.
  /// O [loadingColor] define a cor do indicador de progresso.
  /// O [pulseDuration] define a duração da animação de pulso durante o carregamento.
  /// O [showProgressIndicator] controla se o indicador de progresso deve ser exibido.
  const LoadingButton({
    Key? key,
    required this.config,
    required this.onPressed,
    this.semanticsLabel = true,
    this.buttonStyle = AppButtonStyle.filled,
    this.minWidth,
    this.isExpanded = false,
    this.loadingText,
    this.loadingIcon,
    this.loadingColor,
    this.pulseDuration = const Duration(milliseconds: 1000),
    this.showProgressIndicator = true,
  }) : super(key: key);

  /// Cria um botão de carregamento a partir de um [ButtonType].
  factory LoadingButton.fromType({
    required ButtonType type,
    required Future<void> Function() onPressed,
    AppButtonStyle buttonStyle = AppButtonStyle.filled,
    bool semanticsLabel = true,
    double? minWidth,
    bool isExpanded = false,
    String? loadingText,
    Widget? loadingIcon,
    Color? loadingColor,
    Duration pulseDuration = const Duration(milliseconds: 1000),
    bool showProgressIndicator = true,
    Key? key,
  }) {
    return LoadingButton(
      key: key,
      config: type.config,
      onPressed: onPressed,
      semanticsLabel: semanticsLabel,
      buttonStyle: buttonStyle,
      minWidth: minWidth,
      isExpanded: isExpanded,
      loadingText: loadingText,
      loadingIcon: loadingIcon,
      loadingColor: loadingColor,
      pulseDuration: pulseDuration,
      showProgressIndicator: showProgressIndicator,
    );
  }

  /// Cria um mini botão de carregamento a partir de um [MiniButtonType].
  factory LoadingButton.mini({
    required MiniButtonType type,
    required Future<void> Function() onPressed,
    AppButtonStyle buttonStyle = AppButtonStyle.filled,
    bool semanticsLabel = true,
    bool isExpanded = false,
    String? loadingText,
    Widget? loadingIcon,
    Color? loadingColor,
    Duration pulseDuration = const Duration(milliseconds: 1000),
    bool showProgressIndicator = true,
    Key? key,
  }) {
    return LoadingButton(
      key: key,
      config: type.config,
      onPressed: onPressed,
      semanticsLabel: semanticsLabel,
      buttonStyle: buttonStyle,
      isExpanded: isExpanded,
      loadingText: loadingText,
      loadingIcon: loadingIcon,
      loadingColor: loadingColor,
      pulseDuration: pulseDuration,
      showProgressIndicator: showProgressIndicator,
    );
  }

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      vsync: this,
      duration: widget.pulseDuration,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _pulseController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _pulseController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _pulseController.forward();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _handlePressed() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    _pulseController.forward();

    try {
      await widget.onPressed();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _pulseController.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determinar o estilo e conteúdo do botão dependendo do estado de carregamento
    if (_isLoading) {
      // Configuração durante o carregamento
      final loadingConfig = _createLoadingConfig();
      
      return AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: _buildLoadingButton(loadingConfig),
          );
        },
      );
    } else {
      // Botão normal quando não está carregando
      return AppButton(
        config: widget.config,
        onPressed: _handlePressed,
        semanticsLabel: widget.semanticsLabel,
        buttonStyle: widget.buttonStyle,
        minWidth: widget.minWidth,
        isExpanded: widget.isExpanded,
      );
    }
  }

  /// Cria uma configuração modificada para o estado de carregamento
  ButtonConfig _createLoadingConfig() {
    // Texto e ícone para o estado de carregamento
    final loadingText = widget.loadingText ?? 'Loading...';
    
    // Cor do carregamento (usa a cor do botão por padrão)
    final loadingColor = widget.loadingColor ?? 
        (widget.buttonStyle == AppButtonStyle.filled 
            ? widget.config.backgroundColor 
            : widget.config.borderColor);
    
    return widget.config.copyWith(
      label: loadingText,
      icon: widget.loadingIcon != null ? FontAwesomeIcons.spinner : widget.config.icon,
    );
  }

  /// Constrói o botão no estado de carregamento
  Widget _buildLoadingButton(ButtonConfig loadingConfig) {
    // Botão base com configuração de carregamento
    Widget button = AppButton(
      config: loadingConfig,
      onPressed: () {}, // Botão desabilitado durante o carregamento
      semanticsLabel: widget.semanticsLabel,
      buttonStyle: widget.buttonStyle,
      minWidth: widget.minWidth,
      isExpanded: widget.isExpanded,
    );
    
    // Se o indicador de progresso deve ser exibido, adiciona uma sobreposição
    if (widget.showProgressIndicator) {
      final Color indicatorColor = widget.buttonStyle == AppButtonStyle.filled
          ? Colors.white70
          : loadingConfig.backgroundColor;
      
      return Stack(
        alignment: Alignment.center,
        children: [
          button,
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
            ),
          ),
        ],
      );
    }
    
    return button;
  }
}

/// Estados de um botão que varia conforme a operação
enum OperationState {
  initial,
  inProgress,
  success,
  error,
}

/// Botão que muda de aparência conforme o estado da operação
class StateButton extends StatefulWidget {
  final ButtonConfig initialConfig;
  final Future<bool> Function() onPressed;
  final String loadingText;
  final String successText;
  final String errorText;
  final Duration successDuration;
  final Duration errorDuration;
  final IconData loadingIcon;
  final IconData successIcon;
  final IconData errorIcon;
  final VoidCallback? onSuccess;
  final VoidCallback? onError;
  final AppButtonStyle buttonStyle;

  /// Cria um botão que muda de estado com base no resultado da operação.
  ///
  /// O [initialConfig] define a aparência inicial do botão.
  /// O [onPressed] é chamado quando o botão é pressionado e deve retornar um Future<bool>.
  /// O valor retornado indica sucesso (true) ou erro (false).
  /// Os textos para cada estado são definidos por [loadingText], [successText] e [errorText].
  /// As durações [successDuration] e [errorDuration] definem quanto tempo o botão permanece nos estados de sucesso e erro.
  /// Os ícones para cada estado são definidos por [loadingIcon], [successIcon] e [errorIcon].
  /// Os callbacks [onSuccess] e [onError] são chamados quando a operação é concluída com sucesso ou falha.
  const StateButton({
    Key? key,
    required this.initialConfig,
    required this.onPressed,
    this.loadingText = 'Processing...',
    this.successText = 'Success!',
    this.errorText = 'Failed',
    this.successDuration = const Duration(milliseconds: 1500),
    this.errorDuration = const Duration(milliseconds: 1500),
    this.loadingIcon = FontAwesomeIcons.spinner,
    this.successIcon = FontAwesomeIcons.check,
    this.errorIcon = FontAwesomeIcons.exclamationTriangle,
    this.onSuccess,
    this.onError,
    this.buttonStyle = AppButtonStyle.filled,
  }) : super(key: key);

  /// Cria um botão de estado a partir de um [ButtonType].
  factory StateButton.fromType({
    required ButtonType type,
    required Future<bool> Function() onPressed,
    String loadingText = 'Processing...',
    String successText = 'Success!',
    String errorText = 'Failed',
    Duration successDuration = const Duration(milliseconds: 1500),
    Duration errorDuration = const Duration(milliseconds: 1500),
    IconData loadingIcon = FontAwesomeIcons.spinner,
    IconData successIcon = FontAwesomeIcons.check,
    IconData errorIcon = FontAwesomeIcons.exclamationTriangle,
    VoidCallback? onSuccess,
    VoidCallback? onError,
    AppButtonStyle buttonStyle = AppButtonStyle.filled,
    Key? key,
  }) {
    return StateButton(
      key: key,
      initialConfig: type.config,
      onPressed: onPressed,
      loadingText: loadingText,
      successText: successText,
      errorText: errorText,
      successDuration: successDuration,
      errorDuration: errorDuration,
      loadingIcon: loadingIcon,
      successIcon: successIcon,
      errorIcon: errorIcon,
      onSuccess: onSuccess,
      onError: onError,
      buttonStyle: buttonStyle,
    );
  }

  @override
  State<StateButton> createState() => _StateButtonState();
}

class _StateButtonState extends State<StateButton>
    with SingleTickerProviderStateMixin {
  OperationState _state = OperationState.initial;
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handlePressed() async {
    if (_state != OperationState.initial) return;

    setState(() {
      _state = OperationState.inProgress;
    });

    _animController.forward();

    try {
      final result = await widget.onPressed();
      
      if (!mounted) return;
      
      setState(() {
        _state = result ? OperationState.success : OperationState.error;
      });
      
      if (result) {
        if (widget.onSuccess != null) {
          widget.onSuccess!();
        }
        Future.delayed(widget.successDuration, _resetState);
      } else {
        if (widget.onError != null) {
          widget.onError!();
        }
        Future.delayed(widget.errorDuration, _resetState);
      }
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _state = OperationState.error;
      });
      
      if (widget.onError != null) {
        widget.onError!();
      }
      
      Future.delayed(widget.errorDuration, _resetState);
    }
  }

  void _resetState() {
    if (mounted) {
      setState(() {
        _state = OperationState.initial;
      });
      _animController.reverse();
    }
  }

  ButtonConfig _getConfigForState() {
    switch (_state) {
      case OperationState.initial:
        return widget.initialConfig;
      
      case OperationState.inProgress:
        return widget.initialConfig.copyWith(
          label: widget.loadingText,
          icon: widget.loadingIcon,
          backgroundColor: AppTheme.lightGrayColor,
          borderColor: AppTheme.lightGrayColor,
        );
      
      case OperationState.success:
        return widget.initialConfig.copyWith(
          label: widget.successText,
          icon: widget.successIcon,
          backgroundColor: AppTheme.primaryGreen,
          borderColor: AppTheme.primaryGreen,
        );
      
      case OperationState.error:
        return widget.initialConfig.copyWith(
          label: widget.errorText,
          icon: widget.errorIcon,
          backgroundColor: AppTheme.primaryRed,
          borderColor: AppTheme.primaryRed,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _getConfigForState();
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        // Aplicar escala apenas quando estiver em progresso
        final scale = _state == OperationState.inProgress 
            ? _scaleAnimation.value 
            : 1.0;
            
        return Transform.scale(
          scale: scale,
          child: AppButton(
            config: config,
            onPressed: _state == OperationState.initial 
                ? _handlePressed 
                : () {}, // Desabilitado em outros estados
            buttonStyle: widget.buttonStyle,
          ),
        );
      },
    );
  }
}