class TripCompleted {
  final int tripId;
  final String? completedAt;
  final num? distanceKm;
  final num? durationSec;

  TripCompleted({
    required this.tripId,
    this.completedAt,
    this.distanceKm,
    this.durationSec,
  });
}
