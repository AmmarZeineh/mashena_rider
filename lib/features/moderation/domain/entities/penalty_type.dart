/// Type of disciplinary penalty imposed on a user.
enum PenaltyType {
  warning,
  temporarySuspension,
  permanentBan,
  featureRestriction,
  accountRestriction,
  unknown;

  static PenaltyType fromString(String? value) {
    switch (value?.toUpperCase()) {
      case 'WARNING':
        return PenaltyType.warning;
      case 'TEMPORARY_SUSPENSION':
        return PenaltyType.temporarySuspension;
      case 'PERMANENT_BAN':
        return PenaltyType.permanentBan;
      case 'FEATURE_RESTRICTION':
        return PenaltyType.featureRestriction;
      case 'ACCOUNT_RESTRICTION':
        return PenaltyType.accountRestriction;
      default:
        return PenaltyType.unknown;
    }
  }

  String toBackendString() {
    switch (this) {
      case PenaltyType.warning:
        return 'WARNING';
      case PenaltyType.temporarySuspension:
        return 'TEMPORARY_SUSPENSION';
      case PenaltyType.permanentBan:
        return 'PERMANENT_BAN';
      case PenaltyType.featureRestriction:
        return 'FEATURE_RESTRICTION';
      case PenaltyType.accountRestriction:
        return 'ACCOUNT_RESTRICTION';
      case PenaltyType.unknown:
        return 'UNKNOWN';
    }
  }
}
