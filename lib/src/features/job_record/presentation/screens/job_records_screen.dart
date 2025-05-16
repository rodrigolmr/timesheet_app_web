import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/app_header.dart';
import 'package:timesheet_app_web/src/core/widgets/buttons/buttons.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/job_record_providers.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/widgets/job_record_summary_card.dart';

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
    final colors = context.appColors;
    final textStyles = context.appTextStyles;

    return Scaffold(
      appBar: const AppHeader(
        title: 'Job Records',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Filter by status
            Row(
              children: [
                Text(
                  'Filter by status:',
                  style: textStyles.bodyLarge,
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: _selectedStatus,
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
                      value: 'pending',
                      child: Text('Pending'),
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
              ],
            ),
            const SizedBox(height: 20),
            
            // Records list
            Expanded(
              child: _buildRecordsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordsList() {
    final AsyncValue<List<JobRecordModel>> recordsAsync;
    
    if (_selectedStatus == 'all') {
      recordsAsync = ref.watch(jobRecordsProvider);
    } else {
      recordsAsync = ref.watch(jobRecordsByStatusProvider(_selectedStatus));
    }

    return recordsAsync.when(
      data: (records) {
        if (records.isEmpty) {
          return Center(
            child: Text(
              'No records found',
              style: context.appTextStyles.h3.copyWith(
                color: context.appColors.textSecondary,
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index];
            return JobRecordSummaryCard(record: record);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(
          'Error loading records: $error',
          style: context.appTextStyles.bodyLarge.copyWith(
            color: context.appColors.error,
          ),
        ),
      ),
    );
  }
}