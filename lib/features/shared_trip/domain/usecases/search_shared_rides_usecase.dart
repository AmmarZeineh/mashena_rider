import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import '../entities/search_shared_ride_params.dart';
import '../entities/shared_ride_room_entity.dart';
import '../repositories/shared_trip_repository.dart';

/// UseCase to search for open Shared Ride rooms.
class SearchSharedRidesUsecase {
  final SharedTripRepository repository;

  const SearchSharedRidesUsecase(this.repository);

  Future<Either<Failure, List<SharedRideRoomEntity>>> call(
    SearchSharedRideParams params,
  ) {
    return repository.searchSharedRides(params);
  }
}
