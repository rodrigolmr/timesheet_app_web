// lib/pages/timesheet_page.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/base_layout.dart';
import '../widgets/buttons.dart';
import '../widgets/sort_field.dart';
import '../widgets/timesheet_row.dart';
import '../widgets/form_container.dart';
import '../providers/timesheet_provider.dart';

class TimesheetPage extends ConsumerStatefulWidget {
  const TimesheetPage({Key? key}) : super(key: key);

  @override
  ConsumerState<TimesheetPage> createState() => _TimesheetPageState();
}

class _TimesheetPageState extends ConsumerState<TimesheetPage> {
  // UI state
  bool _showSortField = false;
  bool _loadingUsers = true;
  bool _loadingAuth = true;
  String? _userId;
  String _userRole = 'User';

  // "reais" filtros
  DateTimeRange? _filterRange;
  bool _isDescending = true;
  String _filterCreator = 'Creator';
  String _filterJob = '';
  String _filterTm = '';
  String _filterMaterial = '';

  // controladores para SortField
  final _jobController = TextEditingController();
  final _tmController = TextEditingController();
  final _materialController = TextEditingController();

  final Map<String, String> _usersMap = {};
  List<String> _creatorOptions = ['Creator'];

  // seleção de timesheets
  final ValueNotifier<Set<String>> _selectedIds = ValueNotifier<Set<String>>(
    {},
  );
  List<String> _latestVisibleIds = [];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadUsers();
  }

  Future<void> _loadUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }
    _userId = user.uid;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(_userId).get();
    _userRole =
        doc.exists ? (doc.data()?['role'] as String? ?? 'User') : 'User';
    setState(() => _loadingAuth = false);
  }

  Future<void> _loadUsers() async {
    final snap = await FirebaseFirestore.instance.collection('users').get();
    final opts = <String>['Creator'];
    for (var doc in snap.docs) {
      final data = doc.data();
      final full =
          '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'.trim();
      _usersMap[doc.id] = full.isEmpty ? 'User' : full;
      if (full.isNotEmpty) opts.add(full);
    }
    opts.sort();
    setState(() {
      _creatorOptions = opts;
      _loadingUsers = false;
    });
  }

  void _toggleSortField() {
    setState(() {
      _showSortField = !_showSortField;
      if (_showSortField) {
        _jobController.text = _filterJob;
        _tmController.text = _filterTm;
        _materialController.text = _filterMaterial;
      }
    });
  }

  void _clearAll() {
    setState(() {
      _filterRange = null;
      _isDescending = true;
      _filterCreator = 'Creator';
      _filterJob = '';
      _filterTm = '';
      _filterMaterial = '';
      _jobController.clear();
      _tmController.clear();
      _materialController.clear();
      _selectedIds.value = {};
    });
  }

  void _applyFilters() {
    setState(() {
      _filterJob = _jobController.text;
      _filterTm = _tmController.text;
      _filterMaterial = _materialController.text;
      _showSortField = false;
    });
  }

  void _selectAll() {
    final newSelection = Set<String>.from(_latestVisibleIds);
    _selectedIds.value = newSelection;

    // Força uma atualização do estado para garantir que todos os checkboxes sejam atualizados
    setState(() {});
  }

  void _deselectAll() {
    _selectedIds.value = {};

    // Força uma atualização do estado para garantir que todos os checkboxes sejam atualizados
    setState(() {});
  }

  @override
  void dispose() {
    _jobController.dispose();
    _tmController.dispose();
    _materialController.dispose();
    _selectedIds.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingAuth || _loadingUsers) {
      return BaseLayout(
        title: 'Timesheets',
        showTitleBox: true,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final asyncTimesheets = ref.watch(timesheetListProvider);

    return asyncTimesheets.when(
      data: (timesheets) {
        final filtered =
            timesheets.where((data) {
              final tsDate = data.date!;
              if (_userRole != 'Admin' && data.userId != _userId) return false;
              if (_filterRange != null &&
                  (tsDate.isBefore(_filterRange!.start) ||
                      tsDate.isAfter(_filterRange!.end)))
                return false;
              if (_filterCreator != 'Creator' &&
                  _usersMap[data.userId] != _filterCreator)
                return false;
              if (_filterJob.isNotEmpty &&
                  !data.jobName.toLowerCase().contains(
                    _filterJob.toLowerCase(),
                  ))
                return false;
              if (_filterTm.isNotEmpty &&
                  !data.tm.toLowerCase().contains(_filterTm.toLowerCase()))
                return false;
              if (_filterMaterial.isNotEmpty &&
                  !data.material.toLowerCase().contains(
                    _filterMaterial.toLowerCase(),
                  ))
                return false;
              return true;
            }).toList();
        filtered.sort(
          (a, b) =>
              _isDescending
                  ? b.date!.compareTo(a.date!)
                  : a.date!.compareTo(b.date!),
        );
        _latestVisibleIds = filtered.map((e) => e.id).toList();

        return BaseLayout(
          title: 'Timesheets',
          showTitleBox: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
            child: FormContainer(
              child: Column(
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 340),
                      child: Column(
                        children: [
                          // Todos os botões em uma única linha
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Botões à esquerda (New e PDF)
                              Row(
                                children: [
                                  AppButton(
                                    config: ButtonType.newButton.config,
                                    onPressed: () => Navigator.pushNamed(
                                      context,
                                      '/new-timesheet',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  AppButton(
                                    config: ButtonType.pdfButton.config,
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                              
                              // Botões à direita (Sort, All, None)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center, // Mudado para centralizar
                                children: [
                                  Row(
                                    children: [
                                      AppButton(
                                        config: MiniButtonType.sortMiniButton.config,
                                        onPressed: _toggleSortField,
                                      ),
                                      const SizedBox(width: 8),
                                      AppButton(
                                        config: MiniButtonType.selectAllMiniButton.config,
                                        onPressed: _selectAll,
                                      ),
                                      const SizedBox(width: 8),
                                      AppButton(
                                        config: MiniButtonType.deselectAllMiniButton.config,
                                        onPressed: _deselectAll,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  // Contador simplificado e centralizado
                                  ValueListenableBuilder<Set<String>>(
                                    valueListenable: _selectedIds,
                                    builder: (context, selected, _) {
                                      final count = selected.length;
                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: count > 0 
                                              ? const Color(0xFF0205D3).withOpacity(0.1) 
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(4),
                                          border: count > 0 
                                              ? Border.all(color: const Color(0xFF0205D3))
                                              : null,
                                        ),
                                        child: Text(
                                          'Selected: $count',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: count > 0 
                                                ? const Color(0xFF0205D3)
                                                : Colors.black54,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_showSortField) ...[
                    Center(
                      child: SortField(
                        selectedRange: _filterRange,
                        isDescending: _isDescending,
                        selectedCreator: _filterCreator,
                        creatorOptions: _creatorOptions,
                        jobController: _jobController,
                        tmController: _tmController,
                        materialController: _materialController,
                        onPickRange: () async {
                          final now = DateTime.now();
                          final picked = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            initialDateRange:
                                _filterRange ??
                                DateTimeRange(
                                  start: now.subtract(const Duration(days: 7)),
                                  end: now,
                                ),
                          );
                          if (picked != null)
                            setState(() => _filterRange = picked);
                        },
                        onSortOrderChanged:
                            (desc) => setState(() => _isDescending = desc),
                        onCreatorChanged:
                            (c) =>
                                setState(() => _filterCreator = c ?? 'Creator'),
                        onClearAll: _clearAll,
                        onApply: _applyFilters,
                        onClose: _toggleSortField,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Expanded(
                    child: ValueListenableBuilder<Set<String>>(
                      valueListenable: _selectedIds,
                      builder: (context, selectedIds, _) {
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: filtered.length,
                          itemBuilder: (_, i) {
                            final sheet = filtered[i];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: InkWell(
                                onTap:
                                    () => Navigator.pushNamed(
                                      context,
                                      '/timesheet-view',
                                      arguments: {'docId': sheet.id},
                                    ),
                                child: TimesheetRowItem(
                                  day: DateFormat('d').format(sheet.date!),
                                  month: DateFormat('MMM').format(sheet.date!),
                                  jobName: sheet.jobName,
                                  userName: _usersMap[sheet.userId] ?? '',
                                  initialChecked: selectedIds.contains(
                                    sheet.id,
                                  ),
                                  onCheckChanged: (checked) {
                                    final updated = Set<String>.from(
                                      selectedIds,
                                    );
                                    if (checked)
                                      updated.add(sheet.id);
                                    else
                                      updated.remove(sheet.id);
                                    _selectedIds.value = updated;
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading:
          () => BaseLayout(
            title: 'Timesheets',
            showTitleBox: true,
            child: const Center(child: CircularProgressIndicator()),
          ),
      error:
          (e, _) => BaseLayout(
            title: 'Timesheets',
            showTitleBox: true,
            child: Center(child: Text('Error loading timesheets: $e')),
          ),
    );
  }
}
