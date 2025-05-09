// lib/widgets/buttons.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  });
}

enum ButtonType {
  newButton,
  sheetsButton,
  receiptsButton,
  settingsButton,
  cancelButton,
  clearButton,
  nextButton,
  backButton,
  addWorkerButton,
  submitButton,
  editButton,
  pdfButton,
  addUserButton,
  addCardButton, // Added new button type
  loginButton,
  usersButton,
  workersButton,
  uploadReceiptButton,
  cardsButton,
  columnsButton,
  searchButton,
}

extension ButtonTypeConfig on ButtonType {
  ButtonConfig get config {
    const defaultSize = 50.0; // Alterado de 60.0 para 50.0
    const defaultIconSize = 24.0;
    const defaultTextSize = 12.0;
    const defaultSpacing = 4.0;
    switch (this) {
      case ButtonType.newButton:
        return const ButtonConfig(
          label: 'New',
          icon: FontAwesomeIcons.plus,
          backgroundColor: Color(0xFF17DB4E),
          borderColor: Color(0xFF17DB4E),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: defaultSize,
          height: defaultSize,
          iconSize: defaultIconSize,
          textSize: defaultTextSize,
          iconSpacing: defaultSpacing,
        );
      case ButtonType.sheetsButton:
        return const ButtonConfig(
          label: 'Sheets',
          icon: FontAwesomeIcons.fileExcel,
          backgroundColor: Color(0xFF6E44FF),
          borderColor: Color(0xFF6E44FF),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: defaultSize,
          height: defaultSize,
          iconSize: defaultIconSize,
          textSize: defaultTextSize,
          iconSpacing: defaultSpacing,
        );
      case ButtonType.receiptsButton:
        return const ButtonConfig(
          label: 'Receipts',
          icon: FontAwesomeIcons.fileInvoiceDollar,
          backgroundColor: Color(0xFFFF9800),
          borderColor: Color(0xFFFF9800),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: defaultSize,
          height: defaultSize,
          iconSize: defaultIconSize,
          textSize: defaultTextSize,
          iconSpacing: defaultSpacing,
        );
      case ButtonType.settingsButton:
        return const ButtonConfig(
          label: 'Settings',
          icon: FontAwesomeIcons.cogs,
          backgroundColor: Color(0xFF444444),
          borderColor: Color(0xFF444444),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: defaultSize,
          height: defaultSize,
          iconSize: defaultIconSize,
          textSize: defaultTextSize,
          iconSpacing: defaultSpacing,
        );
      case ButtonType.cancelButton:
        return const ButtonConfig(
          label: 'Cancel',
          icon: FontAwesomeIcons.timesCircle,
          backgroundColor: Color(0xFFDE4545),
          borderColor: Color(0xFFDE4545),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: defaultSize,
          height: defaultSize,
          iconSize: defaultIconSize,
          textSize: defaultTextSize,
          iconSpacing: defaultSpacing,
        );
      case ButtonType.clearButton:
        return const ButtonConfig(
          label: 'Clear',
          icon: FontAwesomeIcons.broom,
          backgroundColor: Color(0xFFFAB515),
          borderColor: Color(0xFFFAB515),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: defaultSize,
          height: defaultSize,
          iconSize: defaultIconSize,
          textSize: defaultTextSize,
          iconSpacing: defaultSpacing,
        );
      case ButtonType.nextButton:
        return const ButtonConfig(
          label: 'Next',
          icon: FontAwesomeIcons.arrowRight,
          backgroundColor: Color(0xFF0205D3),
          borderColor: Color(0xFF0205D3),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: defaultSize,
          height: defaultSize,
          iconSize: defaultIconSize,
          textSize: defaultTextSize,
          iconSpacing: defaultSpacing,
        );
      case ButtonType.backButton:
        return const ButtonConfig(
          label: 'Back',
          icon: FontAwesomeIcons.arrowLeft,
          backgroundColor: Color(0xFF0205D3),
          borderColor: Color(0xFF0205D3),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: defaultSize,
          height: defaultSize,
          iconSize: defaultIconSize,
          textSize: defaultTextSize,
          iconSpacing: defaultSpacing,
        );
      case ButtonType.addWorkerButton:
        return const ButtonConfig(
          label: 'Add Worker',
          icon: FontAwesomeIcons.userPlus,
          backgroundColor: Color(0xFF17DB4E),
          borderColor: Color(0xFF17DB4E),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: defaultSize,
          height: defaultSize,
          iconSize: defaultIconSize,
          textSize: 10.0,
          iconSpacing: defaultSpacing,
        );
      case ButtonType.submitButton:
        return const ButtonConfig(
          label: 'Submit',
          icon: FontAwesomeIcons.checkCircle,
          backgroundColor: Color(0xFF17DB4E),
          borderColor: Color(0xFF17DB4E),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: defaultSize,
          height: defaultSize,
          iconSize: defaultIconSize,
          textSize: defaultTextSize,
          iconSpacing: defaultSpacing,
        );
      case ButtonType.editButton:
        return const ButtonConfig(
          label: 'Edit',
          icon: FontAwesomeIcons.edit,
          backgroundColor: Color(0xFF2196F3),
          borderColor: Color(0xFF2196F3),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: defaultSize,
          height: defaultSize,
          iconSize: defaultIconSize,
          textSize: defaultTextSize,
          iconSpacing: defaultSpacing,
        );
      case ButtonType.pdfButton:
        return const ButtonConfig(
          label: 'PDF',
          icon: FontAwesomeIcons.filePdf,
          backgroundColor: Color(0xFFFF0000),
          borderColor: Color(0xFFFF0000),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: defaultSize,
          height: defaultSize,
          iconSize: 22.0,
          textSize: defaultTextSize,
          iconSpacing: defaultSpacing,
        );
      case ButtonType.addUserButton:
        return const ButtonConfig(
          label: 'Add user',
          icon: FontAwesomeIcons.userPlus,
          backgroundColor: Color(0xFF17DB4E),
          borderColor: Color(0xFF17DB4E),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: defaultSize,
          height: defaultSize,
          iconSize: 22.0,
          textSize: 10.0,
          iconSpacing: defaultSpacing,
        );
      case ButtonType.addCardButton:
        return const ButtonConfig(
          label: 'Add card',
          icon: FontAwesomeIcons.creditCard,
          backgroundColor: Color(0xFF17DB4E),
          borderColor: Color(0xFF17DB4E),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: defaultSize,
          height: defaultSize,
          iconSize: 22.0,
          textSize: 10.0,
          iconSpacing: defaultSpacing,
        );
      case ButtonType.loginButton:
        return const ButtonConfig(
          label: 'Login',
          icon: FontAwesomeIcons.signInAlt,
          backgroundColor: Color(0xFF17DB4E),
          borderColor: Color(0xFF17DB4E),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: defaultSize,
          height: defaultSize,
          iconSize: defaultIconSize,
          textSize: defaultTextSize,
          iconSpacing: defaultSpacing,
        );
      case ButtonType.usersButton:
        return const ButtonConfig(
          label: 'Users',
          icon: FontAwesomeIcons.users,
          backgroundColor: Color(0xFF009688),
          borderColor: Color(0xFF009688),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: defaultSize,
          height: defaultSize,
          iconSize: defaultIconSize,
          textSize: defaultTextSize,
          iconSpacing: defaultSpacing,
        );
      case ButtonType.workersButton:
        return const ButtonConfig(
          label: 'Workers',
          icon: FontAwesomeIcons.users,
          backgroundColor: Color(0xFF6B4423),
          borderColor: Color(0xFF6B4423),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: defaultSize,
          height: defaultSize,
          iconSize: defaultIconSize,
          textSize: defaultTextSize,
          iconSpacing: defaultSpacing,
        );
      case ButtonType.uploadReceiptButton:
        return const ButtonConfig(
          label: 'Upload',
          icon: FontAwesomeIcons.cloudUploadAlt,
          backgroundColor: Color(0xFF0277BD),
          borderColor: Color(0xFF0277BD),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: defaultSize,
          height: defaultSize,
          iconSize: defaultIconSize,
          textSize: defaultTextSize,
          iconSpacing: defaultSpacing,
        );
      case ButtonType.cardsButton:
        return const ButtonConfig(
          label: 'Cards',
          icon: FontAwesomeIcons.creditCard,
          backgroundColor: Color(0xFFD81B60),
          borderColor: Color(0xFFD81B60),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: defaultSize,
          height: defaultSize,
          iconSize: defaultIconSize,
          textSize: defaultTextSize,
          iconSpacing: defaultSpacing,
        );
      case ButtonType.columnsButton:
        return const ButtonConfig(
          label: 'Columns',
          icon: FontAwesomeIcons.columns,
          backgroundColor: Color(0xFFBDBDBD),
          borderColor: Color(0xFFBDBDBD),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: defaultSize,
          height: defaultSize,
          iconSize: defaultIconSize,
          textSize: defaultTextSize,
          iconSpacing: defaultSpacing,
        );
      case ButtonType.searchButton:
        return const ButtonConfig(
          label: 'Search',
          icon: FontAwesomeIcons.search,
          backgroundColor: Color(0xFF3F51B5),
          borderColor: Color(0xFF3F51B5),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: defaultSize,
          height: defaultSize,
          iconSize: defaultIconSize,
          textSize: defaultTextSize,
          iconSpacing: defaultSpacing,
        );
    }
  }
}

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
    const miniButtonHeight = 25.0;
    const miniButtonWidth = 45.0;
    const defaultTextSize = 14.0;
    switch (this) {
      case MiniButtonType.saveMiniButton:
        return const ButtonConfig(
          label: 'Save',
          icon: null,
          backgroundColor: Color(0xFF17DB4E),
          borderColor: Color(0xFF17DB4E),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: miniButtonWidth,
          height: miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
        );
      case MiniButtonType.cancelMiniButton:
        return const ButtonConfig(
          label: 'Cancel',
          icon: null,
          backgroundColor: Color(0xFFDE4545),
          borderColor: Color(0xFFDE4545),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: miniButtonWidth,
          height: miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
        );
      case MiniButtonType.clearMiniButton:
        return const ButtonConfig(
          label: 'Clear',
          icon: null,
          backgroundColor: Color(0xFFFAB515),
          borderColor: Color(0xFFFAB515),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: miniButtonWidth,
          height: miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
        );
      case MiniButtonType.addMiniButton:
        return const ButtonConfig(
          label: 'Add',
          icon: null,
          backgroundColor: Color(0xFF17DB4E),
          borderColor: Color(0xFF17DB4E),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: miniButtonWidth,
          height: miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
        );
      case MiniButtonType.noteMiniButton:
        return const ButtonConfig(
          label: 'Note',
          icon: null,
          backgroundColor: Color(0xFF4287F5),
          borderColor: Color(0xFF4287F5),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: miniButtonWidth,
          height: miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
        );
      case MiniButtonType.sortMiniButton:
        return const ButtonConfig(
          label: 'Sort',
          icon: null,
          backgroundColor: Color(0xFF9C27B0),
          borderColor: Color(0xFF9C27B0),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: miniButtonWidth,
          height: miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
        );
      case MiniButtonType.deleteMiniButton:
        return const ButtonConfig(
          label: 'Delete',
          icon: null,
          backgroundColor: Color(0xFFFF0000),
          borderColor: Color(0xFFFF0000),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: miniButtonWidth,
          height: miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
        );
      case MiniButtonType.editMiniButton:
        return const ButtonConfig(
          label: 'Edit',
          icon: null,
          backgroundColor: Color(0xFF2196F3),
          borderColor: Color(0xFF2196F3),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: miniButtonWidth,
          height: miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
        );
      case MiniButtonType.rangeMiniButton:
        return const ButtonConfig(
          label: 'Range',
          icon: null,
          backgroundColor: Color(0xFF0277BD),
          borderColor: Color(0xFF0277BD),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: miniButtonWidth,
          height: miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
        );
      case MiniButtonType.ascMiniButton:
        return const ButtonConfig(
          label: 'Asc',
          icon: null,
          backgroundColor: Color(0xFF0205D3),
          borderColor: Color(0xFF0205D3),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: miniButtonWidth,
          height: miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
        );
      case MiniButtonType.descMiniButton:
        return const ButtonConfig(
          label: 'Desc',
          icon: null,
          backgroundColor: Color(0xFF0205D3),
          borderColor: Color(0xFF0205D3),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: miniButtonWidth,
          height: miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
        );
      case MiniButtonType.applyMiniButton:
        return const ButtonConfig(
          label: 'Apply',
          icon: null,
          backgroundColor: Color(0xFF17DB4E),
          borderColor: Color(0xFF17DB4E),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: miniButtonWidth,
          height: miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
        );
      case MiniButtonType.clearAllMiniButton:
        return const ButtonConfig(
          label: 'None',
          icon: null,
          backgroundColor: Color(0xFFFF0000),
          borderColor: Color(0xFFFF0000),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: miniButtonWidth,
          height: miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
        );
      case MiniButtonType.closeMiniButton:
        return const ButtonConfig(
          label: 'Close',
          icon: null,
          backgroundColor: Color(0xFF757575),
          borderColor: Color(0xFF757575),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: miniButtonWidth,
          height: miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
        );
      case MiniButtonType.selectAllMiniButton:
        return const ButtonConfig(
          label: 'All',
          icon: null,
          backgroundColor: Color(0xFF0205D3),
          borderColor: Color(0xFF0205D3),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: miniButtonWidth,
          height: miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
        );
      case MiniButtonType.deselectAllMiniButton:
        return const ButtonConfig(
          label: 'None',
          icon: null,
          backgroundColor: Color(0xFF9E9E9E),
          borderColor: Color(0xFF9E9E9E),
          textColor: Colors.white,
          iconColor: Colors.white,
          width: miniButtonWidth,
          height: miniButtonHeight,
          iconSize: 0,
          textSize: defaultTextSize,
          iconSpacing: 0,
        );
    }
  }
}

class AppButton extends StatelessWidget {
  final ButtonConfig config;
  final VoidCallback onPressed;
  const AppButton({Key? key, required this.config, required this.onPressed})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Constante para a largura da borda
    const double borderWidth = 2.0;
    
    return SizedBox(
      width: config.width,
      height: config.height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(config.width, config.height),
          backgroundColor: config.backgroundColor,
          side: BorderSide(color: config.borderColor, width: borderWidth),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          padding: EdgeInsets.zero, // Remove padding interno
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          minimumSize: const Size(0, 0), // Permite tamanhos menores que o padrão
        ),
        child: config.icon != null
            ? LayoutBuilder(
                // Usa o LayoutBuilder para adaptar o conteúdo com base no espaço disponível
                builder: (context, constraints) {
                  // Calcula o espaço interno disponível considerando a borda
                  final availableWidth = constraints.maxWidth - (borderWidth * 2);
                  final availableHeight = constraints.maxHeight - (borderWidth * 2);
                  
                  // Calcula o espaço para o ícone e para o texto
                  // Deixamos ~60% da altura para o ícone em botões regulares
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
                            config.icon,
                            color: config.iconColor,
                          ),
                        ),
                      ),
                      SizedBox(height: availableHeight * 0.1), // 10% de espaço entre ícone e texto
                      // Texto com tamanho adaptável
                      SizedBox(
                        height: textHeight,
                        width: availableWidth * 0.9, // 90% da largura disponível
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            config.label,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: config.textColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )
            : // Para botões sem ícone (apenas texto)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      config.label,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: config.textColor,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
