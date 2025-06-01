import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/app_header.dart';
import 'package:timesheet_app_web/src/features/employee/data/models/employee_model.dart';
import 'package:timesheet_app_web/src/features/employee/presentation/providers/employee_providers.dart';
import 'package:timesheet_app_web/src/features/employee/presentation/providers/employee_search_providers.dart';
import 'package:timesheet_app_web/src/core/widgets/input/app_text_field.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive_grid.dart';
import 'package:timesheet_app_web/src/features/employee/presentation/widgets/employee_filters.dart';
import 'package:timesheet_app_web/src/core/widgets/dialogs/dialogs.dart';

class EmployeesScreen extends ConsumerStatefulWidget {
  const EmployeesScreen({super.key});

  @override
  ConsumerState<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends ConsumerState<EmployeesScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedStatus = 'all';
  bool _filtersExpanded = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employeesAsync = ref.watch(employeesStreamProvider);
    
    return Scaffold(
      appBar: AppHeader(
        title: 'Employees',
        subtitle: 'Manage company employees',
        actionIcon: Icons.add,
        onActionPressed: () => _showCreateDialog(context),
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: employeesAsync.when(
              data: (employees) => _buildEmployeeList(context, employees),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: context.colors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading employees',
                      style: context.textStyles.title,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: context.textStyles.body.copyWith(
                        color: context.colors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return EmployeeFilters(
      searchController: _searchController,
      searchQuery: _searchQuery,
      selectedStatus: _selectedStatus,
      filtersExpanded: _filtersExpanded,
      onSearchChanged: (query) {
        setState(() {
          _searchQuery = query.trim();
        });
        ref.read(employeeSearchQueryProvider.notifier).updateQuery(query);
      },
      onStatusChanged: (status) {
        setState(() {
          _selectedStatus = status;
        });
        // Update the provider based on status
        if (status == 'active') {
          ref.read(employeeSearchFiltersProvider.notifier).updateActiveStatus(true);
        } else if (status == 'inactive') {
          ref.read(employeeSearchFiltersProvider.notifier).updateActiveStatus(false);
        } else {
          ref.read(employeeSearchFiltersProvider.notifier).updateActiveStatus(null);
        }
      },
      onExpandedChanged: (expanded) {
        setState(() {
          _filtersExpanded = expanded;
        });
      },
      onClearFilters: _clearAllFilters,
    );
  }

  void _clearAllFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedStatus = 'all';
    });
    ref.read(employeeSearchQueryProvider.notifier).updateQuery('');
    ref.read(employeeSearchFiltersProvider.notifier).updateActiveStatus(null);
  }

  Widget _buildEmployeeList(BuildContext context, List<EmployeeModel> allEmployees) {
    final searchResults = ref.watch(employeeSearchResultsProvider);
    final employees = searchResults.isEmpty && _searchController.text.isEmpty && _selectedStatus == 'all'
        ? allEmployees
        : searchResults;
    
    if (employees.isEmpty) {
      return _buildEmptyState(context);
    }

    final isMobile = context.isMobile;
    
    if (isMobile) {
      return ListView.builder(
        padding: EdgeInsets.all(context.dimensions.spacingM),
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final employee = employees[index];
          return _buildEmployeeCard(context, employee);
        },
      );
    }

    return Padding(
      padding: EdgeInsets.all(context.dimensions.spacingL),
      child: ResponsiveGrid(
        spacing: context.dimensions.spacingM,
        xsColumns: 1,
        smColumns: 2,
        mdColumns: 3,
        lgColumns: 4,
        children: employees.map((employee) => 
          _buildEmployeeCard(context, employee)
        ).toList(),
      ),
    );
  }

  Widget _buildEmployeeCard(BuildContext context, EmployeeModel employee) {
    return Card(
      margin: EdgeInsets.only(bottom: context.responsive<double>(xs: 6, sm: 8, md: 10)),
      child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.responsive<double>(xs: 12, sm: 14, md: 16),
            vertical: context.responsive<double>(xs: 8, sm: 10, md: 12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: context.responsive<double>(xs: 16, sm: 18, md: 20),
                backgroundColor: employee.isActive 
                    ? context.colors.primary 
                    : context.colors.textSecondary.withOpacity(0.3),
                child: Text(
                  '${employee.firstName[0]}${employee.lastName[0]}',
                  style: TextStyle(
                    color: employee.isActive 
                        ? context.colors.onPrimary 
                        : context.colors.textSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: context.responsive<double>(xs: 12, sm: 13, md: 14),
                  ),
                ),
              ),
              SizedBox(width: context.responsive<double>(xs: 10, sm: 12, md: 14)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${employee.firstName} ${employee.lastName}',
                      style: context.textStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: context.responsive<double>(xs: 14, sm: 15, md: 16),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.responsive<double>(xs: 6, sm: 7, md: 8),
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: employee.isActive
                            ? context.colors.success.withOpacity(0.1)
                            : context.colors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        employee.isActive ? 'Active' : 'Inactive',
                        style: context.textStyles.caption.copyWith(
                          color: employee.isActive
                              ? context.colors.success
                              : context.colors.error,
                          fontWeight: FontWeight.w600,
                          fontSize: context.responsive<double>(xs: 10, sm: 11, md: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.edit_outlined,
                  size: context.responsive<double>(xs: 18, sm: 20, md: 22),
                ),
                onPressed: () => _showEditDialog(context, employee),
                tooltip: 'Edit employee',
                padding: const EdgeInsets.all(4),
                constraints: BoxConstraints(
                  minWidth: context.responsive<double>(xs: 32, sm: 36, md: 40),
                  minHeight: context.responsive<double>(xs: 32, sm: 36, md: 40),
                ),
              ),
            ],
          ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final hasFilters = _searchController.text.isNotEmpty || _selectedStatus != 'all';
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasFilters ? Icons.search_off : Icons.people_outline,
            size: 120,
            color: context.colors.textSecondary.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            hasFilters ? 'No employees found' : 'No employees yet',
            style: context.textStyles.title.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasFilters 
                ? 'Try adjusting your search or filters'
                : 'Start by adding your first employee',
            style: context.textStyles.body.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          if (!hasFilters)
            ElevatedButton.icon(
              onPressed: () => _showCreateDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Employee'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: context.colors.onPrimary,
              ),
            )
          else
            TextButton(
              onPressed: _clearAllFilters,
              child: const Text('Clear filters'),
            ),
        ],
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _CreateEmployeeDialog(ref: ref),
    );
  }

  void _showEditDialog(BuildContext context, EmployeeModel employee) {
    showDialog(
      context: context,
      builder: (_) => _EditEmployeeDialog(employee: employee, ref: ref),
    );
  }
}

class _CreateEmployeeDialog extends ConsumerStatefulWidget {
  final WidgetRef ref;

  const _CreateEmployeeDialog({required this.ref});

  @override
  ConsumerState<_CreateEmployeeDialog> createState() => _CreateEmployeeDialogState();
}

class _CreateEmployeeDialogState extends ConsumerState<_CreateEmployeeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  bool _isActive = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFormDialog(
      title: 'Add Employee',
      icon: Icons.person_add,
      mode: DialogMode.create,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              controller: _firstNameController,
              label: 'First Name',
              hintText: 'Enter first name',
            ),
            SizedBox(height: context.dimensions.spacingM),
            AppTextField(
              controller: _lastNameController,
              label: 'Last Name',
              hintText: 'Enter last name',
            ),
            SizedBox(height: context.dimensions.spacingM),
            CheckboxListTile(
              value: _isActive,
              onChanged: (value) => setState(() => _isActive = value!),
              title: const Text('Active'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      actions: [
        AppFormDialogActions(
          isLoading: _isLoading,
          mode: DialogMode.create,
          onConfirm: _handleSubmit,
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty) {
      await showWarningDialog(
        context: context,
        title: 'Missing Information',
        message: 'Please fill in all required fields.',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final employee = EmployeeModel(
        id: '',
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        isActive: _isActive,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await widget.ref.read(employeeRepositoryProvider).create(employee);

      if (mounted) {
        Navigator.of(context).pop();
        await showSuccessDialog(
          context: context,
          title: 'Success',
          message: 'Employee added successfully.',
        );
      }
    } catch (e) {
      if (mounted) {
        await showErrorDialog(
          context: context,
          title: 'Error',
          message: 'Failed to add employee: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

class _EditEmployeeDialog extends StatefulWidget {
  final EmployeeModel employee;
  final WidgetRef ref;

  const _EditEmployeeDialog({
    required this.employee,
    required this.ref,
  });

  @override
  State<_EditEmployeeDialog> createState() => _EditEmployeeDialogState();
}

class _EditEmployeeDialogState extends State<_EditEmployeeDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late bool _isActive;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.employee.firstName);
    _lastNameController = TextEditingController(text: widget.employee.lastName);
    _isActive = widget.employee.isActive;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFormDialog(
      title: 'Edit Employee',
      icon: Icons.edit,
      mode: DialogMode.edit,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              controller: _firstNameController,
              label: 'First Name',
              hintText: 'Enter first name',
            ),
            SizedBox(height: context.dimensions.spacingM),
            AppTextField(
              controller: _lastNameController,
              label: 'Last Name',
              hintText: 'Enter last name',
            ),
            SizedBox(height: context.dimensions.spacingM),
            CheckboxListTile(
              value: _isActive,
              onChanged: (value) => setState(() => _isActive = value!),
              title: const Text('Active'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      actions: [
        AppFormDialogActions(
          isLoading: _isLoading,
          mode: DialogMode.edit,
          onConfirm: _handleSubmit,
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty) {
      await showWarningDialog(
        context: context,
        title: 'Missing Information',
        message: 'Please fill in all required fields.',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final updatedEmployee = widget.employee.copyWith(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        isActive: _isActive,
        updatedAt: DateTime.now(),
      );

      await widget.ref.read(employeeRepositoryProvider).update(
        widget.employee.id,
        updatedEmployee,
      );

      if (mounted) {
        Navigator.of(context).pop();
        await showSuccessDialog(
          context: context,
          title: 'Success',
          message: 'Employee updated successfully.',
        );
      }
    } catch (e) {
      if (mounted) {
        await showErrorDialog(
          context: context,
          title: 'Error',
          message: 'Failed to update employee: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}