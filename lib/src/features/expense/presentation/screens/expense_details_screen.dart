import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/app_header.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/widgets/static_loading_indicator.dart';
import 'package:timesheet_app_web/src/features/expense/presentation/providers/expense_providers.dart';
import 'package:timesheet_app_web/src/features/company_card/presentation/providers/company_card_providers.dart';
import 'package:timesheet_app_web/src/features/user/presentation/providers/user_providers.dart';
import '../../data/models/expense_model.dart';
import '../../domain/enums/expense_status.dart';
import '../widgets/pdf_viewer_dialog.dart';
import 'package:timesheet_app_web/src/core/widgets/fullscreen_viewer_base.dart';
import 'dart:html' as html;
import 'package:timesheet_app_web/src/features/auth/presentation/providers/permission_providers.dart';

class ExpenseDetailsScreen extends ConsumerWidget {
  final String expenseId;

  const ExpenseDetailsScreen({
    super.key,
    required this.expenseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseAsync = ref.watch(expenseByIdStreamProvider(expenseId));

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppHeader(
        title: 'Expense Details',
        showBackButton: true,
        actions: [
          expenseAsync.whenOrNull(
            data: (expense) {
              if (expense == null) return const SizedBox.shrink();
              
              // Check if user can delete this specific expense
              final canDeleteAsync = ref.watch(canDeleteOwnExpenseProvider(expense.userId));
              final canDelete = canDeleteAsync.valueOrNull ?? false;
              
              if (!canDelete) return const SizedBox.shrink();
              
              return PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'delete') {
                    _showDeleteDialog(context, ref, expense);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ) ?? const SizedBox.shrink(),
        ],
      ),
      body: expenseAsync.when(
        data: (expense) {
          if (expense == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: context.colors.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Expense not found',
                    style: context.textStyles.title.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/expenses'),
                    child: const Text('Back to Expenses'),
                  ),
                ],
              ),
            );
          }
          return _ExpenseDetailsContent(expense: expense);
        },
        loading: () => const Center(child: StaticLoadingIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Error loading expense: $error',
            style: TextStyle(color: context.colors.error),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, ExpenseModel expense) async {
    // Check if user can delete this specific expense
    final canDelete = await ref.read(canDeleteOwnExpenseProvider(expense.userId).future);
    if (!canDelete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('You do not have permission to delete this expense'),
          backgroundColor: context.colors.error,
        ),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: context.colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
        ),
        title: Text(
          'Delete Expense',
          style: context.textStyles.title,
        ),
        content: Text(
          'Are you sure you want to delete this expense? This action cannot be undone.',
          style: context.textStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            style: TextButton.styleFrom(
              foregroundColor: context.colors.textSecondary,
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await _performDeletion(context, ref, expense.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.error,
              foregroundColor: context.colors.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _performDeletion(BuildContext context, WidgetRef ref, String expenseId) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    
    try {
      // Delete the expense
      await ref.read(expenseStateProvider(expenseId).notifier).delete(expenseId);
      
      // Close loading dialog
      if (context.mounted) Navigator.of(context).pop();
      
      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Expense deleted successfully'),
            backgroundColor: context.colors.success,
          ),
        );
        
        // Navigate back to expenses list
        context.go('/expenses');
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) Navigator.of(context).pop();
      
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting expense: $e'),
            backgroundColor: context.colors.error,
          ),
        );
      }
    }
  }
}

class _ExpenseDetailsContent extends ConsumerStatefulWidget {
  final ExpenseModel expense;

  const _ExpenseDetailsContent({
    required this.expense,
  });

  @override
  ConsumerState<_ExpenseDetailsContent> createState() => _ExpenseDetailsContentState();
}

class _ExpenseDetailsContentState extends ConsumerState<_ExpenseDetailsContent> {
  @override
  Widget build(BuildContext context) {
    final cardAsync = ref.watch(companyCardByIdStreamProvider(widget.expense.cardId));
    final userAsync = ref.watch(userByIdStreamProvider(widget.expense.userId));

    return SingleChildScrollView(
      child: ResponsiveContainer(
        child: Padding(
          padding: context.dimensions.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status card
              Card(
                color: _getStatusColor(context, widget.expense.status),
                child: Padding(
                  padding: context.dimensions.padding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getStatusIcon(widget.expense.status),
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.expense.status.name.toUpperCase(),
                        style: context.textStyles.subtitle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: context.dimensions.spacingL),

              // Details card
              Card(
                child: Padding(
                  padding: context.dimensions.padding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expense Information',
                        style: context.textStyles.title,
                      ),
                      SizedBox(height: context.dimensions.spacingM),
                      
                      // Amount
                      _buildDetailRow(
                        context,
                        icon: Icons.attach_money,
                        label: 'Amount',
                        value: NumberFormat.currency(symbol: '\$').format(widget.expense.amount),
                        valueStyle: context.textStyles.headline.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      
                      // Date
                      _buildDetailRow(
                        context,
                        icon: Icons.calendar_today,
                        label: 'Purchase Date',
                        value: DateFormat('MMMM d, yyyy').format(widget.expense.date),
                      ),
                      const Divider(),
                      
                      // Card
                      cardAsync.when(
                        data: (card) => _buildDetailRow(
                          context,
                          icon: Icons.credit_card,
                          label: 'Card Used',
                          value: card != null 
                              ? '${card.holderName} - ****${card.lastFourDigits}'
                              : 'Unknown Card',
                        ),
                        loading: () => _buildDetailRow(
                          context,
                          icon: Icons.credit_card,
                          label: 'Card Used',
                          value: 'Loading...',
                        ),
                        error: (_, __) => _buildDetailRow(
                          context,
                          icon: Icons.credit_card,
                          label: 'Card Used',
                          value: 'Error loading card',
                        ),
                      ),
                      const Divider(),
                      
                      // Description
                      _buildDetailRow(
                        context,
                        icon: Icons.description,
                        label: 'Description',
                        value: widget.expense.description,
                        isMultiline: true,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: context.dimensions.spacingL),

              // Receipt preview
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: context.dimensions.padding,
                      child: Row(
                        children: [
                          Icon(Icons.receipt, color: context.colors.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Receipt',
                            style: context.textStyles.title,
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    InkWell(
                      onTap: () {
                        final isPdf = widget.expense.imageUrl.toLowerCase().contains('.pdf');
                        if (isPdf) {
                          showDialog(
                            context: context,
                            builder: (context) => PdfViewerDialog(
                              pdfUrl: widget.expense.imageUrl,
                              title: 'Receipt - ${widget.expense.description}',
                            ),
                          );
                        } else {
                          _viewFullImage(context);
                        }
                      },
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: 200,
                          maxHeight: MediaQuery.of(context).size.height * 0.5,
                        ),
                        width: double.infinity,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Builder(
                              builder: (context) {
                                debugPrint('Loading image from URL: ${widget.expense.imageUrl}');
                                final isPdf = widget.expense.imageUrl.toLowerCase().contains('.pdf');
                                
                                if (isPdf) {
                                  return Container(
                                    height: 300,
                                    color: context.colors.surface,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.picture_as_pdf,
                                            size: 64,
                                            color: context.colors.primary,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'PDF Receipt',
                                            style: context.textStyles.title,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Tap to open PDF',
                                            style: context.textStyles.caption.copyWith(
                                              color: context.colors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                
                                return Image.network(
                                  widget.expense.imageUrl,
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  headers: const {
                                    'Accept': 'image/*',
                                  },
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      height: 300,
                                      color: context.colors.surface,
                                      child: const Center(
                                        child: StaticLoadingIndicator(),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    debugPrint('Error loading image: $error');
                                    debugPrint('Stack trace: $stackTrace');
                                    return Container(
                                      height: 300,
                                      color: context.colors.surface,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.error_outline,
                                              size: 48,
                                              color: context.colors.error,
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'Failed to load receipt',
                                              style: TextStyle(
                                                color: context.colors.error,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Tap to view full screen',
                                              style: context.textStyles.caption,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            Positioned(
                              bottom: 16,
                              right: 16,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.zoom_in,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Tap to view',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.dimensions.spacingL),

              // Metadata
              Card(
                color: context.colors.surface.withOpacity(0.5),
                child: Padding(
                  padding: context.dimensions.padding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Additional Information',
                        style: context.textStyles.caption,
                      ),
                      SizedBox(height: context.dimensions.spacingS),
                      userAsync.when(
                        data: (user) => Text(
                          'Submitted by: ${user != null ? "${user.firstName} ${user.lastName}" : "Unknown"}',
                          style: context.textStyles.caption,
                        ),
                        loading: () => Text(
                          'Submitted by: Loading...',
                          style: context.textStyles.caption,
                        ),
                        error: (_, __) => Text(
                          'Submitted by: Error loading user',
                          style: context.textStyles.caption,
                        ),
                      ),
                      Text(
                        'Created: ${DateFormat('MMM d, y - h:mm a').format(widget.expense.createdAt)}',
                        style: context.textStyles.caption,
                      ),
                      if (widget.expense.reviewedAt != null) ...[
                        Text(
                          'Reviewed: ${DateFormat('MMM d, y - h:mm a').format(widget.expense.reviewedAt!)}',
                          style: context.textStyles.caption,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(height: context.dimensions.spacingXL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    TextStyle? valueStyle,
    bool isMultiline = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.dimensions.spacingS),
      child: Row(
        crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: context.colors.primary,
          ),
          SizedBox(width: context.dimensions.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.textStyles.caption.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: valueStyle ?? context.textStyles.body,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(BuildContext context, ExpenseStatus status) {
    switch (status) {
      case ExpenseStatus.pending:
        return Colors.orange;
      case ExpenseStatus.approved:
        return context.colors.success;
      case ExpenseStatus.rejected:
        return context.colors.error;
    }
  }

  IconData _getStatusIcon(ExpenseStatus status) {
    switch (status) {
      case ExpenseStatus.pending:
        return Icons.schedule;
      case ExpenseStatus.approved:
        return Icons.check_circle;
      case ExpenseStatus.rejected:
        return Icons.cancel;
    }
  }

  void _viewFullImage(BuildContext context) {
    debugPrint('Opening full screen image: ${widget.expense.imageUrl}');
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => FullscreenViewerBase(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4,
          child: Image.network(
            widget.expense.imageUrl,
            fit: BoxFit.contain,
            headers: const {
              'Accept': 'image/*',
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: StaticLoadingIndicator(
                  color: Colors.white,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              debugPrint('Error in full screen: $error');
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load image',
                      style: context.textStyles.title.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  
  void _viewPdf(BuildContext context, String pdfUrl) {
    // Open PDF in new tab
    html.window.open(pdfUrl, '_blank');
  }
}