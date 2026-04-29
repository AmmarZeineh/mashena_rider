import 'package:dartz/dartz.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_submission_response.dart';
import '../entities/ride_request.dart';
import '../repositories/ride_repository.dart';

class SubmitRideRequestUsecase {
  final RideRepository _repository;

  SubmitRideRequestUsecase(this._repository);

  Future<Either<String, RideSubmissionResponse>> call({
    required RideRequest request,
    required int vehicleTypeId,
  }) {
    return _repository.submitRideRequest(
      request: request,
      vehicleTypeId: vehicleTypeId,
    );
  }
}
