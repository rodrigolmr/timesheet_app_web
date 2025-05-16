import 'package:flutter/material.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';

/// Componente de botão de ícone personalizado para o aplicativo
///
/// Oferece várias opções de estilo, tamanho e comportamento
class AppIconButton extends StatelessWidget {
  /// Ícone a ser exibido no botão
  final IconData icon;
  
  /// Função a ser executada quando o botão for pressionado
  final VoidCallback? onPressed;
  
  /// Se o botão está desabilitado
  final bool isDisabled;
  
  /// Se o botão está em estado de carregamento
  final bool isLoading;
  
  /// Tamanho do botão (pequeno, médio, grande)
  final double size;
  
  /// Cor principal do botão
  final Color? color;
  
  /// Categoria do botão para usar cor específica (opcional)
  final String? categoryName;
  
  /// Tooltip para exibir ao passar o mouse
  final String? tooltip;
  
  /// Se o botão deve ter aparência de círculo
  final bool isCircular;
  
  /// Se o botão deve ter fundo sólido
  final bool hasSolidBackground;
  
  /// Se o botão deve ter contorno (borda)
  final bool hasOutline;
  
  /// Construtor padrão
  const AppIconButton({
    Key? key,
    required this.icon,
    this.onPressed,
    this.isDisabled = false,
    this.isLoading = false,
    this.size = 40.0,
    this.color,
    this.categoryName,
    this.tooltip,
    this.isCircular = true,
    this.hasSolidBackground = false,
    this.hasOutline = false,
  }) : super(key: key);
  
  /// Botão de ícone primário (cor principal do tema)
  factory AppIconButton.primary({
    required IconData icon,
    required VoidCallback? onPressed,
    bool isDisabled = false,
    bool isLoading = false,
    double size = 40.0,
    String? tooltip,
    bool isCircular = true,
  }) {
    return AppIconButton(
      icon: icon,
      onPressed: onPressed,
      isDisabled: isDisabled,
      isLoading: isLoading,
      size: size,
      tooltip: tooltip,
      isCircular: isCircular,
      hasSolidBackground: true,
    );
  }
  
  /// Botão de ícone secundário (com contorno)
  factory AppIconButton.secondary({
    required IconData icon,
    required VoidCallback? onPressed,
    bool isDisabled = false,
    bool isLoading = false,
    double size = 40.0,
    String? tooltip,
    bool isCircular = true,
  }) {
    return AppIconButton(
      icon: icon,
      onPressed: onPressed,
      isDisabled: isDisabled,
      isLoading: isLoading,
      size: size,
      tooltip: tooltip,
      isCircular: isCircular,
      hasOutline: true,
    );
  }
  
  /// Botão de ícone para ações positivas (cor de sucesso)
  factory AppIconButton.success({
    required IconData icon,
    required VoidCallback? onPressed,
    bool isDisabled = false,
    bool isLoading = false,
    double size = 40.0,
    String? tooltip,
    bool isCircular = true,
    bool hasSolidBackground = true,
  }) {
    return AppIconButton(
      icon: icon,
      onPressed: onPressed,
      isDisabled: isDisabled,
      isLoading: isLoading,
      size: size,
      categoryName: "add",
      tooltip: tooltip,
      isCircular: isCircular,
      hasSolidBackground: hasSolidBackground,
    );
  }
  
  /// Botão de ícone para ações negativas (cor de erro)
  factory AppIconButton.error({
    required IconData icon,
    required VoidCallback? onPressed,
    bool isDisabled = false,
    bool isLoading = false,
    double size = 40.0,
    String? tooltip,
    bool isCircular = true,
    bool hasSolidBackground = true,
  }) {
    return AppIconButton(
      icon: icon,
      onPressed: onPressed,
      isDisabled: isDisabled,
      isLoading: isLoading,
      size: size,
      categoryName: "cancel",
      tooltip: tooltip,
      isCircular: isCircular,
      hasSolidBackground: hasSolidBackground,
    );
  }
  
  /// Botão de ícone para timesheet (usando cor da categoria)
  factory AppIconButton.timesheet({
    required IconData icon,
    required VoidCallback? onPressed,
    bool isDisabled = false,
    bool isLoading = false,
    double size = 40.0,
    String? tooltip,
    bool isCircular = true,
    bool hasSolidBackground = true,
  }) {
    return AppIconButton(
      icon: icon,
      onPressed: onPressed,
      isDisabled: isDisabled,
      isLoading: isLoading,
      size: size,
      categoryName: "timesheet",
      tooltip: tooltip,
      isCircular: isCircular,
      hasSolidBackground: hasSolidBackground,
    );
  }
  
  /// Botão de ícone para recibos (usando cor da categoria)
  factory AppIconButton.receipt({
    required IconData icon,
    required VoidCallback? onPressed,
    bool isDisabled = false,
    bool isLoading = false,
    double size = 40.0,
    String? tooltip,
    bool isCircular = true,
    bool hasSolidBackground = true,
  }) {
    return AppIconButton(
      icon: icon,
      onPressed: onPressed,
      isDisabled: isDisabled,
      isLoading: isLoading,
      size: size,
      categoryName: "receipt",
      tooltip: tooltip,
      isCircular: isCircular,
      hasSolidBackground: hasSolidBackground,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determina a cor do botão
    final buttonColor = _getButtonColor(context);
    final iconColor = _getIconColor(context, buttonColor);
    
    // Calcula o tamanho do ícone baseado no tamanho do botão
    final iconSize = size * 0.5;
    
    // Determina o Widget de conteúdo do botão
    Widget buttonContent;
    
    if (isLoading) {
      buttonContent = SizedBox(
        width: iconSize,
        height: iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(iconColor),
        ),
      );
    } else {
      buttonContent = Icon(
        icon,
        size: iconSize,
        color: iconColor,
      );
    }
    
    // Cria o botão com o estilo apropriado
    Widget button;
    
    if (hasSolidBackground) {
      // Botão com fundo sólido
      button = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(isCircular ? size / 2 : 8.0),
          border: hasOutline 
            ? Border.all(color: buttonColor, width: 1.5) 
            : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : onPressed,
            borderRadius: BorderRadius.circular(isCircular ? size / 2 : 8.0),
            child: Center(child: buttonContent),
          ),
        ),
      );
    } else if (hasOutline) {
      // Botão com contorno
      button = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(isCircular ? size / 2 : 8.0),
          border: Border.all(color: buttonColor, width: 1.5),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : onPressed,
            borderRadius: BorderRadius.circular(isCircular ? size / 2 : 8.0),
            child: Center(child: buttonContent),
          ),
        ),
      );
    } else {
      // Botão transparente
      button = SizedBox(
        width: size,
        height: size,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : onPressed,
            borderRadius: BorderRadius.circular(isCircular ? size / 2 : 8.0),
            child: Center(child: buttonContent),
          ),
        ),
      );
    }
    
    // Adiciona tooltip se fornecido
    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }
    
    return button;
  }
  
  // Determina a cor do botão com base nos parâmetros
  Color _getButtonColor(BuildContext context) {
    if (isDisabled) {
      return context.colors.textSecondary.withOpacity(0.3);
    }
    
    if (color != null) {
      return color!;
    }
    
    if (categoryName != null) {
      // Usa o método de extensão que não requer importação de CategoryType
      return context.categoryColorByName(categoryName);
    }
    
    return context.colors.primary;
  }
  
  // Determina a cor do ícone com base no estilo do botão
  Color _getIconColor(BuildContext context, Color buttonColor) {
    if (isDisabled) {
      return context.colors.textSecondary.withOpacity(0.5);
    }
    
    if (hasSolidBackground) {
      return Colors.white;
    }
    
    return buttonColor;
  }
}