/// Proximity details relative to rider's requested pickup and dropoff points.
class SharedRideSearchDetailsEntity {
  final double originDistanceKm;
  final double destinationDistanceKm;

  const SharedRideSearchDetailsEntity({
    required this.originDistanceKm,
    required this.destinationDistanceKm,
  });
}
