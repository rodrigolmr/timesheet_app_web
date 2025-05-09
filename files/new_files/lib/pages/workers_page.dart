import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/base_layout.dart';
import '../widgets/form_container.dart';
import '../widgets/buttons.dart';
import '../widgets/input_field.dart';

class WorkersPage extends StatefulWidget {
  const WorkersPage({Key? key}) : super(key: key);

  @override
  State<WorkersPage> createState() => _WorkersPageState();
}

class _WorkersPageState extends State<WorkersPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _searchController = TextEditingController();

  bool _isLoading = true;
  bool _isAdding = false;
  bool _isEditing = false;
  bool _showSearchInput = false;
  String? _editingId;
  String _userRole = 'User';

  List<DocumentSnapshot> _workers = [];
  List<DocumentSnapshot> _filteredWorkers = [];

  String _statusFilter = 'active'; // Valores: 'active', 'inactive', 'all'

  @override
  void initState() {
    super.initState();
    _checkUserRole();
    _loadWorkers();
  }

  @override
  void dispose() {
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
    } catch (e) {
      setState(() => _userRole = 'User');
    }
  }

  Future<void> _loadWorkers() async {
    setState(() => _isLoading = true);

    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('workers')
              .orderBy('lastName')
              .get();

      setState(() {
        _workers = snapshot.docs;
        _filterWorkers();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Erro ao carregar trabalhadores: ${e.toString()}');
    }
  }

  void _filterWorkers() {
    final searchTerm = _searchController.text.toLowerCase();

    setState(() {
      var filtered = _workers;
      if (searchTerm.isNotEmpty) {
        filtered =
            _workers.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final firstName =
                  (data['firstName'] as String? ?? '').toLowerCase();
              final lastName =
                  (data['lastName'] as String? ?? '').toLowerCase();

              return firstName.contains(searchTerm) ||
                  lastName.contains(searchTerm);
            }).toList();
      }

      if (_statusFilter != 'all') {
        filtered =
            filtered.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final status =
                  data['status'] as String? ??
                  'active'; // Se o status for nulo, assume-se 'active'
              return status == _statusFilter;
            }).toList();
      }

      _filteredWorkers = filtered;
    });
  }

  void _resetForm() {
    _firstNameController.clear();
    _lastNameController.clear();
    setState(() {
      _isAdding = false;
      _isEditing = false;
      _editingId = null;
    });
  }

  Future<void> _saveWorker() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty) {
      _showErrorSnackBar('Por favor, preencha nome e sobrenome');
      return;
    }

    try {
      final data = {
        'firstName': firstName,
        'lastName': lastName,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (!_isEditing) {
        data['status'] = 'active';
        data['createdAt'] = FieldValue.serverTimestamp();
      }

      if (_isEditing && _editingId != null) {
        await FirebaseFirestore.instance
            .collection('workers')
            .doc(_editingId)
            .update(data);
      } else {
        await FirebaseFirestore.instance.collection('workers').add(data);
      }

      _resetForm();
      await _loadWorkers();

      _showSuccessSnackBar(
        _isEditing
            ? 'Worker updated successfully'
            : 'Worker added successfully',
      );
    } catch (e) {
      _showErrorSnackBar('Error: ${e.toString()}');
    }
  }

  Future<void> _toggleWorkerStatus(String id, String currentStatus) async {
    final newStatus = currentStatus == 'active' ? 'inactive' : 'active';
    final statusText = newStatus == 'active' ? 'activate' : 'deactivate';

    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Confirm ${newStatus.capitalize()}'),
            content: Text('Are you sure you want to $statusText this worker?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(newStatus == 'active' ? 'Activate' : 'Deactivate'),
                style: TextButton.styleFrom(
                  foregroundColor:
                      newStatus == 'active' ? Colors.green : Colors.orange,
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        await FirebaseFirestore.instance.collection('workers').doc(id).update({
          'status': newStatus,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        await _loadWorkers();
        _showSuccessSnackBar('Worker ${statusText}d successfully');
      } catch (e) {
        _showErrorSnackBar('Error: ${e.toString()}');
      }
    }
  }

  void _editWorker(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    _firstNameController.text = data['firstName'] as String? ?? '';
    _lastNameController.text = data['lastName'] as String? ?? '';

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

  Future<void> _convertAllStatusToEnglish() async {
    try {
      setState(() => _isLoading = true);

      final snapshot =
          await FirebaseFirestore.instance.collection('workers').get();

      // Para cada documento, atualiza o status para o equivalente em inglês
      int updateCount = 0;
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final currentStatus = data['status'] as String?;

        String newStatus;
        if (currentStatus == 'ativo') {
          newStatus = 'active';
        } else if (currentStatus == 'inativo') {
          newStatus = 'inactive';
        } else if (currentStatus == null) {
          newStatus = 'active'; // Default é 'active'
        } else {
          // Se já estiver em inglês ou for outro valor, mantém
          continue;
        }

        await FirebaseFirestore.instance
            .collection('workers')
            .doc(doc.id)
            .update({
              'status': newStatus,
              'updatedAt': FieldValue.serverTimestamp(),
            });

        updateCount++;
      }

      await _loadWorkers();
      _showSuccessSnackBar(
        'Status de $updateCount workers convertidos para inglês',
      );
    } catch (e) {
      _showErrorSnackBar('Erro ao converter status: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = _userRole == 'Admin';

    return BaseLayout(
      title: 'Workers',
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
                      config: ButtonType.addWorkerButton.config,
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
                      hintText: 'Search workers...',
                      controller: _searchController,
                      onChanged: (_) => _filterWorkers(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppButton(
                          config: MiniButtonType.clearMiniButton.config,
                          onPressed: () {
                            _searchController.clear();
                            _filterWorkers();
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

              // Status filter buttons
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
                        _isEditing ? 'Edit Worker' : 'Add New Worker',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      InputField(
                        label: 'First Name',
                        hintText: 'First Name',
                        controller: _firstNameController,
                      ),
                      const SizedBox(height: 16),

                      InputField(
                        label: 'Last Name',
                        hintText: 'Last Name',
                        controller: _lastNameController,
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
                            onPressed: _saveWorker,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),

              if (_isLoading)
                const CircularProgressIndicator()
              else if (_filteredWorkers.isEmpty)
                const Text('No workers found', style: TextStyle(fontSize: 16))
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
                              flex: 4,
                              child: Text(
                                'Name',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (isAdmin)
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

                      for (int i = 0; i < _filteredWorkers.length; i++)
                        _buildWorkerRow(_filteredWorkers[i], i, isAdmin),
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
          _filterWorkers();
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

  Widget _buildWorkerRow(DocumentSnapshot doc, int index, bool isAdmin) {
    final data = doc.data() as Map<String, dynamic>;
    final status = (data['status'] as String?) ?? 'active';
    final isActive = status == 'active';

    return Container(
      color: index.isEven ? Colors.grey.shade100 : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 4,
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
                  _getWorkerFullName(doc),
                  style: TextStyle(
                    fontSize: 16,
                    color: isActive ? Colors.black : Colors.grey,
                    fontWeight: isActive ? FontWeight.normal : FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          if (isAdmin)
            SizedBox(
              width: 100, // Largura consistente
              child: Center(
                // Centraliza o conteúdo
                child: IconButton(
                  icon: const Icon(Icons.edit),
                  color: Colors.blue,
                  onPressed: () => _editWorker(doc),
                  tooltip: 'Edit',
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getWorkerFullName(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final firstName = data['firstName'] as String? ?? '';
    final lastName = data['lastName'] as String? ?? '';
    return '$firstName $lastName'.trim();
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
