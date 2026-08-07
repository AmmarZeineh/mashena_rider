import 'package:mashena_rider/features/coupons/domain/entities/coupon_entity.dart';

class UserCouponEntity {
  final int id;
  final int userId;
  final int couponId;
  final int remainingUsages;
  final String status; // "ACTIVE", "USED", "EXPIRED"
  final DateTime? activatedAt;
  final DateTime? expiresAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final CouponEntity coupon;

  const UserCouponEntity({
    required this.id,
    required this.userId,
    required this.couponId,
    required this.remainingUsages,
    required this.status,
    this.activatedAt,
    this.expiresAt,
    this.createdAt,
    this.updatedAt,
    required this.coupon,
  });

  bool get isActive => status.toUpperCase() == 'ACTIVE';
  bool get isUsed => status.toUpperCase() == 'USED';
  bool get isExpired => status.toUpperCase() == 'EXPIRED';
}
