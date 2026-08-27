import 'package:equatable/equatable.dart';

enum ActiveTripType {
  regularTrip,
  sharedRide,
  unknown;

  static ActiveTripType fromString(String? value) {
    if (value == null) return ActiveTripType.unknown;
    final normalized = value.trim().toUpperCase();
    if (normalized == 'REGULAR_TRIP' || normalized == 'REGULAR') {
      return ActiveTripType.regularTrip;
    }
    if (normalized == 'SHARED_RIDE' || normalized == 'SHARED_TRIP') {
      return ActiveTripType.sharedRide;
    }
    return ActiveTripType.unknown;
  }
}

enum ActiveTrackingRole {
  self,
  companionBooking,
  unknown;

  static ActiveTrackingRole fromString(String? value) {
    if (value == null) return ActiveTrackingRole.unknown;
    final normalized = value.trim().toUpperCase();
    if (normalized == 'SELF') {
      return ActiveTrackingRole.self;
    }
    if (normalized == 'COMPANION_BOOKING' || normalized == 'COMPANION') {
      return ActiveTrackingRole.companionBooking;
    }
    return ActiveTrackingRole.unknown;
  }
}

class ActiveTripContext extends Equatable {
  final ActiveTripType type;
  final ActiveTrackingRole trackingRole;
  final String status;
  final int? tripId;
  final int? rideRequestId;
  final int? sharedRideId;
  final int? sharedRidePassengerId;
  final bool accountHolderOnBoard;
  final int activeSeats;

  const ActiveTripContext({
    required this.type,
    required this.trackingRole,
    required this.status,
    this.tripId,
    this.rideRequestId,
    this.sharedRideId,
    this.sharedRidePassengerId,
    this.accountHolderOnBoard = false,
    this.activeSeats = 1,
  });

  bool get isRegularTrip => type == ActiveTripType.regularTrip;
  bool get isSharedRide => type == ActiveTripType.sharedRide;
  bool get isCompanionBooking =>
      trackingRole == ActiveTrackingRole.companionBooking;
  bool get isSelf => trackingRole == ActiveTrackingRole.self;

  @override
  List<Object?> get props => [
    type,
    trackingRole,
    status,
    tripId,
    rideRequestId,
    sharedRideId,
    sharedRidePassengerId,
    accountHolderOnBoard,
    activeSeats,
  ];
}
