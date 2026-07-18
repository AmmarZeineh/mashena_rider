import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'ride_estimate.dart';
import 'ride_location.dart';

class RideEstimateResponse {
  const RideEstimateResponse({
    this.rideRequestId,
    required this.distanceKm,
    required this.durationMin,
    required this.stopsCount,
    required this.estimates,
    required this.isNight,
    this.pickup,
    this.destination,
    this.polyline,
    this.stops = const [],
    this.routePoints = const [],
  });

  final int? rideRequestId;
  final double distanceKm;
  final double durationMin;
  final int stopsCount;
  final List<RideEstimate> estimates;
  final bool isNight;
  final RideLocation? pickup;
  final RideLocation? destination;
  final String? polyline;
  final List<MapLatLng> stops;

  /// Decoded route coordinates from the backend `routeGeometry.points` field.
  /// When non-empty, these should be used directly for map rendering
  /// instead of decoding a polyline string or fetching from OSRM.
  final List<MapLatLng> routePoints;
}
