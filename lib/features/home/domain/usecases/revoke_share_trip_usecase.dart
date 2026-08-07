import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import '../repositories/ride_repository.dart';

class RevokeShareTripUsecase {
  final RideRepository _repository;

  RevokeShareTripUsecase(this._repository);

  Future<Either<Failure, bool>> call(int rideRequestId) {
    return _repository.revokeShareTrip(rideRequestId);
  }
}
