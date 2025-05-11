// lib/widgets/app_button.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timesheet_app_web/core/theme/app_theme.dart';

/// Enumeração para definir os diferentes estilos de botão
enum AppButtonStyle {
  filled,    // Botão padrão com preenchimento de cor
  outline,   // Botão com contorno e fundo transparente
  text,      // Botão apenas texto sem fundo ou contorno
  icon,      // Botão apenas com ícone (sem texto)
}

/// Agrupamento dos botões por categoria para melhor organização
enum ButtonCategory {
  navigation,   // Botões de navegação (back, next, etc)
  action,       // Botões de ação primária (new, add, save, submit)
  destructive,  // Botões de remoção ou cancelamento (delete, cancel)
  utility       // Botões de utilidade geral (settings, search, etc)
}

/// Configuração completa de um botão
class ButtonConfig {
  final String label;
  final IconData? icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color iconColor;
  final double width;
  final double height;
  final double iconSize;
  final double textSize;
  final double iconSpacing;
  final ButtonCategory category;

  /// Constrói uma configuração completa de botão
  const ButtonConfig({
    required this.label,
    this.icon,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.iconColor,
    required this.width,
    required this.height,
    required this.iconSize,
    required this.textSize,
    required this.iconSpacing,
    this.category = ButtonCategory.action,
  });

  /// Cria uma cópia da configuração com valores específicos alterados
  ButtonConfig copyWith({
    String? label,
    IconData? icon,
    Color? backgroundColor,
    Color? borderColor,
    Color? textColor,
    Color? iconColor,
    double? width,
    double? height,
    double? iconSize,
    double? textSize,
    double? iconSpacing,
    ButtonCategory? category,
  }) {
    return ButtonConfig(
      label: label ?? this.label,
      icon: icon ?? this.icon,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      textColor: textColor ?? this.textColor,
      iconColor: iconColor ?? this.iconColor,
      width: width ?? this.width,
      height: height ?? this.height,
      iconSize: iconSize ?? this.iconSize,
      textSize: textSize ?? this.textSize,
      iconSpacing: iconSpacing ?? this.iconSpacing,
      category: category ?? this.category,
    );
  }
  
  /// Converte a configuração para o estilo outline (contorno)
  ButtonConfig toOutlineStyle() {
    return copyWith(
      backgroundColor: Colors.transparent,
      textColor: borderColor,
      iconColor: borderColor,
    );
  }
  
  /// Converte a configuração para o estilo text (apenas texto)
  ButtonConfig toTextStyle() {
    return copyWith(
      backgroundColor: Colors.transparent,
      borderColor: Colors.transparent,
      textColor: backgroundColor,
      iconColor: backgroundColor,
    );
  }
  
  /// Converte a configuração para o estilo icon (apenas ícone)
  ButtonConfig toIconStyle() {
    return copyWith(
      width: height, // Torna o botão quadrado
      iconSize: iconSize * 1.2, // Aumenta o tamanho do ícone
    );
  }
  
  /// Converte a configuração para um tamanho flexível
  ButtonConfig toFlexibleWidth() {
    return copyWith(
      width: 0, // Zero indica que a largura será adaptativa
    );
  }
}

/// Define os tipos de botões disponíveis no aplicativo
enum ButtonType {
  // Botões de navegação
  nextButton,
  backButton,

  // Botões de ação primária
  newButton,
  addWorkerButton,
  addUserButton,
  addCardButton,
  submitButton,
  loginButton,
  saveButton,

  // Botões de documentos/dados
  sheetsButton,
  receiptsButton,
  pdfButton,
  uploadReceiptButton,

  // Botões de administração
  settingsButton,
  usersButton,
  workersButton,
  cardsButton,

  // Botões de edição/modificação
  editButton,
  clearButton,
  columnsButton,
  searchButton,
  sortButton,

  // Botões de cancelamento/remoção
  cancelButton,
  deleteButton,
}

extension ButtonTypeConfig on ButtonType {
  ButtonConfig get config {
    switch (this) {
      // Botões de navegação
      case ButtonType.nextButton:
        return const ButtonConfig(
          label: 'Next',
          icon: FontAwesomeIcons.arrowRight,
          backgroundColor: AppTheme.primaryBlue,
          borderColor: AppTheme.primaryBlue,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.buttonWidth,
          height: AppTheme.buttonHeight,
          iconSize: 24.0,
          textSize: AppTheme.buttonTextSize,
          iconSpacing: 4.0,
          category: ButtonCategory.navigation,
        );
        
      case ButtonType.backButton:
        return const ButtonConfig(
          label: 'Back',
          icon: FontAwesomeIcons.arrowLeft,
          backgroundColor: AppTheme.primaryBlue,
          borderColor: AppTheme.primaryBlue,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.buttonWidth,
          height: AppTheme.buttonHeight,
          iconSize: 24.0,
          textSize: AppTheme.buttonTextSize,
          iconSpacing: 4.0,
          category: ButtonCategory.navigation,
        );
      
      // Botões de ação primária
      case ButtonType.newButton:
        return const ButtonConfig(
          label: 'New',
          icon: FontAwesomeIcons.plus,
          backgroundColor: AppTheme.primaryGreen,
          borderColor: AppTheme.primaryGreen,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.buttonWidth,
          height: AppTheme.buttonHeight,
          iconSize: 24.0,
          textSize: AppTheme.buttonTextSize,
          iconSpacing: 4.0,
          category: ButtonCategory.action,
        );
        
      case ButtonType.addWorkerButton:
        return const ButtonConfig(
          label: 'Add Worker',
          icon: FontAwesomeIcons.userPlus,
          backgroundColor: AppTheme.primaryGreen,
          borderColor: AppTheme.primaryGreen,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.buttonWidth,
          height: AppTheme.buttonHeight,
          iconSize: 24.0,
          textSize: 10.0, // Smaller text for longer label
          iconSpacing: 4.0,
          category: ButtonCategory.action,
        );
        
      case ButtonType.addUserButton:
        return const ButtonConfig(
          label: 'Add user',
          icon: FontAwesomeIcons.userPlus,
          backgroundColor: AppTheme.primaryGreen,
          borderColor: AppTheme.primaryGreen,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.buttonWidth,
          height: AppTheme.buttonHeight,
          iconSize: 22.0,
          textSize: 10.0,
          iconSpacing: 4.0,
          category: ButtonCategory.action,
        );
        
      case ButtonType.addCardButton:
        return const ButtonConfig(
          label: 'Add card',
          icon: FontAwesomeIcons.creditCard,
          backgroundColor: AppTheme.primaryGreen,
          borderColor: AppTheme.primaryGreen,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.buttonWidth,
          height: AppTheme.buttonHeight,
          iconSize: 22.0,
          textSize: 10.0,
          iconSpacing: 4.0,
          category: ButtonCategory.action,
        );
        
      case ButtonType.submitButton:
        return const ButtonConfig(
          label: 'Submit',
          icon: FontAwesomeIcons.checkCircle,
          backgroundColor: AppTheme.primaryGreen,
          borderColor: AppTheme.primaryGreen,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.buttonWidth,
          height: AppTheme.buttonHeight,
          iconSize: 24.0,
          textSize: AppTheme.buttonTextSize,
          iconSpacing: 4.0,
          category: ButtonCategory.action,
        );
        
      case ButtonType.loginButton:
        return const ButtonConfig(
          label: 'Login',
          icon: FontAwesomeIcons.signInAlt,
          backgroundColor: AppTheme.primaryGreen,
          borderColor: AppTheme.primaryGreen,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.buttonWidth,
          height: AppTheme.buttonHeight,
          iconSize: 24.0,
          textSize: AppTheme.buttonTextSize,
          iconSpacing: 4.0,
          category: ButtonCategory.action,
        );
        
      case ButtonType.saveButton:
        return const ButtonConfig(
          label: 'Save',
          icon: FontAwesomeIcons.save,
          backgroundColor: AppTheme.primaryGreen,
          borderColor: AppTheme.primaryGreen,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.buttonWidth,
          height: AppTheme.buttonHeight,
          iconSize: 24.0,
          textSize: AppTheme.buttonTextSize,
          iconSpacing: 4.0,
          category: ButtonCategory.action,
        );
      
      // Botões de documentos/dados
      case ButtonType.sheetsButton:
        return const ButtonConfig(
          label: 'Sheets',
          icon: FontAwesomeIcons.fileExcel,
          backgroundColor: AppTheme.purpleColor,
          borderColor: AppTheme.purpleColor,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.buttonWidth,
          height: AppTheme.buttonHeight,
          iconSize: 24.0,
          textSize: AppTheme.buttonTextSize,
          iconSpacing: 4.0,
          category: ButtonCategory.utility,
        );
        
      case ButtonType.receiptsButton:
        return const ButtonConfig(
          label: 'Receipts',
          icon: FontAwesomeIcons.fileInvoiceDollar,
          backgroundColor: AppTheme.orangeColor,
          borderColor: AppTheme.orangeColor,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.buttonWidth,
          height: AppTheme.buttonHeight,
          iconSize: 24.0,
          textSize: AppTheme.buttonTextSize,
          iconSpacing: 4.0,
          category: ButtonCategory.utility,
        );
        
      case ButtonType.pdfButton:
        return const ButtonConfig(
          label: 'PDF',
          icon: FontAwesomeIcons.filePdf,
          backgroundColor: Color(0xFFFF0000),
          borderColor: Color(0xFFFF0000),
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.buttonWidth,
          height: AppTheme.buttonHeight,
          iconSize: 22.0,
          textSize: AppTheme.buttonTextSize,
          iconSpacing: 4.0,
          category: ButtonCategory.utility,
        );
        
      case ButtonType.uploadReceiptButton:
        return const ButtonConfig(
          label: 'Upload',
          icon: FontAwesomeIcons.cloudUploadAlt,
          backgroundColor: AppTheme.lightBlueColor,
          borderColor: AppTheme.lightBlueColor,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.buttonWidth,
          height: AppTheme.buttonHeight,
          iconSize: 24.0,
          textSize: AppTheme.buttonTextSize,
          iconSpacing: 4.0,
          category: ButtonCategory.action,
        );
      
      // Botões de administração
      case ButtonType.settingsButton:
        return const ButtonConfig(
          label: 'Settings',
          icon: FontAwesomeIcons.cogs,
          backgroundColor: AppTheme.darkGrayColor,
          borderColor: AppTheme.darkGrayColor,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.buttonWidth,
          height: AppTheme.buttonHeight,
          iconSize: 24.0,
          textSize: AppTheme.buttonTextSize,
          iconSpacing: 4.0,
          category: ButtonCategory.utility,
        );
        
      case ButtonType.usersButton:
        return const ButtonConfig(
          label: 'Users',
          icon: FontAwesomeIcons.users,
          backgroundColor: AppTheme.tealColor,
          borderColor: AppTheme.tealColor,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.buttonWidth,
          height: AppTheme.buttonHeight,
          iconSize: 24.0,
          textSize: AppTheme.buttonTextSize,
          iconSpacing: 4.0,
          category: ButtonCategory.utility,
        );
        
      case ButtonType.workersButton:
        return const ButtonConfig(
          label: 'Workers',
          icon: FontAwesomeIcons.users,
          backgroundColor: AppTheme.brownColor,
          borderColor: AppTheme.brownColor,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.buttonWidth,
          height: AppTheme.buttonHeight,
          iconSize: 24.0,
          textSize: AppTheme.buttonTextSize,
          iconSpacing: 4.0,
          category: ButtonCategory.utility,
        );
        
      case ButtonType.cardsButton:
        return const ButtonConfig(
          label: 'Cards',
          icon: FontAwesomeIcons.creditCard,
          backgroundColor: AppTheme.pinkColor,
          borderColor: AppTheme.pinkColor,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.buttonWidth,
          height: AppTheme.buttonHeight,
          iconSize: 24.0,
          textSize: AppTheme.buttonTextSize,
          iconSpacing: 4.0,
          category: ButtonCategory.utility,
        );
      
      // Botões de edição/modificação
      case ButtonType.editButton:
        return const ButtonConfig(
          label: 'Edit',
          icon: FontAwesomeIcons.edit,
          backgroundColor: AppTheme.blueColor,
          borderColor: AppTheme.blueColor,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.buttonWidth,
          height: AppTheme.buttonHeight,
          iconSize: 24.0,
          textSize: AppTheme.buttonTextSize,
          iconSpacing: 4.0,
          category: ButtonCategory.action,
        );
        
      case ButtonType.clearButton:
        return const ButtonConfig(
          label: 'Clear',
          icon: FontAwesomeIcons.broom,
          backgroundColor: AppTheme.primaryYellow,
          borderColor: AppTheme.primaryYellow,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.buttonWidth,
          height: AppTheme.buttonHeight,
          iconSize: 24.0,
          textSize: AppTheme.buttonTextSize,
          iconSpacing: 4.0,
          category: ButtonCategory.action,
        );
        
      case ButtonType.columnsButton:
        return const ButtonConfig(
          label: 'Columns',
          icon: FontAwesomeIcons.columns,
          backgroundColor: AppTheme.lightGrayColor,
          borderColor: AppTheme.lightGrayColor,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.buttonWidth,
          height: AppTheme.buttonHeight,
          iconSize: 24.0,
          textSize: AppTheme.buttonTextSize,
          iconSpacing: 4.0,
          category: ButtonCategory.utility,
        );
        
      case ButtonType.searchButton:
        return const ButtonConfig(
          label: 'Search',
          icon: FontAwesomeIcons.search,
          backgroundColor: AppTheme.indigoColor,
          borderColor: AppTheme.indigoColor,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.buttonWidth,
          height: AppTheme.buttonHeight,
          iconSize: 24.0,
          textSize: AppTheme.buttonTextSize,
          iconSpacing: 4.0,
          category: ButtonCategory.utility,
        );

      case ButtonType.sortButton:
        return const ButtonConfig(
          label: 'Sort',
          icon: FontAwesomeIcons.sort,
          backgroundColor: AppTheme.purpleDeepColor,
          borderColor: AppTheme.purpleDeepColor,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.buttonWidth,
          height: AppTheme.buttonHeight,
          iconSize: 24.0,
          textSize: AppTheme.buttonTextSize,
          iconSpacing: 4.0,
          category: ButtonCategory.utility,
        );
      
      // Botões de cancelamento/remoção
      case ButtonType.cancelButton:
        return const ButtonConfig(
          label: 'Cancel',
          icon: FontAwesomeIcons.timesCircle,
          backgroundColor: AppTheme.primaryRed,
          borderColor: AppTheme.primaryRed,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.buttonWidth,
          height: AppTheme.buttonHeight,
          iconSize: 24.0,
          textSize: AppTheme.buttonTextSize,
          iconSpacing: 4.0,
          category: ButtonCategory.destructive,
        );
        
      case ButtonType.deleteButton:
        return const ButtonConfig(
          label: 'Delete',
          icon: FontAwesomeIcons.trash,
          backgroundColor: AppTheme.primaryRed,
          borderColor: AppTheme.primaryRed,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.buttonWidth,
          height: AppTheme.buttonHeight,
          iconSize: 24.0,
          textSize: AppTheme.buttonTextSize,
          iconSpacing: 4.0,
          category: ButtonCategory.destructive,
        );
    }
  }
}

/// Define os tipos de mini botões disponíveis no aplicativo (botões menores e apenas texto)
enum MiniButtonType {
  saveMiniButton,
  cancelMiniButton,
  clearMiniButton,
  addMiniButton,
  noteMiniButton,
  sortMiniButton,
  deleteMiniButton,
  editMiniButton,
  rangeMiniButton,
  ascMiniButton,
  descMiniButton,
  applyMiniButton,
  clearAllMiniButton,
  closeMiniButton,
  selectAllMiniButton,
  deselectAllMiniButton,
}

extension MiniButtonTypeConfig on MiniButtonType {
  ButtonConfig get config {
    const defaultTextSize = 14.0;
    switch (this) {
      case MiniButtonType.saveMiniButton:
        return const ButtonConfig(
          label: 'Save',
          icon: null,
          backgroundColor: AppTheme.primaryGreen,
          borderColor: AppTheme.primaryGreen,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.miniButtonWidth,
          height: AppTheme.miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
          category: ButtonCategory.action,
        );
      case MiniButtonType.cancelMiniButton:
        return const ButtonConfig(
          label: 'Cancel',
          icon: null,
          backgroundColor: AppTheme.primaryRed,
          borderColor: AppTheme.primaryRed,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.miniButtonWidth,
          height: AppTheme.miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
          category: ButtonCategory.destructive,
        );
      case MiniButtonType.clearMiniButton:
        return const ButtonConfig(
          label: 'Clear',
          icon: null,
          backgroundColor: AppTheme.primaryYellow,
          borderColor: AppTheme.primaryYellow,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.miniButtonWidth,
          height: AppTheme.miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
          category: ButtonCategory.action,
        );
      case MiniButtonType.addMiniButton:
        return const ButtonConfig(
          label: 'Add',
          icon: null,
          backgroundColor: AppTheme.primaryGreen,
          borderColor: AppTheme.primaryGreen,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.miniButtonWidth,
          height: AppTheme.miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
          category: ButtonCategory.action,
        );
      case MiniButtonType.noteMiniButton:
        return const ButtonConfig(
          label: 'Note',
          icon: null,
          backgroundColor: AppTheme.noteColor, // Usando a cor atualizada
          borderColor: AppTheme.noteColor,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.miniButtonWidth,
          height: AppTheme.miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
          category: ButtonCategory.action,
        );
      case MiniButtonType.sortMiniButton:
        return const ButtonConfig(
          label: 'Sort',
          icon: null,
          backgroundColor: AppTheme.purpleDeepColor,
          borderColor: AppTheme.purpleDeepColor,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.miniButtonWidth,
          height: AppTheme.miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
          category: ButtonCategory.utility,
        );
      case MiniButtonType.deleteMiniButton:
        return const ButtonConfig(
          label: 'Delete',
          icon: null,
          backgroundColor: AppTheme.pdfRedColor, // Usando a cor atualizada
          borderColor: AppTheme.pdfRedColor,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.miniButtonWidth,
          height: AppTheme.miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
          category: ButtonCategory.destructive,
        );
      case MiniButtonType.editMiniButton:
        return const ButtonConfig(
          label: 'Edit',
          icon: null,
          backgroundColor: AppTheme.blueColor,
          borderColor: AppTheme.blueColor,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.miniButtonWidth,
          height: AppTheme.miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
          category: ButtonCategory.action,
        );
      case MiniButtonType.rangeMiniButton:
        return const ButtonConfig(
          label: 'Range',
          icon: null,
          backgroundColor: AppTheme.lightBlueColor,
          borderColor: AppTheme.lightBlueColor,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.miniButtonWidth,
          height: AppTheme.miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
          category: ButtonCategory.utility,
        );
      case MiniButtonType.ascMiniButton:
        return const ButtonConfig(
          label: 'Asc',
          icon: null,
          backgroundColor: AppTheme.primaryBlue,
          borderColor: AppTheme.primaryBlue,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.miniButtonWidth,
          height: AppTheme.miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
          category: ButtonCategory.utility,
        );
      case MiniButtonType.descMiniButton:
        return const ButtonConfig(
          label: 'Desc',
          icon: null,
          backgroundColor: AppTheme.primaryBlue,
          borderColor: AppTheme.primaryBlue,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.miniButtonWidth,
          height: AppTheme.miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
          category: ButtonCategory.utility,
        );
      case MiniButtonType.applyMiniButton:
        return const ButtonConfig(
          label: 'Apply',
          icon: null,
          backgroundColor: AppTheme.primaryGreen,
          borderColor: AppTheme.primaryGreen,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.miniButtonWidth,
          height: AppTheme.miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
          category: ButtonCategory.action,
        );
      case MiniButtonType.clearAllMiniButton:
        return const ButtonConfig(
          label: 'None',
          icon: null,
          backgroundColor: AppTheme.pdfRedColor, // Usando a cor atualizada
          borderColor: AppTheme.pdfRedColor,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.miniButtonWidth,
          height: AppTheme.miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
          category: ButtonCategory.destructive,
        );
      case MiniButtonType.closeMiniButton:
        return const ButtonConfig(
          label: 'Close',
          icon: null,
          backgroundColor: AppTheme.mediumGrayColor, // Usando a cor atualizada
          borderColor: AppTheme.mediumGrayColor,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.miniButtonWidth,
          height: AppTheme.miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
          category: ButtonCategory.utility,
        );
      case MiniButtonType.selectAllMiniButton:
        return const ButtonConfig(
          label: 'All',
          icon: null,
          backgroundColor: AppTheme.primaryBlue,
          borderColor: AppTheme.primaryBlue,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.miniButtonWidth,
          height: AppTheme.miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
          category: ButtonCategory.utility,
        );
      case MiniButtonType.deselectAllMiniButton:
        return const ButtonConfig(
          label: 'None',
          icon: null,
          backgroundColor: AppTheme.lightGrayAltColor, // Usando a cor atualizada
          borderColor: AppTheme.lightGrayAltColor,
          textColor: AppTheme.textLightColor,
          iconColor: AppTheme.textLightColor,
          width: AppTheme.miniButtonWidth,
          height: AppTheme.miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
          category: ButtonCategory.utility,
        );
    }
  }
}

/// Widget principal que implementa o botão
class AppButton extends StatelessWidget {
  final ButtonConfig config;
  final VoidCallback onPressed;
  final bool semanticsLabel;
  final AppButtonStyle buttonStyle;
  final double? minWidth;
  final bool isExpanded;

  /// Creates a standard app button with consistent styling.
  /// 
  /// The [config] parameter defines the appearance of the button.
  /// The [onPressed] callback is called when the button is tapped.
  /// Set [semanticsLabel] to true to add semantic label for accessibility.
  /// The [buttonStyle] defines the visual style (filled, outline, text, icon).
  /// Set [isExpanded] to true to make the button expand to its parent width.
  /// Use [minWidth] to set a minimum width for flexible buttons.
  const AppButton({
    Key? key,
    required this.config,
    required this.onPressed,
    this.semanticsLabel = true,
    this.buttonStyle = AppButtonStyle.filled,
    this.minWidth,
    this.isExpanded = false,
  }) : super(key: key);
  
  /// Creates a standard button from a [ButtonType].
  /// 
  /// The [type] parameter specifies which predefined button style to use.
  /// The [onPressed] callback is called when the button is tapped.
  factory AppButton.fromType({
    required ButtonType type,
    required VoidCallback onPressed,
    AppButtonStyle buttonStyle = AppButtonStyle.filled,
    bool semanticsLabel = true,
    double? minWidth,
    bool isExpanded = false,
    Key? key,
  }) {
    return AppButton(
      key: key,
      config: type.config,
      onPressed: onPressed,
      semanticsLabel: semanticsLabel,
      buttonStyle: buttonStyle,
      minWidth: minWidth,
      isExpanded: isExpanded,
    );
  }

  /// Creates a mini button from a [MiniButtonType].
  /// 
  /// The [type] parameter specifies which predefined mini button style to use.
  /// The [onPressed] callback is called when the button is tapped.
  factory AppButton.mini({
    required MiniButtonType type,
    required VoidCallback onPressed,
    AppButtonStyle buttonStyle = AppButtonStyle.filled,
    bool semanticsLabel = true,
    bool isExpanded = false,
    Key? key,
  }) {
    return AppButton(
      key: key,
      config: type.config,
      onPressed: onPressed,
      semanticsLabel: semanticsLabel,
      buttonStyle: buttonStyle,
      isExpanded: isExpanded,
    );
  }
  
  /// Creates a flexible width button from a [ButtonType].
  /// 
  /// Creates a button that can expand horizontally based on content.
  /// The [minWidth] parameter sets a minimum width for the button.
  factory AppButton.flexible({
    required ButtonType type,
    required VoidCallback onPressed,
    AppButtonStyle buttonStyle = AppButtonStyle.filled,
    double minWidth = 100.0,
    bool semanticsLabel = true,
    Key? key,
  }) {
    var config = type.config.copyWith(width: 0);
    return AppButton(
      key: key,
      config: config,
      onPressed: onPressed,
      semanticsLabel: semanticsLabel,
      buttonStyle: buttonStyle,
      minWidth: minWidth,
    );
  }
  
  /// Creates an icon-only button from a [ButtonType].
  ///
  /// Creates a square button with only the icon visible.
  factory AppButton.icon({
    required ButtonType type,
    required VoidCallback onPressed,
    bool semanticsLabel = true,
    Key? key,
  }) {
    // Verificar se o tipo de botão tem ícone
    if (type.config.icon == null) {
      throw ArgumentError('ButtonType used with .icon() must have an icon defined');
    }
    
    var config = type.config.toIconStyle();
    return AppButton(
      key: key,
      config: config,
      onPressed: onPressed,
      semanticsLabel: semanticsLabel,
      buttonStyle: AppButtonStyle.icon,
    );
  }
  
  /// Creates an outline button from a [ButtonType].
  ///
  /// Creates a button with a border and transparent background.
  factory AppButton.outline({
    required ButtonType type,
    required VoidCallback onPressed,
    bool semanticsLabel = true,
    bool isExpanded = false,
    Key? key,
  }) {
    return AppButton(
      key: key,
      config: type.config,
      onPressed: onPressed,
      semanticsLabel: semanticsLabel,
      buttonStyle: AppButtonStyle.outline,
      isExpanded: isExpanded,
    );
  }
  
  /// Creates a text button from a [ButtonType].
  ///
  /// Creates a button with no background or border, just text.
  factory AppButton.text({
    required ButtonType type,
    required VoidCallback onPressed,
    bool semanticsLabel = true,
    bool isExpanded = false,
    Key? key,
  }) {
    return AppButton(
      key: key,
      config: type.config,
      onPressed: onPressed,
      semanticsLabel: semanticsLabel,
      buttonStyle: AppButtonStyle.text,
      isExpanded: isExpanded,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Aplicar estilo com base no buttonStyle
    ButtonConfig effectiveConfig = config;
    
    switch (buttonStyle) {
      case AppButtonStyle.filled:
        // Já é o estilo padrão, não precisa alterar
        break;
      case AppButtonStyle.outline:
        effectiveConfig = config.toOutlineStyle();
        break;
      case AppButtonStyle.text:
        effectiveConfig = config.toTextStyle();
        break;
      case AppButtonStyle.icon:
        effectiveConfig = config.toIconStyle();
        break;
    }
    
    // Determinar o conteúdo do botão com base no estilo
    final Widget buttonContent = buttonStyle == AppButtonStyle.icon
        ? _buildIconOnlyButton(effectiveConfig)
        : effectiveConfig.icon != null
            ? _buildIconLabelButton(effectiveConfig)
            : _buildLabelOnlyButton(effectiveConfig);

    // Construir o botão com tamanho adequado
    Widget button = _buildButtonContainer(effectiveConfig, buttonContent);
    
    // Adicionar semântica se solicitado
    if (semanticsLabel) {
      button = Semantics(
        button: true,
        label: effectiveConfig.label,
        enabled: true,
        child: button,
      );
    }
    
    // Envolver em um Expanded se for necessário expandir
    if (isExpanded) {
      return Expanded(child: button);
    }
    
    return button;
  }
  
  /// Constrói o contêiner do botão com as dimensões adequadas
  Widget _buildButtonContainer(ButtonConfig cfg, Widget content) {
    // Para botões com largura flexível
    if (cfg.width == 0 || isExpanded) {
      return Container(
        constraints: minWidth != null 
            ? BoxConstraints(minWidth: minWidth!) 
            : null,
        height: cfg.height,
        child: _buildElevatedButton(cfg, content),
      );
    }
    
    // Para botões com largura fixa
    return SizedBox(
      width: cfg.width,
      height: cfg.height,
      child: _buildElevatedButton(cfg, content),
    );
  }
  
  /// Constrói o botão elevado com estilo e estados
  Widget _buildElevatedButton(ButtonConfig cfg, Widget content) {
    return ElevatedButton(
      onPressed: onPressed,
      style: _getButtonStyle(cfg),
      child: content,
    );
  }
  
  /// Obtém o estilo do botão com base na configuração
  ButtonStyle _getButtonStyle(ButtonConfig cfg) {
    return AppTheme.elevatedButtonStyle(
      backgroundColor: cfg.backgroundColor,
      borderColor: cfg.borderColor,
    ).copyWith(
      // Adicionar estados de hover, pressed e focus
      overlayColor: MaterialStateProperty.resolveWith((states) {
        // Se for um botão outline ou text, usa a cor da borda com opacidade
        final baseColor = (buttonStyle == AppButtonStyle.outline || buttonStyle == AppButtonStyle.text)
            ? cfg.borderColor
            : cfg.backgroundColor;
            
        if (states.contains(MaterialState.pressed)) {
          return baseColor.withOpacity(0.7);
        }
        if (states.contains(MaterialState.hovered)) {
          return baseColor.withOpacity(0.1);
        }
        if (states.contains(MaterialState.focused)) {
          return baseColor.withOpacity(0.2);
        }
        return null;
      }),
      // Melhorar a animação de transição
      animationDuration: const Duration(milliseconds: 200),
      // Adicionar sombra sutil para botões filled
      elevation: buttonStyle == AppButtonStyle.filled
          ? MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) return 1.0;
              if (states.contains(MaterialState.hovered)) return 4.0;
              return 2.0;
            })
          : MaterialStateProperty.all(0),
    );
  }

  /// Constrói um botão com ícone e texto
  Widget _buildIconLabelButton(ButtonConfig cfg) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calcular espaço disponível considerando a espessura da borda
        final availableWidth = constraints.maxWidth - (AppTheme.mediumBorder * 2);
        final availableHeight = constraints.maxHeight - (AppTheme.mediumBorder * 2);
        
        // Alocar espaço para ícone e texto
        final iconHeight = availableHeight * 0.6;
        final textHeight = availableHeight * 0.3;
        
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícone com tamanho proporcional
            SizedBox(
              height: iconHeight,
              child: FittedBox(
                fit: BoxFit.contain,
                child: FaIcon(
                  cfg.icon,
                  color: cfg.iconColor,
                ),
              ),
            ),
            SizedBox(height: availableHeight * 0.1), // Espaço entre ícone e texto
            // Texto com tamanho adaptável
            SizedBox(
              height: textHeight,
              width: availableWidth * 0.9, // 90% da largura disponível
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  cfg.label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: cfg.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Constrói um botão apenas com texto
  Widget _buildLabelOnlyButton(ButtonConfig cfg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            cfg.label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: cfg.textColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
  
  /// Constrói um botão apenas com ícone
  Widget _buildIconOnlyButton(ButtonConfig cfg) {
    return Center(
      child: FaIcon(
        cfg.icon,
        color: cfg.iconColor,
        size: cfg.iconSize,
      ),
    );
  }
}