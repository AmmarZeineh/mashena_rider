// Enums representing states, roles, and types in Shared Rides.

enum SharedRideStatus {
  open('OPEN'),
  ready('READY'),
  inProgress('IN_PROGRESS'),
  completed('COMPLETED'),
  canceled('CANCELED');

  final String value;
  const SharedRideStatus(this.value);

  static SharedRideStatus fromString(String? val) {
    if (val == null) return SharedRideStatus.open;
    return SharedRideStatus.values.firstWhere(
      (e) => e.value.toUpperCase() == val.toUpperCase(),
      orElse: () => SharedRideStatus.open,
    );
  }
}

enum SharedRidePassengerStatus {
  joined('JOINED'),
  onBoard('ON_BOARD'),
  droppedOff('DROPPED_OFF'),
  left('LEFT'),
  removed('REMOVED'),
  canceled('CANCELED');

  final String value;
  const SharedRidePassengerStatus(this.value);

  static SharedRidePassengerStatus fromString(String? val) {
    if (val == null) return SharedRidePassengerStatus.joined;
    return SharedRidePassengerStatus.values.firstWhere(
      (e) => e.value.toUpperCase() == val.toUpperCase(),
      orElse: () => SharedRidePassengerStatus.joined,
    );
  }
}

enum SharedRidePaymentStatus {
  pending('PENDING'),
  processing('PROCESSING'),
  paid('PAID'),
  failed('FAILED'),
  refunded('REFUNDED');

  final String value;
  const SharedRidePaymentStatus(this.value);

  static SharedRidePaymentStatus fromString(String? val) {
    if (val == null) return SharedRidePaymentStatus.pending;
    return SharedRidePaymentStatus.values.firstWhere(
      (e) => e.value.toUpperCase() == val.toUpperCase(),
      orElse: () => SharedRidePaymentStatus.pending,
    );
  }
}

enum SharedRideEndedBy {
  driver('DRIVER'),
  admin('ADMIN'),
  system('SYSTEM');

  final String value;
  const SharedRideEndedBy(this.value);

  static SharedRideEndedBy? fromString(String? val) {
    if (val == null) return null;
    return SharedRideEndedBy.values.firstWhere(
      (e) => e.value.toUpperCase() == val.toUpperCase(),
      orElse: () => SharedRideEndedBy.system,
    );
  }
}

enum SharedRideEndType {
  preStartCancellation('PRE_START_CANCELLATION'),
  completion('COMPLETION');

  final String value;
  const SharedRideEndType(this.value);

  static SharedRideEndType? fromString(String? val) {
    if (val == null) return null;
    return SharedRideEndType.values.firstWhere(
      (e) => e.value.toUpperCase() == val.toUpperCase(),
      orElse: () => SharedRideEndType.completion,
    );
  }
}
