import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/features/notifications/data/models/notification_model.dart';
import 'package:timesheet_app_web/src/features/notifications/presentation/providers/notification_providers.dart';
import 'package:intl/intl.dart';

class NotificationDropdownWidget extends ConsumerWidget {
  final VoidCallback onClose;
  final Function(NotificationModel) onNotificationTap;

  const NotificationDropdownWidget({
    super.key,
    required this.onClose,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(userNotificationsProvider);

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
      child: Container(
        width: 320,
        constraints: const BoxConstraints(maxHeight: 400),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
          border: Border.all(
            color: context.colors.textSecondary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context, ref),
            Divider(height: 1, color: context.colors.textSecondary.withOpacity(0.2)),
            Flexible(
              child: notificationsAsync.when(
                data: (notifications) => _buildNotificationList(
                  context,
                  ref,
                  notifications,
                ),
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'Error loading notifications',
                      style: TextStyle(color: context.colors.error),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.all(context.dimensions.spacingM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Notifications',
            style: context.textStyles.subtitle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.settings, size: 20),
                onPressed: () {
                  onClose();
                  // Navigate to notifications page - it will handle role-based UI
                  context.go('/notifications');
                },
                tooltip: 'Notification Settings',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: onClose,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(
    BuildContext context,
    WidgetRef ref,
    List<NotificationModel> notifications,
  ) {
    if (notifications.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(context.dimensions.spacingXL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.notifications_none,
                size: 48,
                color: context.colors.textSecondary.withOpacity(0.5),
              ),
              SizedBox(height: context.dimensions.spacingM),
              Text(
                'No notifications',
                style: context.textStyles.body.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: context.dimensions.spacingS),
      itemCount: notifications.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: context.colors.textSecondary.withOpacity(0.2),
      ),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationItem(context, ref, notification);
      },
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    WidgetRef ref,
    NotificationModel notification,
  ) {
    final icon = _getNotificationIcon(notification.type);
    final iconColor = _getNotificationColor(context, notification.type);

    return InkWell(
      onTap: () {
        if (!notification.isRead) {
          ref.read(notificationStateProvider.notifier).markAsRead(notification.id);
        }
        onNotificationTap(notification);
      },
      child: Container(
        padding: EdgeInsets.all(context.dimensions.spacingM),
        color: notification.isRead
            ? Colors.transparent
            : context.colors.primary.withOpacity(0.05),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 24,
              color: iconColor,
            ),
            SizedBox(width: context.dimensions.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: context.textStyles.body.copyWith(
                      fontWeight: notification.isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: context.dimensions.spacingXS),
                  Text(
                    notification.body,
                    style: context.textStyles.caption.copyWith(
                      color: context.colors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: context.dimensions.spacingXS),
                  Text(
                    _formatTime(notification.createdAt),
                    style: context.textStyles.caption.copyWith(
                      color: context.colors.textSecondary.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'job_record_created':
      case 'job_record_updated':
        return Icons.work;
      case 'timesheet_reminder':
        return Icons.schedule;
      case 'expense_created':
        return Icons.receipt_long;
      case 'system_updates':
        return Icons.info_outline;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(BuildContext context, String type) {
    switch (type) {
      case 'job_record_created':
      case 'job_record_updated':
        return context.categoryColorByName('timesheet');
      case 'timesheet_reminder':
        return context.colors.warning;
      case 'expense_created':
        return context.categoryColorByName('receipt');
      case 'system_updates':
        return context.colors.info;
      default:
        return context.colors.primary;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return DateFormat('MMM d').format(dateTime);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}