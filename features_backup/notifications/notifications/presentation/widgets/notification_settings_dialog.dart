import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/dialogs/app_form_dialog.dart';
import 'package:timesheet_app_web/src/features/notifications/data/models/notification_preferences_model.dart';
import 'package:timesheet_app_web/src/features/notifications/presentation/providers/notification_providers.dart';
import 'package:timesheet_app_web/src/features/user/presentation/providers/user_providers.dart';

class NotificationSettingsDialog extends ConsumerStatefulWidget {
  const NotificationSettingsDialog({super.key});

  static Future<void> show(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => const NotificationSettingsDialog(),
    );
  }

  @override
  ConsumerState<NotificationSettingsDialog> createState() =>
      _NotificationSettingsDialogState();
}

class _NotificationSettingsDialogState
    extends ConsumerState<NotificationSettingsDialog> {
  late bool _enabled;
  late bool _jobRecordCreated;
  late bool _jobRecordUpdated;
  late bool _timesheetReminder;
  late bool _systemUpdates;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() {
    final preferences = ref.read(userNotificationPreferencesProvider).valueOrNull;
    if (preferences != null) {
      _enabled = preferences.enabled;
      _jobRecordCreated = preferences.jobRecordCreated;
      _jobRecordUpdated = preferences.jobRecordUpdated;
      _timesheetReminder = preferences.timesheetReminder;
      _systemUpdates = preferences.systemUpdates;
    } else {
      // Default values
      _enabled = true;
      _jobRecordCreated = true;
      _jobRecordUpdated = true;
      _timesheetReminder = true;
      _systemUpdates = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppFormDialog(
      title: 'Notification Settings',
      icon: Icons.notifications_active,
      mode: DialogMode.edit,
      actions: [
        AppFormDialogActions(
          isLoading: _isLoading,
          mode: DialogMode.edit,
          onConfirm: _handleSave,
        ),
      ],
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            value: _enabled,
            onChanged: (value) => setState(() => _enabled = value),
            title: Text(
              'Enable Notifications',
              style: context.textStyles.subtitle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Master switch for all notifications',
              style: context.textStyles.caption,
            ),
            activeColor: context.colors.primary,
          ),
          Divider(height: context.dimensions.spacingL),
          Text(
            'Notification Types',
            style: context.textStyles.subtitle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: context.dimensions.spacingM),
          _buildNotificationToggle(
            context,
            'Job Record Created',
            'When new job records are assigned to you',
            _jobRecordCreated,
            (value) => setState(() => _jobRecordCreated = value),
          ),
          _buildNotificationToggle(
            context,
            'Job Record Updated',
            'When job records you\'re involved in are modified',
            _jobRecordUpdated,
            (value) => setState(() => _jobRecordUpdated = value),
          ),
          _buildNotificationToggle(
            context,
            'Timesheet Reminders',
            'Weekly reminders to submit your timesheet',
            _timesheetReminder,
            (value) => setState(() => _timesheetReminder = value),
          ),
          _buildNotificationToggle(
            context,
            'System Updates',
            'Important announcements and maintenance notices',
            _systemUpdates,
            (value) => setState(() => _systemUpdates = value),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationToggle(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.dimensions.spacingS),
      child: SwitchListTile(
        value: value && _enabled,
        onChanged: _enabled ? onChanged : null,
        title: Text(
          title,
          style: context.textStyles.body.copyWith(
            color: _enabled ? null : context.colors.textSecondary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: context.textStyles.caption.copyWith(
            color: _enabled
                ? context.colors.textSecondary
                : context.colors.textSecondary.withOpacity(0.5),
          ),
        ),
        activeColor: context.colors.primary,
        dense: true,
      ),
    );
  }

  Future<void> _handleSave() async {
    setState(() => _isLoading = true);

    try {
      final currentPrefs = ref.read(userNotificationPreferencesProvider).valueOrNull;
      final userProfile = ref.read(currentUserProfileProvider).valueOrNull;
      
      if (userProfile == null) return;

      final updatedPrefs = NotificationPreferencesModel(
        id: currentPrefs?.id ?? '',
        userId: userProfile.id,
        enabled: _enabled,
        jobRecordCreated: _jobRecordCreated,
        jobRecordUpdated: _jobRecordUpdated,
        timesheetReminder: _timesheetReminder,
        expenseCreated: currentPrefs?.expenseCreated ?? true,
        systemUpdates: _systemUpdates,
        fcmToken: currentPrefs?.fcmToken,
        subscribedTopics: currentPrefs?.subscribedTopics,
        data: currentPrefs?.data,
        updatedAt: DateTime.now(),
      );

      await ref
          .read(notificationStateProvider.notifier)
          .updatePreferences(updatedPrefs);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Notification settings saved'),
            backgroundColor: context.colors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving settings: $e'),
            backgroundColor: context.colors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}