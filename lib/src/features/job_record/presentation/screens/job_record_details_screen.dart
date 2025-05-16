import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/app_header.dart';
import 'package:timesheet_app_web/src/core/widgets/buttons/buttons.dart';
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
  final TextEditingController _reviewerNoteController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _reviewerNoteController.dispose();
    super.dispose();
  }

  Future<void> _updateStatus(String status) async {
    setState(() => _isProcessing = true);
    
    try {
      await ref.read(jobRecordStateProvider(widget.recordId).notifier).updateStatus(
        status,
        reviewerNote: _reviewerNoteController.text.trim().isEmpty 
          ? null 
          : _reviewerNoteController.text.trim(),
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status updated to ${status}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating status: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final recordAsync = ref.watch(jobRecordProvider(widget.recordId));
    final colors = context.appColors;
    final textStyles = context.appTextStyles;

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
                style: textStyles.h3.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            );
          }

          return ResponsiveBuilder(
            builder: (context, screenType) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(record.status),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        record.status.toUpperCase(),
                        style: textStyles.bodyMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Record Information
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow('Job Date', record.date.toString().split(' ')[0]),
                            _buildInfoRow('Hours', record.hours.toString()),
                            _buildInfoRow('Company Card', record.companyCardId),
                            _buildInfoRow('User', record.userId),
                            _buildInfoRow('Worker', record.workerId),
                            if (record.reviewedAt != null)
                              _buildInfoRow('Reviewed At', record.reviewedAt!.toString()),
                            if (record.reviewerNote != null && record.reviewerNote!.isNotEmpty)
                              _buildInfoRow('Reviewer Note', record.reviewerNote!),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Review Section (if pending)
                    if (record.status == 'pending' && !_isProcessing) ...[
                      Text(
                        'Review',
                        style: textStyles.h3,
                      ),
                      const SizedBox(height: 10),
                      AppTextField(
                        controller: _reviewerNoteController,
                        placeholder: 'Add a note (optional)',
                        multiline: true,
                        maxLines: 3,
                        enabled: !_isProcessing,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              text: 'Approve',
                              onPressed: _isProcessing
                                  ? null
                                  : () => _updateStatus('approved'),
                              type: ButtonType.primary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AppButton(
                              text: 'Reject',
                              onPressed: _isProcessing
                                  ? null
                                  : () => _updateStatus('rejected'),
                              type: ButtonType.danger,
                            ),
                          ),
                        ],
                      ),
                    ],
                    
                    if (_isProcessing) ...[
                      const SizedBox(height: 20),
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ],
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
            style: textStyles.bodyLarge.copyWith(
              color: colors.error,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final textStyles = context.appTextStyles;
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: textStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: textStyles.bodyMedium,
            ),
          ),
        ],
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