const functions = require('firebase-functions');
const admin = require('firebase-admin');

// Initialize Firebase Admin
admin.initializeApp();

// Get Firestore and FCM instances
const db = admin.firestore();
const messaging = admin.messaging();

// Listen for new notifications and send push notifications
exports.sendPushNotification = functions.firestore
  .document('notifications/{notificationId}')
  .onCreate(async (snap, context) => {
    const notification = snap.data();
    const notificationId = context.params.notificationId;

    try {
      // Get user preferences to check if notifications are enabled
      const preferencesSnapshot = await db.collection('notification_preferences')
        .where('user_id', '==', notification.user_id)
        .limit(1)
        .get();

      if (preferencesSnapshot.empty) {
        console.log('No notification preferences found for user:', notification.user_id);
        return null;
      }

      const preferences = preferencesSnapshot.docs[0].data();

      // Check if notifications are enabled
      if (!preferences.enabled) {
        console.log('Notifications disabled for user:', notification.user_id);
        return null;
      }

      // Check if this type of notification is enabled
      const typeEnabled = checkNotificationTypeEnabled(notification.type, preferences);
      if (!typeEnabled) {
        console.log(`Notification type ${notification.type} disabled for user:`, notification.user_id);
        return null;
      }

      // Check if user has FCM token
      if (!preferences.fcm_token) {
        console.log('No FCM token for user:', notification.user_id);
        return null;
      }

      // Prepare the message payload
      const message = {
        token: preferences.fcm_token,
        notification: {
          title: notification.title,
          body: notification.body,
        },
        data: {
          notificationId: notificationId,
          type: notification.type,
          click_action: 'FLUTTER_NOTIFICATION_CLICK',
          ...notification.data
        },
        webpush: {
          notification: {
            title: notification.title,
            body: notification.body,
            icon: '/icons/Icon-192.png',
            badge: '/icons/Icon-maskable-192.png',
            requireInteraction: shouldRequireInteraction(notification.type),
            vibrate: [200, 100, 200],
            actions: getNotificationActions(notification.type)
          },
          fcmOptions: {
            link: notification.data?.route || '/'
          }
        },
        android: {
          priority: 'high',
          notification: {
            channelId: 'default',
            priority: 'high',
            defaultVibrateTimings: true,
            defaultSound: true
          }
        }
      };

      // Send the message
      const response = await messaging.send(message);
      console.log('Successfully sent push notification:', response);

      return { success: true, messageId: response };
    } catch (error) {
      console.error('Error sending push notification:', error);
      return { success: false, error: error.message };
    }
  });

// Helper function to check if notification type is enabled
function checkNotificationTypeEnabled(type, preferences) {
  switch (type) {
    case 'job_record_created':
      return preferences.job_record_created !== false;
    case 'job_record_updated':
      return preferences.job_record_updated !== false;
    case 'expense_created':
      return preferences.expense_created !== false;
    case 'timesheet_reminder':
      return preferences.timesheet_reminder !== false;
    case 'system_updates':
      return preferences.system_updates !== false;
    default:
      return true;
  }
}

// Helper function to determine if notification should require interaction
function shouldRequireInteraction(type) {
  return type === 'job_record_created' || 
         type === 'job_record_updated' || 
         type === 'timesheet_reminder';
}

// Helper function to get notification actions based on type
function getNotificationActions(type) {
  switch (type) {
    case 'job_record_created':
    case 'job_record_updated':
      return [
        { action: 'view', title: 'View' },
        { action: 'dismiss', title: 'Dismiss' }
      ];
    case 'expense_created':
      return [
        { action: 'view', title: 'View Expense' }
      ];
    case 'timesheet_reminder':
      return [
        { action: 'complete', title: 'Complete Now' }
      ];
    default:
      return [];
  }
}

// Scheduled function to send timesheet reminders
exports.sendTimesheetReminders = functions.pubsub
  .schedule('0 9 * * 5') // Every Friday at 9 AM
  .timeZone('America/New_York')
  .onRun(async (context) => {
    try {
      // Get all users
      const usersSnapshot = await db.collection('users').get();
      
      for (const userDoc of usersSnapshot.docs) {
        const user = userDoc.data();
        
        // Skip if user is admin (they don't submit timesheets)
        if (user.role === 'admin') continue;
        
        // Create reminder notification
        await db.collection('notifications').add({
          user_id: userDoc.id,
          title: 'Timesheet Reminder',
          body: `Please submit your timesheet for this week.`,
          type: 'timesheet_reminder',
          data: {
            route: '/job-records/create'
          },
          is_read: false,
          created_at: admin.firestore.FieldValue.serverTimestamp()
        });
      }
      
      console.log('Timesheet reminders sent successfully');
      return null;
    } catch (error) {
      console.error('Error sending timesheet reminders:', error);
      throw error;
    }
  });

// Clean up old notifications (older than 30 days)
exports.cleanupOldNotifications = functions.pubsub
  .schedule('0 2 * * *') // Every day at 2 AM
  .timeZone('America/New_York')
  .onRun(async (context) => {
    try {
      const thirtyDaysAgo = new Date();
      thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
      
      const oldNotificationsSnapshot = await db.collection('notifications')
        .where('created_at', '<', admin.firestore.Timestamp.fromDate(thirtyDaysAgo))
        .get();
      
      const batch = db.batch();
      oldNotificationsSnapshot.docs.forEach(doc => {
        batch.delete(doc.ref);
      });
      
      await batch.commit();
      
      console.log(`Deleted ${oldNotificationsSnapshot.size} old notifications`);
      return null;
    } catch (error) {
      console.error('Error cleaning up old notifications:', error);
      throw error;
    }
  });

// Process scheduled reminders
exports.processScheduledReminders = functions.pubsub
  .schedule('*/5 * * * *') // Every 5 minutes
  .timeZone('America/New_York')
  .onRun(async (context) => {
    try {
      const now = new Date();
      
      // Get all active reminders that are due
      const remindersSnapshot = await db.collection('scheduled_reminders')
        .where('is_active', '==', true)
        .where('next_send_at', '<=', admin.firestore.Timestamp.fromDate(now))
        .get();
      
      console.log(`Found ${remindersSnapshot.size} reminders to process`);
      
      for (const doc of remindersSnapshot.docs) {
        const reminder = doc.data();
        const reminderId = doc.id;
        
        try {
          // Create notifications for each target user
          const notificationPromises = reminder.target_user_ids.map(userId => 
            db.collection('notifications').add({
              user_id: userId,
              title: reminder.title,
              body: reminder.message,
              type: 'scheduled_reminder',
              data: {
                reminder_id: reminderId,
                route: '/notifications',
              },
              is_read: false,
              created_at: admin.firestore.FieldValue.serverTimestamp()
            })
          );
          
          await Promise.all(notificationPromises);
          
          // Calculate next send time based on frequency
          let nextSendAt = null;
          const scheduledTime = reminder.scheduled_time.toDate();
          
          switch (reminder.frequency) {
            case 'once':
              // One-time reminder, deactivate it
              await doc.ref.update({
                is_active: false,
                last_sent_at: admin.firestore.FieldValue.serverTimestamp(),
                next_send_at: null
              });
              break;
              
            case 'daily':
              // Next day at the same time
              nextSendAt = new Date(now);
              nextSendAt.setDate(nextSendAt.getDate() + 1);
              nextSendAt.setHours(scheduledTime.getHours(), scheduledTime.getMinutes(), 0, 0);
              break;
              
            case 'weekly':
              // Next week on the same day
              const targetWeekday = parseInt(reminder.day_of_week);
              nextSendAt = new Date(now);
              nextSendAt.setDate(nextSendAt.getDate() + 7);
              nextSendAt.setHours(scheduledTime.getHours(), scheduledTime.getMinutes(), 0, 0);
              
              // Adjust to the correct weekday
              while (nextSendAt.getDay() !== targetWeekday - 1) {
                nextSendAt.setDate(nextSendAt.getDate() + 1);
              }
              break;
              
            case 'monthly':
              // Next month on the same day
              nextSendAt = new Date(now);
              nextSendAt.setMonth(nextSendAt.getMonth() + 1);
              nextSendAt.setDate(reminder.day_of_month);
              nextSendAt.setHours(scheduledTime.getHours(), scheduledTime.getMinutes(), 0, 0);
              
              // Handle month-end edge cases
              if (nextSendAt.getDate() !== reminder.day_of_month) {
                // If the day doesn't exist (e.g., Feb 31), use last day of month
                nextSendAt.setDate(0); // Sets to last day of previous month
              }
              break;
          }
          
          // Update reminder with last sent and next send times
          const updateData = {
            last_sent_at: admin.firestore.FieldValue.serverTimestamp()
          };
          
          if (nextSendAt) {
            updateData.next_send_at = admin.firestore.Timestamp.fromDate(nextSendAt);
          }
          
          await doc.ref.update(updateData);
          
          console.log(`Processed reminder ${reminderId} for ${reminder.target_user_ids.length} users`);
          
        } catch (error) {
          console.error(`Error processing reminder ${reminderId}:`, error);
        }
      }
      
      return null;
    } catch (error) {
      console.error('Error processing scheduled reminders:', error);
      throw error;
    }
  });