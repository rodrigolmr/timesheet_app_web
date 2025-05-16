import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/buttons/buttons.dart';
import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';

class JobRecordSummaryCard extends ConsumerWidget {
  final JobRecordModel record;
  final VoidCallback? onTap;

  const JobRecordSummaryCard({
    super.key,
    required this.record,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final textStyles = context.appTextStyles;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap ?? () => context.push('/job-records/${record.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(record.status),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            record.status.toUpperCase(),
                            style: textStyles.bodySmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          record.date.toString().split(' ')[0],
                          style: textStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Company: ${record.companyCardId}',
                      style: textStyles.bodyMedium.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    Text(
                      'Worker: ${record.workerId}',
                      style: textStyles.bodyMedium.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    Text(
                      'Hours: ${record.hours}',
                      style: textStyles.bodyMedium.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: colors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}