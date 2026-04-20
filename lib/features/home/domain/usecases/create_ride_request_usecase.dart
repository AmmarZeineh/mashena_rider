import 'package:dartz/dartz.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_estimate_response.dart';
import '../entities/ride_request.dart';
import '../repositories/ride_repository.dart';

class CreateRideRequestUsecase {
  final RideRepository _repository;

  CreateRideRequestUsecase(this._repository);

  Future<Either<String, RideEstimateResponse>> call(RideRequest request) {
    return _repository.createRideRequest(request);
  }
}
