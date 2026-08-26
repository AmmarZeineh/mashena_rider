/// Status of a disciplinary penalty.
enum PenaltyStatus {
  active,
  expired,
  revoked,
  cancelled,
  unknown;

  static PenaltyStatus fromString(String? value) {
    switch (value?.toUpperCase()) {
      case 'ACTIVE':
        return PenaltyStatus.active;
      case 'EXPIRED':
        return PenaltyStatus.expired;
      case 'REVOKED':
        return PenaltyStatus.revoked;
      case 'CANCELLED':
        return PenaltyStatus.cancelled;
      default:
        return PenaltyStatus.unknown;
    }
  }

  bool get isActive => this == PenaltyStatus.active;
  bool get isExpired => this == PenaltyStatus.expired;
  bool get isRevoked => this == PenaltyStatus.revoked;
}
