import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'ride_estimate.dart';

class RideEstimateResponse {
  const RideEstimateResponse({
    required this.rideRequestId,
    required this.distanceKm,
    required this.durationMin,
    required this.stopsCount,
    required this.estimates,
    this.polyline,
    this.stops = const [],
  });

  final int rideRequestId;
  final double distanceKm;
  final double durationMin;
  final int stopsCount;
  final List<RideEstimate> estimates;
  final String? polyline;
  final List<MapLatLng> stops;
}
