import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/dialogs/app_alert_dialog.dart';
import 'package:timesheet_app_web/src/features/notifications/presentation/providers/notification_providers.dart';

class NotificationPermissionDialog extends ConsumerWidget {
  const NotificationPermissionDialog({super.key});

  static Future<void> show(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const NotificationPermissionDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationStateProvider);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.dimensions.borderRadiusL),
      ),
      title: Row(
        children: [
          Icon(
            Icons.notifications_active,
            color: context.colors.primary,
            size: 28,
          ),
          SizedBox(width: context.dimensions.spacingM),
          Text(
            'Enable Notifications',
            style: context.textStyles.title,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Stay updated with important information:',
            style: context.textStyles.subtitle,
          ),
          SizedBox(height: context.dimensions.spacingM),
          _buildBenefitItem(
            context,
            Icons.work,
            'New job records assigned to you',
          ),
          _buildBenefitItem(
            context,
            Icons.schedule,
            'Timesheet submission reminders',
          ),
          _buildBenefitItem(
            context,
            Icons.info_outline,
            'Important system announcements',
          ),
          SizedBox(height: context.dimensions.spacingL),
          Text(
            'You can change notification preferences anytime in settings.',
            style: context.textStyles.caption.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: notificationState.isLoading
              ? null
              : () => Navigator.of(context).pop(),
          child: Text(
            'Not Now',
            style: TextStyle(color: context.colors.textSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: notificationState.isLoading
              ? null
              : () async {
                  await ref
                      .read(notificationStateProvider.notifier)
                      .requestPermission();

                  if (context.mounted) {
                    final newState = ref.read(notificationStateProvider);
                    if (newState.hasError) {
                      await showErrorDialog(
                        context: context,
                        title: 'Permission Denied',
                        message:
                            'Notifications are disabled. You can enable them later in your browser settings.',
                      );
                    }
                    Navigator.of(context).pop();
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colors.primary,
            foregroundColor: context.colors.onPrimary,
          ),
          child: notificationState.isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: context.colors.onPrimary,
                  ),
                )
              : const Text('Enable Notifications'),
        ),
      ],
    );
  }

  Widget _buildBenefitItem(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.dimensions.spacingS),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: context.colors.primary.withOpacity(0.7),
          ),
          SizedBox(width: context.dimensions.spacingS),
          Expanded(
            child: Text(
              text,
              style: context.textStyles.body,
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationPermissionBanner extends ConsumerWidget {
  const NotificationPermissionBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissionStatus = ref.watch(notificationPermissionStatusProvider);

    return permissionStatus.when(
      data: (status) {
        if (status == AuthorizationStatus.denied ||
            status == AuthorizationStatus.notDetermined) {
          return Container(
            margin: EdgeInsets.all(context.dimensions.spacingM),
            padding: EdgeInsets.all(context.dimensions.spacingM),
            decoration: BoxDecoration(
              color: context.colors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                context.dimensions.borderRadiusM,
              ),
              border: Border.all(
                color: context.colors.primary.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.notifications_off,
                  color: context.colors.primary,
                ),
                SizedBox(width: context.dimensions.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notifications are disabled',
                        style: context.textStyles.subtitle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Enable notifications to stay updated',
                        style: context.textStyles.caption,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => NotificationPermissionDialog.show(context),
                  child: const Text('Enable'),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}