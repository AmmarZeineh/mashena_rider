import 'package:equatable/equatable.dart';
import 'package:mashena_rider/features/notifications/domain/entities/notification_item.dart';

class NotificationsData extends Equatable {
  final int count;
  final int unreadCount;
  final List<NotificationItem> items;

  const NotificationsData({
    required this.count,
    required this.unreadCount,
    required this.items,
  });

  @override
  List<Object?> get props => [count, unreadCount, items];
}
