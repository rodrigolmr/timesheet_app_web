// lib/widgets/progress_indicator.dart

import 'package:flutter/material.dart';
import 'package:timesheet_app_web/core/theme/app_theme.dart';

/// Tipos de indicadores de progresso disponíveis
enum ProgressType {
  circular,
  linear,
  upload,
  download,
  sync,
}

/// Widget de indicador de progresso personalizado
class AppProgressIndicator extends StatelessWidget {
  final ProgressType type;
  final double? value;
  final Color? color;
  final String? label;
  final double size;
  final double strokeWidth;
  final bool showPercentage;

  /// Cria um indicador de progresso personalizado.
  ///
  /// O parâmetro [type] define o tipo de indicador.
  /// O parâmetro [value] é opcional e define o valor atual do progresso (0.0 a 1.0).
  /// Se [value] for null, o indicador será indeterminado.
  /// O parâmetro [color] define a cor do indicador, se não fornecido, usa a cor primária.
  /// O parâmetro [label] é opcional e adiciona um texto abaixo do indicador.
  /// O parâmetro [size] define o tamanho do indicador (apenas para circular).
  /// O parâmetro [strokeWidth] define a espessura do traço do indicador.
  /// O parâmetro [showPercentage] controla se a porcentagem deve ser exibida.
  const AppProgressIndicator({
    Key? key,
    required this.type,
    this.value,
    this.color,
    this.label,
    this.size = 48.0,
    this.strokeWidth = 4.0,
    this.showPercentage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppTheme.primaryBlue;
    
    // Determina o widget do indicador com base no tipo
    Widget indicator;
    switch (type) {
      case ProgressType.circular:
        indicator = _buildCircularIndicator(effectiveColor);
        break;
      case ProgressType.linear:
        indicator = _buildLinearIndicator(effectiveColor);
        break;
      case ProgressType.upload:
        indicator = _buildUploadIndicator(effectiveColor);
        break;
      case ProgressType.download:
        indicator = _buildDownloadIndicator(effectiveColor);
        break;
      case ProgressType.sync:
        indicator = _buildSyncIndicator(effectiveColor);
        break;
    }
    
    // Se tiver rótulo, adiciona abaixo do indicador
    if (label != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          indicator,
          const SizedBox(height: 8.0),
          Text(
            label!,
            style: TextStyle(
              color: effectiveColor,
              fontWeight: FontWeight.bold,
              fontSize: AppTheme.bodyTextSize,
            ),
          ),
          if (showPercentage && value != null) ...[
            const SizedBox(height: 4.0),
            Text(
              '${(value! * 100).toInt()}%',
              style: TextStyle(
                color: effectiveColor,
                fontSize: AppTheme.smallTextSize,
              ),
            ),
          ],
        ],
      );
    }
    
    return indicator;
  }

  /// Constrói um indicador circular
  Widget _buildCircularIndicator(Color color) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: value,
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            backgroundColor: color.withOpacity(0.2),
          ),
          if (showPercentage && value != null)
            Text(
              '${(value! * 100).toInt()}%',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: size / 4,
              ),
            ),
        ],
      ),
    );
  }

  /// Constrói um indicador linear
  Widget _buildLinearIndicator(Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LinearProgressIndicator(
          value: value,
          minHeight: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          backgroundColor: color.withOpacity(0.2),
        ),
        if (showPercentage && value != null) ...[
          const SizedBox(height: 4.0),
          Text(
            '${(value! * 100).toInt()}%',
            style: TextStyle(
              color: color,
              fontSize: AppTheme.smallTextSize,
            ),
          ),
        ],
      ],
    );
  }

  /// Constrói um indicador de upload com ícone
  Widget _buildUploadIndicator(Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                value: value,
                strokeWidth: strokeWidth,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                backgroundColor: color.withOpacity(0.2),
              ),
            ),
            Icon(
              Icons.cloud_upload,
              size: size / 2,
              color: color,
            ),
          ],
        ),
        if (showPercentage && value != null) ...[
          const SizedBox(height: 4.0),
          Text(
            '${(value! * 100).toInt()}%',
            style: TextStyle(
              color: color,
              fontSize: AppTheme.smallTextSize,
            ),
          ),
        ],
      ],
    );
  }

  /// Constrói um indicador de download com ícone
  Widget _buildDownloadIndicator(Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                value: value,
                strokeWidth: strokeWidth,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                backgroundColor: color.withOpacity(0.2),
              ),
            ),
            Icon(
              Icons.cloud_download,
              size: size / 2,
              color: color,
            ),
          ],
        ),
        if (showPercentage && value != null) ...[
          const SizedBox(height: 4.0),
          Text(
            '${(value! * 100).toInt()}%',
            style: TextStyle(
              color: color,
              fontSize: AppTheme.smallTextSize,
            ),
          ),
        ],
      ],
    );
  }

  /// Constrói um indicador de sincronização com animação de rotação
  Widget _buildSyncIndicator(Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (value != null)
                CircularProgressIndicator(
                  value: value,
                  strokeWidth: strokeWidth,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  backgroundColor: color.withOpacity(0.2),
                )
              else
                CircularProgressIndicator(
                  strokeWidth: strokeWidth,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              // Ícone de sincronização
              SizedBox(
                width: size / 2,
                height: size / 2,
                child: AnimatedRotation(
                  // Se não tiver valor definido, anima continuamente
                  turns: value == null ? 1.0 : 0.0,
                  duration: const Duration(seconds: 2),
                  child: Icon(
                    Icons.sync,
                    size: size / 3,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showPercentage && value != null) ...[
          const SizedBox(height: 4.0),
          Text(
            '${(value! * 100).toInt()}%',
            style: TextStyle(
              color: color,
              fontSize: AppTheme.smallTextSize,
            ),
          ),
        ],
      ],
    );
  }
}

/// Widget para exibir o progresso de sincronização
class SyncProgressIndicator extends StatefulWidget {
  final double size;
  final Color? color;
  final String? label;

  const SyncProgressIndicator({
    Key? key,
    this.size = 48.0,
    this.color,
    this.label,
  }) : super(key: key);

  @override
  State<SyncProgressIndicator> createState() => _SyncProgressIndicatorState();
}

class _SyncProgressIndicatorState extends State<SyncProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.color ?? AppTheme.primaryBlue;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                strokeWidth: 4.0,
                valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
              ),
              RotationTransition(
                turns: _controller,
                child: Icon(
                  Icons.sync,
                  size: widget.size / 2.5,
                  color: effectiveColor,
                ),
              ),
            ],
          ),
        ),
        if (widget.label != null) ...[
          const SizedBox(height: 8.0),
          Text(
            widget.label!,
            style: TextStyle(
              color: effectiveColor,
              fontWeight: FontWeight.bold,
              fontSize: AppTheme.bodyTextSize,
            ),
          ),
        ],
      ],
    );
  }
}

/// Widget para exibir o progresso de carregamento em uma operação
class LoadingProgressOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;
  final Color color;

  const LoadingProgressOverlay({
    Key? key,
    required this.isLoading,
    required this.child,
    this.message,
    this.color = AppTheme.primaryBlue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.largeRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 48.0,
                        height: 48.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      ),
                      if (message != null) ...[
                        const SizedBox(height: 16.0),
                        Text(
                          message!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppTheme.bodyTextSize,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}