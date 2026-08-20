import 'package:mashena_rider/features/notifications/domain/entities/notification_item.dart';

class NotificationItemModel {
  final int id;
  final int userId;
  final String title;
  final String body;
  final String type;
  final Map<String, dynamic>? metadata;
  final bool isRead;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const NotificationItemModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.metadata,
    required this.isRead,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
    return NotificationItemModel(
      id: _toInt(json['id']) ?? 0,
      userId: _toInt(json['userId']) ?? 0,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      type: json['type'] as String? ?? '',
      metadata: json['metadata'] as Map<String, dynamic>?,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())?.toLocal()
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())?.toLocal()
          : null,
    );
  }

  NotificationItem toEntity() {
    return NotificationItem(
      id: id,
      userId: userId,
      title: title,
      body: body,
      type: type,
      metadata: metadata,
      isRead: isRead,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static int? _toInt(dynamic val) {
    if (val == null) return null;
    if (val is int) return val;
    if (val is num) return val.toInt();
    return int.tryParse(val.toString());
  }
}
