import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/notification_providers.dart';

class NotificationDropdown extends ConsumerWidget {
  final VoidCallback onClose;

  const NotificationDropdown({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingRecords = ref.watch(pendingJobRecordsPreviewProvider);
    final totalCount = ref.watch(pendingJobRecordsCountProvider);
    final dateFormat = DateFormat('MM/dd/yyyy');
    
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
      child: Container(
        width: 300,
        constraints: const BoxConstraints(maxHeight: 400),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
          border: Border.all(
            color: context.colors.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(context.dimensions.spacingM),
              decoration: BoxDecoration(
                color: context.colors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(context.dimensions.borderRadiusM),
                  topRight: Radius.circular(context.dimensions.borderRadiusM),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.pending_actions,
                    size: 20,
                    color: context.colors.primary,
                  ),
                  SizedBox(width: context.dimensions.spacingS),
                  Text(
                    'Pending Approvals',
                    style: context.textStyles.subtitle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.dimensions.spacingS,
                      vertical: context.dimensions.spacingXS,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.error,
                      borderRadius: BorderRadius.circular(context.dimensions.borderRadiusS),
                    ),
                    child: Text(
                      totalCount.toString(),
                      style: TextStyle(
                        color: context.colors.onError,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // List of pending records
            if (pendingRecords.isEmpty)
              Padding(
                padding: EdgeInsets.all(context.dimensions.spacingL),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 48,
                      color: context.colors.success,
                    ),
                    SizedBox(height: context.dimensions.spacingM),
                    Text(
                      'All caught up!',
                      style: context.textStyles.subtitle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: context.dimensions.spacingXS),
                    Text(
                      'No pending approvals',
                      style: context.textStyles.body.copyWith(
                        color: context.colors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else ...[
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(context.dimensions.spacingS),
                  itemCount: pendingRecords.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: context.colors.outline.withOpacity(0.2),
                  ),
                  itemBuilder: (context, index) {
                    final record = pendingRecords[index];
                    return InkWell(
                      onTap: () {
                        onClose();
                        context.push('/job-records/${record.id}');
                      },
                      borderRadius: BorderRadius.circular(context.dimensions.borderRadiusS),
                      child: Padding(
                        padding: EdgeInsets.all(context.dimensions.spacingS),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: context.colors.warning.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(context.dimensions.borderRadiusS),
                              ),
                              child: Center(
                                child: Text(
                                  '⏳',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            SizedBox(width: context.dimensions.spacingS),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    record.jobName,
                                    style: context.textStyles.body.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    dateFormat.format(record.date),
                                    style: context.textStyles.caption.copyWith(
                                      color: context.colors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 20,
                              color: context.colors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // View all button
              if (totalCount > 5)
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: context.colors.outline.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      onClose();
                      // Navigate to job records with pending filter
                      context.go('/job-records');
                    },
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(context.dimensions.borderRadiusM),
                      bottomRight: Radius.circular(context.dimensions.borderRadiusM),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(context.dimensions.spacingM),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'View all ${totalCount} pending',
                            style: context.textStyles.body.copyWith(
                              color: context.colors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: context.dimensions.spacingXS),
                          Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: context.colors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}