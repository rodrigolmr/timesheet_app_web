// lib/pages/button_showcase_page.dart

import 'package:flutter/material.dart';
import 'package:timesheet_app_web/core/theme/app_theme.dart';
import 'package:timesheet_app_web/widgets/app_button.dart';
import 'package:timesheet_app_web/widgets/base_layout.dart';

class ButtonShowcasePage extends StatelessWidget {
  static const String routeName = '/button-showcase';
  
  const ButtonShowcasePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'Button Showcase',
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.defaultSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SEÇÃO 1: Botões Padrão Agrupados por Categoria
              _buildSectionHeader('Botões por Categoria'),
              const SizedBox(height: AppTheme.smallSpacing),
              
              _buildSubsectionHeader('Navegação'),
              _buildButtonGrid([
                ButtonType.backButton,
                ButtonType.nextButton,
              ], AppButtonStyle.filled),
              
              const SizedBox(height: AppTheme.defaultSpacing),
              _buildSubsectionHeader('Ações'),
              _buildButtonGrid([
                ButtonType.newButton,
                ButtonType.submitButton,
                ButtonType.saveButton,
                ButtonType.editButton,
                ButtonType.clearButton,
                ButtonType.loginButton,
              ], AppButtonStyle.filled),
              
              const SizedBox(height: AppTheme.defaultSpacing),
              _buildSubsectionHeader('Itens'),
              _buildButtonGrid([
                ButtonType.addWorkerButton,
                ButtonType.addUserButton,
                ButtonType.addCardButton,
                ButtonType.workersButton,
                ButtonType.usersButton,
                ButtonType.cardsButton,
              ], AppButtonStyle.filled),
              
              const SizedBox(height: AppTheme.defaultSpacing),
              _buildSubsectionHeader('Documentos'),
              _buildButtonGrid([
                ButtonType.sheetsButton,
                ButtonType.receiptsButton,
                ButtonType.pdfButton,
                ButtonType.uploadReceiptButton,
              ], AppButtonStyle.filled),
              
              const SizedBox(height: AppTheme.defaultSpacing),
              _buildSubsectionHeader('Utilitários'),
              _buildButtonGrid([
                ButtonType.settingsButton,
                ButtonType.searchButton,
                ButtonType.columnsButton,
              ], AppButtonStyle.filled),
              
              const SizedBox(height: AppTheme.defaultSpacing),
              _buildSubsectionHeader('Destrutivos'),
              _buildButtonGrid([
                ButtonType.cancelButton,
                ButtonType.deleteButton,
              ], AppButtonStyle.filled),
              
              const SizedBox(height: AppTheme.extraLargeSpacing),
              
              // SEÇÃO 2: Variantes de Estilo
              _buildSectionHeader('Variantes de Estilo'),
              
              const SizedBox(height: AppTheme.defaultSpacing),
              _buildSubsectionHeader('Estilo Outline'),
              _buildButtonGrid([
                ButtonType.newButton,
                ButtonType.editButton,
                ButtonType.submitButton,
                ButtonType.cancelButton,
                ButtonType.sheetsButton,
              ], AppButtonStyle.outline),
              
              const SizedBox(height: AppTheme.defaultSpacing),
              _buildSubsectionHeader('Estilo Texto'),
              _buildButtonGrid([
                ButtonType.newButton,
                ButtonType.editButton,
                ButtonType.submitButton,
                ButtonType.cancelButton,
                ButtonType.sheetsButton,
              ], AppButtonStyle.text),
              
              const SizedBox(height: AppTheme.defaultSpacing),
              _buildSubsectionHeader('Estilo Icon-Only'),
              _buildButtonIconGrid([
                ButtonType.newButton,
                ButtonType.editButton,
                ButtonType.submitButton,
                ButtonType.cancelButton,
                ButtonType.searchButton,
              ]),
              
              const SizedBox(height: AppTheme.extraLargeSpacing),
              
              // SEÇÃO 3: Botões Flexíveis e Expandidos
              _buildSectionHeader('Botões Adaptáveis'),
              
              const SizedBox(height: AppTheme.defaultSpacing),
              _buildSubsectionHeader('Botões com Largura Flexível'),
              Wrap(
                spacing: AppTheme.defaultSpacing,
                runSpacing: AppTheme.defaultSpacing,
                children: [
                  AppButton.flexible(
                    type: ButtonType.submitButton,
                    onPressed: () {},
                    minWidth: 150,
                  ),
                  AppButton.flexible(
                    type: ButtonType.addWorkerButton,
                    onPressed: () {},
                    minWidth: 150,
                  ),
                  AppButton.flexible(
                    type: ButtonType.loginButton, 
                    onPressed: () {},
                    minWidth: 120,
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.defaultSpacing),
              _buildSubsectionHeader('Botões em Linha (expanded)'),
              Row(
                children: [
                  AppButton.fromType(
                    type: ButtonType.cancelButton,
                    onPressed: () {},
                    isExpanded: true,
                  ),
                  const SizedBox(width: AppTheme.smallSpacing),
                  AppButton.fromType(
                    type: ButtonType.submitButton,
                    onPressed: () {},
                    isExpanded: true,
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.extraLargeSpacing),
              
              // SEÇÃO 4: Mini Botões
              _buildSectionHeader('Mini Botões'),
              const SizedBox(height: AppTheme.defaultSpacing),
              
              _buildSubsectionHeader('Mini Buttons - Filled'),
              _buildMiniButtonGrid([
                MiniButtonType.saveMiniButton,
                MiniButtonType.cancelMiniButton,
                MiniButtonType.clearMiniButton,
                MiniButtonType.addMiniButton,
                MiniButtonType.noteMiniButton,
                MiniButtonType.sortMiniButton,
                MiniButtonType.deleteMiniButton,
                MiniButtonType.editMiniButton,
              ], AppButtonStyle.filled),
              
              const SizedBox(height: AppTheme.smallSpacing),
              _buildMiniButtonGrid([
                MiniButtonType.rangeMiniButton,
                MiniButtonType.ascMiniButton,
                MiniButtonType.descMiniButton,
                MiniButtonType.applyMiniButton,
                MiniButtonType.clearAllMiniButton,
                MiniButtonType.closeMiniButton,
                MiniButtonType.selectAllMiniButton,
                MiniButtonType.deselectAllMiniButton,
              ], AppButtonStyle.filled),
              
              const SizedBox(height: AppTheme.defaultSpacing),
              _buildSubsectionHeader('Mini Buttons - Outline'),
              _buildMiniButtonGrid([
                MiniButtonType.saveMiniButton,
                MiniButtonType.cancelMiniButton,
                MiniButtonType.clearMiniButton,
                MiniButtonType.addMiniButton,
                MiniButtonType.deleteMiniButton,
                MiniButtonType.editMiniButton,
              ], AppButtonStyle.outline),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: AppTheme.titleTextSize,
        fontWeight: FontWeight.bold,
        color: AppTheme.primaryBlue,
      ),
    );
  }
  
  Widget _buildSubsectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: AppTheme.bodyTextSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildButtonGrid(List<ButtonType> buttonTypes, AppButtonStyle style) {
    return Wrap(
      spacing: AppTheme.defaultSpacing,
      runSpacing: AppTheme.defaultSpacing,
      children: buttonTypes.map((type) {
        return AppButton.fromType(
          type: type,
          onPressed: () {},
          buttonStyle: style,
        );
      }).toList(),
    );
  }
  
  Widget _buildButtonIconGrid(List<ButtonType> buttonTypes) {
    return Wrap(
      spacing: AppTheme.defaultSpacing,
      runSpacing: AppTheme.defaultSpacing,
      children: buttonTypes.map((type) {
        return AppButton.icon(
          type: type,
          onPressed: () {},
        );
      }).toList(),
    );
  }

  Widget _buildMiniButtonGrid(List<MiniButtonType> buttonTypes, AppButtonStyle style) {
    return Wrap(
      spacing: AppTheme.smallSpacing,
      runSpacing: AppTheme.smallSpacing,
      children: buttonTypes.map((type) {
        return AppButton.mini(
          type: type,
          onPressed: () {},
          buttonStyle: style,
        );
      }).toList(),
    );
  }
}