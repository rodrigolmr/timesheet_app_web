import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/base_layout.dart';
import '../widgets/form_container.dart';
import '../widgets/buttons.dart';
import '../widgets/input_worker_hours.dart';
import '../providers/timesheet_provider.dart';

class TimesheetWorkersPage extends ConsumerStatefulWidget {
  const TimesheetWorkersPage({Key? key}) : super(key: key);

  @override
  ConsumerState<TimesheetWorkersPage> createState() =>
      _TimesheetWorkersPageState();
}

class _TimesheetWorkersPageState extends ConsumerState<TimesheetWorkersPage> {
  final _nameController = TextEditingController();
  final _startController = TextEditingController();
  final _finishController = TextEditingController();
  final _hoursController = TextEditingController();
  final _travelController = TextEditingController();
  final _mealController = TextEditingController();

  bool _showWorkerSection = false;
  bool _showMissingWorkerMessage = false;
  int? _selectedWorkerIndex;
  bool _isEditMode = false;
  String _docId = '';

  final List<String> _workerOptions = [];

  @override
  void initState() {
    super.initState();
    _loadWorkersFromFirebase();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Lê os argumentos passados na navegação
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
        {};
    _isEditMode = args['editMode'] as bool? ?? false;
    _docId = args['docId'] as String? ?? '';
  }

  Future<void> _loadWorkersFromFirebase() async {
    final snap = await FirebaseFirestore.instance.collection('workers').get();
    final names =
        snap.docs
            .map((doc) {
              final data = doc.data();
              final firstName = data['firstName'] ?? '';
              final lastName = data['lastName'] ?? '';
              return '$firstName $lastName'.trim();
            })
            .where((name) => name.isNotEmpty)
            .toList();
    names.sort();
    setState(() {
      _workerOptions.clear();
      _workerOptions.addAll(names);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _startController.dispose();
    _finishController.dispose();
    _hoursController.dispose();
    _travelController.dispose();
    _mealController.dispose();
    super.dispose();
  }

  void _handleNext() {
    final workers = ref.read(timesheetProvider).workers;
    setState(() {
      _showMissingWorkerMessage = workers.isEmpty;
    });
    if (workers.isEmpty) return;

    Navigator.pushNamed(
      context,
      '/timesheet-review',
      arguments: {'editMode': _isEditMode, 'docId': _docId},
    );
  }

  void _editWorker(Map<String, String> worker, int index) {
    _nameController.text = worker['name'] ?? '';
    _startController.text = worker['start'] ?? '';
    _finishController.text = worker['finish'] ?? '';
    _hoursController.text = worker['hours'] ?? '';
    _travelController.text = worker['travel'] ?? '';
    _mealController.text = worker['meal'] ?? '';
    setState(() {
      _showWorkerSection = true;
      _selectedWorkerIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final workers = ref.watch(timesheetProvider).workers;

    return BaseLayout(
      title: _isEditMode ? 'Edit Workers' : 'Add Workers',
      showTitleBox: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: FormContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 330,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppButton(
                        config: ButtonType.backButton.config,
                        onPressed: () => Navigator.pop(context),
                      ),
                      AppButton(
                        config: ButtonType.addWorkerButton.config,
                        onPressed: () {
                          setState(() {
                            _showWorkerSection = true;
                            _showMissingWorkerMessage = false;
                            _selectedWorkerIndex = null;
                            _nameController.clear();
                            _startController.clear();
                            _finishController.clear();
                            _hoursController.clear();
                            _travelController.clear();
                            _mealController.clear();
                          });
                        },
                      ),
                      AppButton(
                        config: ButtonType.nextButton.config,
                        onPressed: _handleNext,
                      ),
                    ],
                  ),
                ),
                if (_showMissingWorkerMessage)
                  const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Center(
                      child: Text(
                        'Add a worker first.',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                if (_showWorkerSection)
                  InputWorkerHours(
                    workerOptions: _workerOptions,
                    nameController: _nameController,
                    startController: _startController,
                    finishController: _finishController,
                    hoursController: _hoursController,
                    travelController: _travelController,
                    mealController: _mealController,
                    selectedIndex: _selectedWorkerIndex,
                    onCancel: () => setState(() => _showWorkerSection = false),
                  ),
                const SizedBox(height: 24),
                if (workers.isNotEmpty) ...[
                  const Text(
                    'Added Workers',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 340,
                    child: Table(
                      border: TableBorder.all(color: Colors.black12),
                      columnWidths: const {
                        0: FlexColumnWidth(3),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(1),
                        4: FlexColumnWidth(1),
                        5: FlexColumnWidth(1),
                      },
                      children: [
                        TableRow(
                          decoration: const BoxDecoration(
                            color: Color(0xFFE0E0E0),
                          ),
                          children: [
                            for (final label in [
                              'Name',
                              'Start',
                              'Finish',
                              'Hours',
                              'Travel',
                              'Meal',
                            ])
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Center(
                                  child: Text(
                                    label,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        for (int i = 0; i < workers.length; i++)
                          TableRow(
                            decoration: BoxDecoration(
                              color:
                                  i.isEven
                                      ? const Color(0xFFF7F7F7)
                                      : Colors.white,
                            ),
                            children: [
                              for (final key in [
                                'name',
                                'start',
                                'finish',
                                'hours',
                                'travel',
                                'meal',
                              ])
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () => _editWorker(workers[i], i),
                                  child: SizedBox(
                                    height: 35,
                                    child: Center(
                                      child: Text(
                                        workers[i][key] ?? '',
                                        style: const TextStyle(fontSize: 14),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
