import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Services/FCMService.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _notificationsEnabled = false;
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final enabled = await FCMService.areNotificationsEnabled();
    final token = FCMService.fcmToken;

    setState(() {
      _notificationsEnabled = enabled;
      _fcmToken = token;
    });
  }

  Future<void> _copyTokenToClipboard() async {
    if (_fcmToken != null) {
      await Clipboard.setData(ClipboardData(text: _fcmToken!));
      Get.snackbar(
        'Copied',
        'FCM token copied to clipboard',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Notification Settings'),
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notification Status
          Card(
            child: ListTile(
              leading: Icon(
                _notificationsEnabled
                    ? Icons.notifications_active
                    : Icons.notifications_off,
                color: _notificationsEnabled ? Colors.green : Colors.red,
              ),
              title: const Text('Push Notifications'),
              subtitle: Text(
                _notificationsEnabled ? 'Enabled' : 'Disabled',
                style: TextStyle(
                  color: _notificationsEnabled ? Colors.green : Colors.red,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadNotificationSettings,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // FCM Token
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.token),
                      const SizedBox(width: 8),
                      const Text(
                        'FCM Token',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      if (_fcmToken != null)
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: _copyTokenToClipboard,
                          tooltip: 'Copy token',
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    ),
                    child: Text(
                      _fcmToken ?? 'Loading...',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Topic Subscriptions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.topic),
                      SizedBox(width: 8),
                      Text(
                        'Topic Subscriptions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTopicSubscription('general', 'General Notifications'),
                  _buildTopicSubscription(
                    'feeding_reminders',
                    'Feeding Reminders',
                  ),
                  _buildTopicSubscription(
                    'diaper_reminders',
                    'Diaper Reminders',
                  ),
                  _buildTopicSubscription(
                    'sleep_reminders',
                    'Sleep Reminders',
                  ),
                  _buildTopicSubscription(
                    'analytics_updates',
                    'Analytics Updates',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Test Notification Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _sendTestNotification,
              icon: const Icon(Icons.send),
              label: const Text('Send Test Notification'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildTopicSubscription(String topic, String displayName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(child: Text(displayName)),
          Row(
            children: [
              TextButton(
                onPressed: () => FCMService.subscribeToTopic(topic),
                child: const Text('Subscribe'),
              ),
              TextButton(
                onPressed: () => FCMService.unsubscribeFromTopic(topic),
                child: const Text('Unsubscribe'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _sendTestNotification() {
    // This would typically be done from your server
    // For demo purposes, we'll show a local notification-style snackbar
    Get.snackbar(
      'Test Notification',
      'This is a test notification from MomsMilk app!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(Icons.baby_changing_station, color: Colors.white),
    );
  }
}
