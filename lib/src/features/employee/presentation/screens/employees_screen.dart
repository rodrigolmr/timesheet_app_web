import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timesheet_app_web/src/features/employee/data/models/employee_model.dart';
import 'package:timesheet_app_web/src/features/employee/presentation/providers/employee_providers.dart';
import 'package:timesheet_app_web/src/features/employee/presentation/screens/employee_details_screen.dart';

/// Tela para listar todos os funcionários
class EmployeesScreen extends ConsumerWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Usando provider que retorna um Stream para atualizações em tempo real
    final employeesAsync = ref.watch(employeesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEmployeeDialog(context, ref),
          ),
        ],
      ),
      // Usando o pattern matching do AsyncValue para lidar com os estados
      body: employeesAsync.when(
        data: (employees) {
          if (employees.isEmpty) {
            return const Center(
              child: Text('No employees found'),
            );
          }

          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final employee = employees[index];
              return EmployeeListTile(employee: employee);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading employees: ${error.toString()}'),
        ),
      ),
    );
  }

  void _showAddEmployeeDialog(BuildContext context, WidgetRef ref) {
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Employee'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                ),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (firstNameController.text.isNotEmpty &&
                    lastNameController.text.isNotEmpty) {
                  _addEmployee(
                    ref,
                    firstNameController.text,
                    lastNameController.text,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addEmployee(
    WidgetRef ref,
    String firstName,
    String lastName,
  ) async {
    final newEmployee = EmployeeModel(
      id: '', // ID será gerado pelo Firestore
      firstName: firstName,
      lastName: lastName,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      await ref
          .read(employeeStateProvider('').notifier)
          .create(newEmployee);
    } catch (e) {
      // Em um app real, você pode querer mostrar um snackbar ou toast com o erro
      print('Error adding employee: $e');
    }
  }
}

/// Widget para exibir um funcionário na lista
class EmployeeListTile extends ConsumerWidget {
  final EmployeeModel employee;

  const EmployeeListTile({super.key, required this.employee});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text('${employee.firstName} ${employee.lastName}'),
      subtitle: Text(employee.isActive ? 'Active' : 'Inactive'),
      leading: CircleAvatar(
        child: Text(employee.firstName[0] + employee.lastName[0]),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Toggle para ativar/desativar funcionário
          Switch(
            value: employee.isActive,
            onChanged: (value) {
              ref
                  .read(employeeStateProvider(employee.id).notifier)
                  .toggleActive(value);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ref
                  .read(employeeStateProvider(employee.id).notifier)
                  .delete(employee.id);
            },
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EmployeeDetailsScreen(employeeId: employee.id),
          ),
        );
      },
    );
  }
}