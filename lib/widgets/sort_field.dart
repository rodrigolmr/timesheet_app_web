// lib/widgets/sort_field.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'app_button.dart';
import 'package:timesheet_app_web/core/responsive/responsive.dart';

/// Widget para filtrar e ordenar uma lista de itens.
///
/// Este componente oferece interface para seleção de intervalo de datas,
/// ordem de classificação, filtro por criador e campo de busca unificado.
class SortField extends StatelessWidget {
  /// Intervalo de datas selecionado para filtro.
  final DateTimeRange? selectedRange;
  
  /// Indica se a ordem é decrescente.
  final bool isDescending;
  
  /// Criador selecionado no filtro.
  final String selectedCreator;
  
  /// Lista de opções para filtro por criador.
  final List<String> creatorOptions;
  
  /// Controlador para o campo de busca unificado.
  final TextEditingController searchController;
  
  /// Função chamada quando o intervalo de datas é alterado.
  final VoidCallback onPickRange;
  
  /// Função chamada quando a ordem de classificação é alterada.
  final ValueChanged<bool> onSortOrderChanged;
  
  /// Função chamada quando o criador selecionado é alterado.
  final ValueChanged<String?> onCreatorChanged;
  
  /// Função chamada para limpar todos os filtros.
  final VoidCallback onClearAll;

  /// Função chamada para fechar o painel de filtros.
  final VoidCallback onClose;
  
  /// Função chamada quando o texto da busca unificada é alterado.
  final ValueChanged<String> onSearchChanged;

  /// Constrói um campo de filtro e ordenação.
  const SortField({
    Key? key,
    required this.selectedRange,
    required this.isDescending,
    required this.selectedCreator,
    required this.creatorOptions,
    required this.searchController,
    required this.onPickRange,
    required this.onSortOrderChanged,
    required this.onCreatorChanged,
    required this.onClearAll,
    required this.onClose,
    required this.onSearchChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDateActive = selectedRange != null;
    final isCreatorActive = selectedCreator != 'Creator';
    final isSearchActive = searchController.text.isNotEmpty;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0FF),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1) Range + setas
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: isDateActive
                            ? [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.6),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ]
                            : [],
                      ),
                      child: Material(
                        color: isDateActive ? Colors.green : const Color(0xFF777777),
                        borderRadius: BorderRadius.circular(4),
                        elevation: 0,
                        child: InkWell(
                          onTap: onPickRange,
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            width: 80,
                            height: 40,
                            alignment: Alignment.center,
                            child: const Text(
                              "Range",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          isDateActive
                              ? "${DateFormat('MMM/dd').format(selectedRange!.start)} - ${DateFormat('MMM/dd').format(selectedRange!.end)}"
                              : "No date range",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _squareArrow(
                      Icons.arrow_upward,
                      !isDescending,
                      () => onSortOrderChanged(false),
                    ),
                    const SizedBox(width: 8),
                    _squareArrow(
                      Icons.arrow_downward,
                      isDescending,
                      () => onSortOrderChanged(true),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // 2) Creator dropdown
                Center(
                  child: SizedBox(
                    width: 200,
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color:
                              isCreatorActive
                                  ? Colors.green
                                  : Colors.grey,
                          width: isCreatorActive ? 2 : 1,
                        ),
                        boxShadow:
                            isCreatorActive
                                ? [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.6),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : [],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedCreator,
                          style: const TextStyle(fontSize: 14, color: Colors.black),
                          onChanged: onCreatorChanged,
                          items:
                              creatorOptions
                                  .map(
                                    (c) =>
                                        DropdownMenuItem(value: c, child: Text(c)),
                                  )
                                  .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // 3) Campo de busca unificado
                _buildSearchField(
                  "Search in all fields", 
                  searchController, 
                  isSearchActive
                ),
                const SizedBox(height: 10),

                // 4) Botões de ação
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppButton.mini(
                      type: MiniButtonType.clearMiniButton,
                      onPressed: onClearAll,
                    ),
                    AppButton.mini(
                      type: MiniButtonType.closeMiniButton,
                      onPressed: onClose,
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

  Widget _squareArrow(IconData icon, bool isActive, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.green.withOpacity(0.6),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? Colors.green : Colors.grey,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _buildSearchField(
    String label,
    TextEditingController controller,
    bool isActive,
  ) {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        boxShadow:
            isActive
                ? [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.6),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
      ),
      child: TextField(
        controller: controller,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          labelText: label,
          hintText: label,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
          floatingLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: isActive ? Colors.green : Colors.grey,
          ),
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.search),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isActive ? Colors.green : Colors.grey,
              width: isActive ? 2 : 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isActive ? Colors.green : Colors.grey,
              width: isActive ? 2 : 1,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
        onChanged: onSearchChanged,
      ),
    );
  }
}