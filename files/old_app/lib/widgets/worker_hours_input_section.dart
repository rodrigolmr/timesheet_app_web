import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Supondo que você já tenha a classe TimeTextFormatter definida
class TimeTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final bool isRemoving = newValue.text.length < oldValue.text.length;
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length > 4) {
      digitsOnly = digitsOnly.substring(0, 4);
    }
    String formatted;
    switch (digitsOnly.length) {
      case 0:
        formatted = '';
        break;
      case 1:
        formatted = digitsOnly;
        break;
      case 2:
        formatted = digitsOnly;
        break;
      case 3:
        formatted = digitsOnly[0] + ':' + digitsOnly.substring(1);
        break;
      default:
        formatted = digitsOnly.substring(0, 2) + ':' + digitsOnly.substring(2);
    }
    TextSelection newSelection;
    if (isRemoving) {
      final baseOffset =
          newValue.selection.baseOffset.clamp(0, formatted.length);
      final extentOffset =
          newValue.selection.extentOffset.clamp(0, formatted.length);
      newSelection = TextSelection(
        baseOffset: baseOffset,
        extentOffset: extentOffset,
      );
    } else {
      newSelection = TextSelection.collapsed(offset: formatted.length);
    }
    return TextEditingValue(
      text: formatted,
      selection: newSelection,
    );
  }
}

class WorkerHoursInputSection extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController startController;
  final TextEditingController finishController;
  final TextEditingController hoursController;
  final TextEditingController travelController;
  final TextEditingController mealController;

  const WorkerHoursInputSection({
    Key? key,
    required this.nameController,
    required this.startController,
    required this.finishController,
    required this.hoursController,
    required this.travelController,
    required this.mealController,
  }) : super(key: key);

  @override
  WorkerHoursInputSectionState createState() => WorkerHoursInputSectionState();
}

class WorkerHoursInputSectionState extends State<WorkerHoursInputSection> {
  List<String> _workerOptions = []; // Lista de workers carregados dinamicamente
  String? _selectedName;

  // Controla a borda vermelha do Name
  bool _nameError = false;
  // Controla a borda vermelha do Hours
  bool _hoursError = false;

  // FocusNode para remover erro ao focar o campo Hours
  final FocusNode _hoursFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.nameController.text.isNotEmpty) {
      _selectedName = widget.nameController.text;
    }
    _hoursFocus.addListener(() {
      if (_hoursFocus.hasFocus && _hoursError) {
        setState(() {
          _hoursError = false;
        });
      }
    });
    _loadWorkers();
  }

  /// Carrega a lista de workers cadastrados no Firestore (coleção 'workers')
  Future<void> _loadWorkers() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('workers').get();
      List<String> workers = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final firstName = data['firstName'] ?? "";
        final lastName = data['lastName'] ?? "";
        final fullName = (firstName + " " + lastName).trim();
        if (fullName.isNotEmpty) {
          workers.add(fullName);
        }
      }
      // Ordena alfabeticamente
      workers.sort();
      setState(() {
        _workerOptions = workers;
      });
    } catch (e) {
      print("Error loading workers: $e");
    }
  }

  // Define erro no Name (4 bordas vermelhas)
  void setNameError(bool value) {
    setState(() {
      _nameError = value;
    });
  }

  // Define erro no Hours
  void setHoursError(bool value) {
    setState(() {
      _hoursError = value;
    });
  }

  // Reseta o dropdown para o placeholder
  void resetDropdown() {
    setState(() {
      _selectedName = null;
      widget.nameController.clear();
      _nameError = false;
    });
  }

  // Define o valor do dropdown (usado ao editar registro)
  void setDropdownValue(String newValue) {
    setState(() {
      if (_workerOptions.contains(newValue)) {
        _selectedName = newValue;
        widget.nameController.text = newValue;
      } else {
        _selectedName = null;
        widget.nameController.clear();
      }
      _nameError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dropdown para selecionar o worker
        GestureDetector(
          onTap: () {
            if (_nameError) {
              setState(() {
                _nameError = false;
              });
            }
          },
          child: Container(
            width: 294,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFEFFE4),
              border: Border.all(
                color: _nameError ? Colors.red : const Color(0xFF0205D3),
                width: 2,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 24,
                style: const TextStyle(
                  fontFamily: 'Barlow',
                  fontSize: 20,
                  color: Color(0xFF3D3D3D),
                ),
                hint: const Center(
                  child: Text(
                    'Name',
                    style: TextStyle(fontSize: 20, color: Color(0xFF9C9C9C)),
                    textAlign: TextAlign.center,
                  ),
                ),
                value: _selectedName,
                items: _workerOptions
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Center(child: Text(value)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedName = newValue;
                    widget.nameController.text = newValue ?? '';
                    _nameError = false;
                  });
                },
              ),
            ),
          ),
        ),
        // A seguir, o restante dos campos (barra azul e inputs) permanece inalterado.
        Container(
          width: 294,
          height: 20,
          color: const Color(0xFF0205D3),
          child: Row(
            children: [
              _buildTitle('Start', 65),
              _buildTitle('Finish', 65),
              _buildTitle('Hours', 50),
              _buildTitle('Travel', 50),
              _buildTitle('Meal', 50),
            ],
          ),
        ),
        Container(
          width: 294,
          height: 30,
          decoration: BoxDecoration(
            color: const Color(0xFFFEFFE4),
            border: Border.all(
              color: const Color(0xFF0205D3),
              width: 2,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
          ),
          child: Row(
            children: [
              _buildStartFinishField(widget.startController,
                  width: 65, drawRightBorder: true),
              _buildStartFinishField(widget.finishController,
                  width: 65, drawRightBorder: true),
              _buildHoursField(widget.hoursController,
                  width: 50, drawRightBorder: true),
              _buildDecimalField(widget.travelController,
                  width: 50, drawRightBorder: true),
              _buildNumberField(widget.mealController,
                  width: 50, drawRightBorder: false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(String text, double width) {
    return Container(
      width: width,
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildStartFinishField(
    TextEditingController controller, {
    required double width,
    required bool drawRightBorder,
  }) {
    return Container(
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          right: drawRightBorder
              ? const BorderSide(color: Color(0xFF0205D3), width: 1)
              : BorderSide.none,
        ),
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Barlow',
          fontSize: 16,
          color: Color(0xFF3D3D3D),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [TimeTextFormatter()],
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildHoursField(
    TextEditingController controller, {
    required double width,
    required bool drawRightBorder,
  }) {
    return Container(
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          right: drawRightBorder
              ? const BorderSide(color: Color(0xFF0205D3), width: 1)
              : BorderSide.none,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: _hoursFocus,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Barlow',
          fontSize: 16,
          color: Color(0xFF3D3D3D),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
        ],
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          enabledBorder: _hoursError
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                )
              : InputBorder.none,
          focusedBorder: _hoursError
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                )
              : OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
        ),
      ),
    );
  }

  Widget _buildDecimalField(
    TextEditingController controller, {
    required double width,
    required bool drawRightBorder,
  }) {
    return Container(
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          right: drawRightBorder
              ? const BorderSide(color: Color(0xFF0205D3), width: 1)
              : BorderSide.none,
        ),
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Barlow',
          fontSize: 16,
          color: Color(0xFF3D3D3D),
        ),
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
    );
  }

  Widget _buildNumberField(
    TextEditingController controller, {
    required double width,
    required bool drawRightBorder,
  }) {
    return Container(
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          right: drawRightBorder
              ? const BorderSide(color: Color(0xFF0205D3), width: 1)
              : BorderSide.none,
        ),
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Barlow',
          fontSize: 16,
          color: Color(0xFF3D3D3D),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
