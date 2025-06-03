import 'package:timesheet_app_web/src/features/job_record/data/models/job_record_model.dart';
import 'package:timesheet_app_web/src/features/notifications/data/models/notification_model.dart';
import 'package:timesheet_app_web/src/features/notifications/domain/repositories/notification_repository.dart';
import 'package:timesheet_app_web/src/features/user/domain/repositories/user_repository.dart';

class NotificationHelper {
  final NotificationRepository notificationRepository;
  final UserRepository userRepository;

  NotificationHelper({
    required this.notificationRepository,
    required this.userRepository,
  });

  Future<void> sendJobRecordCreatedNotification({
    required JobRecordModel jobRecord,
    required String creatorId,
  }) async {
    // Get all managers and admins to notify
    final users = await userRepository.getAll();
    final managersAndAdmins = users.where((user) => 
      user.role == 'manager' || user.role == 'admin'
    ).where((user) => user.id != creatorId); // Don't notify the creator

    // Create notification for each manager/admin
    for (final user in managersAndAdmins) {
      final notification = NotificationModel(
        id: '',
        userId: user.id,
        title: 'New Job Record Created',
        body: 'A new job record "${jobRecord.jobName}" has been created and needs review.',
        type: 'job_record_created',
        data: {
          'job_record_id': jobRecord.id,
          'job_name': jobRecord.jobName,
          'route': '/job-records/${jobRecord.id}',
        },
        isRead: false,
        createdAt: DateTime.now(),
      );

      await notificationRepository.createNotification(notification);
    }
  }

  Future<void> sendJobRecordUpdatedNotification({
    required JobRecordModel jobRecord,
    required String updaterId,
  }) async {
    // Notify the original creator if different from updater
    if (jobRecord.userId != updaterId) {
      final notification = NotificationModel(
        id: '',
        userId: jobRecord.userId,
        title: 'Job Record Updated',
        body: 'Your job record "${jobRecord.jobName}" has been updated.',
        type: 'job_record_updated',
        data: {
          'job_record_id': jobRecord.id,
          'job_name': jobRecord.jobName,
          'route': '/job-records/${jobRecord.id}',
        },
        isRead: false,
        createdAt: DateTime.now(),
      );

      await notificationRepository.createNotification(notification);
    }

    // Also notify managers about the update
    final users = await userRepository.getAll();
    final managers = users.where((user) => 
      user.role == 'manager' && user.id != updaterId
    );

    for (final manager in managers) {
      final notification = NotificationModel(
        id: '',
        userId: manager.id,
        title: 'Job Record Updated',
        body: 'Job record "${jobRecord.jobName}" has been updated.',
        type: 'job_record_updated',
        data: {
          'job_record_id': jobRecord.id,
          'job_name': jobRecord.jobName,
          'route': '/job-records/${jobRecord.id}',
        },
        isRead: false,
        createdAt: DateTime.now(),
      );

      await notificationRepository.createNotification(notification);
    }
  }


  Future<void> sendExpenseCreatedNotification({
    required String expenseId,
    required String description,
    required double amount,
    required String creatorId,
  }) async {
    // Get all managers and admins to notify
    final users = await userRepository.getAll();
    final managersAndAdmins = users.where((user) => 
      user.role == 'manager' || user.role == 'admin'
    ).where((user) => user.id != creatorId); // Don't notify the creator

    // Create notification for each manager/admin
    for (final user in managersAndAdmins) {
      final notification = NotificationModel(
        id: '',
        userId: user.id,
        title: 'New Expense Created',
        body: 'A new expense "\$${amount.toStringAsFixed(2)} - $description" has been created.',
        type: 'expense_created',
        data: {
          'expense_id': expenseId,
          'amount': amount,
          'route': '/expenses/$expenseId',
        },
        isRead: false,
        createdAt: DateTime.now(),
      );

      await notificationRepository.createNotification(notification);
    }
  }

  Future<void> sendTimesheetReminderNotification({
    required String userId,
    required String employeeName,
    required DateTime weekStart,
  }) async {
    final notification = NotificationModel(
      id: '',
      userId: userId,
      title: 'Timesheet Reminder',
      body: 'Please submit your timesheet for the week of ${_formatDate(weekStart)}.',
      type: 'timesheet_reminder',
      data: {
        'week_start': weekStart.toIso8601String(),
        'route': '/job-records/create',
      },
      isRead: false,
      createdAt: DateTime.now(),
    );

    await notificationRepository.createNotification(notification);
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}