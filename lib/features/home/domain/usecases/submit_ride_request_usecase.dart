import 'package:dartz/dartz.dart';
import '../repositories/ride_repository.dart';

class SubmitRideRequestUsecase {
  final RideRepository _repository;

  SubmitRideRequestUsecase(this._repository);

  Future<Either<String, void>> call({
    required int rideRequestId,
    required int vehicleTypeId,
  }) {
    return _repository.submitRideRequest(
      rideRequestId: rideRequestId,
      vehicleTypeId: vehicleTypeId,
    );
  }
}
