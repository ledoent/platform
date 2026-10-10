import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';
import '../core/api/rest_client.dart';

const _uuid = Uuid();

/// Manages FCM push notifications and registers as a PushSubscription
/// in the Huly workspace so the notification service can deliver alerts.
class PushNotificationService {
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  String? _fcmToken;

  /// Initialize FCM and local notifications.
  Future<void> initialize() async {
    // Request permission.
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialize local notifications for foreground display.
    await _localNotifications.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

    // Get FCM token.
    _fcmToken = await messaging.getToken();

    // Listen for foreground messages.
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Listen for token refresh.
    messaging.onTokenRefresh.listen((token) {
      _fcmToken = token;
    });
  }

  /// Get the current FCM token.
  String? get fcmToken => _fcmToken;

  /// Register the FCM token as a PushSubscription in the Huly workspace.
  /// This allows the Huly notification service to send push notifications.
  Future<void> registerWithWorkspace(HulyRestClient client) async {
    if (_fcmToken == null) return;

    final subscriptionId = 'push:sub:${_uuid.v4()}';

    // The FCM endpoint URL is a valid Web Push endpoint.
    // The Huly notification service uses web-push which supports FCM URLs.
    final tx = {
      '_class': 'core:class:TxCreateDoc',
      'objectId': subscriptionId,
      'objectClass': 'notification:class:PushSubscription',
      'objectSpace': 'core:space:Space',
      'attributes': {
        'endpoint': 'https://fcm.googleapis.com/fcm/send/$_fcmToken',
        'keys': {
          'p256dh': '',
          'auth': '',
        },
      },
    };

    try {
      await client.tx(tx);
    } catch (e) {
      // Subscription may already exist or workspace may not support it.
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      notification.hashCode,
      notification.title ?? 'Huly',
      notification.body,
      const NotificationDetails(
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
        android: AndroidNotificationDetails(
          'huly_notifications',
          'Huly Notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }
}

/// Background message handler (must be top-level function).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Background messages are automatically displayed by the system.
}
