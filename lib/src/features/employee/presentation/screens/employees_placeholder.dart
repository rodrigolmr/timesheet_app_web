import 'package:flutter/material.dart';

/// Tela temporária para substituir a tela de funcionários que foi excluída
class EmployeesPlaceholder extends StatelessWidget {
  const EmployeesPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Employees screen removed',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

/// Tela temporária para substituir a tela de detalhes do funcionário que foi excluída
class EmployeeDetailsPlaceholder extends StatelessWidget {
  final String employeeId;

  const EmployeeDetailsPlaceholder({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Employee details screen removed\nEmployee ID: $employeeId',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}