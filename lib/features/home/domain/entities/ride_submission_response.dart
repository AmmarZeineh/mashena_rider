class RideSubmissionResponse {
  final int rideRequestId;
  final String status;
  final double distanceKm;
  final double durationMin;
  final bool isNight;
  final double estimatedFare;
  final String currency;

  const RideSubmissionResponse({
    required this.rideRequestId,
    required this.status,
    required this.distanceKm,
    required this.durationMin,
    required this.isNight,
    required this.estimatedFare,
    required this.currency,
  });
}
