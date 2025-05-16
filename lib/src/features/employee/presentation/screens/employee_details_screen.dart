import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timesheet_app_web/src/features/employee/data/models/employee_model.dart';
import 'package:timesheet_app_web/src/features/employee/presentation/providers/employee_providers.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/job_record_providers.dart';

/// Tela de detalhes de um funcionário específico
class EmployeeDetailsScreen extends ConsumerWidget {
  final String employeeId;

  const EmployeeDetailsScreen({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Usando provider para observar um funcionário específico em tempo real
    final employeeAsync = ref.watch(employeeStreamProvider(employeeId));
    
    // Usando provider para obter registros de trabalho do funcionário
    final jobRecordsAsync = ref.watch(jobRecordsByWorkerStreamProvider(employeeId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditDialog(context, ref),
          ),
        ],
      ),
      body: employeeAsync.when(
        data: (employee) {
          if (employee == null) {
            return const Center(
              child: Text('Employee not found'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEmployeeInfo(employee),
                const SizedBox(height: 24),
                const Text(
                  'Work Records',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _buildJobRecordsList(jobRecordsAsync),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading details: ${error.toString()}'),
        ),
      ),
    );
  }

  Widget _buildEmployeeInfo(EmployeeModel employee) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                child: Text(
                  employee.firstName[0] + employee.lastName[0],
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                '${employee.firstName} ${employee.lastName}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Chip(
                backgroundColor: employee.isActive
                    ? Colors.green.withOpacity(0.2)
                    : Colors.red.withOpacity(0.2),
                label: Text(
                  employee.isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    color: employee.isActive ? Colors.green[800] : Colors.red[800],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            _buildInfoRow('Created on', 
                _formatDateTime(employee.createdAt)),
            const SizedBox(height: 8),
            _buildInfoRow('Last updated', 
                _formatDateTime(employee.updatedAt)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(value),
      ],
    );
  }

  Widget _buildJobRecordsList(AsyncValue jobRecordsAsync) {
    return jobRecordsAsync.when(
      data: (jobRecords) {
        if (jobRecords.isEmpty) {
          return const Center(
            child: Text('No work records found'),
          );
        }

        return ListView.builder(
          itemCount: jobRecords.length,
          itemBuilder: (context, index) {
            final record = jobRecords[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(record.projectName),
                subtitle: Text(_formatDateTime(record.date)),
                trailing: Text('${record.hours}h'),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error loading records: ${error.toString()}'),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/'
        '${dateTime.month.toString().padLeft(2, '0')}/'
        '${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    final employeeAsync = ref.read(employeeStreamProvider(employeeId));
    
    if (employeeAsync is! AsyncData || employeeAsync.value == null) {
      return;
    }
    
    final employee = employeeAsync.value!;
    final firstNameController = TextEditingController(text: employee.firstName);
    final lastNameController = TextEditingController(text: employee.lastName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Employee'),
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
                  _updateEmployee(
                    ref,
                    employee,
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

  Future<void> _updateEmployee(
    WidgetRef ref,
    EmployeeModel employee,
    String firstName,
    String lastName,
  ) async {
    final updatedEmployee = employee.copyWith(
      firstName: firstName,
      lastName: lastName,
      updatedAt: DateTime.now(),
    );

    try {
      await ref
          .read(employeeStateProvider(employee.id).notifier)
          .updateEmployee(updatedEmployee);
    } catch (e) {
      print('Error updating employee: $e');
    }
  }
}