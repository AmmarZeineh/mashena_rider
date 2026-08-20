/// Represents a passenger in a Shared Ride room.
class SharedRidePassengerEntity {
  final int id;
  final int sharedRideId;
  final int riderProfileId;
  final String? riderName;
  final String status;
  final String paymentStatus;
  final int seatsNeeded;
  final int activeSeats;
  final double totalPaidFare;
  final double? finalDistanceKm;
  final int? finalDurationSec;
  final double? finalFare;
  final DateTime joinedAt;
  final DateTime? onBoardAt;
  final DateTime? droppedOffAt;
  final bool accountHolderOnBoard;
  final DateTime? accountHolderDroppedOffAt;
  final DateTime? leftAt;
  final DateTime? canceledAt;
  final DateTime? removedAt;
  final String? removeReason;

  const SharedRidePassengerEntity({
    required this.id,
    required this.sharedRideId,
    required this.riderProfileId,
    this.riderName,
    required this.status,
    required this.paymentStatus,
    required this.seatsNeeded,
    required this.activeSeats,
    required this.totalPaidFare,
    this.finalDistanceKm,
    this.finalDurationSec,
    this.finalFare,
    required this.joinedAt,
    this.onBoardAt,
    this.droppedOffAt,
    this.accountHolderOnBoard = false,
    this.accountHolderDroppedOffAt,
    this.leftAt,
    this.canceledAt,
    this.removedAt,
    this.removeReason,
  });

  bool get isPaid => paymentStatus.toUpperCase() == 'PAID';
  bool get isOnBoard => status.toUpperCase() == 'ON_BOARD';
  bool get isDroppedOff => status.toUpperCase() == 'DROPPED_OFF';
}
