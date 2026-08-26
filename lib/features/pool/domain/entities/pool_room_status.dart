enum PoolRoomStatus {
  open,
  readyForDriver,
  matched,
  canceled,
  expired,
  unknown;

  static PoolRoomStatus fromString(String? value) {
    if (value == null) return PoolRoomStatus.unknown;
    switch (value.toUpperCase()) {
      case 'OPEN':
        return PoolRoomStatus.open;
      case 'READY_FOR_DRIVER':
        return PoolRoomStatus.readyForDriver;
      case 'MATCHED':
        return PoolRoomStatus.matched;
      case 'CANCELED':
      case 'CANCELLED':
        return PoolRoomStatus.canceled;
      case 'EXPIRED':
        return PoolRoomStatus.expired;
      default:
        return PoolRoomStatus.unknown;
    }
  }

  String toBackendValue() {
    switch (this) {
      case PoolRoomStatus.open:
        return 'OPEN';
      case PoolRoomStatus.readyForDriver:
        return 'READY_FOR_DRIVER';
      case PoolRoomStatus.matched:
        return 'MATCHED';
      case PoolRoomStatus.canceled:
        return 'CANCELED';
      case PoolRoomStatus.expired:
        return 'EXPIRED';
      case PoolRoomStatus.unknown:
        return 'UNKNOWN';
    }
  }

  bool get isOpen => this == PoolRoomStatus.open;
  bool get isReadyForDriver => this == PoolRoomStatus.readyForDriver;
  bool get isMatched => this == PoolRoomStatus.matched;
  bool get isCanceled => this == PoolRoomStatus.canceled;
  bool get isExpired => this == PoolRoomStatus.expired;
}
