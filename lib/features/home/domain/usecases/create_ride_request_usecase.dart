import 'package:dartz/dartz.dart';
import '../entities/ride_request.dart';
import '../repositories/ride_repository.dart';

class CreateRideRequestUsecase {
  final RideRepository _repository;

  CreateRideRequestUsecase(this._repository);

  Future<Either<String, dynamic>> call(RideRequest request) {
    return _repository.createRideRequest(request);
  }
}
