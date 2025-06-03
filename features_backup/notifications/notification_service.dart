import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final _messageStreamController = StreamController<RemoteMessage>.broadcast();
  
  Stream<RemoteMessage> get messageStream => _messageStreamController.stream;
  
  String? _fcmToken;
  String? get fcmToken => _fcmToken;
  
  bool _initialized = false;
  bool get initialized => _initialized;

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      // Request permission for notifications
      await requestPermission();
      
      // Get the token
      await getToken();
      
      // Configure message handlers
      _configureMessageHandlers();
      
      // Listen for token refresh
      _messaging.onTokenRefresh.listen((token) {
        _fcmToken = token;
        _saveToken(token);
        if (kDebugMode) {
          print('FCM Token refreshed: $token');
        }
      });
      
      _initialized = true;
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing notifications: $e');
      }
      rethrow;
    }
  }

  /// Request notification permissions
  Future<NotificationSettings> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    
    if (kDebugMode) {
      print('User granted permission: ${settings.authorizationStatus}');
    }
    
    return settings;
  }

  /// Get the current permission status
  Future<AuthorizationStatus> getPermissionStatus() async {
    final settings = await _messaging.getNotificationSettings();
    return settings.authorizationStatus;
  }

  /// Get FCM token
  Future<String?> getToken() async {
    try {
      // For web, we need to provide the VAPID key
      if (kIsWeb) {
        _fcmToken = await _messaging.getToken(
          vapidKey: 'BCyFHArX9k7mYFvTvBHV9DDFq_trOcHt-bI_PKQEmdY0MJAEFCEE99flN-pVRn_r5lKBpJz8YiYvSvPacDXBHRk',
        );
      } else {
        _fcmToken = await _messaging.getToken();
      }
      
      if (_fcmToken != null) {
        await _saveToken(_fcmToken!);
      }
      
      if (kDebugMode) {
        print('FCM Token: $_fcmToken');
      }
      
      return _fcmToken;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting FCM token: $e');
      }
      return null;
    }
  }

  /// Save token to local storage
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token);
  }

  /// Get saved token from local storage
  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('fcm_token');
  }

  /// Configure message handlers
  void _configureMessageHandlers() {
    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
        
        if (message.notification != null) {
          print('Message also contained a notification: ${message.notification}');
        }
      }
      
      _messageStreamController.add(message);
    });

    // Handle message click
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('A new onMessageOpenedApp event was published!');
        print('Message data: ${message.data}');
      }
      
      _handleMessageClick(message);
    });
  }

  /// Handle notification click
  void _handleMessageClick(RemoteMessage message) {
    // Navigate based on message data
    final data = message.data;
    
    if (data.containsKey('route')) {
      // Navigation will be handled by the app
      _messageStreamController.add(message);
    }
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      if (kDebugMode) {
        print('Subscribed to topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error subscribing to topic: $e');
      }
      rethrow;
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      if (kDebugMode) {
        print('Unsubscribed from topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error unsubscribing from topic: $e');
      }
      rethrow;
    }
  }

  /// Get initial message (if app was opened from notification)
  Future<RemoteMessage?> getInitialMessage() async {
    return await _messaging.getInitialMessage();
  }

  /// Dispose the service
  void dispose() {
    _messageStreamController.close();
  }
}

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('Handling a background message: ${message.messageId}');
  }
}