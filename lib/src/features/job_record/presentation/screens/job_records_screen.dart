import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/app_header.dart';
import 'package:timesheet_app_web/src/core/widgets/buttons/buttons.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/job_record_providers.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/widgets/job_record_card.dart';

class JobRecordsScreen extends ConsumerStatefulWidget {
  static const routePath = '/job-records';
  static const routeName = 'job-records';

  const JobRecordsScreen({super.key});

  @override
  ConsumerState<JobRecordsScreen> createState() => _JobRecordsScreenState();
}

class _JobRecordsScreenState extends ConsumerState<JobRecordsScreen> {
  String _selectedStatus = 'all';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Scaffold(
      appBar: AppHeader(
        title: 'Job Records',
        actionIcon: Icons.add,
        onActionPressed: () => context.push('/job-record-create'),
      ),
      body: Column(
        children: [
          // Filter bar with responsive padding
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: context.responsive<double>(
                xs: 8,
                sm: 16,
                md: 24,
              ),
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: colors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(
                  'Filter by status:',
                  style: textStyles.body,
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: colors.primary),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedStatus,
                      icon: Icon(Icons.arrow_drop_down, color: colors.primary),
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value!;
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'all',
                          child: Text('All'),
                        ),
                        DropdownMenuItem(
                          value: 'approved',
                          child: Text('Approved'),
                        ),
                        DropdownMenuItem(
                          value: 'rejected',
                          child: Text('Rejected'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Records list
          Expanded(
            child: _buildRecordsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/job-record-create'),
        backgroundColor: colors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRecordsList() {
    final AsyncValue<List<JobRecordModel>> recordsAsync;
    
    // Use jobRecordsStreamProvider para obter os registros em tempo real
    recordsAsync = ref.watch(jobRecordsStreamProvider);

    return recordsAsync.when(
      data: (records) {
        if (records.isEmpty) {
          return _buildEmptyState('No records found');
        }

        // Filtrar registros por status se necessário
        final filteredRecords = _selectedStatus == 'all'
            ? records
            : records.where((record) => record.status == _selectedStatus).toList();

        if (filteredRecords.isEmpty) {
          return _buildEmptyState('No records with status "$_selectedStatus" found');
        }

        return ResponsiveContainer(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: filteredRecords.length,
            itemBuilder: (context, index) {
              final record = filteredRecords[index];
              return JobRecordCard(record: record);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(
          'Error loading records: $error',
          style: context.textStyles.body.copyWith(
            color: context.colors.error,
          ),
        ),
      ),
    );
  }
  
  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 80,
            color: context.colors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: context.textStyles.title.copyWith(
              color: context.colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push('/job-record-create'),
            icon: const Icon(Icons.add),
            label: const Text('Create New Job Record'),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.primary,
              foregroundColor: context.colors.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}