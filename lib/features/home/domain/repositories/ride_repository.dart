import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/features/home/domain/entities/matched_trip.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_estimate_response.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_submission_response.dart';
import 'package:mashena_rider/features/home/domain/entities/trip_completed.dart';
import 'package:mashena_rider/features/home/domain/entities/trip_cancelled.dart';
import 'package:mashena_rider/features/home/data/models/driver_arrived_payload.dart';
import '../entities/ride_request.dart';

abstract interface class RideRepository {
  Future<Either<String, RideEstimateResponse>> createRideRequest(
    RideRequest request,
  );

  Future<Either<String, RideSubmissionResponse>> submitRideRequest({
    required RideRequest request,
    required int vehicleTypeId,
  });

  Future<Either<String, MatchedTrip>> getMatchedTripDetails(int rideRequestId);


  /// Stream emitting the matched ride request IDs
  Stream<int> get rideMatchedStream;

  /// Stream emitting live driver coordinates
  Stream<MapLatLng> get driverLocationStream;

  /// Stream emitting when the driver has arrived
  Stream<DriverArrivedPayload> get driverArrivedStream;

  /// Stream emitting when the driver has started the trip
  Stream<int> get driverStartedStream;

  /// Stream emitting when the trip is completed
  Stream<TripCompleted> get tripCompletedStream;

  /// Stream emitting when the trip is cancelled
  Stream<TripCancelled> get tripCancelledStream;

  /// Connects the underlying socket to the server.
  /// Should be called early (on screen init) so the rider is registered
  /// in the gateway before submitting a ride request.
  Future<void> connectSocket();

  /// Starts listening to real-time updates for the ride
  void listenToRide(int rideRequestId);

  /// Stops listening to real-time updates for the ride
  void stopListeningToRide(int rideRequestId);

  /// Cancels the ride request or matched trip
  Future<Either<String, void>> cancelRide(int rideRequestId);
}
