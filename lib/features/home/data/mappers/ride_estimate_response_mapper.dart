import '../../domain/entities/ride_estimate_response.dart';
import '../models/ride_estimate_response_model.dart';
import 'ride_location_mapper.dart';
import 'ride_estimate_mapper.dart';

extension RideEstimateResponseModelMapper on RideEstimateResponseModel {
  RideEstimateResponse toEntity() {
    return RideEstimateResponse(
      rideRequestId: rideRequestId,
      distanceKm: distanceKm,
      durationMin: durationMin,
      stopsCount: stopsCount,
      isNight: isNight,
      pickup: pickup?.toEntity(),
      destination: destination?.toEntity(),
      estimates: estimates.map((estimate) => estimate.toEntity()).toList(),
      polyline: polyline,
      stops: stops,
      routePoints: routePoints,
    );
  }
}
