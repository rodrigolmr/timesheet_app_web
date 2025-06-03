// Import Firebase scripts - using latest stable version
importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js');

// Initialize Firebase with correct project config
const firebaseConfig = {
  apiKey: 'AIzaSyDwJETLpwpYw79mOqoKbA27kJaEiI67XAA',
  appId: '1:283421680164:web:84051a48e1bd19850eeeb1',
  messagingSenderId: '283421680164',
  projectId: 'timesheet-app-web',
  authDomain: 'timesheet-app-web.firebaseapp.com',
  storageBucket: 'timesheet-app-web.firebasestorage.app',
};

firebase.initializeApp(firebaseConfig);

// Retrieve Firebase Messaging instance
const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message:', payload);
  
  // Extract notification data from either notification or data payload
  const notificationData = payload.data || {};
  const notification = payload.notification || {};
  
  const notificationTitle = notification.title || notificationData.title || 'Timesheet Manager';
  const notificationOptions = {
    body: notification.body || notificationData.body || 'You have a new notification',
    icon: '/icons/Icon-192.png',
    badge: '/icons/Icon-maskable-192.png',
    tag: notificationData.notificationId || 'default',
    data: notificationData,
    requireInteraction: false,
    vibrate: [200, 100, 200],
    actions: []
  };

  // Add custom actions based on notification type
  const notificationType = notificationData.type;
  if (notificationType === 'job_record_created' || notificationType === 'job_record_updated') {
    notificationOptions.actions = [
      { action: 'view', title: 'View' },
      { action: 'dismiss', title: 'Dismiss' }
    ];
    notificationOptions.requireInteraction = true;
  } else if (notificationType === 'expense_created') {
    notificationOptions.actions = [
      { action: 'view', title: 'View Expense' }
    ];
  } else if (notificationType === 'timesheet_reminder') {
    notificationOptions.actions = [
      { action: 'complete', title: 'Complete Now' }
    ];
    notificationOptions.requireInteraction = true;
  }

  // Show the notification
  return self.registration.showNotification(notificationTitle, notificationOptions);
});

// Handle notification clicks
self.addEventListener('notificationclick', function(event) {
  console.log('[firebase-messaging-sw.js] Notification clicked:', event);
  event.notification.close();

  const data = event.notification.data || {};
  let urlToOpen = '/';

  // Determine URL based on notification type and action
  if (event.action === 'view' || !event.action) {
    // Default click or view action
    if (data.route) {
      urlToOpen = data.route;
    } else if (data.type === 'job_record_created' || data.type === 'job_record_updated') {
      if (data.recordId) {
        urlToOpen = `/job-records/${data.recordId}`;
      } else {
        urlToOpen = '/job-records';
      }
    } else if (data.type === 'expense_created') {
      if (data.expenseId) {
        urlToOpen = `/expenses/${data.expenseId}`;
      } else {
        urlToOpen = '/expenses';
      }
    } else if (data.type === 'timesheet_reminder') {
      urlToOpen = '/job-records/create';
    }
  } else if (event.action === 'complete') {
    urlToOpen = '/job-records/create';
  } else if (event.action === 'dismiss') {
    // Just close the notification
    return;
  }

  // Focus existing window or open new one
  event.waitUntil(
    clients.matchAll({ 
      type: 'window', 
      includeUncontrolled: true 
    }).then(function(clientList) {
      // Check if app is already open
      for (let i = 0; i < clientList.length; i++) {
        const client = clientList[i];
        const clientUrl = new URL(client.url);
        
        if (clientUrl.origin === self.location.origin && 'focus' in client) {
          // Focus the window
          client.focus();
          // Navigate to the specific page
          client.navigate(urlToOpen);
          return;
        }
      }
      
      // If app is not open, open it with the target URL
      if (clients.openWindow) {
        return clients.openWindow(urlToOpen);
      }
    })
  );
});

// Listen for skip waiting message
self.addEventListener('message', function(event) {
  if (event.data && event.data.type === 'SKIP_WAITING') {
    self.skipWaiting();
  }
});