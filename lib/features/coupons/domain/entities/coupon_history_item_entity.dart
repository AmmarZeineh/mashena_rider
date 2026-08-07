import 'package:mashena_rider/features/coupons/domain/entities/user_coupon_entity.dart';

class CouponHistoryItemEntity {
  final int id;
  final int userCouponId;
  final int tripId;
  final double discountAmount;
  final double originalFare;
  final double finalFare;
  final DateTime? createdAt;
  final int? rideRequestId;
  final UserCouponEntity userCoupon;

  const CouponHistoryItemEntity({
    required this.id,
    required this.userCouponId,
    required this.tripId,
    required this.discountAmount,
    required this.originalFare,
    required this.finalFare,
    this.createdAt,
    this.rideRequestId,
    required this.userCoupon,
  });
}
