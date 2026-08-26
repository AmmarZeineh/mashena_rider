/// Types of violations that can occur on the platform.
enum ViolationType {
  riderTripCancellation,
  noShow,
  lateCancellation,
  sharedRideMisuse,
  passengerPoolMisuse,
  paymentAbuse,
  walletAbuse,
  abusiveBehavior,
  fraud,
  manualAdminViolation,
  unknown;

  static ViolationType fromString(String? value) {
    switch (value?.toUpperCase()) {
      case 'RIDER_TRIP_CANCELLATION':
        return ViolationType.riderTripCancellation;
      case 'NO_SHOW':
        return ViolationType.noShow;
      case 'LATE_CANCELLATION':
        return ViolationType.lateCancellation;
      case 'SHARED_RIDE_MISUSE':
        return ViolationType.sharedRideMisuse;
      case 'PASSENGER_POOL_MISUSE':
        return ViolationType.passengerPoolMisuse;
      case 'PAYMENT_ABUSE':
        return ViolationType.paymentAbuse;
      case 'WALLET_ABUSE':
        return ViolationType.walletAbuse;
      case 'ABUSIVE_BEHAVIOR':
        return ViolationType.abusiveBehavior;
      case 'FRAUD':
        return ViolationType.fraud;
      case 'MANUAL_ADMIN_VIOLATION':
        return ViolationType.manualAdminViolation;
      default:
        return ViolationType.unknown;
    }
  }
}
