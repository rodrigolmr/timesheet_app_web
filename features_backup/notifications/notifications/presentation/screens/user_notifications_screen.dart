import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/app_header.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive_container.dart';
import 'package:timesheet_app_web/src/core/widgets/dialogs/app_alert_dialog.dart';
import 'package:timesheet_app_web/src/features/notifications/presentation/providers/notification_providers.dart';
import 'package:timesheet_app_web/src/features/notifications/data/models/notification_preferences_model.dart';
import 'package:timesheet_app_web/src/features/user/presentation/providers/user_providers.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/permission_providers.dart';
import 'package:timesheet_app_web/src/features/user/domain/enums/user_role.dart';

class UserNotificationsScreen extends ConsumerStatefulWidget {
  const UserNotificationsScreen({super.key});

  @override
  ConsumerState<UserNotificationsScreen> createState() => _UserNotificationsScreenState();
}

class _UserNotificationsScreenState extends ConsumerState<UserNotificationsScreen> {
  // Common settings
  bool _dailyReminderEnabled = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 17, minute: 0);
  
  // Manager settings
  bool _jobRecordCreated = true;
  bool _jobRecordUpdated = true;
  bool _expenseCreated = true;
  bool _systemUpdates = false;
  
  bool _isLoading = false;
  UserRole? _userRole;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() {
    final preferences = ref.read(userNotificationPreferencesProvider).valueOrNull;
    if (preferences != null) {
      setState(() {
        // Common settings
        _dailyReminderEnabled = preferences.timesheetReminder;
        
        // Manager settings
        _jobRecordCreated = preferences.jobRecordCreated;
        _jobRecordUpdated = preferences.jobRecordUpdated;
        _expenseCreated = preferences.expenseCreated;
        _systemUpdates = preferences.systemUpdates;
        
        // Load saved reminder time
        if (preferences.data?['daily_reminder_time'] != null) {
          final timeParts = preferences.data!['daily_reminder_time'].split(':');
          _reminderTime = TimeOfDay(
            hour: int.parse(timeParts[0]),
            minute: int.parse(timeParts[1]),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userRole = ref.watch(currentUserRoleProvider).valueOrNull;
    _userRole = userRole;
    
    // If user is admin, redirect to admin screen
    if (userRole == UserRole.admin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/notifications-admin');
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppHeader(
        title: 'Notification Settings',
        showBackButton: true,
      ),
      body: ResponsiveContainer(
        xlMaxWidth: 800,
        child: SingleChildScrollView(
          padding: context.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Daily Reminder Section (for all users)
              _buildDailyReminderSection(context),
              
              // Manager-specific notifications
              if (userRole == UserRole.manager) ...[
                SizedBox(height: context.dimensions.spacingXL),
                _buildManagerNotificationSection(context),
              ],
              
              SizedBox(height: context.dimensions.spacingL),
              
              // Information Box
              _buildInfoBox(context, userRole == UserRole.manager),
              
              SizedBox(height: context.dimensions.spacingXL),
              
              // Save Button
              _buildSaveButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailyReminderSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Reminders',
          style: context.textStyles.headline,
        ),
        SizedBox(height: context.dimensions.spacingM),
        Text(
          'Set up daily reminders to submit your job records',
          style: context.textStyles.body.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        SizedBox(height: context.dimensions.spacingL),
        
        Card(
          child: Padding(
            padding: EdgeInsets.all(context.dimensions.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      color: context.colors.primary,
                      size: 28,
                    ),
                    SizedBox(width: context.dimensions.spacingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Job Record Reminder',
                            style: context.textStyles.subtitle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: context.dimensions.spacingXS),
                          Text(
                            'Get reminded every day to submit your job records',
                            style: context.textStyles.caption.copyWith(
                              color: context.colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _dailyReminderEnabled,
                      onChanged: (value) {
                        setState(() {
                          _dailyReminderEnabled = value;
                        });
                      },
                      activeColor: context.colors.primary,
                    ),
                  ],
                ),
                
                // Time Picker
                if (_dailyReminderEnabled) ...[
                  SizedBox(height: context.dimensions.spacingL),
                  Divider(
                    color: context.colors.textSecondary.withOpacity(0.2),
                  ),
                  SizedBox(height: context.dimensions.spacingM),
                  Row(
                    children: [
                      Text(
                        'Reminder Time:',
                        style: context.textStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: context.dimensions.spacingM),
                      InkWell(
                        onTap: () => _selectTime(context),
                        borderRadius: BorderRadius.circular(
                          context.dimensions.borderRadiusM,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.dimensions.spacingM,
                            vertical: context.dimensions.spacingS,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: context.colors.primary,
                            ),
                            borderRadius: BorderRadius.circular(
                              context.dimensions.borderRadiusM,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 20,
                                color: context.colors.primary,
                              ),
                              SizedBox(width: context.dimensions.spacingS),
                              Text(
                                _reminderTime.format(context),
                                style: context.textStyles.body.copyWith(
                                  color: context.colors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildManagerNotificationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Manager Notifications',
          style: context.textStyles.headline,
        ),
        SizedBox(height: context.dimensions.spacingM),
        Text(
          'Choose which notifications you want to receive as a manager',
          style: context.textStyles.body.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        SizedBox(height: context.dimensions.spacingL),
        
        Card(
          child: Padding(
            padding: EdgeInsets.all(context.dimensions.spacingM),
            child: Column(
              children: [
                _buildNotificationToggle(
                  context,
                  icon: Icons.add_box,
                  title: 'New Job Records',
                  subtitle: 'When new job records are created by team members',
                  value: _jobRecordCreated,
                  onChanged: (value) => setState(() => _jobRecordCreated = value),
                ),
                Divider(height: context.dimensions.spacingL),
                _buildNotificationToggle(
                  context,
                  icon: Icons.edit_note,
                  title: 'Job Record Updates',
                  subtitle: 'When job records are modified',
                  value: _jobRecordUpdated,
                  onChanged: (value) => setState(() => _jobRecordUpdated = value),
                ),
                Divider(height: context.dimensions.spacingL),
                _buildNotificationToggle(
                  context,
                  icon: Icons.receipt_long,
                  title: 'New Expenses',
                  subtitle: 'When new expenses are created by team members',
                  value: _expenseCreated,
                  onChanged: (value) => setState(() => _expenseCreated = value),
                ),
                Divider(height: context.dimensions.spacingL),
                _buildNotificationToggle(
                  context,
                  icon: Icons.info_outline,
                  title: 'System Updates',
                  subtitle: 'Important announcements and system maintenance',
                  value: _systemUpdates,
                  onChanged: (value) => setState(() => _systemUpdates = value),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationToggle(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.dimensions.spacingS),
      child: Row(
        children: [
          Icon(
            icon,
            color: value ? context.colors.primary : context.colors.textSecondary,
            size: 24,
          ),
          SizedBox(width: context.dimensions.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: context.dimensions.spacingXS),
                Text(
                  subtitle,
                  style: context.textStyles.caption.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: context.colors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(BuildContext context, bool isManager) {
    return Container(
      padding: EdgeInsets.all(context.dimensions.spacingM),
      decoration: BoxDecoration(
        color: context.colors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(
          context.dimensions.borderRadiusM,
        ),
        border: Border.all(
          color: context.colors.info.withOpacity(0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: context.colors.info,
            size: 20,
          ),
          SizedBox(width: context.dimensions.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How it works',
                  style: context.textStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colors.info,
                  ),
                ),
                SizedBox(height: context.dimensions.spacingXS),
                Text(
                  isManager
                      ? 'You\'ll receive notifications based on your preferences. Daily reminders will notify you at the selected time, while manager notifications will arrive in real-time when events occur.'
                      : 'When enabled, you\'ll receive a notification at the selected time every day reminding you to submit your job records for the day.',
                  style: context.textStyles.caption,
                ),
                SizedBox(height: context.dimensions.spacingS),
                Text(
                  'Make sure notifications are enabled in your browser settings for this to work.',
                  style: context.textStyles.caption.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveSettings,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colors.primary,
          foregroundColor: context.colors.onPrimary,
          padding: EdgeInsets.symmetric(
            vertical: context.dimensions.spacingM,
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Save Settings'),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.colors.primary,
              onPrimary: context.colors.onPrimary,
              secondary: context.colors.secondary,
              onSecondary: context.colors.onSecondary,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _reminderTime) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  Future<void> _saveSettings() async {
    setState(() => _isLoading = true);

    try {
      final currentPrefs = ref.read(userNotificationPreferencesProvider).valueOrNull;
      final userProfile = ref.read(currentUserProfileProvider).valueOrNull;
      
      if (userProfile == null) return;

      // Request notification permission if enabling for the first time
      if ((_dailyReminderEnabled || (_userRole == UserRole.manager && (_jobRecordCreated || _jobRecordUpdated || _expenseCreated || _systemUpdates))) && 
          (currentPrefs == null || !currentPrefs.enabled)) {
        final permissionStatus = await ref.read(notificationPermissionStatusProvider.future);
        
        if (permissionStatus != AuthorizationStatus.authorized &&
            permissionStatus != AuthorizationStatus.provisional) {
          await ref.read(notificationStateProvider.notifier).requestPermission();
        }
      }

      final isManager = _userRole == UserRole.manager;
      final anyNotificationEnabled = _dailyReminderEnabled || 
          (isManager && (_jobRecordCreated || _jobRecordUpdated || _expenseCreated || _systemUpdates));

      final updatedPrefs = NotificationPreferencesModel(
        id: currentPrefs?.id ?? '',
        userId: userProfile.id,
        enabled: anyNotificationEnabled,
        jobRecordCreated: isManager ? _jobRecordCreated : false,
        jobRecordUpdated: isManager ? _jobRecordUpdated : false,
        timesheetReminder: _dailyReminderEnabled,
        expenseCreated: isManager ? _expenseCreated : false,
        systemUpdates: isManager ? _systemUpdates : false,
        fcmToken: currentPrefs?.fcmToken,
        subscribedTopics: currentPrefs?.subscribedTopics,
        data: {
          'daily_reminder_time': '${_reminderTime.hour}:${_reminderTime.minute}',
        },
        updatedAt: DateTime.now(),
      );

      await ref
          .read(notificationStateProvider.notifier)
          .updatePreferences(updatedPrefs);

      if (mounted) {
        await showSuccessDialog(
          context: context,
          title: 'Settings Saved',
          message: 'Your notification preferences have been updated.',
        );
      }
    } catch (e) {
      if (mounted) {
        await showErrorDialog(
          context: context,
          title: 'Error',
          message: 'Failed to save settings: $e',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}