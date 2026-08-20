import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import '../../data/models/shared_ride_socket_events.dart';
import '../entities/join_shared_ride_params.dart';
import '../entities/search_shared_ride_params.dart';
import '../entities/shared_ride_passenger_entity.dart';
import '../entities/shared_ride_room_details_entity.dart';
import '../entities/shared_ride_room_entity.dart';

/// Contract for Shared Trip operations.
abstract interface class SharedTripRepository {
  /// Searches for open Shared Ride rooms matching pickup and dropoff points.
  Future<Either<Failure, List<SharedRideRoomEntity>>> searchSharedRides(
    SearchSharedRideParams params,
  );

  /// Retrieves full details of a specific Shared Ride room by ID.
  Future<Either<Failure, SharedRideRoomDetailsEntity>> getSharedRideDetails(
    int id,
  );

  /// Allows a passenger to join an open Shared Ride room.
  Future<Either<Failure, SharedRidePassengerEntity>> joinSharedRide(
    JoinSharedRideParams params,
  );

  /// Allows a passenger to voluntarily leave an open or ready Shared Ride room.
  Future<Either<Failure, SharedRideRoomDetailsEntity>> leaveSharedRide(
    int roomId,
  );

  /// Socket Streams
  Stream<SharedRideDriverLocationPayload> get driverLocationStream;
  Stream<SharedRidePassengerJoinedPayload> get passengerJoinedStream;
  Stream<SharedRidePassengerLeftPayload> get passengerLeftStream;
  Stream<SharedRidePassengerRemovedPayload> get passengerRemovedStream;
  Stream<SharedRideRemovedPayload> get riderRemovedStream;
  Stream<SharedRideRoomReadyPayload> get roomReadyStream;
  Stream<SharedRideTripStartedPayload> get tripStartedStream;
  Stream<SharedRidePassengerOnBoardPayload> get passengerOnBoardStream;
  Stream<SharedRidePassengerDroppedPayload> get passengerDroppedStream;
  Stream<SharedRideCompletedPayload> get tripCompletedStream;
  Stream<SharedRideCancelledPayload> get tripCancelledStream;
  Stream<SharedRidePresencePayload> get presenceStream;

  void listenToRoom(int sharedRideId);
  void stopListeningToRoom(int sharedRideId);
}
