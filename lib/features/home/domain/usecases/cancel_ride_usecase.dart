import 'package:dartz/dartz.dart';
import '../repositories/ride_repository.dart';

class CancelRideUsecase {
  final RideRepository _repository;

  CancelRideUsecase(this._repository);

  Future<Either<String, void>> call(int rideRequestId) {
    return _repository.cancelRide(rideRequestId);
  }
}
