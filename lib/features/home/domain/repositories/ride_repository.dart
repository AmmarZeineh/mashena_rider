import 'package:dartz/dartz.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_estimate_response.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_submission_response.dart';
import '../entities/ride_request.dart';

abstract interface class RideRepository {
  Future<Either<String, RideEstimateResponse>> createRideRequest(
    RideRequest request,
  );

  Future<Either<String, RideSubmissionResponse>> submitRideRequest({
    required RideRequest request,
    required int vehicleTypeId,
  });
}
