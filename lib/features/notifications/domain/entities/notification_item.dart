import 'package:equatable/equatable.dart';

class NotificationItem extends Equatable {
  final int id;
  final int userId;
  final String title;
  final String body;
  final String type;
  final Map<String, dynamic>? metadata;
  final bool isRead;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const NotificationItem({
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

  bool get isTripNotification => type.startsWith('notification.trip');
  bool get isWalletNotification => type.startsWith('notification.wallet');
  bool get isSharedRideNotification =>
      type.startsWith('notification.shared_ride');
  bool get isDriverApproved => type == 'notification.driver.approved';

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    body,
    type,
    metadata,
    isRead,
    createdAt,
    updatedAt,
  ];
}
