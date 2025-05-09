import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/base_layout.dart';
import '../widgets/form_container.dart';
import '../widgets/buttons.dart';
import '../widgets/input_field.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({Key? key}) : super(key: key);

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  final _cardNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _searchController = TextEditingController();

  bool _isLoading = true;
  bool _isAdding = false;
  bool _isEditing = false;
  bool _showSearchInput = false;
  String? _editingId;
  String _userRole = 'User';

  List<DocumentSnapshot> _cards = [];
  List<DocumentSnapshot> _filteredCards = [];

  // Mudando o valor padrão do filtro para 'all' para mostrar todos os cards
  String _statusFilter = 'all'; // Values: 'active', 'inactive', 'all'

  @override
  void initState() {
    super.initState();
    _checkUserRole();
    _loadCards();
  }

  @override
  void dispose() {
    _cardNameController.dispose();
    _cardNumberController.dispose();
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
        Navigator.pop(context);
        _showErrorSnackBar('Only administrators can access this page');
      }
    } catch (e) {
      setState(() => _userRole = 'User');
      Navigator.pop(context);
    }
  }

  Future<void> _loadCards() async {
    setState(() => _isLoading = true);

    try {
      // Log para debug
      print("Iniciando carregamento dos cards...");

      final snapshot =
          await FirebaseFirestore.instance
              .collection('cards')
              .orderBy('cardholderName') // Nome do campo no app antigo
              .get();

      print("Cards recuperados: ${snapshot.docs.length}");

      // Log para debug dos campos
      if (snapshot.docs.isNotEmpty) {
        final firstCard = snapshot.docs.first.data();
        print("Primeiro card: ${firstCard.keys}");
      }

      setState(() {
        _cards = snapshot.docs;
        _filterCards();
        _isLoading = false;
      });
    } catch (e) {
      print("Erro ao carregar cards: $e");
      setState(() => _isLoading = false);
      _showErrorSnackBar('Error loading cards: ${e.toString()}');
    }
  }

  void _filterCards() {
    final searchTerm = _searchController.text.toLowerCase();

    setState(() {
      var filtered = _cards;
      if (searchTerm.isNotEmpty) {
        filtered =
            _cards.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              // Verificando os dois conjuntos possíveis de campos (antigo e novo)
              final cardName =
                  ((data['cardName'] ?? data['cardholderName']) as String? ??
                          '')
                      .toLowerCase();
              final cardNumber =
                  ((data['cardNumber'] ?? data['last4Digits']) as String? ?? '')
                      .toLowerCase();

              return cardName.contains(searchTerm) ||
                  cardNumber.contains(searchTerm);
            }).toList();
      }

      if (_statusFilter != 'all') {
        filtered =
            filtered.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final status = data['status'] as String? ?? 'active';
              // Para o app antigo que usava 'ativo' e 'inativo'
              return status == _statusFilter ||
                  (status == 'ativo' && _statusFilter == 'active') ||
                  (status == 'inativo' && _statusFilter == 'inactive');
            }).toList();
      }

      _filteredCards = filtered;
    });
  }

  void _resetForm() {
    _cardNameController.clear();
    _cardNumberController.clear();
    setState(() {
      _isAdding = false;
      _isEditing = false;
      _editingId = null;
    });
  }

  Future<void> _saveCard() async {
    final cardName = _cardNameController.text.trim();
    final cardNumber = _cardNumberController.text.trim();

    if (cardName.isEmpty || cardNumber.isEmpty) {
      _showErrorSnackBar('Card name and number are required');
      return;
    }

    try {
      final data = {
        'cardName': cardName,
        'cardNumber': cardNumber,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (!_isEditing) {
        data['status'] = 'active';
        data['createdAt'] = FieldValue.serverTimestamp();
      }

      if (_isEditing && _editingId != null) {
        await FirebaseFirestore.instance
            .collection('cards')
            .doc(_editingId)
            .update(data);
      } else {
        await FirebaseFirestore.instance.collection('cards').add(data);
      }

      _resetForm();
      await _loadCards();

      _showSuccessSnackBar(
        _isEditing ? 'Card updated successfully' : 'Card added successfully',
      );
    } catch (e) {
      _showErrorSnackBar('Error: ${e.toString()}');
    }
  }

  Future<void> _toggleCardStatus(String id, String currentStatus) async {
    final newStatus = currentStatus == 'active' ? 'inactive' : 'active';
    final statusText = newStatus == 'active' ? 'activate' : 'deactivate';

    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Confirm ${newStatus.capitalize()}'),
            content: Text('Are you sure you want to $statusText this card?'),
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
        await FirebaseFirestore.instance.collection('cards').doc(id).update({
          'status': newStatus,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        await _loadCards();
        _showSuccessSnackBar('Card ${statusText}d successfully');
      } catch (e) {
        _showErrorSnackBar('Error: ${e.toString()}');
      }
    }
  }

  void _editCard(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Usa campos do app antigo se os novos não existirem
    _cardNameController.text =
        (data['cardName'] ?? data['cardholderName']) as String? ?? '';
    _cardNumberController.text =
        (data['cardNumber'] ?? data['last4Digits']) as String? ?? '';

    setState(() {
      _isEditing = true;
      _isAdding = false;
      _editingId = doc.id;
    });
  }

  Future<void> _convertAllStatusToEnglish() async {
    try {
      setState(() => _isLoading = true);

      final snapshot =
          await FirebaseFirestore.instance.collection('cards').get();

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

        await FirebaseFirestore.instance.collection('cards').doc(doc.id).update(
          {'status': newStatus, 'updatedAt': FieldValue.serverTimestamp()},
        );

        updateCount++;
      }

      await _loadCards();
      _showSuccessSnackBar(
        'Status de $updateCount cards convertidos para inglês',
      );
    } catch (e) {
      _showErrorSnackBar('Erro ao converter status: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
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
      title: 'Card Management',
      showTitleBox: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: FormContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top buttons row with 3 buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left button
                  AppButton(
                    config: ButtonType.backButton.config,
                    onPressed: () => Navigator.pop(context),
                  ),

                  // Middle button - Add Card
                  if (!_isAdding && !_isEditing)
                    AppButton(
                      config: ButtonType.addCardButton.config,
                      onPressed: () => setState(() => _isAdding = true),
                    ),

                  // Right button - Search
                  AppButton(
                    config: ButtonType.searchButton.config,
                    onPressed:
                        () => setState(
                          () => _showSearchInput = !_showSearchInput,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search input - only shown when search button is clicked
              if (_showSearchInput)
                Column(
                  children: [
                    InputField(
                      label: 'Search Cards',
                      hintText: 'Type card name or number',
                      controller: _searchController,
                      onChanged: (value) => _filterCards(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppButton(
                          config: MiniButtonType.clearMiniButton.config,
                          onPressed: () {
                            _searchController.clear();
                            _filterCards();
                          },
                        ),
                        const SizedBox(width: 16),
                        AppButton(
                          config: MiniButtonType.closeMiniButton.config,
                          onPressed:
                              () => setState(() => _showSearchInput = false),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),

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
                    border: Border.all(color: const Color(0xFFD81B60)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isEditing ? 'Edit Card' : 'Add New Card',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      InputField(
                        label: 'Card Name',
                        hintText: 'Enter card name',
                        controller: _cardNameController,
                      ),
                      const SizedBox(height: 16),

                      InputField(
                        label: 'Card Number',
                        hintText: 'Enter card number',
                        controller: _cardNumberController,
                        keyboardType: TextInputType.number,
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
                              _cardNameController.clear();
                              _cardNumberController.clear();
                            },
                          ),
                          const SizedBox(width: 16),
                          AppButton(
                            config:
                                _isEditing
                                    ? MiniButtonType.saveMiniButton.config
                                    : MiniButtonType.addMiniButton.config,
                            onPressed: _saveCard,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),

              if (_isLoading)
                const CircularProgressIndicator()
              else if (_filteredCards.isEmpty)
                const Text('No cards found', style: TextStyle(fontSize: 16))
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
                        color: const Color(0xFFD81B60),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Name',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 60,
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

                      for (int i = 0; i < _filteredCards.length; i++)
                        _buildCardRow(_filteredCards[i], i),
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
          _filterCards();
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

  Widget _buildCardRow(DocumentSnapshot doc, int index) {
    final data = doc.data() as Map<String, dynamic>;
    // Se não houver status definido, considera como 'active'
    final status = data['status'] as String? ?? 'active';
    final isActive = status == 'active';

    return Container(
      color: index.isEven ? Colors.grey.shade100 : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
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
                  _getCardName(doc),
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
            width: 60,
            child: Center(
              // Centraliza o botão
              child: IconButton(
                icon: const Icon(Icons.edit),
                color: Colors.blue,
                onPressed: () => _editCard(doc),
                tooltip: 'Edit',
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCardName(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    // Tenta obter pelo campo novo, se não encontrar usa o campo antigo
    return (data['cardName'] ?? data['cardholderName']) as String? ?? '';
  }

  String _getCardNumber(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    // Tenta obter pelo campo novo, se não encontrar usa o campo antigo
    return (data['cardNumber'] ?? data['last4Digits']) as String? ?? '';
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
