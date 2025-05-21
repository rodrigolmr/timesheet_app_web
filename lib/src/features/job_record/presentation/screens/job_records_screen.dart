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
import 'package:timesheet_app_web/src/features/job_record/presentation/widgets/job_record_card.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/widgets/job_record_filters.dart';


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
    return AppHeader(
      title: 'Job Records',
      actionIcon: Icons.add,
      onActionPressed: () => context.push('/job-record-create'),
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
      onPressed: () => context.push('/job-record-create'),
      backgroundColor: context.colors.primary,
      mini: context.responsive<bool>(
        xs: true,
        sm: true,
        md: false,
      ),
      child: const Icon(Icons.add),
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
              
              // Records for this week with minimal spacing
              ...weekGroup.records.map((record) => Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: JobRecordCard(record: record),
              )),
              
              // Spacer between weeks
              SizedBox(height: context.responsive<double>(xs: 8, sm: 10, md: 12)),
            ],
          );
        },
      ),
    );
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
    
    return Padding(
      padding: EdgeInsets.only(
        bottom: 6,
        top: context.responsive<double>(xs: 6, sm: 8, md: 10),
        left: context.responsive<double>(xs: 1, sm: 2, md: 6),
        right: context.responsive<double>(xs: 1, sm: 2, md: 6),
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
            onPressed: () => context.push('/job-record-create'),
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
}