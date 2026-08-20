import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import '../entities/join_shared_ride_params.dart';
import '../entities/shared_ride_passenger_entity.dart';
import '../repositories/shared_trip_repository.dart';

/// UseCase to join an open Shared Ride room.
class JoinSharedRideUsecase {
  final SharedTripRepository repository;

  const JoinSharedRideUsecase(this.repository);

  Future<Either<Failure, SharedRidePassengerEntity>> call(
    JoinSharedRideParams params,
  ) {
    return repository.joinSharedRide(params);
  }
}
