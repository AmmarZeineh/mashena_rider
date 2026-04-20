import 'ride_estimate.dart';

class RideEstimateResponse {
  const RideEstimateResponse({
    required this.rideRequestId,
    required this.distanceKm,
    required this.durationMin,
    required this.stopsCount,
    required this.estimates,
  });

  final int rideRequestId;
  final double distanceKm;
  final double durationMin;
  final int stopsCount;
  final List<RideEstimate> estimates;
}
