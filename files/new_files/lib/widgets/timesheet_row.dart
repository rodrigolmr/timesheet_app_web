// lib/widgets/timesheet_row.dart

import 'package:flutter/material.dart';

class TimesheetRowItem extends StatefulWidget {
  final String day;
  final String month;
  final String jobName;
  final String userName;
  final bool initialChecked;
  final ValueChanged<bool>? onCheckChanged;

  const TimesheetRowItem({
    Key? key,
    required this.day,
    required this.month,
    required this.jobName,
    required this.userName,
    this.initialChecked = false,
    this.onCheckChanged,
  }) : super(key: key);

  @override
  State<TimesheetRowItem> createState() => _TimesheetRowItemState();
}

class _TimesheetRowItemState extends State<TimesheetRowItem> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialChecked;
  }

  @override
  void didUpdateWidget(covariant TimesheetRowItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Para garantir que o checkbox atualize mesmo quando initialChecked não mudou
    // mas o ValueNotifier subjacente mudou
    setState(() {
      _isChecked = widget.initialChecked;
    });
  }

  void _onCheckboxChanged(bool? value) {
    if (value == null) return;
    setState(() => _isChecked = value);
    widget.onCheckChanged?.call(_isChecked);
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF0205D3);

    // separa primeiro e último nome
    final parts = widget.userName.split(' ');
    final firstName = parts.first;
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 5), // Mantém o padding existente
      child: Row( // Row principal é agora filho direto do Padding
        children: [
          Expanded( // Container de conteúdo principal agora é Expanded
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFDD0), // amarelo claro
                border: Border.all(color: primaryBlue, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              clipBehavior: Clip.antiAlias,
              child: Row(
                children: [
                  // 1) Dia e mês (38px) - Largura fixa mantida
                  Container(
                    width: 38,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8E5FF), // lilás claro
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 25,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              widget.day,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF0000),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              widget.month,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 2) Nome do Job (Agora Expanded)
                  Expanded( // Container do JobName agora é Expanded
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        widget.jobName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF3B3B3B),
                        ),
                      ),
                    ),
                  ),
                  // 3) Nome do Usuário (90px) — Largura fixa mantida
                  Container(
                    width: 90,
                    height: 45,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: const BoxDecoration(
                      // borda branca entre jobName e userName
                      border: Border(
                        left: BorderSide(color: Colors.white, width: 1),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // primeiro nome
                        SizedBox(
                          height: 20,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              firstName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10,
                                fontStyle: FontStyle.italic,
                                color: Color(0xFF3B3B3B),
                              ),
                            ),
                          ),
                        ),
                        // sobrenome
                        SizedBox(
                          height: 20,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              lastName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10,
                                fontStyle: FontStyle.italic,
                                color: Color(0xFF3B3B3B),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // checkbox (adjusted width)
          SizedBox(
            width: 38, // Changed from 40 to 38 to resolve 2px overflow
            child: Checkbox(
              value: _isChecked,
              onChanged: _onCheckboxChanged,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              activeColor: primaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}
