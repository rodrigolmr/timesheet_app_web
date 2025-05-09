import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/base_layout.dart';
import '../widgets/form_container.dart';
import '../widgets/buttons.dart';
import '../widgets/input_field.dart';
import '../widgets/input_field_dropdown.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _searchController = TextEditingController();

  String _selectedRole = 'User';
  final List<String> _roles = ['User', 'Admin'];

  String _selectedStatus = 'active';
  final List<String> _statuses = ['active', 'inactive'];

  bool _isLoading = true;
  bool _isAdding = false;
  bool _isEditing = false;
  bool _showSearchInput = false;
  String? _editingId;
  String _userRole = 'User';
  bool _obscurePassword = true;

  List<DocumentSnapshot> _users = [];
  List<DocumentSnapshot> _filteredUsers = [];

  String _statusFilter = 'active'; // Valores: 'active', 'inactive', 'all'

  @override
  void initState() {
    super.initState();
    _checkUserRole();
    _loadUsers();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _checkUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      setState(() {
        _userRole =
            doc.exists ? (doc.data()?['role'] as String? ?? 'User') : 'User';
      });

      if (_userRole != 'Admin') {
        // Redirect non-admin users back to Settings
        Navigator.pop(context);
        _showErrorSnackBar('Only administrators can access this page');
      }
    } catch (e) {
      setState(() => _userRole = 'User');
      Navigator.pop(context);
    }
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);

    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .orderBy('firstName')
              .get();

      setState(() {
        _users = snapshot.docs;
        _filterUsers();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Error loading users: ${e.toString()}');
    }
  }

  void _filterUsers() {
    final searchTerm = _searchController.text.toLowerCase();

    setState(() {
      var filtered = _users;
      if (searchTerm.isNotEmpty) {
        filtered =
            _users.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final firstName =
                  (data['firstName'] as String? ?? '').toLowerCase();
              final lastName =
                  (data['lastName'] as String? ?? '').toLowerCase();
              final email = (data['email'] as String? ?? '').toLowerCase();

              return firstName.contains(searchTerm) ||
                  lastName.contains(searchTerm) ||
                  email.contains(searchTerm);
            }).toList();
      }

      if (_statusFilter != 'all') {
        filtered =
            filtered.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final status = data['status'] as String? ?? 'active';
              return status == _statusFilter;
            }).toList();
      }

      _filteredUsers = filtered;
    });
  }

  void _resetForm() {
    _emailController.clear();
    _passwordController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    setState(() {
      _selectedRole = 'User';
      _selectedStatus = 'active';
      _isAdding = false;
      _isEditing = false;
      _editingId = null;
      _obscurePassword = true;
    });
  }

  Future<void> _saveUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    if (email.isEmpty || (_isAdding && password.isEmpty) || firstName.isEmpty) {
      _showErrorSnackBar('Email, password and first name are required');
      return;
    }

    try {
      if (_isEditing && _editingId != null) {
        final data = {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'role': _selectedRole,
          'status': _selectedStatus,
          'updatedAt': FieldValue.serverTimestamp(),
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc(_editingId)
            .update(data);

        _resetForm();
        await _loadUsers();
        _showSuccessSnackBar('User updated successfully');
      } else {
        final userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        final userId = userCredential.user!.uid;

        final data = {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'role': _selectedRole,
          'status': 'active',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .set(data);

        _resetForm();
        await _loadUsers();
        _showSuccessSnackBar('User created successfully');
      }
    } catch (e) {
      _showErrorSnackBar('Error: ${e.toString()}');
    }
  }

  Future<void> _toggleUserStatus(String id, String currentStatus) async {
    final newStatus = currentStatus == 'active' ? 'inactive' : 'active';

    try {
      await FirebaseFirestore.instance.collection('users').doc(id).update({
        'status': newStatus,
      });

      _showSuccessSnackBar(
        'User ${newStatus == 'active' ? 'activated' : 'deactivated'} successfully',
      );

      await _loadUsers();
    } catch (e) {
      _showErrorSnackBar('Error updating user status: ${e.toString()}');
    }
  }

  void _editUser(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    _emailController.text = data['email'] as String? ?? '';
    _firstNameController.text = data['firstName'] as String? ?? '';
    _lastNameController.text = data['lastName'] as String? ?? '';
    _selectedRole = data['role'] as String? ?? 'User';
    _selectedStatus = data['status'] as String? ?? 'active';

    setState(() {
      _isEditing = true;
      _isAdding = false;
      _editingId = doc.id;
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = _userRole == 'Admin';

    if (!isAdmin) {
      return const SizedBox.shrink();
    }

    return BaseLayout(
      title: 'User Management',
      showTitleBox: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: FormContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top row with buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left - Back button
                  AppButton(
                    config: ButtonType.backButton.config,
                    onPressed: () => Navigator.pop(context),
                  ),

                  // Middle - Add button
                  if (!_isAdding && !_isEditing)
                    AppButton(
                      config: ButtonType.addUserButton.config,
                      onPressed: () => setState(() => _isAdding = true),
                    ),

                  // Right - Search button
                  AppButton(
                    config: ButtonType.searchButton.config,
                    onPressed:
                        () => setState(
                          () => _showSearchInput = !_showSearchInput,
                        ),
                  ),
                ],
              ),

              // Search input field section
              if (_showSearchInput) ...[
                const SizedBox(height: 16),
                Column(
                  children: [
                    InputField(
                      label: 'Search',
                      hintText: 'Search users...',
                      controller: _searchController,
                      onChanged: (_) => _filterUsers(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppButton(
                          config: MiniButtonType.clearMiniButton.config,
                          onPressed: () {
                            _searchController.clear();
                            _filterUsers();
                          },
                        ),
                        const SizedBox(width: 16),
                        AppButton(
                          config: MiniButtonType.closeMiniButton.config,
                          onPressed: () {
                            setState(() {
                              _showSearchInput = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatusFilterButton(
                    label: 'Active',
                    status: 'active',
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  _buildStatusFilterButton(
                    label: 'Inactive',
                    status: 'inactive',
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  _buildStatusFilterButton(
                    label: 'All',
                    status: 'all',
                    color: Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (_isAdding || _isEditing)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0FF),
                    border: Border.all(color: const Color(0xFF0205D3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isEditing ? 'Edit User' : 'Add New User',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      InputField(
                        label: 'Email',
                        hintText: 'Enter email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textCapitalization: TextCapitalization.none,
                      ),
                      const SizedBox(height: 16),

                      if (_isAdding)
                        InputField(
                          label: 'Password',
                          hintText: 'Enter password',
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textCapitalization: TextCapitalization.none,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed:
                                () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                          ),
                        ),
                      if (_isAdding) const SizedBox(height: 16),

                      InputField(
                        label: 'First Name',
                        hintText: 'Enter first name',
                        controller: _firstNameController,
                      ),
                      const SizedBox(height: 16),

                      InputField(
                        label: 'Last Name',
                        hintText: 'Enter last name',
                        controller: _lastNameController,
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Role',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: const Color(0xFFFFFDD0),
                        ),
                        value: _selectedRole,
                        items:
                            _roles.map((String role) {
                              return DropdownMenuItem<String>(
                                value: role,
                                child: Text(role),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() => _selectedRole = newValue);
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: const Color(0xFFFFFDD0),
                        ),
                        value: _selectedStatus,
                        items:
                            _statuses.map((String status) {
                              return DropdownMenuItem<String>(
                                value: status,
                                child: Text(status.capitalize()),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() => _selectedStatus = newValue);
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppButton(
                            config: MiniButtonType.cancelMiniButton.config,
                            onPressed: _resetForm,
                          ),
                          const SizedBox(width: 16),
                          AppButton(
                            config: MiniButtonType.clearMiniButton.config,
                            onPressed: () {
                              _emailController.clear();
                              _passwordController.clear();
                              _firstNameController.clear();
                              _lastNameController.clear();
                            },
                          ),
                          const SizedBox(width: 16),
                          AppButton(
                            config:
                                _isEditing
                                    ? MiniButtonType.saveMiniButton.config
                                    : MiniButtonType.addMiniButton.config,
                            onPressed: _saveUser,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),

              if (_isLoading)
                const CircularProgressIndicator()
              else if (_filteredUsers.isEmpty)
                const Text('No users found', style: TextStyle(fontSize: 16))
              else
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Container(
                        color: const Color(0xFF0205D3),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Text(
                                'Name',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: Text(
                                'Edit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),

                      for (int i = 0; i < _filteredUsers.length; i++)
                        _buildUserRow(_filteredUsers[i], i),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusFilterButton({
    required String label,
    required String status,
    required Color color,
  }) {
    final isSelected = _statusFilter == status;

    return OutlinedButton(
      onPressed: () {
        setState(() {
          _statusFilter = status;
          _filterUsers();
        });
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? color : null,
        foregroundColor: isSelected ? Colors.white : color,
        side: BorderSide(color: color),
      ),
      child: Text(label),
    );
  }

  Widget _buildUserRow(DocumentSnapshot doc, int index) {
    final data = doc.data() as Map<String, dynamic>;
    final status = data['status'] as String? ?? 'active';
    final isActive = status == 'active';

    return Container(
      color: index.isEven ? Colors.grey.shade100 : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Row(
              children: [
                // Indicador visual de status
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? Colors.green : Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _getUserFullName(doc),
                  style: TextStyle(
                    fontSize: 16,
                    color: isActive ? Colors.black : Colors.grey,
                    fontWeight: isActive ? FontWeight.normal : FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 100,
            child: Center(
              // Centralizando o ícone
              child: IconButton(
                icon: const Icon(Icons.edit),
                color: Colors.blue,
                onPressed: () => _editUser(doc),
                tooltip: 'Edit',
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getUserFullName(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final firstName = data['firstName'] as String? ?? '';
    final lastName = data['lastName'] as String? ?? '';
    return '$firstName $lastName'.trim();
  }

  String _getUserEmail(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return data['email'] as String? ?? '';
  }

  String _getUserRole(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return data['role'] as String? ?? 'User';
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
