import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mashena_rider/app/router/app_router.dart';
import 'package:mashena_rider/app/router/app_routes.dart';
import 'package:mashena_rider/core/services/logger_service.dart';
import 'package:mashena_rider/features/notifications/domain/entities/notification_item.dart';

/// Centralized router responsible for dispatching notification taps
/// (Push notifications & In-app list clicks) to their target screens.
final class NotificationRouter {
  const NotificationRouter._();

  static const String _logTag = 'mashena_rider.notification_router';

  /// Routes based on [NotificationItem] entity from the in-app notifications list.
  static void routeFromItem(NotificationItem item) {
    route(type: item.type, metadata: item.metadata);
  }

  /// Routes based on a Firebase [RemoteMessage].
  static void routeFromRemoteMessage(RemoteMessage message) {
    final data = message.data;
    final type = _extractType(data);
    final metadata = _extractMetadata(data);

    route(type: type, metadata: metadata);
  }

  /// Routes based on a JSON-string payload (from FlutterLocalNotificationsPlugin).
  static void routeFromPayload(String? payload) {
    if (payload == null || payload.trim().isEmpty) return;

    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) {
        final type = _extractType(decoded);
        final metadata = _extractMetadata(decoded);
        route(type: type, metadata: metadata);
      }
    } catch (e, stackTrace) {
      LoggerService.debug(
        'Failed to parse notification payload',
        name: _logTag,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Core routing logic mapping each notification type and metadata to its destination.
  static void route({required String type, Map<String, dynamic>? metadata}) {
    final meta = metadata ?? const <String, dynamic>{};
    LoggerService.debug(
      'Routing notification of type: "$type" with metadata: $meta',
      name: _logTag,
    );

    try {
      // 1. Single Trip Notifications
      if (type.startsWith('notification.trip')) {
        _routeTripNotification(type, meta);
        return;
      }

      // 2. Shared Ride Notifications
      if (type.startsWith('notification.shared_ride')) {
        _routeSharedRideNotification(type, meta);
        return;
      }

      // 3. Passenger Pool Notifications
      if (type.startsWith('notification.passenger_pool')) {
        _routePassengerPoolNotification(type, meta);
        return;
      }

      // 4. Moderation & Penalties Notifications
      if (type.startsWith('notification.moderation')) {
        AppRouter.router.push(AppRoutes.moderationPath);
        return;
      }

      // 5. Wallet Notifications
      if (type.startsWith('notification.wallet')) {
        AppRouter.router.push(AppRoutes.profilePath);
        return;
      }

      // 6. Driver Approval
      if (type == 'notification.driver.approved') {
        AppRouter.router.go(AppRoutes.homePath);
        return;
      }

      // 7. General / Admin Notifications / Default
      AppRouter.router.push(AppRoutes.notificationsPath);
    } catch (e, stackTrace) {
      LoggerService.debug(
        'Error during notification navigation',
        name: _logTag,
        error: e,
        stackTrace: stackTrace,
      );
      // Fallback navigation
      AppRouter.router.push(AppRoutes.notificationsPath);
    }
  }

  static void _routeTripNotification(String type, Map<String, dynamic> meta) {
    switch (type) {
      case 'notification.trip.completed':
        AppRouter.router.push(AppRoutes.tripHistoryPath);
        break;
      case 'notification.trip.accepted':
      case 'notification.trip.driver_arrived':
      case 'notification.trip.started':
      case 'notification.trip.cancelled':
      default:
        AppRouter.router.go(AppRoutes.homePath);
        break;
    }
  }

  static void _routeSharedRideNotification(
    String type,
    Map<String, dynamic> meta,
  ) {
    switch (type) {
      case 'notification.shared_ride.joined':
      case 'notification.shared_ride.left':
        final roomId = _extractInt(
          meta['roomId'] ?? meta['room_id'] ?? meta['tripId'] ?? meta['id'],
        );
        if (roomId != null && roomId > 0) {
          AppRouter.router.push(
            AppRoutes.sharedTripRoomDetailsPath,
            extra: roomId,
          );
        } else {
          AppRouter.router.go(AppRoutes.homePath);
        }
        break;
      case 'notification.shared_ride.removed':
      default:
        AppRouter.router.go(AppRoutes.homePath);
        break;
    }
  }

  static void _routePassengerPoolNotification(
    String type,
    Map<String, dynamic> meta,
  ) {
    switch (type) {
      case 'notification.passenger_pool.member_joined':
      case 'notification.passenger_pool.member_left':
      case 'notification.passenger_pool.driver_accepted':
        final roomId = _extractInt(
          meta['roomId'] ?? meta['room_id'] ?? meta['id'],
        );
        if (roomId != null && roomId > 0) {
          AppRouter.router.push(AppRoutes.poolLobbyPath, extra: roomId);
        } else {
          AppRouter.router.go(AppRoutes.homePath);
        }
        break;
      case 'notification.passenger_pool.room_expired':
      case 'notification.passenger_pool.room_canceled':
      default:
        AppRouter.router.go(AppRoutes.homePath);
        break;
    }
  }

  static String _extractType(Map<String, dynamic> data) {
    if (data.containsKey('type') && data['type'] != null) {
      return data['type'].toString();
    }
    if (data.containsKey('event') && data['event'] != null) {
      return data['event'].toString();
    }
    return '';
  }

  static Map<String, dynamic> _extractMetadata(Map<String, dynamic> data) {
    if (data.containsKey('metadata')) {
      final rawMeta = data['metadata'];
      if (rawMeta is Map<String, dynamic>) {
        return rawMeta;
      }
      if (rawMeta is String && rawMeta.trim().isNotEmpty) {
        try {
          final decoded = jsonDecode(rawMeta);
          if (decoded is Map<String, dynamic>) return decoded;
        } catch (_) {}
      }
    }
    return data;
  }

  static int? _extractInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }
}
