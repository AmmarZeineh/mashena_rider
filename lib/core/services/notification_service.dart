import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/core/services/device_id_service.dart';
import 'package:mashena_rider/core/services/logger_service.dart';
import 'package:mashena_rider/core/services/notification_router.dart';
import 'package:mashena_rider/features/notifications/domain/repositories/notifications_repository.dart';
import '../../firebase_options.dart';

class NotificationService {
  static const Duration _apnsTokenRetryDelay = Duration(milliseconds: 500);
  static const int _apnsTokenMaxAttempts = 10;
  static const String _logTag = 'mashena_rider.notifications';

  static const String _androidChannelId = 'mashena_rider_notifications_channel';
  static const String _androidChannelName = 'Mashena Rider Notifications';
  static const String _androidChannelDesc =
      'Main notification channel for ride and account updates';

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
    // 1. Request notification permissions (iOS & Android 13+)
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    LoggerService.debug(
      'Notification authorization status: ${settings.authorizationStatus}',
      name: _logTag,
    );

    // 2. Set iOS foreground notification presentation options
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 3. Foreground message listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await _showFlutterNotification(message);
    });

    // 4. Notification tap listeners
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message);
    });

    // 5. Token refresh listener
    _firebaseMessaging.onTokenRefresh.listen(_handleTokenRefresh);

    // 6. Setup local notifications and channel
    await _initializedLocalNotification();
    await _setupNotificationChannels();

    // 7. Check if opened from a terminated state
    await _getInitialNotification();

    // 8. Prefetch FCM token asynchronously
    unawaited(getFcmToken());
  }

  static Future<void> _showFlutterNotification(RemoteMessage message) async {
    final RemoteNotification? notification = message.notification;
    final Map<String, dynamic> data = message.data;

    final String title = notification?.title ?? data['title'] ?? 'Mashena';
    final String body = notification?.body ?? data['body'] ?? '';

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _androidChannelId,
      _androidChannelName,
      channelDescription: _androidChannelDesc,
      icon: '@mipmap/launcher_icon',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final notificationId =
        DateTime.now().millisecondsSinceEpoch.remainder(100000);

    await flutterLocalNotificationsPlugin.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: jsonEncode(data),
    );
  }

  static Future<void> _initializedLocalNotification() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSetting = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initSetting,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        NotificationRouter.routeFromPayload(response.payload);
      },
    );
  }

  static Future<void> _getInitialNotification() async {
    final RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      _handleNotificationTap(message);
    }
  }

  static void _handleNotificationTap(RemoteMessage message) {
    NotificationRouter.routeFromRemoteMessage(message);
  }

  static Future<void> _setupNotificationChannels() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _androidChannelId,
      _androidChannelName,
      description: _androidChannelDesc,
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

  /// Retrieves the device FCM token (handling APNs availability on iOS).
  static Future<String?> getFcmToken() {
    final cachedToken = _cachedFcmToken;
    if (cachedToken != null) return Future<String?>.value(cachedToken);

    return _tokenRequest ??= _requestFcmToken();
  }

  static Future<String?> _requestFcmToken() async {
    try {
      if (!await _isApnsTokenAvailable()) {
        LoggerService.debug(
          'APNs token is not available yet on iOS. Ensure Push Notifications capability is enabled in Xcode and tested on a physical device.',
          name: _logTag,
        );
      }

      final token = await _firebaseMessaging.getToken();
      _cachedFcmToken = token;
      LoggerService.debug('Retrieved FCM token successfully: $token', name: _logTag);
      return token;
    } on FirebaseException catch (error, stackTrace) {
      LoggerService.debug(
        'Failed to retrieve the FCM token.',
        name: _logTag,
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    } catch (error, stackTrace) {
      LoggerService.debug(
        'Unexpected error retrieving FCM token.',
        name: _logTag,
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
      if (token != null) {
        LoggerService.debug('APNs token received on attempt ${attempt + 1}', name: _logTag);
        return true;
      }
      await Future<void>.delayed(_apnsTokenRetryDelay);
    }

    return false;
  }

  /// Registers/synchronizes the current device FCM token with the backend.
  static Future<void> syncTokenWithBackend() async {
    try {
      final token = await getFcmToken();
      if (token == null || token.trim().isEmpty) return;

      final platform = kIsWeb
          ? 'web'
          : (defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android');
      final deviceId = await DeviceIdService.getOrCreateDeviceId();

      if (getIt.isRegistered<NotificationsRepository>()) {
        final repository = getIt<NotificationsRepository>();
        final result = await repository.registerToken(
          token: token,
          platform: platform,
          deviceId: deviceId,
        );

        result.fold(
          (failure) => LoggerService.debug(
            'Failed to sync FCM token with backend: ${failure.rawMessage}',
            name: _logTag,
          ),
          (_) => LoggerService.debug(
            'FCM token successfully synchronized with backend ($platform, deviceId: $deviceId)',
            name: _logTag,
          ),
        );
      }
    } catch (e, stackTrace) {
      LoggerService.debug(
        'Exception while syncing FCM token',
        name: _logTag,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Unregisters the current device FCM token from the backend on logout.
  static Future<void> unregisterTokenWithBackend() async {
    try {
      final token = _cachedFcmToken ?? await getFcmToken();
      if (token == null || token.trim().isEmpty) return;

      if (getIt.isRegistered<NotificationsRepository>()) {
        final repository = getIt<NotificationsRepository>();
        await repository.unregisterToken(token);
        LoggerService.debug(
          'FCM token successfully unregistered from backend.',
          name: _logTag,
        );
      }
    } catch (e, stackTrace) {
      LoggerService.debug(
        'Exception while unregistering FCM token',
        name: _logTag,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  static void _handleTokenRefresh(String token) {
    _cachedFcmToken = token;
    unawaited(syncTokenWithBackend());
  }
}
