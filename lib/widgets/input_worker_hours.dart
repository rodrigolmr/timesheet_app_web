// lib/widgets/input_worker_hours.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import '../providers/timesheet_provider.dart';
import 'app_button.dart';
import 'text_formatter.dart';

class InputWorkerHours extends ConsumerStatefulWidget {
  final List<String> workerOptions;
  final TextEditingController nameController;
  final TextEditingController startController;
  final TextEditingController finishController;
  final TextEditingController hoursController;
  final TextEditingController travelController;
  final TextEditingController mealController;
  final VoidCallback? onCancel;
  final int? selectedIndex;

  const InputWorkerHours({
    Key? key,
    required this.workerOptions,
    required this.nameController,
    required this.startController,
    required this.finishController,
    required this.hoursController,
    required this.travelController,
    required this.mealController,
    this.onCancel,
    this.selectedIndex,
  }) : super(key: key);

  @override
  ConsumerState<InputWorkerHours> createState() => _InputWorkerHoursState();
}

class _InputWorkerHoursState extends ConsumerState<InputWorkerHours> {
  String? _selectedWorker;
  bool _nameError = false;
  bool _hoursError = false;
  final FocusNode _hoursFocusNode = FocusNode();
  
  @override
  void initState() {
    super.initState();
    _selectedWorker = widget.nameController.text.isNotEmpty
        ? widget.nameController.text
        : null;
    
    _hoursFocusNode.addListener(_onHoursFocusChange);
  }
  
  @override
  void dispose() {
    _hoursFocusNode.removeListener(_onHoursFocusChange);
    _hoursFocusNode.dispose();
    super.dispose();
  }
  
  void _onHoursFocusChange() {
    if (_hoursFocusNode.hasFocus && _hoursError) {
      setState(() {
        _hoursError = false;
      });
    }
  }

  void _updateSelectedWorker() {
    if (_selectedWorker != widget.nameController.text) {
      _selectedWorker = widget.nameController.text;
    }
    
    if (_selectedWorker != null && 
        !widget.workerOptions.contains(_selectedWorker)) {
      _selectedWorker = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateSelectedWorker();
    
    // Cores e constantes conforme o design da pasta new_files
    final primaryColor = AppTheme.primaryBlue;
    final errorBg = Colors.red.withOpacity(0.2);
    const bgColor = Color(0xFFFEFFE4);
    const headerHeight = 24.0;
    const cellHeight = 36.0;
    const columnFlex = [13, 13, 10, 10, 10];
    final titles = ['Start', 'Finish', 'Hours', 'Travel', 'Meal'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Dropdown de seleção de trabalhador
        Container(
          height: 48, // Altura ajustada para acessibilidade
          decoration: BoxDecoration(
            color: _nameError ? errorBg : bgColor,
            border: Border.all(color: primaryColor, width: 2),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Material(
            color: Colors.transparent,
            child: Semantics(
              label: 'Worker name selection',
              focused: false,
              enabled: true,
              button: true,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Center(
                    child: Text(
                      'Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF9C9C9C),
                      ),
                    ),
                  ),
                  iconSize: 28, // Ícone maior para facilitar o toque
                  selectedItemBuilder: (_) => widget.workerOptions
                      .map((w) => Center(
                            child: Text(
                              w,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ))
                      .toList(),
                  value: _selectedWorker,
                  items: widget.workerOptions
                      .map((w) => DropdownMenuItem(
                          value: w,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(w),
                          )))
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      _selectedWorker = v;
                      widget.nameController.text = v ?? '';
                      _nameError = false;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
        
        // Cabeçalho com títulos
        Container(
          height: headerHeight,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.zero,
            border: Border.all(color: primaryColor, width: 2),
          ),
          child: Row(
            children: List.generate(titles.length, (i) {
              return Expanded(
                flex: columnFlex[i],
                child: Center(
                  child: Text(
                    titles[i],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        
        // Campos de entrada
        Container(
          height: cellHeight,
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: primaryColor, width: 2),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(5),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              _buildTimeCell(
                widget.startController,
                columnFlex[0],
                primaryColor,
                isFirst: true,
              ),
              _buildTimeCell(
                widget.finishController,
                columnFlex[1],
                primaryColor,
              ),
              _buildHoursCell(
                widget.hoursController,
                columnFlex[2],
                primaryColor,
                errorBg,
              ),
              _buildDecimalCell(
                widget.travelController,
                columnFlex[3],
                primaryColor,
              ),
              _buildNumberCell(
                widget.mealController,
                columnFlex[4],
                primaryColor,
                drawBorderRight: false,
                isLastCell: true,
              ),
            ],
          ),
        ),
        
        // Botões de ação
        const SizedBox(height: 16),
        SizedBox(
          height: 25,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.selectedIndex != null) ...[
                SizedBox(
                  width: 60,
                  child: AppButton.mini(
                    type: MiniButtonType.deleteMiniButton,
                    onPressed: _handleDelete,
                  ),
                ),
                const SizedBox(width: 20),
              ],
              SizedBox(
                width: 60,
                child: AppButton.mini(
                  type: MiniButtonType.cancelMiniButton,
                  onPressed: _handleCancel,
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 60,
                child: AppButton.mini(
                  type: MiniButtonType.clearMiniButton,
                  onPressed: _handleClear,
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 60,
                child: AppButton.mini(
                  type: widget.selectedIndex != null
                      ? MiniButtonType.saveMiniButton
                      : MiniButtonType.addMiniButton,
                  onPressed: _handleSubmit,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Componentes de células - seguindo exatamente o design original
  // Método base reutilizável para construir uma célula de input
  // com feedback visual e acessibilidade melhorada
  Widget _buildBaseCell({
    required TextEditingController controller,
    required int flex,
    required Color primaryColor,
    String? semanticLabel,
    Color? backgroundColor,
    FocusNode? focusNode,
    bool drawBorderRight = true,
    List<TextInputFormatter>? inputFormatters,
    TextInputType keyboardType = TextInputType.text,
    String? hintText,
    bool isFirstCell = false,
    bool isLastCell = false,
  }) => Expanded(
    flex: flex,
    child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          right: drawBorderRight
              ? BorderSide(color: primaryColor, width: 1)
              : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: isFirstCell ? const Radius.circular(5) : Radius.zero,
          bottomRight: isLastCell ? const Radius.circular(5) : Radius.zero,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.center,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            hintText: hintText ?? '',
            hoverColor: AppTheme.primaryBlue.withOpacity(0.05),
            fillColor: Colors.transparent,
            filled: true,
          ),
        ),
      ),
    ),
  );

  // Métodos específicos que usam o método base para construir células especializadas
  Widget _buildTimeCell(
    TextEditingController controller,
    int flex,
    Color primaryColor, {
    bool isFirst = false,
  }) => _buildBaseCell(
    controller: controller,
    flex: flex,
    primaryColor: primaryColor,
    semanticLabel: 'Time input',
    inputFormatters: [TextFormatter.time(hoursFormat: 24)],
    keyboardType: TextInputType.number,
    hintText: '00:00',
    isFirstCell: isFirst,
  );

  Widget _buildHoursCell(
    TextEditingController controller,
    int flex,
    Color primaryColor,
    Color errorBg,
  ) => _buildBaseCell(
    controller: controller,
    flex: flex,
    primaryColor: primaryColor,
    backgroundColor: _hoursError ? errorBg : null,
    focusNode: _hoursFocusNode,
    semanticLabel: 'Hours worked input',
    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    hintText: '0.0',
  );

  Widget _buildDecimalCell(
    TextEditingController controller,
    int flex,
    Color primaryColor,
  ) => _buildBaseCell(
    controller: controller,
    flex: flex,
    primaryColor: primaryColor,
    semanticLabel: 'Travel hours input',
    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    hintText: '0.0',
  );

  Widget _buildNumberCell(
    TextEditingController controller,
    int flex,
    Color primaryColor, {
    bool drawBorderRight = true,
    bool isLastCell = false,
  }) => _buildBaseCell(
    controller: controller,
    flex: flex,
    primaryColor: primaryColor,
    drawBorderRight: drawBorderRight,
    semanticLabel: 'Meal count input',
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    keyboardType: TextInputType.number,
    hintText: '0',
    isLastCell: isLastCell,
  );

  // Métodos de ação
  void _handleClear() {
    widget.nameController.clear();
    widget.startController.clear();
    widget.finishController.clear();
    widget.hoursController.clear();
    widget.travelController.clear();
    widget.mealController.clear();
    setState(() {
      _selectedWorker = null;
      _nameError = false;
      _hoursError = false;
    });
  }

  void _handleCancel() {
    _handleClear();
    widget.onCancel?.call();
  }

  void _handleDelete() {
    if (widget.selectedIndex != null) {
      ref.read(timesheetProvider.notifier).deleteWorker(widget.selectedIndex!);
      _handleClear();
      widget.onCancel?.call();
    }
  }

  void _handleSubmit() {
    final name = widget.nameController.text.trim();
    final hours = widget.hoursController.text.trim();

    setState(() {
      _nameError = name.isEmpty;
      _hoursError = hours.isEmpty;
    });

    if (_nameError || _hoursError) {
      return;
    }

    final worker = {
      'name': name,
      'start': widget.startController.text.trim(),
      'finish': widget.finishController.text.trim(),
      'hours': hours,
      'travel': widget.travelController.text.trim(),
      'meal': widget.mealController.text.trim(),
    };

    if (widget.selectedIndex != null) {
      // Editar trabalhador existente
      ref.read(timesheetProvider.notifier).editWorker(widget.selectedIndex!, worker);
      _handleClear();
      widget.onCancel?.call();
    } else {
      // Adicionar novo trabalhador
      ref.read(timesheetProvider.notifier).addWorker(worker);

      // Resetar apenas o nome, mantendo os outros campos
      widget.nameController.clear();
      setState(() {
        _selectedWorker = null;
        _nameError = false;
      });
    }
  }
}