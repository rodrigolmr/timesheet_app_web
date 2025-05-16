import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timesheet_app_web/src/core/theme/theme.dart';

/// Tela para seleção de temas do aplicativo
class ThemeSelectorScreen extends ConsumerWidget {
  const ThemeSelectorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtém o tema atual
    final currentTheme = ref.watch(themeControllerProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolha de Tema'),
        elevation: 0,
      ),
      floatingActionButton: Semantics(
        label: 'Confirmar seleção de tema e voltar à tela anterior',
        hint: 'Botão para aplicar o tema selecionado e retornar à página anterior',
        button: true,
        child: FloatingActionButton.extended(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.check),
          label: const Text('Confirmar'),
          elevation: 2,
          backgroundColor: Theme.of(context).colorScheme.primary,
          tooltip: 'Confirmar seleção de tema',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              hint: 'Título da tela de seleção de temas',
              child: const Text(
                'Selecione o tema de sua preferência',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            
            // Tema Azul (Light)
            _buildThemeCard(
              context,
              title: 'Azul Corporativo',
              description: 'Tema padrão com tons de azul corporativo',
              variant: ThemeVariant.light,
              isSelected: currentTheme.variant == ThemeVariant.light,
              onSelect: () => _selectTheme(ref, ThemeVariant.light),
            ),
            
            // Tema Dark
            _buildThemeCard(
              context,
              title: 'Tema Escuro',
              description: 'Tema escuro para visualização em ambientes com pouca luz',
              variant: ThemeVariant.dark,
              isSelected: currentTheme.variant == ThemeVariant.dark,
              onSelect: () => _selectTheme(ref, ThemeVariant.dark),
            ),
            
            // Tema Rosa (Feminine)
            _buildThemeCard(
              context,
              title: 'Tema Rosa',
              description: 'Tema com tons de rosa, moderno e vibrante',
              variant: ThemeVariant.feminine,
              isSelected: currentTheme.variant == ThemeVariant.feminine,
              onSelect: () => _selectTheme(ref, ThemeVariant.feminine),
            ),
            
            // Tema Verde
            _buildThemeCard(
              context,
              title: 'Tema Verde',
              description: 'Tema com tons de verde, transmitindo tranquilidade',
              variant: ThemeVariant.green,
              isSelected: currentTheme.variant == ThemeVariant.green,
              onSelect: () => _selectTheme(ref, ThemeVariant.green),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Seleciona um tema e exibe feedback de confirmação
  void _selectTheme(WidgetRef ref, ThemeVariant variant) {
    ref.read(themeControllerProvider.notifier).setTheme(variant);
    
    // Obtenha o contexto do ScaffoldMessenger ao qual podemos anexar o SnackBar
    final scaffoldMessenger = ScaffoldMessenger.of(ref.context);
    
    // Determine o nome do tema para exibir no feedback
    String themeName;
    switch (variant) {
      case ThemeVariant.light:
        themeName = 'Azul Corporativo';
        break;
      case ThemeVariant.dark:
        themeName = 'Tema Escuro';
        break;
      case ThemeVariant.feminine:
        themeName = 'Tema Rosa';
        break;
      case ThemeVariant.green:
        themeName = 'Tema Verde';
        break;
    }
    
    // Exibe um SnackBar com o tema selecionado
    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          'Tema $themeName aplicado com sucesso',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: _getColorForVariant(variant),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
  
  /// Constrói um card para cada opção de tema
  Widget _buildThemeCard(
    BuildContext context, {
    required String title,
    required String description,
    required ThemeVariant variant,
    required bool isSelected,
    required VoidCallback onSelect,
  }) {
    // Define cores baseadas na variante
    final Color primaryColor = _getColorForVariant(variant);
    final Color backgroundColor = isSelected 
      ? primaryColor.withOpacity(0.1) 
      : Colors.transparent;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isSelected ? 2 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: primaryColor, width: 2)
            : BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Semantics(
        label: 'Tema $title',
        hint: 'Selecionar o tema $title. $description',
        button: true,
        checked: isSelected,
        enabled: true,
        child: InkWell(
          onTap: onSelect,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Círculo de cor que representa o tema
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getIconForVariant(variant),
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Título e descrição
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Ícone de seleção
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: primaryColor,
                        size: 28,
                      ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Amostras de cores do tema
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildColorSample(
                      color: primaryColor,
                      label: 'Primária',
                    ),
                    _buildColorSample(
                      color: _getLighterColorForVariant(variant),
                      label: 'Secundária',
                    ),
                    _buildColorSample(
                      color: _getSuccessColorForVariant(variant),
                      label: 'Sucesso',
                    ),
                    _buildColorSample(
                      color: _getWarningColorForVariant(variant),
                      label: 'Alerta',
                    ),
                    _buildColorSample(
                      color: _getErrorColorForVariant(variant),
                      label: 'Erro',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  /// Constrói uma amostra de cor do tema
  Widget _buildColorSample({
    required Color color,
    required String label,
  }) {
    return Semantics(
      label: 'Amostra de cor $label',
      hint: 'Cor $label no tema selecionado',
      child: Column(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Retorna o ícone para a variante de tema
  IconData _getIconForVariant(ThemeVariant variant) {
    switch (variant) {
      case ThemeVariant.light:
        return Icons.wb_sunny;
      case ThemeVariant.dark:
        return Icons.nightlight_round;
      case ThemeVariant.feminine:
        return Icons.spa;
      case ThemeVariant.green:
        return Icons.forest;
    }
  }
  
  /// Retorna a cor primária para uma variante de tema
  Color _getColorForVariant(ThemeVariant variant) {
    // Usar as cores exatas das paletas definidas
    switch (variant) {
      case ThemeVariant.light:
        return const Color(0xFF1565C0); // Azul Corporativo da Palette4CorporateAmber
      case ThemeVariant.dark:
        return const Color(0xFF0D47A1); // Azul escuro para dark mode
      case ThemeVariant.feminine:
        return const Color(0xFFE91E63); // Rosa principal da Palette5PinkSoft
      case ThemeVariant.green:
        return const Color(0xFF00897B); // Verde teal da Palette6GreenFresh
    }
  }
  
  /// Retorna a cor secundária para uma variante de tema
  Color _getLighterColorForVariant(ThemeVariant variant) {
    switch (variant) {
      case ThemeVariant.light:
        return const Color(0xFF1E88E5); // primaryLight da Palette4CorporateAmber
      case ThemeVariant.dark:
        return const Color(0xFF1976D2); // Secondary para dark mode
      case ThemeVariant.feminine:
        return const Color(0xFFF06292); // primaryLight da Palette5PinkSoft
      case ThemeVariant.green:
        return const Color(0xFF4DB6AC); // primaryLight da Palette6GreenFresh
    }
  }
  
  /// Retorna a cor de sucesso para uma variante de tema
  Color _getSuccessColorForVariant(ThemeVariant variant) {
    switch (variant) {
      case ThemeVariant.light:
        return const Color(0xFF388E3C); // success da Palette4CorporateAmber
      case ThemeVariant.dark:
        return const Color(0xFF2E7D32); // success para dark mode
      case ThemeVariant.feminine:
        return const Color(0xFF4CAF50); // success da Palette5PinkSoft
      case ThemeVariant.green:
        return const Color(0xFF4CAF50); // success da Palette6GreenFresh
    }
  }
  
  /// Retorna a cor de alerta para uma variante de tema
  Color _getWarningColorForVariant(ThemeVariant variant) {
    switch (variant) {
      case ThemeVariant.light:
        return const Color(0xFFFFA000); // warning da Palette4CorporateAmber
      case ThemeVariant.dark:
        return const Color(0xFFFF8F00); // warning para dark mode
      case ThemeVariant.feminine:
        return const Color(0xFFFF9800); // warning da Palette5PinkSoft
      case ThemeVariant.green:
        return const Color(0xFFFFB300); // warning da Palette6GreenFresh
    }
  }
  
  /// Retorna a cor de erro para uma variante de tema
  Color _getErrorColorForVariant(ThemeVariant variant) {
    switch (variant) {
      case ThemeVariant.light:
        return const Color(0xFFD32F2F); // error da Palette4CorporateAmber
      case ThemeVariant.dark:
        return const Color(0xFFC62828); // error para dark mode
      case ThemeVariant.feminine:
        return const Color(0xFFF44336); // error da Palette5PinkSoft
      case ThemeVariant.green:
        return const Color(0xFFE53935); // error da Palette6GreenFresh
    }
  }
}