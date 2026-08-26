import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/core/network/json_readers.dart';
import 'shared_ride_details_response_model.dart';
import 'shared_ride_passenger_model.dart';

/// 1. Driver location event payload
class SharedRideDriverLocationPayload {
  final int sharedRideId;
  final double lat;
  final double lng;
  final DateTime timestamp;

  const SharedRideDriverLocationPayload({
    required this.sharedRideId,
    required this.lat,
    required this.lng,
    required this.timestamp,
  });

  MapLatLng get position => MapLatLng(latitude: lat, longitude: lng);

  factory SharedRideDriverLocationPayload.fromJson(Map<String, dynamic> json) {
    return SharedRideDriverLocationPayload(
      sharedRideId: readInt(json['sharedRideId']),
      lat: readDouble(json['lat']),
      lng: readDouble(json['lng']),
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

/// 2. Passenger joined room event payload
class SharedRidePassengerJoinedPayload {
  final int sharedRideId;
  final int userId;
  final DateTime timestamp;
  final SharedRidePassengerModel passenger;

  const SharedRidePassengerJoinedPayload({
    required this.sharedRideId,
    required this.userId,
    required this.timestamp,
    required this.passenger,
  });

  factory SharedRidePassengerJoinedPayload.fromJson(Map<String, dynamic> json) {
    return SharedRidePassengerJoinedPayload(
      sharedRideId: readInt(json['sharedRideId']),
      userId: readInt(json['userId']),
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      passenger: json['passenger'] is Map<String, dynamic>
          ? SharedRidePassengerModel.fromJson(
              json['passenger'] as Map<String, dynamic>,
            )
          : SharedRidePassengerModel.fromJson(json),
    );
  }
}

/// 3. Passenger left room event payload
class SharedRidePassengerLeftPayload {
  final int sharedRideId;
  final int userId;
  final DateTime timestamp;
  final SharedRideDetailsResponseModel? ride;

  const SharedRidePassengerLeftPayload({
    required this.sharedRideId,
    required this.userId,
    required this.timestamp,
    this.ride,
  });

  factory SharedRidePassengerLeftPayload.fromJson(Map<String, dynamic> json) {
    return SharedRidePassengerLeftPayload(
      sharedRideId: readInt(json['sharedRideId']),
      userId: readInt(json['userId']),
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      ride: json['ride'] is Map<String, dynamic>
          ? SharedRideDetailsResponseModel.fromJson(
              json['ride'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

/// 4. Passenger removed by driver (broadcast to room)
class SharedRidePassengerRemovedPayload {
  final int sharedRideId;
  final int userId;
  final String? reason;
  final DateTime timestamp;
  final SharedRideDetailsResponseModel? ride;

  const SharedRidePassengerRemovedPayload({
    required this.sharedRideId,
    required this.userId,
    this.reason,
    required this.timestamp,
    this.ride,
  });

  factory SharedRidePassengerRemovedPayload.fromJson(
    Map<String, dynamic> json,
  ) {
    return SharedRidePassengerRemovedPayload(
      sharedRideId: readInt(json['sharedRideId']),
      userId: readInt(json['userId']),
      reason: json['reason'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      ride: json['ride'] is Map<String, dynamic>
          ? SharedRideDetailsResponseModel.fromJson(
              json['ride'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

/// 5. Passenger removed (sent privately to the removed rider)
class SharedRideRemovedPayload {
  final int sharedRideId;
  final int userId;
  final String? reason;
  final DateTime timestamp;

  const SharedRideRemovedPayload({
    required this.sharedRideId,
    required this.userId,
    this.reason,
    required this.timestamp,
  });

  factory SharedRideRemovedPayload.fromJson(Map<String, dynamic> json) {
    return SharedRideRemovedPayload(
      sharedRideId: readInt(json['sharedRideId']),
      userId: readInt(json['userId']),
      reason: json['reason'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

/// 6. Room marked as READY
class SharedRideRoomReadyPayload {
  final int sharedRideId;
  final String status;
  final DateTime timestamp;
  final SharedRideDetailsResponseModel? ride;

  const SharedRideRoomReadyPayload({
    required this.sharedRideId,
    required this.status,
    required this.timestamp,
    this.ride,
  });

  factory SharedRideRoomReadyPayload.fromJson(Map<String, dynamic> json) {
    return SharedRideRoomReadyPayload(
      sharedRideId: readInt(json['sharedRideId']),
      status: json['status'] as String? ?? 'READY',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      ride: json['ride'] is Map<String, dynamic>
          ? SharedRideDetailsResponseModel.fromJson(
              json['ride'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

/// 7. Trip started (IN_PROGRESS)
class SharedRideTripStartedPayload {
  final int sharedRideId;
  final String status;
  final DateTime timestamp;
  final SharedRideDetailsResponseModel? ride;

  const SharedRideTripStartedPayload({
    required this.sharedRideId,
    required this.status,
    required this.timestamp,
    this.ride,
  });

  factory SharedRideTripStartedPayload.fromJson(Map<String, dynamic> json) {
    return SharedRideTripStartedPayload(
      sharedRideId: readInt(json['sharedRideId']),
      status: json['status'] as String? ?? 'IN_PROGRESS',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      ride: json['ride'] is Map<String, dynamic>
          ? SharedRideDetailsResponseModel.fromJson(
              json['ride'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

/// 8. Passenger on board
class SharedRidePassengerOnBoardPayload {
  final int sharedRideId;
  final int userId;
  final String status;
  final int passengerId;
  final int riderProfileId;
  final DateTime? onBoardAt;
  final DateTime timestamp;

  const SharedRidePassengerOnBoardPayload({
    required this.sharedRideId,
    required this.userId,
    required this.status,
    required this.passengerId,
    required this.riderProfileId,
    this.onBoardAt,
    required this.timestamp,
  });

  factory SharedRidePassengerOnBoardPayload.fromJson(
    Map<String, dynamic> json,
  ) {
    Map<String, dynamic>? pass;
    if (json['passenger'] is Map<String, dynamic>) {
      pass = json['passenger'] as Map<String, dynamic>;
    }

    return SharedRidePassengerOnBoardPayload(
      sharedRideId: readInt(json['sharedRideId']),
      userId: readInt(json['userId']),
      status: json['status'] as String? ?? 'ON_BOARD',
      passengerId: pass != null
          ? readInt(pass['id'])
          : readInt(json['passengerId']),
      riderProfileId: pass != null
          ? readInt(pass['riderProfileId'])
          : readInt(json['riderProfileId']),
      onBoardAt: (pass != null && pass['onBoardAt'] != null)
          ? DateTime.tryParse(pass['onBoardAt'].toString())
          : (json['onBoardAt'] != null
                ? DateTime.tryParse(json['onBoardAt'].toString())
                : null),
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

/// 9. Passenger dropped off
class SharedRidePassengerDroppedPayload {
  final int sharedRideId;
  final int userId;
  final String status;
  final int passengerId;
  final int riderProfileId;
  final DateTime? droppedOffAt;
  final double? finalFare;
  final double? finalDistanceKm;
  final int? finalDurationSec;
  final DateTime timestamp;
  final SharedRidePassengerModel? passenger;
  final bool accountHolderOnBoard;
  final DateTime? accountHolderDroppedOffAt;
  final int? activeSeats;
  final int? seatsNeeded;
  final double? totalPaidFare;
  final String? passengerStatus;

  const SharedRidePassengerDroppedPayload({
    required this.sharedRideId,
    required this.userId,
    required this.status,
    required this.passengerId,
    required this.riderProfileId,
    this.droppedOffAt,
    this.finalFare,
    this.finalDistanceKm,
    this.finalDurationSec,
    required this.timestamp,
    this.passenger,
    this.accountHolderOnBoard = false,
    this.accountHolderDroppedOffAt,
    this.activeSeats,
    this.seatsNeeded,
    this.totalPaidFare,
    this.passengerStatus,
  });

  factory SharedRidePassengerDroppedPayload.fromJson(
    Map<String, dynamic> json,
  ) {
    SharedRidePassengerModel? passModel;
    Map<String, dynamic>? pass;
    if (json['passenger'] is Map<String, dynamic>) {
      pass = json['passenger'] as Map<String, dynamic>;
      try {
        passModel = SharedRidePassengerModel.fromJson(pass);
      } catch (_) {}
    }

    final bool accountHolderOnBoard =
        pass != null && pass['accountHolderOnBoard'] != null
        ? readBool(pass['accountHolderOnBoard'])
        : (json['accountHolderOnBoard'] != null
              ? readBool(json['accountHolderOnBoard'])
              : false);

    final String passengerStatus = pass != null && pass['status'] != null
        ? pass['status'].toString()
        : (json['status'] as String? ?? 'DROPPED_OFF');

    final double? totalPaidFare = pass != null && pass['totalPaidFare'] != null
        ? readDouble(pass['totalPaidFare'])
        : (json['totalPaidFare'] != null
              ? readDouble(json['totalPaidFare'])
              : null);

    final int? activeSeats = pass != null && pass['activeSeats'] != null
        ? readInt(pass['activeSeats'])
        : (json['activeSeats'] != null ? readInt(json['activeSeats']) : null);

    final int? seatsNeeded = pass != null && pass['seatsNeeded'] != null
        ? readInt(pass['seatsNeeded'])
        : (json['seatsNeeded'] != null ? readInt(json['seatsNeeded']) : null);

    final DateTime? accountHolderDroppedOffAt =
        (pass != null && pass['accountHolderDroppedOffAt'] != null)
        ? DateTime.tryParse(pass['accountHolderDroppedOffAt'].toString())
        : (json['accountHolderDroppedOffAt'] != null
              ? DateTime.tryParse(json['accountHolderDroppedOffAt'].toString())
              : null);

    return SharedRidePassengerDroppedPayload(
      sharedRideId: readInt(json['sharedRideId']),
      userId: readInt(json['userId']),
      status: json['status'] as String? ?? 'DROPPED_OFF',
      passengerId: pass != null
          ? readInt(pass['id'])
          : readInt(json['passengerId']),
      riderProfileId: pass != null
          ? readInt(pass['riderProfileId'])
          : readInt(json['riderProfileId']),
      droppedOffAt: (pass != null && pass['droppedOffAt'] != null)
          ? DateTime.tryParse(pass['droppedOffAt'].toString())
          : (json['droppedOffAt'] != null
                ? DateTime.tryParse(json['droppedOffAt'].toString())
                : null),
      finalFare: pass != null && pass['finalFare'] != null
          ? readDouble(pass['finalFare'])
          : (json['finalFare'] != null ? readDouble(json['finalFare']) : null),
      finalDistanceKm: pass != null && pass['finalDistanceKm'] != null
          ? readDouble(pass['finalDistanceKm'])
          : (json['finalDistanceKm'] != null
                ? readDouble(json['finalDistanceKm'])
                : null),
      finalDurationSec: pass != null && pass['finalDurationSec'] != null
          ? readInt(pass['finalDurationSec'])
          : (json['finalDurationSec'] != null
                ? readInt(json['finalDurationSec'])
                : null),
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      passenger: passModel,
      accountHolderOnBoard: accountHolderOnBoard,
      accountHolderDroppedOffAt: accountHolderDroppedOffAt,
      activeSeats: activeSeats,
      seatsNeeded: seatsNeeded,
      totalPaidFare: totalPaidFare,
      passengerStatus: passengerStatus,
    );
  }
}

/// 10. Trip completed
class SharedRideCompletedPayload {
  final int sharedRideId;
  final String status;
  final DateTime timestamp;
  final SharedRideDetailsResponseModel? ride;

  const SharedRideCompletedPayload({
    required this.sharedRideId,
    required this.status,
    required this.timestamp,
    this.ride,
  });

  factory SharedRideCompletedPayload.fromJson(Map<String, dynamic> json) {
    return SharedRideCompletedPayload(
      sharedRideId: readInt(json['sharedRideId']),
      status: json['status'] as String? ?? 'COMPLETED',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      ride: json['ride'] is Map<String, dynamic>
          ? SharedRideDetailsResponseModel.fromJson(
              json['ride'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

/// 11. Trip cancelled
class SharedRideCancelledPayload {
  final int sharedRideId;
  final String status;
  final String? cancellationReason;
  final DateTime timestamp;
  final SharedRideDetailsResponseModel? ride;

  const SharedRideCancelledPayload({
    required this.sharedRideId,
    required this.status,
    this.cancellationReason,
    required this.timestamp,
    this.ride,
  });

  factory SharedRideCancelledPayload.fromJson(Map<String, dynamic> json) {
    return SharedRideCancelledPayload(
      sharedRideId: readInt(json['sharedRideId']),
      status: json['status'] as String? ?? 'CANCELED',
      cancellationReason: json['cancellationReason'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      ride: json['ride'] is Map<String, dynamic>
          ? SharedRideDetailsResponseModel.fromJson(
              json['ride'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

/// 12. Presence payload (driver or passenger online/offline)
class SharedRidePresencePayload {
  final int sharedRideId;
  final int userId;
  final bool isOnline;
  final bool isDriver;
  final DateTime timestamp;

  const SharedRidePresencePayload({
    required this.sharedRideId,
    required this.userId,
    required this.isOnline,
    required this.isDriver,
    required this.timestamp,
  });

  factory SharedRidePresencePayload.fromJson(
    Map<String, dynamic> json, {
    required bool isOnline,
    required bool isDriver,
  }) {
    return SharedRidePresencePayload(
      sharedRideId: readInt(json['sharedRideId']),
      userId: readInt(json['userId']),
      isOnline: isOnline,
      isDriver: isDriver,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
