import 'applied_coupon.dart';

class RideEstimate {
  const RideEstimate({
    required this.vehicleTypeId,
    required this.name,
    required this.currency,
    required this.estimatedFare,
    this.imageUrl,
    this.originalFare,
    this.discountAmount,
    this.finalFare,
    this.appliedCoupon,
  });

  final int vehicleTypeId;
  final String name;
  final String? imageUrl;
  final String currency;
  final double estimatedFare;
  final double? originalFare;
  final double? discountAmount;
  final double? finalFare;
  final AppliedCoupon? appliedCoupon;

  /// Whether this estimate has an active discount or coupon applied.
  bool get hasDiscount {
    if (discountAmount != null && discountAmount! > 0) return true;
    if (originalFare != null &&
        finalFare != null &&
        originalFare! > finalFare!) {
      return true;
    }
    if (originalFare != null && originalFare! > estimatedFare) {
      return true;
    }
    return false;
  }

  /// The original fare before discount. Falls back to [estimatedFare].
  double get displayOriginalFare {
    if (originalFare != null && originalFare! > 0) return originalFare!;
    return estimatedFare;
  }

  /// The final discounted fare to pay. Falls back to [estimatedFare].
  double get displayFinalFare {
    if (hasDiscount && finalFare != null) return finalFare!;
    if (finalFare != null && finalFare! > 0) return finalFare!;
    return estimatedFare;
  }

  /// The effective discount amount saved.
  double get effectiveDiscountAmount {
    if (discountAmount != null && discountAmount! > 0) return discountAmount!;
    if (displayOriginalFare > displayFinalFare) {
      return displayOriginalFare - displayFinalFare;
    }
    return 0;
  }

  @override
  String toString() {
    return 'RideEstimate(vehicleTypeId: $vehicleTypeId, name: $name, currency: $currency, '
        'estimatedFare: $estimatedFare, originalFare: $originalFare, '
        'discountAmount: $discountAmount, finalFare: $finalFare, '
        'appliedCoupon: ${appliedCoupon?.code})';
  }
}
