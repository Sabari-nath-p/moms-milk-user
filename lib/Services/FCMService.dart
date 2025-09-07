import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FCMService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static String? _fcmToken;

  // Get the FCM token
  static String? get fcmToken => _fcmToken;

  // Initialize FCM
  static Future<void> initialize() async {
    try {
      // Request permission for notifications
      await _requestPermission();

      // Get the FCM token
      _fcmToken = await _firebaseMessaging.getToken();
      if (kDebugMode) {
        print('FCM Token: $_fcmToken');
      }

      // Configure foreground notification presentation options
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((token) {
        _fcmToken = token;
        if (kDebugMode) {
          print('FCM Token refreshed: $token');
        }
        // TODO: Send the new token to your server
        _sendTokenToServer(token);
      });

      // Handle messages when the app is in the foreground
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle notification taps when the app is in the background
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

      // Handle notification tap when the app is terminated
      _firebaseMessaging.getInitialMessage().then((message) {
        if (message != null) {
          _handleBackgroundMessage(message);
        }
      });

      if (kDebugMode) {
        print('FCM Service initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing FCM: $e');
      }
    }
  }

  // Request notification permission
  static Future<void> _requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
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

    // For iOS, also request permission for local notifications
    if (Platform.isIOS) {
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  // Handle foreground messages
  static void _handleForegroundMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
    }

    if (message.notification != null) {
      if (kDebugMode) {
        print('Message also contained a notification: ${message.notification}');
      }

      // Show in-app notification or custom UI
      _showInAppNotification(message);
    }
  }

  // Handle background/terminated message taps
  static void _handleBackgroundMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('Handling a background message: ${message.messageId}');
      print('Message data: ${message.data}');
    }

    // Navigate to specific screen based on message data
    _handleNotificationNavigation(message);
  }

  // Show in-app notification for foreground messages
  static void _showInAppNotification(RemoteMessage message) {
    if (Get.context != null) {
      Get.snackbar(
        message.notification?.title ?? 'New Message',
        message.notification?.body ?? 'You have a new message',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.notifications, color: Colors.white),
        onTap: (_) {
          _handleNotificationNavigation(message);
        },
      );
    }
  }

  // Handle notification navigation
  static void _handleNotificationNavigation(RemoteMessage message) {
    // Extract navigation data from message
    final String? type = message.data['type'];
    final String? screen = message.data['screen'];
    final String? id = message.data['id'];

    if (kDebugMode) {
      print('Navigation data - Type: $type, Screen: $screen, ID: $id');
    }

    // Navigate based on notification type
    switch (type) {
      case 'baby_update':
        // Navigate to baby details
        break;
      case 'feeding_reminder':
        // Navigate to feeding screen
        break;
      case 'request_update':
        // Navigate to requests screen
        break;
      case 'analytics':
        // Navigate to analytics screen
        break;
      default:
        // Navigate to home or default screen
        break;
    }
  }

  // Send token to server
  static Future<void> _sendTokenToServer(String token) async {
    try {
      // TODO: Implement your API call to send token to server
      if (kDebugMode) {
        print('Sending token to server: $token');
      }

      // Example API call:
      // await ApiService.post('/user/fcm-token', {
      //   'token': token,
      //   'platform': Platform.isIOS ? 'ios' : 'android',
      // });
    } catch (e) {
      if (kDebugMode) {
        print('Error sending token to server: $e');
      }
    }
  }

  // Subscribe to topic
  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      if (kDebugMode) {
        print('Subscribed to topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error subscribing to topic $topic: $e');
      }
    }
  }

  // Unsubscribe from topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      if (kDebugMode) {
        print('Unsubscribed from topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error unsubscribing from topic $topic: $e');
      }
    }
  }

  // Get notification settings
  static Future<NotificationSettings> getNotificationSettings() async {
    return await _firebaseMessaging.getNotificationSettings();
  }

  // Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    final settings = await getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }
}

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('Handling a background message: ${message.messageId}');
    print('Message data: ${message.data}');
  }
}
