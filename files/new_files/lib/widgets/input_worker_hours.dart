import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'input_field_core.dart';
import 'buttons.dart';
import '../providers/timesheet_provider.dart';

class TimeTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 4) digits = digits.substring(0, 4);
    String formatted;
    switch (digits.length) {
      case 0:
      case 1:
      case 2:
        formatted = digits;
        break;
      case 3:
        formatted = digits[0] + ':' + digits.substring(1);
        break;
      default:
        formatted = digits.substring(0, 2) + ':' + digits.substring(2);
    }
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

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

  @override
  void initState() {
    super.initState();
    _selectedWorker =
        widget.nameController.text.isNotEmpty
            ? widget.nameController.text
            : null;
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedWorker != widget.nameController.text) {
      _selectedWorker = widget.nameController.text;
    }
    if (_selectedWorker != null &&
        !widget.workerOptions.contains(_selectedWorker)) {
      _selectedWorker = null;
    }

    final primaryColor = InputFieldCore.appBlueColor;
    final errorBg = Colors.redAccent.withOpacity(0.2);
    const bgColor = Color(0xFFFEFFE4);
    const headerHeight = 24.0;
    const cellHeight = 36.0;
    const columnFlex = [13, 13, 10, 10, 10];
    final titles = ['Start', 'Finish', 'Hours', 'Travel', 'Meal'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
              hint: Center(
                child: Text(
                  'Name',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: InputFieldCore.hintGrayColor,
                  ),
                ),
              ),
              selectedItemBuilder:
                  (_) =>
                      widget.workerOptions
                          .map(
                            (w) => Center(
                              child: Text(
                                w,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                          .toList(),
              value: _selectedWorker,
              items:
                  widget.workerOptions
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
        Container(
          height: headerHeight,
          color: primaryColor,
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
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        Container(
          height: cellHeight,
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: primaryColor, width: 2),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(5),
            ),
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
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.selectedIndex != null) ...[
              AppButton(
                config: const ButtonConfig(
                  label: 'Delete',
                  icon: null,
                  backgroundColor: Color(0xFF9E9E9E),
                  borderColor: Color(0xFF9E9E9E),
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  width: 60,
                  height: 25,
                  iconSize: 0,
                  textSize: 14,
                  iconSpacing: 0,
                ),
                onPressed: () {
                  ref
                      .read(timesheetProvider.notifier)
                      .deleteWorker(widget.selectedIndex!);
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
                  widget.onCancel?.call();
                },
              ),
              const SizedBox(width: 20),
            ],
            AppButton(
              config: MiniButtonType.cancelMiniButton.config,
              onPressed: () {
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
                widget.onCancel?.call();
              },
            ),
            const SizedBox(width: 20),
            AppButton(
              config: MiniButtonType.clearMiniButton.config,
              onPressed: () {
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
              },
            ),
            const SizedBox(width: 20),
            AppButton(
              config:
                  (widget.selectedIndex != null
                          ? MiniButtonType.saveMiniButton
                          : MiniButtonType.addMiniButton)
                      .config,
              onPressed: () {
                final name = widget.nameController.text.trim();
                final hours = widget.hoursController.text.trim();
                setState(() {
                  _nameError = name.isEmpty;
                  _hoursError = hours.isEmpty;
                });
                if (_nameError || _hoursError) return;

                final worker = {
                  'name': name,
                  'start': widget.startController.text.trim(),
                  'finish': widget.finishController.text.trim(),
                  'hours': hours,
                  'travel': widget.travelController.text.trim(),
                  'meal': widget.mealController.text.trim(),
                };

                if (widget.selectedIndex != null) {
                  ref
                      .read(timesheetProvider.notifier)
                      .editWorker(widget.selectedIndex!, worker);
                } else {
                  ref.read(timesheetProvider.notifier).addWorker(worker);
                }

                widget.nameController.clear();
                setState(() => _selectedWorker = null);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeCell(
    TextEditingController controller,
    int flex,
    Color primaryColor,
  ) => Expanded(
    flex: flex,
    child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: primaryColor, width: 1)),
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [TimeTextFormatter()],
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
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
        border: Border(right: BorderSide(color: primaryColor, width: 1)),
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
        ],
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
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
        border: Border(right: BorderSide(color: primaryColor, width: 1)),
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
        ],
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
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
          right:
              drawBorderRight
                  ? BorderSide(color: primaryColor, width: 1)
                  : BorderSide.none,
        ),
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    ),
  );
}
