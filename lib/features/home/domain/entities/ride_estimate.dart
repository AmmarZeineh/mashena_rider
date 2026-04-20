class RideEstimate {
  const RideEstimate({
    required this.vehicleTypeId,
    required this.name,
    required this.currency,
    required this.estimatedFare,
    this.imageUrl,
  });

  final int vehicleTypeId;
  final String name;
  final String? imageUrl;
  final String currency;
  final double estimatedFare;
}
