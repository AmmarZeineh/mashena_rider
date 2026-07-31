import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import '../repositories/ride_repository.dart';

class CancelRideUsecase {
  final RideRepository _repository;

  CancelRideUsecase(this._repository);

  Future<Either<Failure, void>> call(int rideRequestId) {
    return _repository.cancelRide(rideRequestId);
  }
}
