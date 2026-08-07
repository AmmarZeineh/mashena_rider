import 'package:mashena_rider/features/coupons/data/models/user_coupon_model.dart';
import 'package:mashena_rider/features/coupons/domain/entities/coupon_history_item_entity.dart';

class CouponHistoryItemModel {
  final int id;
  final int userCouponId;
  final int tripId;
  final double discountAmount;
  final double originalFare;
  final double finalFare;
  final DateTime? createdAt;
  final int? rideRequestId;
  final UserCouponModel userCoupon;

  const CouponHistoryItemModel({
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

  factory CouponHistoryItemModel.fromJson(Map<String, dynamic> json) {
    int? rideRequestId;
    if (json['trip'] != null && json['trip'] is Map<String, dynamic>) {
      final tripMap = json['trip'] as Map<String, dynamic>;
      rideRequestId = _toInt(tripMap['rideRequestId']);
    }

    return CouponHistoryItemModel(
      id: _toInt(json['id']) ?? 0,
      userCouponId: _toInt(json['userCouponId']) ?? 0,
      tripId: _toInt(json['tripId']) ?? 0,
      discountAmount: _toDouble(json['discountAmount']),
      originalFare: _toDouble(json['originalFare']),
      finalFare: _toDouble(json['finalFare']),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      rideRequestId: rideRequestId,
      userCoupon: json['userCoupon'] != null
          ? UserCouponModel.fromJson(json['userCoupon'] as Map<String, dynamic>)
          : UserCouponModel.fromJson(const {}),
    );
  }

  CouponHistoryItemEntity toEntity() {
    return CouponHistoryItemEntity(
      id: id,
      userCouponId: userCouponId,
      tripId: tripId,
      discountAmount: discountAmount,
      originalFare: originalFare,
      finalFare: finalFare,
      createdAt: createdAt,
      rideRequestId: rideRequestId,
      userCoupon: userCoupon.toEntity(),
    );
  }

  static double _toDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is num) return val.toDouble();
    return double.tryParse(val.toString()) ?? 0.0;
  }

  static int? _toInt(dynamic val) {
    if (val == null) return null;
    if (val is int) return val;
    if (val is num) return val.toInt();
    return int.tryParse(val.toString());
  }
}
