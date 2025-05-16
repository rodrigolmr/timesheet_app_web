import 'package:flutter/material.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';

/// Componente de botão de ação flutuante personalizado para o aplicativo
class AppFloatingActionButton extends StatelessWidget {
  /// Ícone a ser exibido no botão
  final IconData icon;
  
  /// Texto opcional do botão (para FAB estendido)
  final String? label;
  
  /// Função a ser executada quando o botão for pressionado
  final VoidCallback? onPressed;
  
  /// Se o botão está em estado de carregamento
  final bool isLoading;
  
  /// Cor personalizada do botão (opcional)
  final Color? color;
  
  /// Categoria do botão para usar cor específica (opcional)
  final String? categoryName;
  
  /// Tooltip para exibir ao passar o mouse
  final String? tooltip;
  
  /// Se o botão deve ser pequeno
  final bool mini;
  
  /// Se o botão deve ser estendido (com texto)
  final bool isExtended;
  
  /// Cor personalizada do texto e ícone
  final Color? foregroundColor;
  
  /// Construtor padrão para o botão de ação flutuante padrão
  const AppFloatingActionButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.label,
    this.isLoading = false,
    this.color,
    this.categoryName,
    this.tooltip,
    this.mini = false,
    this.isExtended = false,
    this.foregroundColor,
  }) : super(key: key);
  
  /// Botão de ação flutuante para ações de adicionar
  factory AppFloatingActionButton.add({
    VoidCallback? onPressed,
    String? label,
    bool isLoading = false,
    String? tooltip,
    bool mini = false,
    bool isExtended = false,
  }) {
    return AppFloatingActionButton(
      icon: Icons.add,
      onPressed: onPressed,
      label: label,
      isLoading: isLoading,
      categoryName: "add",
      tooltip: tooltip ?? 'Adicionar',
      mini: mini,
      isExtended: isExtended,
    );
  }
  
  /// Botão de ação flutuante para ações relacionadas a timesheets
  factory AppFloatingActionButton.timesheet({
    required IconData icon,
    required VoidCallback? onPressed,
    String? label,
    bool isLoading = false,
    String? tooltip,
    bool mini = false,
    bool isExtended = false,
  }) {
    return AppFloatingActionButton(
      icon: icon,
      onPressed: onPressed,
      label: label,
      isLoading: isLoading,
      categoryName: "timesheet",
      tooltip: tooltip,
      mini: mini,
      isExtended: isExtended,
    );
  }
  
  /// Botão de ação flutuante para ações relacionadas a recibos
  factory AppFloatingActionButton.receipt({
    required IconData icon,
    required VoidCallback? onPressed,
    String? label,
    bool isLoading = false,
    String? tooltip,
    bool mini = false,
    bool isExtended = false,
  }) {
    return AppFloatingActionButton(
      icon: icon,
      onPressed: onPressed,
      label: label,
      isLoading: isLoading,
      categoryName: "receipt",
      tooltip: tooltip,
      mini: mini,
      isExtended: isExtended,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determina a cor do botão
    final buttonColor = _getButtonColor(context);
    
    // Determina a cor do ícone/texto
    final contentColor = foregroundColor ?? Colors.white;
    
    // Função que lida com o clique no botão
    final effectiveOnPressed = isLoading ? null : onPressed;
    
    // Determina o ícone ou indicador de progresso a ser exibido
    Widget buttonIcon = isLoading
        ? SizedBox(
            width: 24.0,
            height: 24.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(contentColor),
            ),
          )
        : Icon(icon, color: contentColor);
    
    // Cria o botão apropriado com base nos parâmetros
    if (isExtended && label != null) {
      return FloatingActionButton.extended(
        onPressed: effectiveOnPressed,
        icon: buttonIcon,
        label: Text(
          label!,
          style: TextStyle(
            color: contentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: buttonColor,
        tooltip: tooltip,
        elevation: 4.0,
        highlightElevation: 8.0,
      );
    } else {
      return FloatingActionButton(
        onPressed: effectiveOnPressed,
        mini: mini,
        child: buttonIcon,
        backgroundColor: buttonColor,
        foregroundColor: contentColor,
        tooltip: tooltip,
        elevation: 4.0,
        highlightElevation: 8.0,
      );
    }
  }
  
  // Determina a cor do botão com base nos parâmetros
  Color _getButtonColor(BuildContext context) {
    if (color != null) return color!;
    
    if (categoryName != null) {
      // Usa o método de extensão que não requer importação de CategoryType
      return context.categoryColorByName(categoryName);
    }
    
    return context.colors.primary;
  }
}