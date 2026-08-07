import 'package:mashena_rider/features/coupons/data/models/coupon_model.dart';
import 'package:mashena_rider/features/coupons/domain/entities/user_coupon_entity.dart';

class UserCouponModel {
  final int id;
  final int userId;
  final int couponId;
  final int remainingUsages;
  final String status;
  final DateTime? activatedAt;
  final DateTime? expiresAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final CouponModel coupon;

  const UserCouponModel({
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

  factory UserCouponModel.fromJson(Map<String, dynamic> json) {
    return UserCouponModel(
      id: _toInt(json['id']) ?? 0,
      userId: _toInt(json['userId']) ?? 0,
      couponId: _toInt(json['couponId']) ?? 0,
      remainingUsages: _toInt(json['remainingUsages']) ?? 0,
      status: json['status'] as String? ?? 'ACTIVE',
      activatedAt: json['activatedAt'] != null
          ? DateTime.tryParse(json['activatedAt'].toString())
          : null,
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'].toString())
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      coupon: json['coupon'] != null
          ? CouponModel.fromJson(json['coupon'] as Map<String, dynamic>)
          : const CouponModel(
              id: 0,
              code: '',
              name: '',
              discountType: 'PERCENTAGE',
              discountValue: 0,
              isActive: false,
            ),
    );
  }

  UserCouponEntity toEntity() {
    return UserCouponEntity(
      id: id,
      userId: userId,
      couponId: couponId,
      remainingUsages: remainingUsages,
      status: status,
      activatedAt: activatedAt,
      expiresAt: expiresAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      coupon: coupon.toEntity(),
    );
  }

  static int? _toInt(dynamic val) {
    if (val == null) return null;
    if (val is int) return val;
    if (val is num) return val.toInt();
    return int.tryParse(val.toString());
  }
}
