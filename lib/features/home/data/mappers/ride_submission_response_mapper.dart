import '../../domain/entities/ride_submission_response.dart';
import '../models/ride_submission_response_model.dart';

extension RideSubmissionResponseModelMapper on RideSubmissionResponseModel {
  RideSubmissionResponse toEntity() {
    return RideSubmissionResponse(
      rideRequestId: rideRequestId,
      status: status,
      distanceKm: distanceKm,
      durationMin: durationMin,
      isNight: isNight,
      estimatedFare: estimatedFare,
      currency: currency,
    );
  }
}
