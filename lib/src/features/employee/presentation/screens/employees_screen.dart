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

class EmployeesScreen extends ConsumerStatefulWidget {
  const EmployeesScreen({super.key});

  @override
  ConsumerState<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends ConsumerState<EmployeesScreen> {
  final _searchController = TextEditingController();
  bool? _filterIsActive;
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
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(
          bottom: BorderSide(
            color: context.colors.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: _filtersExpanded ? null : 60,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(context.dimensions.spacingM),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 36,
                        child: AppTextField(
                          controller: _searchController,
                          label: '',
                          hintText: 'Search by name...',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          onChanged: (value) {
                            ref.read(employeeSearchQueryProvider.notifier).updateQuery(value);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        _filtersExpanded ? Icons.expand_less : Icons.expand_more,
                        color: context.colors.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          _filtersExpanded = !_filtersExpanded;
                        });
                      },
                      tooltip: _filtersExpanded ? 'Hide filters' : 'Show filters',
                    ),
                  ],
                ),
                if (_filtersExpanded) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            FilterChip(
                              label: const Text('Active'),
                              selected: _filterIsActive == true,
                              onSelected: (selected) {
                                setState(() {
                                  _filterIsActive = selected ? true : null;
                                });
                                ref.read(employeeSearchFiltersProvider.notifier)
                                    .updateActiveStatus(selected ? true : null);
                              },
                              selectedColor: context.colors.primary.withOpacity(0.2),
                            ),
                            FilterChip(
                              label: const Text('Inactive'),
                              selected: _filterIsActive == false,
                              onSelected: (selected) {
                                setState(() {
                                  _filterIsActive = selected ? false : null;
                                });
                                ref.read(employeeSearchFiltersProvider.notifier)
                                    .updateActiveStatus(selected ? false : null);
                              },
                              selectedColor: context.colors.error.withOpacity(0.2),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: _clearAllFilters,
                        child: const Text('Clear filters'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _filterIsActive = null;
      _searchController.clear();
    });
    ref.read(employeeSearchQueryProvider.notifier).updateQuery('');
    ref.read(employeeSearchFiltersProvider.notifier).updateActiveStatus(null);
  }

  Widget _buildEmployeeList(BuildContext context, List<EmployeeModel> allEmployees) {
    final searchResults = ref.watch(employeeSearchResultsProvider);
    final employees = searchResults.isEmpty && _searchController.text.isEmpty && _filterIsActive == null
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
      margin: EdgeInsets.only(bottom: context.dimensions.spacingM),
      child: Padding(
          padding: EdgeInsets.all(context.dimensions.spacingM),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
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
                  ),
                ),
              ),
              SizedBox(width: context.dimensions.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${employee.firstName} ${employee.lastName}',
                      style: context.textStyles.subtitle.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: employee.isActive
                                ? context.colors.success.withOpacity(0.1)
                                : context.colors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            employee.isActive ? 'Active' : 'Inactive',
                            style: context.textStyles.caption.copyWith(
                              color: employee.isActive
                                  ? context.colors.success
                                  : context.colors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => _showEditDialog(context, employee),
                tooltip: 'Edit employee',
              ),
            ],
          ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final hasFilters = _searchController.text.isNotEmpty || _filterIsActive != null;
    
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

class _CreateEmployeeDialog extends StatefulWidget {
  final WidgetRef ref;

  const _CreateEmployeeDialog({required this.ref});

  @override
  State<_CreateEmployeeDialog> createState() => _CreateEmployeeDialogState();
}

class _CreateEmployeeDialogState extends State<_CreateEmployeeDialog> {
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
    return AlertDialog(
      title: const Text('Add Employee'),
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
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colors.primary,
            foregroundColor: context.colors.onPrimary,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Add'),
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in all fields'),
          backgroundColor: context.colors.error,
        ),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Employee added successfully'),
            backgroundColor: context.colors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: context.colors.error,
          ),
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
    return AlertDialog(
      title: const Text('Edit Employee'),
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
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colors.primary,
            foregroundColor: context.colors.onPrimary,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in all fields'),
          backgroundColor: context.colors.error,
        ),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Employee updated successfully'),
            backgroundColor: context.colors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: context.colors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}