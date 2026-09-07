class AppliedCoupon {
  const AppliedCoupon({
    required this.id,
    required this.code,
    required this.type,
    required this.value,
    this.remainingUsages,
    this.expiresAt,
  });

  final int id;
  final String code;
  final String type;
  final double value;
  final int? remainingUsages;
  final DateTime? expiresAt;
}
