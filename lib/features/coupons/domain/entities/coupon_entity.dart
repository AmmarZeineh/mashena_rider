class CouponEntity {
  final int id;
  final String code;
  final String name;
  final String? description;
  final String discountType; // "PERCENTAGE" or "FIXED"
  final double discountValue;
  final double? maxDiscount;
  final int? activationDurationDays;
  final int? allowedUsages;
  final int? globalUsageLimit;
  final int? usedCount;
  final DateTime? startsAt;
  final DateTime? expiresAt;
  final bool isActive;

  const CouponEntity({
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

  bool get isPercentage => discountType.toUpperCase() == 'PERCENTAGE';

  String formattedDiscount([String currency = 'SYP']) {
    if (isPercentage) {
      return '${discountValue.toStringAsFixed(discountValue % 1 == 0 ? 0 : 1)}%';
    }
    return '${discountValue.toStringAsFixed(discountValue % 1 == 0 ? 0 : 1)} $currency';
  }
}
