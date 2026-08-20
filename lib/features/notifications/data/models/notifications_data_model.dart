import 'package:mashena_rider/features/notifications/data/models/notification_item_model.dart';
import 'package:mashena_rider/features/notifications/domain/entities/notifications_data.dart';

class NotificationsDataModel {
  final int count;
  final int unreadCount;
  final List<NotificationItemModel> data;

  const NotificationsDataModel({
    required this.count,
    required this.unreadCount,
    required this.data,
  });

  factory NotificationsDataModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'] as List? ?? [];
    return NotificationsDataModel(
      count: _toInt(json['count']) ?? 0,
      unreadCount: _toInt(json['unreadCount']) ?? 0,
      data: rawList
          .map((e) => NotificationItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  NotificationsData toEntity() {
    return NotificationsData(
      count: count,
      unreadCount: unreadCount,
      items: data.map((e) => e.toEntity()).toList(),
    );
  }

  static int? _toInt(dynamic val) {
    if (val == null) return null;
    if (val is int) return val;
    if (val is num) return val.toInt();
    return int.tryParse(val.toString());
  }
}
