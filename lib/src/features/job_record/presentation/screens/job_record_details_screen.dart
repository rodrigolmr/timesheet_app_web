import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/app_header.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive_builder.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/job_record_providers.dart';

class JobRecordDetailsScreen extends ConsumerStatefulWidget {
  static const routePath = '/job-records/:id';
  static const routeName = 'job-record-details';

  final String recordId;

  const JobRecordDetailsScreen({
    super.key,
    required this.recordId,
  });

  @override
  ConsumerState<JobRecordDetailsScreen> createState() => _JobRecordDetailsScreenState();
}

class _JobRecordDetailsScreenState extends ConsumerState<JobRecordDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    final recordAsync = ref.watch(jobRecordProvider(widget.recordId));
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Scaffold(
      appBar: const AppHeader(
        title: 'Job Record Details',
      ),
      body: recordAsync.when(
        data: (record) {
          if (record == null) {
            return Center(
              child: Text(
                'Record not found',
                style: textStyles.headline.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            );
          }

          return ResponsiveBuilder(
            builder: (context, constraints, screenSize) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Record Information
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow('Job Date', record.date.toString().split(' ')[0]),
                            _buildInfoRow('User', record.userId),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Error loading record: $error',
            style: textStyles.body.copyWith(
              color: colors.error,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final textStyles = context.textStyles;
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: textStyles.body.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: textStyles.body,
            ),
          ),
        ],
      ),
    );
  }

}