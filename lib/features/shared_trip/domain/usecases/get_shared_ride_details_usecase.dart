import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import '../entities/shared_ride_room_details_entity.dart';
import '../repositories/shared_trip_repository.dart';

/// UseCase to get full room details of a Shared Ride by ID.
class GetSharedRideDetailsUsecase {
  final SharedTripRepository repository;

  const GetSharedRideDetailsUsecase(this.repository);

  Future<Either<Failure, SharedRideRoomDetailsEntity>> call(int id) {
    return repository.getSharedRideDetails(id);
  }
}
