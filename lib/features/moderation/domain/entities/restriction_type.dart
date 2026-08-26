/// Specific feature restriction applied to a user.
enum RestrictionType {
  requestRide,
  joinSharedRide,
  joinPassengerPool,
  walletTransfer,
  payment,
  fullAccount,
  unknown;

  static RestrictionType fromString(String? value) {
    switch (value?.toUpperCase().trim()) {
      case 'REQUEST_RIDE':
      case 'RIDE_REQUEST':
        return RestrictionType.requestRide;
      case 'JOIN_SHARED_RIDE':
      case 'SHARED_RIDE':
        return RestrictionType.joinSharedRide;
      case 'JOIN_PASSENGER_POOL':
      case 'PASSENGER_POOL':
        return RestrictionType.joinPassengerPool;
      case 'WALLET_TRANSFER':
      case 'WALLET':
        return RestrictionType.walletTransfer;
      case 'PAYMENT':
      case 'PAYMENTS':
        return RestrictionType.payment;
      case 'FULL_ACCOUNT':
      case 'ACCOUNT':
      case 'ACCOUNT_RESTRICTION':
        return RestrictionType.fullAccount;
      default:
        return RestrictionType.unknown;
    }
  }

  String toBackendString() {
    switch (this) {
      case RestrictionType.requestRide:
        return 'REQUEST_RIDE';
      case RestrictionType.joinSharedRide:
        return 'JOIN_SHARED_RIDE';
      case RestrictionType.joinPassengerPool:
        return 'JOIN_PASSENGER_POOL';
      case RestrictionType.walletTransfer:
        return 'WALLET_TRANSFER';
      case RestrictionType.payment:
        return 'PAYMENT';
      case RestrictionType.fullAccount:
        return 'FULL_ACCOUNT';
      case RestrictionType.unknown:
        return 'UNKNOWN';
    }
  }
}
