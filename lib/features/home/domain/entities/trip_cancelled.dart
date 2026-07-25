class TripCancelled {
  final int tripId;
  final String? canceledAt;
  final String? cancelledBy;

  TripCancelled({
    required this.tripId,
    this.canceledAt,
    this.cancelledBy,
  });
}
