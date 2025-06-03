import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/app_header.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive_container.dart';
import 'package:timesheet_app_web/src/core/widgets/dialogs/app_alert_dialog.dart';
import 'package:timesheet_app_web/src/features/notifications/presentation/providers/notification_providers.dart';
import 'package:timesheet_app_web/src/features/notifications/presentation/providers/notification_admin_providers.dart';
import 'package:timesheet_app_web/src/features/notifications/data/models/notification_model.dart';
import 'package:timesheet_app_web/src/features/user/presentation/providers/user_providers.dart';
import 'package:intl/intl.dart';

class NotificationsAdminScreen extends ConsumerStatefulWidget {
  const NotificationsAdminScreen({super.key});

  @override
  ConsumerState<NotificationsAdminScreen> createState() => _NotificationsAdminScreenState();
}

class _NotificationsAdminScreenState extends ConsumerState<NotificationsAdminScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader.withTabs(
        title: 'Notification Management',
        showBackButton: true,
        tabBar: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.settings), text: 'Settings'),
            Tab(icon: Icon(Icons.history), text: 'History'),
            Tab(icon: Icon(Icons.people), text: 'Users'),
            Tab(icon: Icon(Icons.send), text: 'Send'),
            Tab(icon: Icon(Icons.schedule), text: 'Reminders'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _NotificationSettingsTab(),
          _NotificationHistoryTab(),
          _UserNotificationPreferencesTab(),
          _SendNotificationTab(),
          _ScheduledRemindersTab(),
        ],
      ),
    );
  }
}

// Tab 1: Configurações de Permissões por Role
class _NotificationSettingsTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_NotificationSettingsTab> createState() => _NotificationSettingsTabState();
}

class _NotificationSettingsTabState extends ConsumerState<_NotificationSettingsTab> {
  final Map<String, Map<String, bool>> _rolePermissions = {
    'job_record_created': {
      'admin': true,
      'manager': true,
      'user': false,
    },
    'job_record_updated': {
      'admin': true,
      'manager': true,
      'user': false,
    },
    'expense_created': {
      'admin': true,
      'manager': true,
      'user': false,
    },
    'timesheet_reminder': {
      'admin': true,
      'manager': true,
      'user': true,
    },
    'system_updates': {
      'admin': true,
      'manager': false,
      'user': false,
    },
  };

  final Map<String, String> _notificationTypeNames = {
    'job_record_created': 'Job Record Created',
    'job_record_updated': 'Job Record Updated',
    'expense_created': 'Expense Created',
    'timesheet_reminder': 'Timesheet Reminders',
    'system_updates': 'System Updates',
  };

  final Map<String, String> _notificationTypeDescriptions = {
    'job_record_created': 'When new job records are created',
    'job_record_updated': 'When job records are modified',
    'expense_created': 'When new expenses are submitted',
    'timesheet_reminder': 'Weekly timesheet submission reminders',
    'system_updates': 'Important system announcements',
  };

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      child: SingleChildScrollView(
        padding: context.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notification Permissions by Role',
              style: context.textStyles.headline,
            ),
            SizedBox(height: context.dimensions.spacingM),
            Text(
              'Configure which roles receive each type of notification',
              style: context.textStyles.body.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            SizedBox(height: context.dimensions.spacingL),
            _buildPermissionsTable(context),
            SizedBox(height: context.dimensions.spacingXL),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _resetToDefaults(context),
                  child: const Text('Reset to Defaults'),
                ),
                SizedBox(width: context.dimensions.spacingM),
                ElevatedButton(
                  onPressed: () => _saveSettings(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    foregroundColor: context.colors.onPrimary,
                  ),
                  child: const Text('Save Settings'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionsTable(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.dimensions.spacingM),
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(
                vertical: context.dimensions.spacingM,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: context.colors.textSecondary.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Notification Type',
                      style: context.textStyles.subtitle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildRoleHeader(context, 'Admin'),
                  _buildRoleHeader(context, 'Manager'),
                  _buildRoleHeader(context, 'User'),
                ],
              ),
            ),
            // Rows
            ..._rolePermissions.entries.map((entry) {
              final type = entry.key;
              final permissions = entry.value;
              
              return Container(
                padding: EdgeInsets.symmetric(
                  vertical: context.dimensions.spacingM,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: context.colors.textSecondary.withOpacity(0.1),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _notificationTypeNames[type]!,
                            style: context.textStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: context.dimensions.spacingXS),
                          Text(
                            _notificationTypeDescriptions[type]!,
                            style: context.textStyles.caption.copyWith(
                              color: context.colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildRoleCheckbox(context, type, 'admin', permissions['admin']!),
                    _buildRoleCheckbox(context, type, 'manager', permissions['manager']!),
                    _buildRoleCheckbox(context, type, 'user', permissions['user']!),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleHeader(BuildContext context, String role) {
    return Expanded(
      child: Center(
        child: Text(
          role,
          style: context.textStyles.body.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCheckbox(BuildContext context, String type, String role, bool value) {
    return Expanded(
      child: Center(
        child: Checkbox(
          value: value,
          onChanged: (newValue) {
            setState(() {
              _rolePermissions[type]![role] = newValue!;
            });
          },
          activeColor: context.colors.primary,
        ),
      ),
    );
  }

  void _resetToDefaults(BuildContext context) {
    setState(() {
      _rolePermissions['job_record_created'] = {
        'admin': true,
        'manager': true,
        'user': false,
      };
      _rolePermissions['job_record_updated'] = {
        'admin': true,
        'manager': true,
        'user': false,
      };
      _rolePermissions['expense_created'] = {
        'admin': true,
        'manager': true,
        'user': false,
      };
      _rolePermissions['timesheet_reminder'] = {
        'admin': true,
        'manager': true,
        'user': true,
      };
      _rolePermissions['system_updates'] = {
        'admin': true,
        'manager': false,
        'user': false,
      };
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Reset to default settings'),
        backgroundColor: context.colors.info,
      ),
    );
  }

  void _saveSettings(BuildContext context) async {
    // TODO: Implement save to Firebase
    await showSuccessDialog(
      context: context,
      title: 'Settings Saved',
      message: 'Notification permissions have been updated successfully.',
    );
  }
}

// Tab 2: Histórico de Notificações
class _NotificationHistoryTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(allNotificationsStreamProvider);
    
    return ResponsiveContainer(
      child: notificationsAsync.when(
        data: (notifications) => _buildHistoryList(context, ref, notifications),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Error loading notifications: $error',
            style: TextStyle(color: context.colors.error),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryList(BuildContext context, WidgetRef ref, List<NotificationModel> notifications) {
    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: context.colors.textSecondary.withOpacity(0.5),
            ),
            SizedBox(height: context.dimensions.spacingM),
            Text(
              'No notifications sent yet',
              style: context.textStyles.title.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: context.padding,
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return Card(
          margin: EdgeInsets.only(bottom: context.dimensions.spacingM),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getNotificationColor(context, notification.type),
              child: Icon(
                _getNotificationIcon(notification.type),
                color: Colors.white,
                size: 20,
              ),
            ),
            title: Text(notification.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.body),
                SizedBox(height: context.dimensions.spacingXS),
                Row(
                  children: [
                    Icon(
                      notification.isRead ? Icons.done_all : Icons.done,
                      size: 16,
                      color: notification.isRead 
                          ? context.colors.success 
                          : context.colors.textSecondary,
                    ),
                    SizedBox(width: context.dimensions.spacingXS),
                    Text(
                      DateFormat('MMM d, y h:mm a').format(notification.createdAt),
                      style: context.textStyles.caption,
                    ),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _deleteNotification(context, ref, notification.id),
            ),
          ),
        );
      },
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'job_record_created':
      case 'job_record_updated':
        return Icons.work;
      case 'expense_created':
        return Icons.receipt_long;
      case 'timesheet_reminder':
        return Icons.schedule;
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
      case 'expense_created':
        return context.categoryColorByName('receipt');
      case 'timesheet_reminder':
        return context.colors.warning;
      case 'system_updates':
        return context.colors.info;
      default:
        return context.colors.primary;
    }
  }

  void _deleteNotification(BuildContext context, WidgetRef ref, String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Notification'),
        content: const Text('Are you sure you want to delete this notification?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(notificationStateProvider.notifier).deleteNotification(id);
    }
  }
}

// Tab 3: Preferências dos Usuários
class _UserNotificationPreferencesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersStreamProvider);
    
    return ResponsiveContainer(
      child: usersAsync.when(
        data: (users) => _buildUsersList(context, ref, users),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Error loading users: $error',
            style: TextStyle(color: context.colors.error),
          ),
        ),
      ),
    );
  }

  Widget _buildUsersList(BuildContext context, WidgetRef ref, List<dynamic> users) {
    return ListView.builder(
      padding: context.padding,
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final prefsAsync = ref.watch(userNotificationPreferencesByIdProvider(user.id));
        
        return Card(
          margin: EdgeInsets.only(bottom: context.dimensions.spacingM),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: context.colors.primary,
              child: Text(
                '${user.firstName[0]}${user.lastName[0]}',
                style: TextStyle(color: context.colors.onPrimary),
              ),
            ),
            title: Text('${user.firstName} ${user.lastName}'),
            subtitle: Text(user.email),
            children: [
              prefsAsync.when(
                data: (prefs) => _buildUserPreferences(context, prefs),
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, __) => Padding(
                  padding: EdgeInsets.all(context.dimensions.spacingM),
                  child: Text(
                    'No preferences set',
                    style: TextStyle(color: context.colors.textSecondary),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserPreferences(BuildContext context, dynamic prefs) {
    if (prefs == null) {
      return Padding(
        padding: EdgeInsets.all(context.dimensions.spacingM),
        child: Text(
          'User has not configured notification preferences',
          style: TextStyle(color: context.colors.textSecondary),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(context.dimensions.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPreferenceRow(context, 'Notifications Enabled', prefs.enabled),
          _buildPreferenceRow(context, 'Job Record Created', prefs.jobRecordCreated),
          _buildPreferenceRow(context, 'Job Record Updated', prefs.jobRecordUpdated),
          _buildPreferenceRow(context, 'Expense Created', prefs.expenseCreated),
          _buildPreferenceRow(context, 'Timesheet Reminders', prefs.timesheetReminder),
          _buildPreferenceRow(context, 'System Updates', prefs.systemUpdates),
          if (prefs.fcmToken != null) ...[
            SizedBox(height: context.dimensions.spacingM),
            Text(
              'FCM Token:',
              style: context.textStyles.caption.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              prefs.fcmToken!.substring(0, 20) + '...',
              style: context.textStyles.caption.copyWith(
                fontFamily: 'monospace',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPreferenceRow(BuildContext context, String label, bool value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.dimensions.spacingXS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: context.textStyles.body),
          Icon(
            value ? Icons.check_circle : Icons.cancel,
            color: value ? context.colors.success : context.colors.error,
            size: 20,
          ),
        ],
      ),
    );
  }
}

// Tab 4: Enviar Notificação Manual
class _SendNotificationTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_SendNotificationTab> createState() => _SendNotificationTabState();
}

class _SendNotificationTabState extends ConsumerState<_SendNotificationTab> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  String _selectedType = 'system_updates';
  String _selectedTarget = 'all'; // all, role, user
  String? _selectedRole;
  String? _selectedUserId;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      xlMaxWidth: 800,
      child: SingleChildScrollView(
        padding: context.padding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Send Manual Notification',
                style: context.textStyles.headline,
              ),
              SizedBox(height: context.dimensions.spacingM),
              Text(
                'Send a custom notification to users',
                style: context.textStyles.body.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              SizedBox(height: context.dimensions.spacingL),
              
              // Notification Type
              _buildDropdownField(
                context,
                'Notification Type',
                _selectedType,
                {
                  'system_updates': 'System Update',
                  'job_record_created': 'Job Record Created',
                  'job_record_updated': 'Job Record Updated',
                  'expense_created': 'Expense Created',
                  'timesheet_reminder': 'Timesheet Reminder',
                },
                (value) => setState(() => _selectedType = value!),
              ),
              
              SizedBox(height: context.dimensions.spacingM),
              
              // Target Selection
              _buildDropdownField(
                context,
                'Send To',
                _selectedTarget,
                {
                  'all': 'All Users',
                  'role': 'By Role',
                  'user': 'Specific User',
                },
                (value) => setState(() {
                  _selectedTarget = value!;
                  _selectedRole = null;
                  _selectedUserId = null;
                }),
              ),
              
              if (_selectedTarget == 'role') ...[
                SizedBox(height: context.dimensions.spacingM),
                _buildDropdownField(
                  context,
                  'Select Role',
                  _selectedRole,
                  {
                    'admin': 'Admin',
                    'manager': 'Manager',
                    'user': 'User',
                  },
                  (value) => setState(() => _selectedRole = value),
                ),
              ],
              
              if (_selectedTarget == 'user') ...[
                SizedBox(height: context.dimensions.spacingM),
                _buildUserDropdown(context),
              ],
              
              SizedBox(height: context.dimensions.spacingM),
              
              // Title
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Notification Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: context.dimensions.spacingM),
              
              // Body
              TextFormField(
                controller: _bodyController,
                decoration: InputDecoration(
                  labelText: 'Notification Message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                  ),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Message is required';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: context.dimensions.spacingL),
              
              // Preview
              Card(
                child: Padding(
                  padding: EdgeInsets.all(context.dimensions.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Preview',
                        style: context.textStyles.subtitle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: context.dimensions.spacingM),
                      Row(
                        children: [
                          Icon(
                            _getNotificationIcon(_selectedType),
                            color: context.colors.primary,
                          ),
                          SizedBox(width: context.dimensions.spacingM),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _titleController.text.isEmpty 
                                      ? 'Notification Title' 
                                      : _titleController.text,
                                  style: context.textStyles.body.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: context.dimensions.spacingXS),
                                Text(
                                  _bodyController.text.isEmpty 
                                      ? 'Notification message will appear here' 
                                      : _bodyController.text,
                                  style: context.textStyles.caption,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: context.dimensions.spacingL),
              
              // Send Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sendNotification,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    foregroundColor: context.colors.onPrimary,
                    padding: EdgeInsets.symmetric(
                      vertical: context.dimensions.spacingM,
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Send Notification'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    BuildContext context,
    String label,
    String? value,
    Map<String, String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textStyles.body.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: context.dimensions.spacingS),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
            ),
          ),
          items: items.entries.map((entry) {
            return DropdownMenuItem(
              value: entry.key,
              child: Text(entry.value),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select an option';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildUserDropdown(BuildContext context) {
    final usersAsync = ref.watch(usersStreamProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select User',
          style: context.textStyles.body.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: context.dimensions.spacingS),
        usersAsync.when(
          data: (users) => DropdownButtonFormField<String>(
            value: _selectedUserId,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
              ),
            ),
            items: users.map((user) {
              return DropdownMenuItem(
                value: user.id,
                child: Text('${user.firstName} ${user.lastName} (${user.email})'),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedUserId = value),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a user';
              }
              return null;
            },
          ),
          loading: () => const CircularProgressIndicator(),
          error: (_, __) => const Text('Error loading users'),
        ),
      ],
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'job_record_created':
      case 'job_record_updated':
        return Icons.work;
      case 'expense_created':
        return Icons.receipt_long;
      case 'timesheet_reminder':
        return Icons.schedule;
      case 'system_updates':
        return Icons.info_outline;
      default:
        return Icons.notifications;
    }
  }

  Future<void> _sendNotification() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Implement actual notification sending logic
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        await showSuccessDialog(
          context: context,
          title: 'Notification Sent',
          message: 'The notification has been sent successfully.',
        );
        
        // Clear form
        _titleController.clear();
        _bodyController.clear();
        setState(() {
          _selectedType = 'system_updates';
          _selectedTarget = 'all';
          _selectedRole = null;
          _selectedUserId = null;
        });
      }
    } catch (e) {
      if (mounted) {
        await showErrorDialog(
          context: context,
          title: 'Error',
          message: 'Failed to send notification: $e',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

// Tab 5: Lembretes Agendados
class _ScheduledRemindersTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ScheduledRemindersTab> createState() => _ScheduledRemindersTabState();
}

class _ScheduledRemindersTabState extends ConsumerState<_ScheduledRemindersTab> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      child: Column(
        children: [
          // Header com botão de criar
          Padding(
            padding: EdgeInsets.all(context.dimensions.spacingM),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Scheduled Reminders',
                  style: context.textStyles.headline,
                ),
                ElevatedButton.icon(
                  onPressed: () => _showCreateReminderDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('New Reminder'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    foregroundColor: context.colors.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          // Lista de lembretes
          Expanded(
            child: _buildRemindersList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildRemindersList(BuildContext context) {
    // TODO: Implementar stream de lembretes
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: context.dimensions.spacingM),
      itemCount: 0, // Temporário
      itemBuilder: (context, index) {
        return _buildReminderCard(context, index);
      },
    );
  }

  Widget _buildReminderCard(BuildContext context, int index) {
    // TODO: Implementar card de lembrete
    return Card(
      margin: EdgeInsets.only(bottom: context.dimensions.spacingM),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: context.colors.primary.withOpacity(0.1),
          child: Icon(Icons.schedule, color: context.colors.primary),
        ),
        title: Text('Reminder Title'),
        subtitle: Text('Message preview...'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: true,
              onChanged: (value) {
                // TODO: Toggle active status
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // TODO: Edit reminder
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // TODO: Delete reminder
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateReminderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => _CreateReminderDialog(),
    );
  }
}

// Dialog para criar/editar lembretes
class _CreateReminderDialog extends ConsumerStatefulWidget {
  final String? reminderId;
  
  const _CreateReminderDialog({this.reminderId});

  @override
  ConsumerState<_CreateReminderDialog> createState() => _CreateReminderDialogState();
}

class _CreateReminderDialogState extends ConsumerState<_CreateReminderDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  
  String _frequency = 'once';
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  DateTime _selectedDate = DateTime.now();
  String? _selectedDayOfWeek;
  int? _selectedDayOfMonth;
  List<String> _selectedUserIds = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(usersStreamProvider);
    
    return Dialog(
      child: Container(
        width: 600,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(widget.reminderId == null ? 'Create Reminder' : 'Edit Reminder'),
            actions: [
              TextButton(
                onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveReminder,
                child: _isLoading 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save'),
              ),
              SizedBox(width: context.dimensions.spacingM),
            ],
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(context.dimensions.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Reminder Title',
                      hintText: 'e.g., Timesheet Submission Reminder',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Title is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: context.dimensions.spacingM),
                  
                  // Message
                  TextFormField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: 'Message',
                      hintText: 'e.g., Please submit your timesheet for this week',
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Message is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: context.dimensions.spacingL),
                  
                  // Frequency
                  Text('Frequency', style: context.textStyles.subtitle),
                  SizedBox(height: context.dimensions.spacingS),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'once', label: Text('Once')),
                      ButtonSegment(value: 'daily', label: Text('Daily')),
                      ButtonSegment(value: 'weekly', label: Text('Weekly')),
                      ButtonSegment(value: 'monthly', label: Text('Monthly')),
                    ],
                    selected: {_frequency},
                    onSelectionChanged: (Set<String> selection) {
                      setState(() {
                        _frequency = selection.first;
                      });
                    },
                  ),
                  SizedBox(height: context.dimensions.spacingL),
                  
                  // Date/Time Selection
                  Row(
                    children: [
                      // Time picker
                      Expanded(
                        child: ListTile(
                          title: const Text('Time'),
                          subtitle: Text(_selectedTime.format(context)),
                          leading: const Icon(Icons.access_time),
                          onTap: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: _selectedTime,
                            );
                            if (time != null) {
                              setState(() {
                                _selectedTime = time;
                              });
                            }
                          },
                        ),
                      ),
                      
                      // Date picker (only for 'once')
                      if (_frequency == 'once')
                        Expanded(
                          child: ListTile(
                            title: const Text('Date'),
                            subtitle: Text(DateFormat('MMM d, y').format(_selectedDate)),
                            leading: const Icon(Icons.calendar_today),
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                              );
                              if (date != null) {
                                setState(() {
                                  _selectedDate = date;
                                });
                              }
                            },
                          ),
                        ),
                    ],
                  ),
                  
                  // Day of week (for weekly)
                  if (_frequency == 'weekly') ...[
                    SizedBox(height: context.dimensions.spacingM),
                    Text('Day of Week', style: context.textStyles.subtitle),
                    SizedBox(height: context.dimensions.spacingS),
                    Wrap(
                      spacing: context.dimensions.spacingS,
                      children: [
                        'Monday', 'Tuesday', 'Wednesday', 'Thursday', 
                        'Friday', 'Saturday', 'Sunday'
                      ].asMap().entries.map((entry) {
                        final index = entry.key + 1;
                        final day = entry.value;
                        return ChoiceChip(
                          label: Text(day),
                          selected: _selectedDayOfWeek == index.toString(),
                          onSelected: (selected) {
                            setState(() {
                              _selectedDayOfWeek = selected ? index.toString() : null;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                  
                  // Day of month (for monthly)
                  if (_frequency == 'monthly') ...[
                    SizedBox(height: context.dimensions.spacingM),
                    Text('Day of Month', style: context.textStyles.subtitle),
                    SizedBox(height: context.dimensions.spacingS),
                    DropdownButtonFormField<int>(
                      value: _selectedDayOfMonth,
                      decoration: const InputDecoration(
                        hintText: 'Select day',
                      ),
                      items: List.generate(31, (index) => index + 1)
                          .map((day) => DropdownMenuItem(
                                value: day,
                                child: Text(day.toString()),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDayOfMonth = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a day';
                        }
                        return null;
                      },
                    ),
                  ],
                  
                  SizedBox(height: context.dimensions.spacingL),
                  
                  // User Selection
                  Text('Send To', style: context.textStyles.subtitle),
                  SizedBox(height: context.dimensions.spacingS),
                  usersAsync.when(
                    data: (users) => Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: context.colors.outline),
                        borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                      ),
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          final isSelected = _selectedUserIds.contains(user.id);
                          
                          return CheckboxListTile(
                            title: Text('${user.firstName} ${user.lastName}'),
                            subtitle: Text(user.email),
                            value: isSelected,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  _selectedUserIds.add(user.id);
                                } else {
                                  _selectedUserIds.remove(user.id);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const Text('Error loading users'),
                  ),
                  
                  if (_selectedUserIds.isEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: context.dimensions.spacingS),
                      child: Text(
                        'Please select at least one user',
                        style: TextStyle(color: context.colors.error, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveReminder() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedUserIds.isEmpty) return;
    
    // Validate frequency-specific fields
    if (_frequency == 'weekly' && _selectedDayOfWeek == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a day of the week')),
      );
      return;
    }
    
    if (_frequency == 'monthly' && _selectedDayOfMonth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a day of the month')),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      // TODO: Implementar salvamento do lembrete
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Reminder saved successfully'),
            backgroundColor: context.colors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving reminder: $e'),
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

