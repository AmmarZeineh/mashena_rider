import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/features/home/domain/entities/driver_arrived.dart';
import 'package:mashena_rider/features/home/domain/entities/matched_trip.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_estimate_response.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_submission_response.dart';
import 'package:mashena_rider/features/home/domain/entities/trip_completed.dart';
import 'package:mashena_rider/features/home/domain/entities/trip_cancelled.dart';
import 'package:mashena_rider/features/home/domain/entities/trip_share.dart';
import '../entities/ride_request.dart';

abstract interface class RideRepository {
  Future<Either<Failure, RideEstimateResponse>> createRideRequest(
    RideRequest request,
  );

  Future<Either<Failure, RideSubmissionResponse>> submitRideRequest({
    required RideRequest request,
    required int vehicleTypeId,
  });

  Future<Either<Failure, MatchedTrip>> getMatchedTripDetails(int rideRequestId);

  /// Stream emitting the matched ride request IDs
  Stream<int> get rideMatchedStream;

  /// Stream emitting live driver coordinates
  Stream<MapLatLng> get driverLocationStream;

  /// Stream emitting when the driver has arrived
  Stream<DriverArrived> get driverArrivedStream;

  /// Stream emitting when the driver has started the trip
  Stream<int> get driverStartedStream;

  /// Stream emitting when the trip is completed
  Stream<TripCompleted> get tripCompletedStream;

  /// Stream emitting when the trip is cancelled
  Stream<TripCancelled> get tripCancelledStream;

  /// Stream emitting when the ride request expires
  Stream<int> get rideExpiredStream;

  /// Connects the underlying socket to the server.
  /// Should be called early (on screen init) so the rider is registered
  /// in the gateway before submitting a ride request.
  Future<void> connectSocket();

  /// Starts listening to real-time updates for the ride
  void listenToRide(int rideRequestId);

  /// Stops listening to real-time updates for the ride
  void stopListeningToRide(int rideRequestId);

  /// Cancels the ride request or matched trip
  Future<Either<Failure, void>> cancelRide(int rideRequestId);

  /// Creates or retrieves a public trip share URL for the ride request
  Future<Either<Failure, TripShare>> shareTrip(int rideRequestId);

  /// Revokes public trip sharing for the ride request
  Future<Either<Failure, bool>> revokeShareTrip(int rideRequestId);
}
