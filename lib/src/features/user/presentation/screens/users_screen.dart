import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/widgets.dart';
import 'package:timesheet_app_web/src/features/user/data/models/user_model.dart';
import 'package:timesheet_app_web/src/features/user/presentation/providers/user_providers.dart';
import 'package:timesheet_app_web/src/features/user/presentation/providers/user_search_providers.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive_grid.dart';
import 'package:timesheet_app_web/src/features/user/presentation/widgets/user_filters.dart';
import 'package:timesheet_app_web/src/core/widgets/dialogs/dialogs.dart';
import 'package:timesheet_app_web/src/features/employee/presentation/providers/employee_providers.dart';
import 'package:timesheet_app_web/src/features/employee/data/models/employee_model.dart';

class UsersScreen extends ConsumerStatefulWidget {
  const UsersScreen({super.key});

  @override
  ConsumerState<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> {
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
    final usersAsync = ref.watch(usersStreamProvider);
    
    return Scaffold(
      appBar: AppHeader(
        title: 'Users',
        subtitle: 'Manage system users',
        actionIcon: Icons.add,
        onActionPressed: () => _showCreateDialog(context),
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: usersAsync.when(
              data: (users) => _buildUserList(context, users),
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
                      'Error loading users',
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
    return UserFilters(
      searchController: _searchController,
      searchQuery: _searchQuery,
      selectedStatus: _selectedStatus,
      filtersExpanded: _filtersExpanded,
      onSearchChanged: (query) {
        setState(() {
          _searchQuery = query.trim();
        });
        ref.read(userSearchQueryProvider.notifier).updateQuery(query);
      },
      onStatusChanged: (status) {
        setState(() {
          _selectedStatus = status;
        });
        // Update the provider based on status
        if (status == 'active') {
          ref.read(userSearchFiltersProvider.notifier).updateActiveStatus(true);
        } else if (status == 'inactive') {
          ref.read(userSearchFiltersProvider.notifier).updateActiveStatus(false);
        } else {
          ref.read(userSearchFiltersProvider.notifier).updateActiveStatus(null);
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
    ref.read(userSearchQueryProvider.notifier).updateQuery('');
    ref.read(userSearchFiltersProvider.notifier).updateActiveStatus(null);
  }

  Widget _buildUserList(BuildContext context, List<UserModel> allUsers) {
    final searchResults = ref.watch(userSearchResultsProvider);
    final users = searchResults.isEmpty && _searchController.text.isEmpty && _selectedStatus == 'all'
        ? allUsers
        : searchResults;
    
    if (users.isEmpty) {
      return _buildEmptyState(context);
    }

    final isMobile = context.isMobile;
    
    if (isMobile) {
      return ListView.builder(
        padding: EdgeInsets.all(context.dimensions.spacingM),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return _buildUserCard(context, user);
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
        children: users.map((user) => 
          _buildUserCard(context, user)
        ).toList(),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, UserModel user) {
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
                backgroundColor: user.isActive 
                    ? context.colors.primary 
                    : context.colors.textSecondary.withOpacity(0.3),
                child: Text(
                  '${user.firstName[0]}${user.lastName[0]}',
                  style: TextStyle(
                    color: user.isActive 
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
                      '${user.firstName} ${user.lastName}',
                      style: context.textStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: context.responsive<double>(xs: 14, sm: 15, md: 16),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.email,
                      style: context.textStyles.caption.copyWith(
                        color: context.colors.textSecondary,
                        fontSize: context.responsive<double>(xs: 11, sm: 12, md: 13),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 2),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.responsive<double>(xs: 6, sm: 7, md: 8),
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: user.isActive
                                ? context.colors.success.withOpacity(0.1)
                                : context.colors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            user.isActive ? 'Active' : 'Inactive',
                            style: context.textStyles.caption.copyWith(
                              color: user.isActive
                                  ? context.colors.success
                                  : context.colors.error,
                              fontWeight: FontWeight.w600,
                              fontSize: context.responsive<double>(xs: 10, sm: 11, md: 12),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.responsive<double>(xs: 6, sm: 7, md: 8),
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: context.colors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            user.role,
                            style: context.textStyles.caption.copyWith(
                              color: context.colors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: context.responsive<double>(xs: 10, sm: 11, md: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.edit_outlined,
                  size: context.responsive<double>(xs: 18, sm: 20, md: 22),
                ),
                onPressed: () => _showEditDialog(context, user),
                tooltip: 'Edit user',
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
            hasFilters ? 'No users found' : 'No users yet',
            style: context.textStyles.title.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasFilters 
                ? 'Try adjusting your search or filters'
                : 'Start by adding your first user',
            style: context.textStyles.body.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          if (!hasFilters)
            ElevatedButton.icon(
              onPressed: () => _showCreateDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Add User'),
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
      builder: (_) => _CreateUserDialog(ref: ref),
    );
  }

  void _showEditDialog(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (_) => _EditUserDialog(user: user, ref: ref),
    );
  }
}

class _CreateUserDialog extends ConsumerStatefulWidget {
  final WidgetRef ref;

  const _CreateUserDialog({required this.ref});

  @override
  ConsumerState<_CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends ConsumerState<_CreateUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'user';
  bool _isActive = true;
  bool _isLoading = false;
  bool _showValidationErrors = false;
  
  // New fields for employee association
  String _employeeAssociation = 'new'; // 'new', 'existing', 'none'
  String? _selectedEmployeeId;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employeesWithoutUserAsync = ref.watch(employeesWithoutUserStreamProvider);
    
    return AppFormDialog(
      title: 'Add User',
      icon: Icons.person_add,
      mode: DialogMode.create,
      actions: [
        AppFormDialogActions(
          isLoading: _isLoading,
          mode: DialogMode.create,
          onConfirm: _handleSubmit,
        ),
      ],
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Employee Association Radio Buttons
            Container(
              padding: EdgeInsets.all(context.dimensions.spacingS),
              decoration: BoxDecoration(
                border: Border.all(color: context.colors.outline),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Employee Association',
                    style: context.textStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  RadioListTile<String>(
                    value: 'new',
                    groupValue: _employeeAssociation,
                    onChanged: (value) => setState(() {
                      _employeeAssociation = value!;
                      _selectedEmployeeId = null;
                    }),
                    title: const Text('Create new employee'),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  RadioListTile<String>(
                    value: 'existing',
                    groupValue: _employeeAssociation,
                    onChanged: (value) => setState(() {
                      _employeeAssociation = value!;
                    }),
                    title: const Text('Link to existing employee'),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  RadioListTile<String>(
                    value: 'none',
                    groupValue: _employeeAssociation,
                    onChanged: (value) => setState(() {
                      _employeeAssociation = value!;
                      _selectedEmployeeId = null;
                    }),
                    title: const Text('No employee association'),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            SizedBox(height: context.dimensions.spacingM),
            
            // Employee Dropdown (only visible when "existing" is selected)
            if (_employeeAssociation == 'existing')
              employeesWithoutUserAsync.when(
                data: (employees) {
                  print('Employees without user: ${employees.length}');
                  return Column(
                  children: [
                    if (employees.isEmpty)
                      Container(
                        padding: EdgeInsets.all(context.dimensions.spacingM),
                        decoration: BoxDecoration(
                          color: context.colors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: context.colors.warning),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: context.colors.warning),
                            SizedBox(width: context.dimensions.spacingS),
                            Expanded(
                              child: Text(
                                'No employees available. All employees already have user accounts.',
                                style: context.textStyles.body,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (employees.isNotEmpty)
                      AppDropdownField<EmployeeModel>(
                        label: 'Select Employee',
                        hintText: 'Choose an employee',
                        items: employees,
                        value: employees.firstWhereOrNull((e) => e.id == _selectedEmployeeId),
                        itemLabelBuilder: (employee) => '${employee.firstName} ${employee.lastName}',
                        onChanged: (employee) {
                          setState(() {
                            _selectedEmployeeId = employee?.id;
                            // Auto-fill name fields when employee is selected
                            if (employee != null) {
                              _firstNameController.text = employee.firstName;
                              _lastNameController.text = employee.lastName;
                            }
                          });
                        },
                        hasError: _employeeAssociation == 'existing' && _selectedEmployeeId == null && _showValidationErrors,
                        errorText: 'Please select an employee',
                      ),
                    SizedBox(height: context.dimensions.spacingM),
                  ],
                );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Text(
                  'Error loading employees',
                  style: TextStyle(color: context.colors.error),
                ),
              ),
            
            AppTextField(
              controller: _firstNameController,
              label: 'First Name',
              hintText: 'Enter first name',
              enabled: _employeeAssociation != 'existing',
            ),
            SizedBox(height: context.dimensions.spacingM),
            AppTextField(
              controller: _lastNameController,
              label: 'Last Name',
              hintText: 'Enter last name',
              enabled: _employeeAssociation != 'existing',
            ),
            SizedBox(height: context.dimensions.spacingM),
            AppTextField.email(
              controller: _emailController,
              label: 'Email',
              hintText: 'Enter email',
            ),
            SizedBox(height: context.dimensions.spacingM),
            AppPasswordField(
              controller: _passwordController,
              label: 'Password',
              hintText: 'Enter password',
            ),
            SizedBox(height: context.dimensions.spacingM),
            AppDropdownField<String>(
              label: 'Role',
              hintText: 'Select user role',
              items: const ['admin', 'manager', 'user'],
              value: _selectedRole,
              itemLabelBuilder: (role) => role[0].toUpperCase() + role.substring(1),
              onChanged: (value) => setState(() => _selectedRole = value!),
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
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      await showWarningDialog(
        context: context,
        title: 'Missing Information',
        message: 'Please fill in all required fields.',
      );
      return;
    }
    
    // Validate employee selection when linking to existing employee
    if (_employeeAssociation == 'existing' && _selectedEmployeeId == null) {
      setState(() => _showValidationErrors = true);
      await showWarningDialog(
        context: context,
        title: 'Missing Information',
        message: 'Please select an employee to link.',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = UserModel(
        id: '',
        authUid: '', // This will be set by the repository
        email: _emailController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        role: _selectedRole,
        isActive: _isActive,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final userRepository = widget.ref.read(userRepositoryProvider);
      final password = _passwordController.text.trim();
      
      // Call different methods based on employee association
      switch (_employeeAssociation) {
        case 'new':
          await userRepository.createUserWithNewEmployee(user, password);
          break;
        case 'existing':
          await userRepository.createUserWithExistingEmployee(
            user, 
            password, 
            _selectedEmployeeId!,
          );
          break;
        case 'none':
          await userRepository.createUserWithAuth(user, password);
          break;
      }

      if (mounted) {
        Navigator.of(context).pop();
        await showSuccessDialog(
          context: context,
          title: 'Success',
          message: 'User added successfully.',
        );
      }
    } catch (e) {
      if (mounted) {
        await showErrorDialog(
          context: context,
          title: 'Error',
          message: 'Failed to add user: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

class _EditUserDialog extends ConsumerStatefulWidget {
  final UserModel user;
  final WidgetRef ref;

  const _EditUserDialog({
    required this.user,
    required this.ref,
  });

  @override
  ConsumerState<_EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends ConsumerState<_EditUserDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late String _selectedRole;
  late bool _isActive;
  bool _isLoading = false;
  String? _selectedEmployeeId;
  bool _showEmployeeSelection = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _emailController = TextEditingController(text: widget.user.email);
    _selectedRole = widget.user.role.toLowerCase();
    _isActive = widget.user.isActive;
    _selectedEmployeeId = widget.user.employeeId;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFormDialog(
      title: 'Edit User',
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
            AppTextField.email(
              controller: _emailController,
              label: 'Email',
              hintText: 'Enter email',
            ),
            SizedBox(height: context.dimensions.spacingM),
            AppDropdownField<String>(
              label: 'Role',
              hintText: 'Select user role',
              items: const ['admin', 'manager', 'user'],
              value: _selectedRole,
              itemLabelBuilder: (role) => role[0].toUpperCase() + role.substring(1),
              onChanged: (value) => setState(() => _selectedRole = value!),
            ),
            SizedBox(height: context.dimensions.spacingM),
            CheckboxListTile(
              value: _isActive,
              onChanged: (value) => setState(() => _isActive = value!),
              title: const Text('Active'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            SizedBox(height: context.dimensions.spacingM),
            
            // Employee Association Section
            Container(
              padding: EdgeInsets.all(context.dimensions.spacingS),
              decoration: BoxDecoration(
                border: Border.all(color: context.colors.outline),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Employee Association',
                    style: context.textStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: context.dimensions.spacingS),
                  
                  // Show current employee if exists
                  if (_selectedEmployeeId != null) ...[
                    FutureBuilder<EmployeeModel?>(
                      future: ref.read(employeeProvider(_selectedEmployeeId!).future),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        
                        final employee = snapshot.data;
                        if (employee == null) {
                          return Text(
                            'Associated employee not found',
                            style: TextStyle(color: context.colors.error),
                          );
                        }
                        
                        return Container(
                          padding: EdgeInsets.all(context.dimensions.spacingS),
                          decoration: BoxDecoration(
                            color: context.colors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: context.colors.primary,
                                size: 20,
                              ),
                              SizedBox(width: context.dimensions.spacingS),
                              Expanded(
                                child: Text(
                                  '${employee.firstName} ${employee.lastName}',
                                  style: context.textStyles.body.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: context.colors.error,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selectedEmployeeId = null;
                                  });
                                },
                                tooltip: 'Remove association',
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ] else ...[
                    // Show option to associate with employee
                    if (!_showEmployeeSelection) ...[
                      Center(
                        child: TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _showEmployeeSelection = true;
                            });
                          },
                          icon: const Icon(Icons.link),
                          label: const Text('Associate with Employee'),
                        ),
                      ),
                    ] else ...[
                      // Employee selection dropdown
                      Consumer(
                        builder: (context, ref, child) {
                          final employeesWithoutUserAsync = ref.watch(employeesWithoutUserStreamProvider);
                          
                          return employeesWithoutUserAsync.when(
                            data: (employees) {
                              if (employees.isEmpty) {
                                return Container(
                                  padding: EdgeInsets.all(context.dimensions.spacingM),
                                  decoration: BoxDecoration(
                                    color: context.colors.warning.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: context.colors.warning),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.info_outline, color: context.colors.warning),
                                      SizedBox(width: context.dimensions.spacingS),
                                      Expanded(
                                        child: Text(
                                          'No employees available. All employees already have user accounts.',
                                          style: context.textStyles.body,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              
                              return Column(
                                children: [
                                  AppDropdownField<EmployeeModel>(
                                    label: 'Select Employee',
                                    hintText: 'Choose an employee to associate',
                                    items: employees,
                                    value: employees.firstWhereOrNull((e) => e.id == _selectedEmployeeId),
                                    itemLabelBuilder: (employee) => '${employee.firstName} ${employee.lastName}',
                                    onChanged: (employee) {
                                      setState(() {
                                        _selectedEmployeeId = employee?.id;
                                        _showEmployeeSelection = false;
                                      });
                                    },
                                  ),
                                  SizedBox(height: context.dimensions.spacingS),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _showEmployeeSelection = false;
                                      });
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                ],
                              );
                            },
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (error, _) => Text(
                              'Error loading employees',
                              style: TextStyle(color: context.colors.error),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ],
              ),
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
        _lastNameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty) {
      await showWarningDialog(
        context: context,
        title: 'Missing Information',
        message: 'Please fill in all required fields.',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userRepository = widget.ref.read(userRepositoryProvider);
      
      // Check if we need to handle employee association changes
      final hasEmployeeChanged = widget.user.employeeId != _selectedEmployeeId;
      
      if (hasEmployeeChanged) {
        final employeeRepository = ref.read(employeeRepositoryProvider);
        
        // If user had an employee and now doesn't
        if (widget.user.employeeId != null && _selectedEmployeeId == null) {
          // Remove association from old employee
          await employeeRepository.dissociateFromUser(widget.user.employeeId!);
        }
        // If user had an employee and is getting a different one
        else if (widget.user.employeeId != null && _selectedEmployeeId != null && widget.user.employeeId != _selectedEmployeeId) {
          // Remove association from old employee
          await employeeRepository.dissociateFromUser(widget.user.employeeId!);
          // Associate with new employee
          await userRepository.associateUserWithEmployee(widget.user.id, _selectedEmployeeId!);
        }
        // If user didn't have an employee and is getting one
        else if (widget.user.employeeId == null && _selectedEmployeeId != null) {
          // Associate with new employee
          await userRepository.associateUserWithEmployee(widget.user.id, _selectedEmployeeId!);
        }
      }
      
      // Update user data (including employeeId)
      final updatedUser = widget.user.copyWith(
        email: _emailController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        role: _selectedRole,
        isActive: _isActive,
        employeeId: _selectedEmployeeId,
        updatedAt: DateTime.now(),
      );

      await userRepository.update(
        widget.user.id,
        updatedUser,
      );

      if (mounted) {
        Navigator.of(context).pop();
        await showSuccessDialog(
          context: context,
          title: 'Success',
          message: 'User updated successfully.',
        );
      }
    } catch (e) {
      if (mounted) {
        await showErrorDialog(
          context: context,
          title: 'Error',
          message: 'Failed to update user: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}