import 'package:mashena_rider/features/coupons/domain/entities/coupon_entity.dart';

class CouponModel {
  final int id;
  final String code;
  final String name;
  final String? description;
  final String discountType;
  final double discountValue;
  final double? maxDiscount;
  final int? activationDurationDays;
  final int? allowedUsages;
  final int? globalUsageLimit;
  final int? usedCount;
  final DateTime? startsAt;
  final DateTime? expiresAt;
  final bool isActive;

  const CouponModel({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    required this.discountType,
    required this.discountValue,
    this.maxDiscount,
    this.activationDurationDays,
    this.allowedUsages,
    this.globalUsageLimit,
    this.usedCount,
    this.startsAt,
    this.expiresAt,
    required this.isActive,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: _toInt(json['id']) ?? 0,
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      discountType: json['discountType'] as String? ?? 'PERCENTAGE',
      discountValue: _toDouble(json['discountValue']),
      maxDiscount: json['maxDiscount'] != null
          ? _toDouble(json['maxDiscount'])
          : null,
      activationDurationDays: _toInt(json['activationDurationDays']),
      allowedUsages: _toInt(json['allowedUsages']),
      globalUsageLimit: _toInt(json['globalUsageLimit']),
      usedCount: _toInt(json['usedCount']),
      startsAt: json['startsAt'] != null
          ? DateTime.tryParse(json['startsAt'].toString())
          : null,
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'].toString())
          : null,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  CouponEntity toEntity() {
    return CouponEntity(
      id: id,
      code: code,
      name: name,
      description: description,
      discountType: discountType,
      discountValue: discountValue,
      maxDiscount: maxDiscount,
      activationDurationDays: activationDurationDays,
      allowedUsages: allowedUsages,
      globalUsageLimit: globalUsageLimit,
      usedCount: usedCount,
      startsAt: startsAt,
      expiresAt: expiresAt,
      isActive: isActive,
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
