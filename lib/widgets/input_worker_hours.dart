// lib/widgets/input_worker_hours.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import '../providers/timesheet_provider.dart';
import 'app_button.dart';
import 'time_text_formatter.dart';

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
          height: 40,
          decoration: BoxDecoration(
            color: _nameError ? errorBg : bgColor,
            border: Border.all(color: primaryColor, width: 2),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
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
                  .map((w) => DropdownMenuItem(value: w, child: Text(w)))
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
          // Removemos as bordas internas para evitar sobreposição
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(3),
            ),
            child: Row(
              children: [
                _buildTimeCell(
                  widget.startController,
                  columnFlex[0],
                  primaryColor,
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
                ),
              ],
            ),
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
  Widget _buildTimeCell(
    TextEditingController controller,
    int flex,
    Color primaryColor,
  ) => Expanded(
    flex: flex,
    child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: primaryColor, width: 2)),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          const TimeTextFormatter(hoursFormat: 24)
        ],
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintText: '',
        ),
      ),
    ),
  );

  Widget _buildHoursCell(
    TextEditingController controller,
    int flex,
    Color primaryColor,
    Color errorBg,
  ) => Expanded(
    flex: flex,
    child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _hoursError ? errorBg : null,
        border: Border(right: BorderSide(color: primaryColor, width: 2)),
      ),
      child: TextField(
        controller: controller,
        focusNode: _hoursFocusNode,
        style: const TextStyle(
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
        ],
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintText: '',
        ),
      ),
    ),
  );

  Widget _buildDecimalCell(
    TextEditingController controller,
    int flex,
    Color primaryColor,
  ) => Expanded(
    flex: flex,
    child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: primaryColor, width: 2)),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
        ],
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintText: '',
        ),
      ),
    ),
  );

  Widget _buildNumberCell(
    TextEditingController controller,
    int flex,
    Color primaryColor, {
    bool drawBorderRight = true,
  }) => Expanded(
    flex: flex,
    child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          right: drawBorderRight
              ? BorderSide(color: primaryColor, width: 2)
              : BorderSide.none,
        ),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintText: '',
        ),
      ),
    ),
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
      ref.read(timesheetProvider.notifier).editWorker(widget.selectedIndex!, worker);
    } else {
      ref.read(timesheetProvider.notifier).addWorker(worker);
    }

    _handleClear();
  }
}