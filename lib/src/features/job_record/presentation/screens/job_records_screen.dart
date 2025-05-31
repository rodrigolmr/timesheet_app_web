import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/utils/date_utils.dart';
import 'package:timesheet_app_web/src/core/widgets/buttons/buttons.dart';
import 'package:timesheet_app_web/src/core/widgets/app_header.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/job_record_providers.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/job_record_create_providers.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/widgets/job_record_card.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/widgets/job_record_filters.dart';
import 'package:timesheet_app_web/src/features/job_record/data/services/job_record_print_service.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/permission_providers.dart';
import 'package:timesheet_app_web/src/features/user/domain/enums/user_role.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/widgets/timesheet_date_range_dialog.dart';


class JobRecordsScreen extends ConsumerStatefulWidget {
  static const routePath = '/job-records';
  static const routeName = 'job-records';

  const JobRecordsScreen({super.key});

  @override
  ConsumerState<JobRecordsScreen> createState() => _JobRecordsScreenState();
}

class _JobRecordsScreenState extends ConsumerState<JobRecordsScreen> {
  // Controladores para o filtro de data
  final _dateRangeController = TextEditingController();
  final _searchController = TextEditingController();
  final _dateFormat = DateFormat('MM/dd/yyyy');
  DateTimeRange? _selectedDateRange;
  String _searchQuery = '';
  String? _selectedCreator;
  bool _filtersExpanded = false; // Estado para controlar se os filtros estão expandidos

  @override
  void initState() {
    super.initState();
    
    // Iniciar sem datas pré-selecionadas, mas manter o visual
    _selectedDateRange = null;
    _dateRangeController.text = '';
  }

  @override
  void dispose() {
    _dateRangeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final selectionState = ref.watch(jobRecordSelectionProvider);
    
    if (selectionState.isSelectionMode) {
      final canDeleteAsync = ref.watch(canDeleteJobRecordProvider);
      final canDelete = canDeleteAsync.valueOrNull ?? false;
      final canPrintAsync = ref.watch(canPrintJobRecordsProvider);
      final canPrint = canPrintAsync.valueOrNull ?? false;
      
      return AppBar(
        backgroundColor: context.colors.primary,
        foregroundColor: context.colors.onPrimary,
        title: Text(
          '${selectionState.selectionCount} selected',
          style: context.textStyles.title.copyWith(
            color: context.colors.onPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => ref.read(jobRecordSelectionProvider.notifier).exitSelectionMode(),
          tooltip: 'Cancel selection',
        ),
        actions: [
          if (selectionState.hasSelection) ...[
            if (canDelete)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _showDeleteConfirmDialog(selectionState.selectedIds),
                tooltip: 'Delete selected',
              ),
            if (canPrint)
              IconButton(
                icon: const Icon(Icons.print),
                onPressed: () => _printSelected(selectionState.selectedIds),
                tooltip: 'Print selected',
              ),
          ],
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) => _handleSelectionAction(value, selectionState),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'select_all',
                child: Text('Select All'),
              ),
              const PopupMenuItem(
                value: 'select_none',
                child: Text('Select None'),
              ),
            ],
          ),
        ],
      );
    }
    
    // Check if user can generate timesheet
    final canGenerateTimesheetAsync = ref.watch(canGenerateTimesheetProvider);
    final canGenerateTimesheet = canGenerateTimesheetAsync.valueOrNull ?? false;
    
    // Check if user can use selection mode (only managers and admins)
    final canUseSelectionModeAsync = ref.watch(canDeleteJobRecordProvider);
    final canUseSelectionMode = canUseSelectionModeAsync.valueOrNull ?? false;
    
    return AppHeader(
      title: 'Job Records',
      actions: [
        if (canUseSelectionMode)
          IconButton(
            icon: const Icon(Icons.checklist),
            onPressed: () => ref.read(jobRecordSelectionProvider.notifier).enterSelectionMode(),
            tooltip: 'Select records',
          ),
        if (canGenerateTimesheet)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'generate_timesheet':
                  _showTimeSheetDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'generate_timesheet',
                child: Row(
                  children: [
                    Icon(Icons.table_chart_outlined, size: 20),
                    SizedBox(width: 8),
                    Text('Generate Timesheet'),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildFilters(),
        Expanded(
          child: _buildRecordsList(),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return JobRecordFilters(
      dateRangeController: _dateRangeController,
      searchController: _searchController,
      dateFormat: _dateFormat,
      selectedDateRange: _selectedDateRange,
      searchQuery: _searchQuery,
      selectedCreator: _selectedCreator,
      filtersExpanded: _filtersExpanded,
      onDateRangeChanged: (dateRange) {
        setState(() {
          _selectedDateRange = dateRange;
          if (dateRange != null) {
            _dateRangeController.text = '${_dateFormat.format(dateRange.start)} - ${_dateFormat.format(dateRange.end)}';
          }
        });
      },
      onSearchChanged: (query) {
        setState(() {
          _searchQuery = query.trim();
        });
      },
      onCreatorChanged: (creator) {
        setState(() {
          _selectedCreator = creator;
        });
      },
      onExpandedChanged: (expanded) {
        setState(() {
          _filtersExpanded = expanded;
        });
      },
      onClearFilters: _clearAllFilters,
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => _createNewJobRecord(),
      backgroundColor: context.colors.primary,
      elevation: 8,
      mini: false,
      child: const Icon(Icons.add, size: 28),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedCreator = null;
      
      // Limpar datas completamente
      _selectedDateRange = null;
      _dateRangeController.text = '';
    });
  }

  void _handleSelectionAction(String action, JobRecordSelectionState selectionState) {
    final recordsAsync = ref.read(jobRecordsSearchStreamProvider(
      searchQuery: _searchQuery,
      startDate: _selectedDateRange?.start,
      endDate: _selectedDateRange?.end,
      creatorId: _selectedCreator,
    ).future);

    recordsAsync.then((records) {
      final allIds = records.map((record) => record.id).toList();
      
      switch (action) {
        case 'select_all':
          ref.read(jobRecordSelectionProvider.notifier).selectAll(allIds);
          break;
        case 'select_none':
          ref.read(jobRecordSelectionProvider.notifier).selectNone();
          break;
      }
    });
  }

  void _showDeleteConfirmDialog(Set<String> selectedIds) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Records'),
        content: Text(
          'Are you sure you want to delete ${selectedIds.length} job record${selectedIds.length > 1 ? 's' : ''}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.error,
              foregroundColor: context.colors.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        _deleteSelectedRecords(selectedIds);
      }
    });
  }

  void _deleteSelectedRecords(Set<String> selectedIds) async {
    // Verificar permissão para deletar
    final canDelete = await ref.read(canDeleteJobRecordProvider.future);
    
    if (!canDelete) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('You do not have permission to delete job records'),
            backgroundColor: context.colors.error,
          ),
        );
      }
      return;
    }
    
    // Mostrar loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    
    try {
      // Deletar cada registro
      int successCount = 0;
      int errorCount = 0;
      
      for (final id in selectedIds) {
        try {
          await ref.read(jobRecordStateProvider(id).notifier).delete(id);
          successCount++;
        } catch (e) {
          errorCount++;
          debugPrint('Error deleting job record $id: $e');
        }
      }
      
      // Fechar loading
      if (mounted) Navigator.of(context).pop();
      
      // Mostrar resultado
      if (mounted) {
        if (errorCount == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Successfully deleted $successCount record${successCount > 1 ? 's' : ''}'),
              backgroundColor: context.colors.success,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Deleted $successCount record${successCount > 1 ? 's' : ''}, $errorCount failed'),
              backgroundColor: context.colors.warning,
            ),
          );
        }
      }
      
      // Remover registros deletados da seleção e sair do modo seleção se necessário
      ref.read(jobRecordSelectionProvider.notifier).removeDeletedRecords(
        selectedIds.where((id) => successCount > 0).toSet()
      );
      
      // Se todos foram deletados, sair do modo seleção
      if (successCount == selectedIds.length) {
        ref.read(jobRecordSelectionProvider.notifier).exitSelectionMode();
      }
    } catch (e) {
      // Fechar loading
      if (mounted) Navigator.of(context).pop();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting records: $e'),
            backgroundColor: context.colors.error,
          ),
        );
      }
    }
  }

  void _printSelected(Set<String> selectedIds) async {
    if (selectedIds.isEmpty) return;

    // Check permission first
    final canPrint = await ref.read(canPrintJobRecordsProvider.future);
    if (!canPrint) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('You do not have permission to print job records'),
            backgroundColor: context.colors.error,
          ),
        );
      }
      return;
    }

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Print Confirmation'),
        content: Text(
          'Are you sure you want to print ${selectedIds.length} job record${selectedIds.length > 1 ? 's' : ''}? This will open the print dialog in your browser.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.primary,
              foregroundColor: context.colors.onPrimary,
            ),
            child: const Text('Print'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      // Get job records data
      final allRecordsAsync = await ref.read(jobRecordsSearchStreamProvider(
        searchQuery: _searchQuery,
        startDate: _selectedDateRange?.start,
        endDate: _selectedDateRange?.end,
        creatorId: _selectedCreator,
      ).future);

      // Filter only selected records
      final selectedRecords = allRecordsAsync
          .where((record) => selectedIds.contains(record.id))
          .toList();

      if (selectedRecords.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('No records found to print'),
              backgroundColor: context.colors.error,
            ),
          );
        }
        return;
      }

      // Sort records by date in ascending order (oldest first)
      selectedRecords.sort((a, b) => a.date.compareTo(b.date));

      // Call print service
      await JobRecordPrintService.printJobRecords(selectedRecords);

      // Exit selection mode after successful print
      ref.read(jobRecordSelectionProvider.notifier).exitSelectionMode();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Print initiated for ${selectedRecords.length} record${selectedRecords.length > 1 ? 's' : ''}'),
            backgroundColor: context.colors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error printing records: $e'),
            backgroundColor: context.colors.error,
          ),
        );
      }
    }
  }





  Widget _buildRecordsList() {
    final recordsAsync = ref.watch(
      jobRecordsSearchStreamProvider(
        searchQuery: _searchQuery,
        startDate: _selectedDateRange?.start,
        endDate: _selectedDateRange?.end,
        creatorId: _selectedCreator,
      )
    );

    return recordsAsync.when(
      data: (records) {
        if (records.isEmpty) {
          return _buildEmptyState(_buildEmptyMessage());
        }
        
        // Group records by week using the utils
        final weekGroups = groupRecordsByWeek(records);

        return _buildWeekGroupsList(weekGroups);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _buildErrorState(error),
    );
  }

  String _buildEmptyMessage() {
    // Verifica se há filtros ativos
    final hasFilters = _searchQuery.isNotEmpty || 
                      _selectedDateRange != null || 
                      _selectedCreator != null;
    
    if (!hasFilters) {
      // Sem filtros - mensagem padrão baseada no role
      final userRoleAsync = ref.read(currentUserRoleProvider);
      return userRoleAsync.when(
        data: (role) {
          if (role == UserRole.user) {
            return 'You have no job records yet';
          } else {
            return 'No job records found';
          }
        },
        loading: () => 'No records found',
        error: (_, __) => 'No records found',
      );
    }
    
    // Com filtros - mensagem específica
    String message = 'No records found';
    if (_searchQuery.isNotEmpty) {
      message += ' matching "$_searchQuery"';
    }
    if (_selectedDateRange != null) {
      message += ' in selected date range';
    }
    if (_selectedCreator != null) {
      message += ' for selected creator';
    }
    return message;
  }

  Widget _buildWeekGroupsList(List<WeekGroup> weekGroups) {
    return ResponsiveContainer(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          vertical: context.responsive<double>(xs: 4, sm: 6, md: 8),
          horizontal: context.responsive<double>(xs: 0, sm: 2, md: 6),
        ),
        itemCount: weekGroups.length,
        itemBuilder: (context, weekIndex) {
          final weekGroup = weekGroups[weekIndex];
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMinimalHeader(weekGroup),
              
              // Build records grouped by day
              ..._buildDayGroups(weekGroup),
              
              // Spacer between weeks
              SizedBox(height: context.responsive<double>(xs: 8, sm: 10, md: 12)),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildDayGroups(WeekGroup weekGroup) {
    // Check if user is manager or admin
    final canViewAllAsync = ref.watch(canViewAllJobRecordsProvider);
    final canViewAll = canViewAllAsync.valueOrNull ?? false;
    
    if (!canViewAll) {
      // For regular users, just return the records without day grouping
      return weekGroup.records.map((record) => Padding(
        padding: const EdgeInsets.only(bottom: 2.0),
        child: JobRecordCard(record: record),
      )).toList();
    }
    
    // For managers/admins, group by day
    final Map<int, List<JobRecordModel>> recordsByDay = {};
    
    // Group records by weekday
    for (final record in weekGroup.records) {
      final weekday = record.date.weekday;
      if (!recordsByDay.containsKey(weekday)) {
        recordsByDay[weekday] = [];
      }
      recordsByDay[weekday]!.add(record);
    }
    
    // Sort days in chronological order within the week (Friday to Thursday)
    // Friday = 5, Saturday = 6, Sunday = 7, Monday = 1, Tuesday = 2, Wednesday = 3, Thursday = 4
    final sortedDays = recordsByDay.keys.toList()..sort((a, b) {
      // Convert to week order (Friday first)
      final orderA = a >= 5 ? a - 5 : a + 2;  // Fri=0, Sat=1, Sun=2, Mon=3, Tue=4, Wed=5, Thu=6
      final orderB = b >= 5 ? b - 5 : b + 2;
      return orderB.compareTo(orderA); // Reverse for most recent first
    });
    
    final List<Widget> dayWidgets = [];
    
    for (final weekday in sortedDays) {
      final dayRecords = recordsByDay[weekday]!;
      final dayName = _getDayName(weekday);
      final date = dayRecords.first.date;
      
      // Add day header
      dayWidgets.add(_buildDayHeader(dayName, date));
      
      // Add records for this day
      dayWidgets.addAll(
        dayRecords.map((record) => Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: JobRecordCard(record: record),
        )),
      );
    }
    
    return dayWidgets;
  }
  
  Widget _buildDayHeader(String dayName, DateTime date) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    
    // Use same width as cards
    final headerWidth = context.responsive<double>(
      xs: 300,
      sm: 340,
      md: 360,
      lg: 400,
      xl: 440,
    );
    
    return Center(
      child: SizedBox(
        width: headerWidth,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 8,
            bottom: 4,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  dayName,
                  style: textStyles.caption.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: context.responsive<double>(xs: 11, sm: 12, md: 13),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('d MMM').format(date),
                style: textStyles.caption.copyWith(
                  color: colors.textSecondary,
                  fontSize: context.responsive<double>(xs: 10, sm: 11, md: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Monday';
      case 2: return 'Tuesday';
      case 3: return 'Wednesday';
      case 4: return 'Thursday';
      case 5: return 'Friday';
      case 6: return 'Saturday';
      case 7: return 'Sunday';
      default: return '';
    }
  }
  
  Widget _buildErrorState(Object error) {
    return Center(
      child: Text(
        'Error loading records: $error',
        style: context.textStyles.body.copyWith(
          color: context.colors.error,
        ),
      ),
    );
  }
  
  // Cabeçalho minimalista (só linha de texto + separador)
  Widget _buildMinimalHeader(WeekGroup weekGroup) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    
    // Use same width as cards
    final headerWidth = context.responsive<double>(
      xs: 300,
      sm: 340,
      md: 360,
      lg: 400,
      xl: 440,
    );
    
    return Center(
      child: SizedBox(
        width: headerWidth,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: 6,
            top: context.responsive<double>(xs: 6, sm: 8, md: 10),
          ),
          child: Row(
            children: [
              // Título
              Text(
                weekGroup.weekTitle,
                style: textStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: context.responsive<double>(xs: 12, sm: 13, md: 14),
                ),
              ),
              
              // Separador
              Expanded(
                child: Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  color: colors.primary.withOpacity(0.2),
                ),
              ),
              
              // Range de datas
              Text(
                weekGroup.weekRange,
                style: textStyles.caption.copyWith(
                  color: colors.textSecondary,
                  fontSize: context.responsive<double>(xs: 10, sm: 11, md: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildEmptyState(String message) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    
    // Tornando o estado vazio responsivo
    final iconSize = context.responsive<double>(
      xs: 60, // Menor para mobile
      sm: 70,
      md: 80,
    );
    
    // Tamanho de texto responsivo
    final titleFontSize = context.responsive<double>(
      xs: 16, // Menor para mobile
      sm: 18,
      md: 20,
    );
    
    // Padding do botão responsivo
    final buttonPadding = EdgeInsets.symmetric(
      horizontal: context.responsive<double>(xs: 16, sm: 20, md: 24),
      vertical: context.responsive<double>(xs: 8, sm: 10, md: 12),
    );
    
    // Espaçamento vertical responsivo
    final spacing1 = context.responsive<double>(xs: 12, sm: 14, md: 16);
    final spacing2 = context.responsive<double>(xs: 16, sm: 20, md: 24);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: iconSize,
            color: colors.textSecondary.withOpacity(0.5),
          ),
          SizedBox(height: spacing1),
          Text(
            message,
            style: textStyles.title.copyWith(
              color: colors.textSecondary,
              fontSize: titleFontSize,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing2),
          ElevatedButton.icon(
            onPressed: () => _createNewJobRecord(),
            icon: const Icon(Icons.add),
            label: const Text('Create New Job Record'),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              padding: buttonPadding,
            ),
          ),
        ],
      ),
    );
  }

  void _createNewJobRecord() {
    // Reset all form state providers before creating new record
    ref.read(jobRecordFormStateProvider.notifier).resetForm();
    ref.read(isEditModeProvider.notifier).setEditMode(false);
    ref.read(currentStepNotifierProvider.notifier).setStep(0);
    
    // Navigate to create screen
    context.push('/job-record-create');
  }

  void _showTimeSheetDialog() {
    showDialog(
      context: context,
      builder: (context) => const TimeSheetDateRangeDialog(),
    );
  }
}