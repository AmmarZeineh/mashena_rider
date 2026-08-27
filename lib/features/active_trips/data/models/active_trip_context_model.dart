import 'package:mashena_rider/core/network/json_readers.dart';
import '../../domain/entities/active_trip_context.dart';

class ActiveTripContextModel {
  final String type;
  final String trackingRole;
  final String status;
  final int? tripId;
  final int? rideRequestId;
  final int? sharedRideId;
  final int? sharedRidePassengerId;
  final bool accountHolderOnBoard;
  final int activeSeats;

  const ActiveTripContextModel({
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

  factory ActiveTripContextModel.fromJson(Map<String, dynamic> json) {
    return ActiveTripContextModel(
      type: readStringOrEmpty(json['type']),
      trackingRole: readStringOrEmpty(json['trackingRole']),
      status: readStringOrEmpty(json['status']),
      tripId: json['tripId'] != null ? readInt(json['tripId']) : null,
      rideRequestId: json['rideRequestId'] != null
          ? readInt(json['rideRequestId'])
          : null,
      sharedRideId: json['sharedRideId'] != null
          ? readInt(json['sharedRideId'])
          : null,
      sharedRidePassengerId: json['sharedRidePassengerId'] != null
          ? readInt(json['sharedRidePassengerId'])
          : null,
      accountHolderOnBoard: readBool(json['accountHolderOnBoard']),
      activeSeats: json['activeSeats'] != null
          ? readInt(json['activeSeats'])
          : 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'trackingRole': trackingRole,
      'status': status,
      if (tripId != null) 'tripId': tripId,
      if (rideRequestId != null) 'rideRequestId': rideRequestId,
      if (sharedRideId != null) 'sharedRideId': sharedRideId,
      if (sharedRidePassengerId != null)
        'sharedRidePassengerId': sharedRidePassengerId,
      'accountHolderOnBoard': accountHolderOnBoard,
      'activeSeats': activeSeats,
    };
  }

  ActiveTripContext toEntity() {
    return ActiveTripContext(
      type: ActiveTripType.fromString(type),
      trackingRole: ActiveTrackingRole.fromString(trackingRole),
      status: status,
      tripId: tripId,
      rideRequestId: rideRequestId,
      sharedRideId: sharedRideId,
      sharedRidePassengerId: sharedRidePassengerId,
      accountHolderOnBoard: accountHolderOnBoard,
      activeSeats: activeSeats,
    );
  }
}
