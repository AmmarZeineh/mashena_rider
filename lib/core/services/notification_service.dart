import 'dart:async';
import 'package:mashena_rider/core/services/logger_service.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../firebase_options.dart';

class NotificationService {
  static const Duration _apnsTokenRetryDelay = Duration(milliseconds: 500);
  static const int _apnsTokenMaxAttempts = 10;

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<String?>? _tokenRequest;
  static String? _cachedFcmToken;

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await _initializedLocalNotification();
    await _showFlutterNotification(message);
  }

  static Future<void> initializeNotification() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await _showFlutterNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message);
    });

    _firebaseMessaging.onTokenRefresh.listen(_handleTokenRefresh);
    unawaited(getFcmToken());
    await _initializedLocalNotification();
    await _getInitialNotification();

    await _setupNotificationChannels();
  }

  static Future<void> _showFlutterNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    Map<String, dynamic> data = message.data;

    String title = notification?.title ?? data['title'] ?? 'No Title';
    String body = notification?.body ?? data['body'] ?? 'No body';

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      channelDescription: 'Notiffication channel for basic test',
      icon: '@mipmap/launcher_icon',

      priority: Priority.high,
      importance: Importance.high,
    );
    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id: 0,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }

  static Future<void> _initializedLocalNotification() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
    final InitializationSettings initSetting = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );
    await flutterLocalNotificationsPlugin.initialize(
      settings: initSetting,
      onDidReceiveNotificationResponse: (NotificationResponse response) {},
    );
  }

  static Future<void> _getInitialNotification() async {
    RemoteMessage? message = await FirebaseMessaging.instance
        .getInitialMessage();
    if (message != null) {
      _handleNotificationTap(message);
    }
  }

  static void _handleNotificationTap(RemoteMessage message) {}

  static Future<void> _setupNotificationChannels() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      description: 'Notification channel for basic test',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  static Future<String?> getFcmToken() {
    final cachedToken = _cachedFcmToken;
    if (cachedToken != null) return Future<String?>.value(cachedToken);

    return _tokenRequest ??= _requestFcmToken();
  }

  static Future<String?> _requestFcmToken() async {
    try {
      if (!await _isApnsTokenAvailable()) {
        LoggerService.debug(
          'APNs token is not available yet.',
          name: 'mashena_rider.notifications',
        );
        return null;
      }

      final token = await _firebaseMessaging.getToken();
      _cachedFcmToken = token;
      return token;
    } on FirebaseException catch (error, stackTrace) {
      LoggerService.debug(
        'Failed to retrieve the FCM token.',
        name: 'mashena_rider.notifications',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    } finally {
      _tokenRequest = null;
    }
  }

  static Future<bool> _isApnsTokenAvailable() async {
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.iOS &&
            defaultTargetPlatform != TargetPlatform.macOS)) {
      return true;
    }

    for (var attempt = 0; attempt < _apnsTokenMaxAttempts; attempt++) {
      final token = await _firebaseMessaging.getAPNSToken();
      if (token != null) return true;
      await Future<void>.delayed(_apnsTokenRetryDelay);
    }

    return false;
  }

  static void _handleTokenRefresh(String token) {
    _cachedFcmToken = token;
    // Send the refreshed token to the backend when token synchronization
    // is implemented.
  }
}
