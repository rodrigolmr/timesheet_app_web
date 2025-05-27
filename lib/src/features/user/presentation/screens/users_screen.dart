import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/app_header.dart';
import 'package:timesheet_app_web/src/features/user/data/models/user_model.dart';
import 'package:timesheet_app_web/src/features/user/presentation/providers/user_providers.dart';
import 'package:timesheet_app_web/src/features/user/presentation/providers/user_search_providers.dart';
import 'package:timesheet_app_web/src/core/widgets/input/app_text_field.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive_grid.dart';
import 'package:timesheet_app_web/src/features/user/presentation/widgets/user_filters.dart';

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
                    ),
                    const SizedBox(height: 2),
                    Row(
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
                        const SizedBox(width: 6),
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

class _CreateUserDialog extends StatefulWidget {
  final WidgetRef ref;

  const _CreateUserDialog({required this.ref});

  @override
  State<_CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<_CreateUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedRole = 'user';
  bool _isActive = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add User'),
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
            AppTextField(
              controller: _emailController,
              label: 'Email',
              hintText: 'Enter email',
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: context.dimensions.spacingM),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: const InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
                DropdownMenuItem(value: 'manager', child: Text('Manager')),
                DropdownMenuItem(value: 'user', child: Text('User')),
              ],
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
        _lastNameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty) {
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

      await widget.ref.read(userRepositoryProvider).create(user);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('User added successfully'),
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

class _EditUserDialog extends StatefulWidget {
  final UserModel user;
  final WidgetRef ref;

  const _EditUserDialog({
    required this.user,
    required this.ref,
  });

  @override
  State<_EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<_EditUserDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late String _selectedRole;
  late bool _isActive;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _emailController = TextEditingController(text: widget.user.email);
    _selectedRole = widget.user.role.toLowerCase();
    _isActive = widget.user.isActive;
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
    return AlertDialog(
      title: const Text('Edit User'),
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
            AppTextField(
              controller: _emailController,
              label: 'Email',
              hintText: 'Enter email',
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: context.dimensions.spacingM),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: const InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
                DropdownMenuItem(value: 'manager', child: Text('Manager')),
                DropdownMenuItem(value: 'user', child: Text('User')),
              ],
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
        _lastNameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty) {
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
      final updatedUser = widget.user.copyWith(
        email: _emailController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        role: _selectedRole,
        isActive: _isActive,
        updatedAt: DateTime.now(),
      );

      await widget.ref.read(userRepositoryProvider).update(
        widget.user.id,
        updatedUser,
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('User updated successfully'),
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