import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import '../entities/shared_ride_room_details_entity.dart';
import '../repositories/shared_trip_repository.dart';

/// UseCase to leave an open or ready Shared Ride room.
class LeaveSharedRideUsecase {
  final SharedTripRepository repository;

  const LeaveSharedRideUsecase(this.repository);

  Future<Either<Failure, SharedRideRoomDetailsEntity>> call(int roomId) {
    return repository.leaveSharedRide(roomId);
  }
}
