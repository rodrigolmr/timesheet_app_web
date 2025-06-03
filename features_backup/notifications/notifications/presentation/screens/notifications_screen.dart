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

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  bool _dailyReminderEnabled = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 17, minute: 0); // 5:00 PM default
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() {
    final preferences = ref.read(userNotificationPreferencesProvider).valueOrNull;
    if (preferences != null) {
      setState(() {
        _dailyReminderEnabled = preferences.timesheetReminder;
        // If there's a saved time in data, parse it
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
    
    // If user is admin or manager, redirect to admin screen
    if (userRole == UserRole.admin || userRole == UserRole.manager) {
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
              // Header
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
              
              // Daily Reminder Card
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
              
              SizedBox(height: context.dimensions.spacingL),
              
              // Information Box
              Container(
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
                            'When enabled, you\'ll receive a notification at the selected time every day reminding you to submit your job records for the day.',
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
              ),
              
              SizedBox(height: context.dimensions.spacingXL),
              
              // Save Button
              SizedBox(
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
              ),
            ],
          ),
        ),
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
      if (_dailyReminderEnabled && (currentPrefs == null || !currentPrefs.timesheetReminder)) {
        final permissionStatus = await ref.read(notificationPermissionStatusProvider.future);
        
        if (permissionStatus != AuthorizationStatus.authorized &&
            permissionStatus != AuthorizationStatus.provisional) {
          await ref.read(notificationStateProvider.notifier).requestPermission();
        }
      }

      final updatedPrefs = NotificationPreferencesModel(
        id: currentPrefs?.id ?? '',
        userId: userProfile.id,
        enabled: _dailyReminderEnabled,
        jobRecordCreated: false, // User doesn't control this
        jobRecordUpdated: false, // User doesn't control this
        timesheetReminder: _dailyReminderEnabled,
        expenseCreated: false, // User doesn't control this
        systemUpdates: false, // User doesn't control this
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