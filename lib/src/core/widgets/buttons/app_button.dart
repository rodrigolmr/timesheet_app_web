import 'package:flutter/material.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';

/// Tipos de botão suportados
enum AppButtonType {
  /// Botão primário com fundo colorido
  primary,
  
  /// Botão secundário com estilo menos destacado
  secondary,
  
  /// Botão com estilo de destaque para ações importantes
  accent,
  
  /// Botão com estilo sutil para ações menos importantes
  text,
  
  /// Botão com aparência de link
  link,
  
  /// Botão de ação positiva (ex: confirmar, salvar)
  success,
  
  /// Botão de ação negativa (ex: cancelar, excluir)
  error,
  
  /// Botão para alertas ou ações de atenção
  warning,
}

/// Tipos de tamanho de botão
enum AppButtonSize {
  /// Tamanho extra pequeno para espaços restritos
  xs,
  
  /// Tamanho pequeno para áreas com espaço limitado
  small,
  
  /// Tamanho médio (padrão) para a maioria dos casos
  medium,
  
  /// Tamanho grande para maior destaque
  large,
}

/// Componente de botão principal com diversos estilos e opções
class AppButton extends StatelessWidget {
  /// Texto do botão
  final String label;
  
  /// Tipo/estilo do botão (primário, secundário, etc.)
  final AppButtonType type;
  
  /// Tamanho do botão
  final AppButtonSize size;
  
  /// Ícone opcional para exibir no botão (antes do texto)
  final IconData? icon;
  
  /// Ícone opcional para exibir no botão (depois do texto)
  final IconData? trailingIcon;
  
  /// Posição do ícone (true para esquerda, false para direita)
  final bool iconLeading;
  
  /// Se o botão deve ocupar toda a largura disponível
  final bool fullWidth;
  
  /// Se o botão está em estado de carregamento
  final bool isLoading;
  
  /// Se o botão está desabilitado
  final bool isDisabled;
  
  /// Ação a ser executada quando o botão for pressionado
  final VoidCallback? onPressed;
  
  /// Se o botão deve ter bordas arredondadas mais pronunciadas
  final bool isRounded;
  
  /// Cor personalizada para o botão (opcional)
  final Color? customColor;
  
  /// Construtor padrão
  const AppButton({
    Key? key,
    required this.label,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.trailingIcon,
    this.iconLeading = true,
    this.fullWidth = false,
    this.isLoading = false,
    this.isDisabled = false,
    this.onPressed,
    this.isRounded = false,
    this.customColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determina a cor base do botão de acordo com o tipo
    final buttonColor = _getButtonColor(context);
    
    // Determina a cor do texto/ícone baseado no tipo de botão
    final contentColor = _getContentColor(context);
    
    // Determina o padding interno do botão baseado no tamanho
    final buttonPadding = _getButtonPadding(context);
    
    // Determina o tamanho da fonte e do ícone baseado no tamanho do botão
    final fontSize = _getFontSize(context);
    final iconSize = _getIconSize(context);
    
    // Determina o raio da borda baseado no tamanho e se deve ser arredondado
    final borderRadius = _getBorderRadius(context);
    
    // Calcula a largura do botão com base no parâmetro fullWidth
    final buttonWidth = fullWidth ? double.infinity : null;
    
    // Altura do botão baseada no tamanho
    final buttonHeight = _getButtonHeight(context);
    
    // Constrói o conteúdo do botão (texto e ícones)
    Widget buttonContent = _buildButtonContent(
      context, 
      contentColor, 
      fontSize, 
      iconSize
    );
    
    // Se o botão estiver em carregamento, mostra um indicador
    if (isLoading) {
      buttonContent = _buildLoadingContent(context, contentColor);
    }
    
    // Determinamos qual o tipo de botão a ser construído baseado no tipo
    Widget button;
    
    switch (type) {
      case AppButtonType.text:
      case AppButtonType.link:
        button = TextButton(
          onPressed: isDisabled || isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: buttonColor,
            padding: buttonPadding,
            textStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius,
            ),
          ),
          child: buttonContent,
        );
        break;
        
      case AppButtonType.secondary:
        button = OutlinedButton(
          onPressed: isDisabled || isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: buttonColor,
            side: BorderSide(color: buttonColor),
            padding: buttonPadding,
            textStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius,
            ),
            minimumSize: Size(0, buttonHeight),
          ),
          child: buttonContent,
        );
        break;
        
      case AppButtonType.primary:
      case AppButtonType.accent:
      case AppButtonType.success:
      case AppButtonType.error:
      case AppButtonType.warning:
      default:
        button = ElevatedButton(
          onPressed: isDisabled || isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: contentColor,
            padding: buttonPadding,
            textStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius,
            ),
            minimumSize: Size(0, buttonHeight),
          ),
          child: buttonContent,
        );
        break;
    }
    
    // Se o botão for de largura total, envolvemos em um container
    return SizedBox(
      width: buttonWidth,
      child: button,
    );
  }
  
  // Constrói o conteúdo do botão com texto e ícones
  Widget _buildButtonContent(
    BuildContext context, 
    Color contentColor, 
    double fontSize,
    double iconSize,
  ) {
    // Se não tiver ícones, retorna apenas o texto
    if (icon == null && trailingIcon == null) {
      return Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          height: 1.0,
        ),
      );
    }
    
    // Lista de widgets que compõem o conteúdo do botão
    final List<Widget> contentItems = [];
    
    // Adiciona o ícone principal se estiver configurado para aparecer antes do texto
    if (icon != null && iconLeading) {
      contentItems.add(Icon(icon, size: iconSize));
      contentItems.add(SizedBox(width: iconSize * 0.5));
    }
    
    // Adiciona o texto do botão
    contentItems.add(
      Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          height: 1.0,
        ),
      ),
    );
    
    // Adiciona o ícone principal se estiver configurado para aparecer depois do texto
    if (icon != null && !iconLeading) {
      contentItems.add(SizedBox(width: iconSize * 0.5));
      contentItems.add(Icon(icon, size: iconSize));
    }
    
    // Adiciona o ícone trailing se existir
    if (trailingIcon != null) {
      contentItems.add(SizedBox(width: iconSize * 0.5));
      contentItems.add(Icon(trailingIcon, size: iconSize));
    }
    
    // Retorna uma linha com os itens de conteúdo
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: contentItems,
    );
  }
  
  // Constrói o conteúdo do botão em estado de carregamento
  Widget _buildLoadingContent(BuildContext context, Color contentColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: _getIconSize(context),
          height: _getIconSize(context),
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(contentColor),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Loading...',
          style: TextStyle(
            fontSize: _getFontSize(context),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  // Determina a cor do botão com base no tipo
  Color _getButtonColor(BuildContext context) {
    if (customColor != null) return customColor!;
    
    if (isDisabled) {
      return context.colors.textSecondary.withOpacity(0.3);
    }
    
    switch (type) {
      case AppButtonType.primary:
        return context.colors.primary;
      case AppButtonType.secondary:
        return context.colors.background;
      case AppButtonType.accent:
        return context.colors.secondary;
      case AppButtonType.success:
        return context.colors.success;
      case AppButtonType.error:
        return context.colors.error;
      case AppButtonType.warning:
        return context.colors.warning;
      case AppButtonType.text:
      case AppButtonType.link:
        return Colors.transparent;
    }
  }
  
  // Determina a cor do conteúdo (texto/ícones) com base no tipo de botão
  Color _getContentColor(BuildContext context) {
    if (isDisabled) {
      return context.colors.textSecondary.withOpacity(0.5);
    }
    
    switch (type) {
      case AppButtonType.primary:
        return context.colors.onPrimary;
      case AppButtonType.secondary:
        return context.colors.primary;
      case AppButtonType.accent:
        return context.colors.onSecondary;
      case AppButtonType.success:
        return context.colors.onSuccess;
      case AppButtonType.error:
        return context.colors.onError;
      case AppButtonType.warning:
        return context.colors.onWarning;
      case AppButtonType.text:
      case AppButtonType.link:
        return context.colors.primary;
    }
  }
  
  // Determina o padding do botão baseado no tamanho
  EdgeInsets _getButtonPadding(BuildContext context) {
    switch (size) {
      case AppButtonSize.xs:
        return EdgeInsets.symmetric(
          horizontal: context.dimensions.spacingS,
          vertical: context.dimensions.spacingXS,
        );
      case AppButtonSize.small:
        return EdgeInsets.symmetric(
          horizontal: context.dimensions.spacingM,
          vertical: context.dimensions.spacingXS,
        );
      case AppButtonSize.medium:
        return EdgeInsets.symmetric(
          horizontal: context.dimensions.spacingM,
          vertical: context.dimensions.spacingS,
        );
      case AppButtonSize.large:
        return EdgeInsets.symmetric(
          horizontal: context.dimensions.spacingL,
          vertical: context.dimensions.spacingM,
        );
    }
  }
  
  // Determina o tamanho da fonte baseado no tamanho do botão
  double _getFontSize(BuildContext context) {
    switch (size) {
      case AppButtonSize.xs:
        return 12.0;
      case AppButtonSize.small:
        return 14.0;
      case AppButtonSize.medium:
        return 16.0;
      case AppButtonSize.large:
        return 18.0;
    }
  }
  
  // Determina o tamanho do ícone baseado no tamanho do botão
  double _getIconSize(BuildContext context) {
    switch (size) {
      case AppButtonSize.xs:
        return 14.0;
      case AppButtonSize.small:
        return 16.0;
      case AppButtonSize.medium:
        return 20.0;
      case AppButtonSize.large:
        return 24.0;
    }
  }
  
  // Determina o raio da borda baseado no tamanho e se o botão é arredondado
  BorderRadius _getBorderRadius(BuildContext context) {
    final baseRadius = isRounded 
      ? context.dimensions.borderRadiusL 
      : context.dimensions.borderRadiusS;
      
    switch (size) {
      case AppButtonSize.xs:
        return BorderRadius.circular(isRounded ? 12.0 : 4.0);
      case AppButtonSize.small:
        return BorderRadius.circular(isRounded ? 16.0 : 6.0);
      case AppButtonSize.medium:
        return BorderRadius.circular(isRounded ? 20.0 : 8.0);
      case AppButtonSize.large:
        return BorderRadius.circular(isRounded ? 24.0 : 10.0);
    }
  }
  
  // Determina a altura do botão baseada no tamanho
  double _getButtonHeight(BuildContext context) {
    switch (size) {
      case AppButtonSize.xs:
        return 28.0;
      case AppButtonSize.small:
        return 36.0;
      case AppButtonSize.medium:
        return 44.0;
      case AppButtonSize.large:
        return 52.0;
    }
  }
}