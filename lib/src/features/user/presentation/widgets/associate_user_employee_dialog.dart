import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/widgets.dart';
import 'package:timesheet_app_web/src/core/widgets/dialogs/dialogs.dart';
import 'package:timesheet_app_web/src/features/user/data/models/user_model.dart';
import 'package:timesheet_app_web/src/features/user/presentation/providers/user_providers.dart';
import 'package:timesheet_app_web/src/features/employee/data/models/employee_model.dart';
import 'package:timesheet_app_web/src/features/employee/presentation/providers/employee_providers.dart';

class AssociateUserEmployeeDialog extends ConsumerStatefulWidget {
  const AssociateUserEmployeeDialog({super.key});

  @override
  ConsumerState<AssociateUserEmployeeDialog> createState() => _AssociateUserEmployeeDialogState();
}

class _AssociateUserEmployeeDialogState extends ConsumerState<AssociateUserEmployeeDialog> {
  String? _selectedUserId;
  String? _selectedEmployeeId;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final usersWithoutEmployeeAsync = ref.watch(usersWithoutEmployeeStreamProvider);
    final employeesWithoutUserAsync = ref.watch(employeesWithoutUserStreamProvider);

    return AppFormDialog(
      title: 'Link User to Employee',
      icon: Icons.link,
      mode: DialogMode.create,
      actions: [
        AppFormDialogActions(
          isLoading: _isLoading,
          mode: DialogMode.create,
          confirmText: 'Link',
          onConfirm: _handleAssociate,
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // User Selection
          usersWithoutEmployeeAsync.when(
            data: (users) {
              if (users.isEmpty) {
                return Container(
                  padding: EdgeInsets.all(context.dimensions.spacingM),
                  decoration: BoxDecoration(
                    color: context.colors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: context.colors.info),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: context.colors.info),
                      SizedBox(width: context.dimensions.spacingS),
                      Expanded(
                        child: Text(
                          'No users without employee association.',
                          style: context.textStyles.body,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return AppDropdownField<UserModel>(
                label: 'Select User',
                hintText: 'Choose a user without employee',
                items: users,
                value: users.firstWhereOrNull((u) => u.id == _selectedUserId),
                itemLabelBuilder: (user) => '${user.firstName} ${user.lastName} (${user.email})',
                onChanged: (user) {
                  setState(() {
                    _selectedUserId = user?.id;
                  });
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text(
              'Error loading users: $error',
              style: TextStyle(color: context.colors.error),
            ),
          ),
          
          SizedBox(height: context.dimensions.spacingL),
          
          // Employee Selection
          employeesWithoutUserAsync.when(
            data: (employees) {
              if (employees.isEmpty) {
                return Container(
                  padding: EdgeInsets.all(context.dimensions.spacingM),
                  decoration: BoxDecoration(
                    color: context.colors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: context.colors.info),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: context.colors.info),
                      SizedBox(width: context.dimensions.spacingS),
                      Expanded(
                        child: Text(
                          'No employees without user association.',
                          style: context.textStyles.body,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return AppDropdownField<EmployeeModel>(
                label: 'Select Employee',
                hintText: 'Choose an employee without user',
                items: employees,
                value: employees.firstWhereOrNull((e) => e.id == _selectedEmployeeId),
                itemLabelBuilder: (employee) => '${employee.firstName} ${employee.lastName}',
                onChanged: (employee) {
                  setState(() {
                    _selectedEmployeeId = employee?.id;
                  });
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text(
              'Error loading employees: $error',
              style: TextStyle(color: context.colors.error),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAssociate() async {
    if (_selectedUserId == null || _selectedEmployeeId == null) {
      await showWarningDialog(
        context: context,
        title: 'Missing Information',
        message: 'Please select both a user and an employee to link.',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(userRepositoryProvider).associateUserWithEmployee(
        _selectedUserId!,
        _selectedEmployeeId!,
      );

      if (mounted) {
        Navigator.of(context).pop();
        await showSuccessDialog(
          context: context,
          title: 'Success',
          message: 'User and employee linked successfully.',
        );
      }
    } catch (e) {
      if (mounted) {
        await showErrorDialog(
          context: context,
          title: 'Error',
          message: 'Failed to link user and employee: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}