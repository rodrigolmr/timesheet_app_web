// lib/widgets/sort_field.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'buttons.dart';
import 'form_container.dart';

class SortField extends StatelessWidget {
  final DateTimeRange? selectedRange;
  final bool isDescending;
  final String selectedCreator;
  final List<String> creatorOptions;
  final TextEditingController jobController;
  final TextEditingController tmController;
  final TextEditingController materialController;

  final VoidCallback onPickRange;
  final ValueChanged<bool> onSortOrderChanged;
  final ValueChanged<String?> onCreatorChanged;
  final VoidCallback onClearAll;
  final VoidCallback onApply;
  final VoidCallback onClose;

  const SortField({
    Key? key,
    required this.selectedRange,
    required this.isDescending,
    required this.selectedCreator,
    required this.creatorOptions,
    required this.jobController,
    required this.tmController,
    required this.materialController,
    required this.onPickRange,
    required this.onSortOrderChanged,
    required this.onCreatorChanged,
    required this.onClearAll,
    required this.onApply,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isDateActive = selectedRange != null;
    final isCreatorActive = selectedCreator != 'Creator';
    final isJobActive = jobController.text.isNotEmpty;
    final isTmActive = tmController.text.isNotEmpty;
    final isMaterialActive = materialController.text.isNotEmpty;

    return FormContainer(
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isDateActive ? Colors.green : const Color(0xFF0277BD),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(80, 40),
                  ),
                  onPressed: onPickRange,
                  child: const Text("Range"),
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
                              : const Color(0xFF0205D3),
                      width: isCreatorActive ? 2 : 1,
                    ),
                    boxShadow:
                        isCreatorActive
                            ? [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.4),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
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

            // 3) Campos de busca
            _buildSearchField("Job Name", jobController, isJobActive),
            _buildSearchField("T.M.", tmController, isTmActive),
            _buildSearchField("Material", materialController, isMaterialActive),
            const SizedBox(height: 10),

            // 4) Botões de ação
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AppButton(
                  config: MiniButtonType.clearMiniButton.config,
                  onPressed: onClearAll,
                ),
                AppButton(
                  config: MiniButtonType.applyMiniButton.config,
                  onPressed: onApply,
                ),
                AppButton(
                  config: MiniButtonType.closeMiniButton.config,
                  onPressed: onClose,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _squareArrow(IconData icon, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF0205D3) : Colors.grey,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
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
                    color: Colors.green.withOpacity(0.4),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
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
          floatingLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Colors.green,
          ),
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isActive ? Colors.green : const Color(0xFF0205D3),
              width: isActive ? 2 : 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isActive ? Colors.green : const Color(0xFF0205D3),
              width: isActive ? 2 : 1,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
