import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_estimate_response.dart';

/// Result returned when the user confirms pickup and destination.
///
/// This gives Home everything needed to draw a route and show available rides.
final class ConfirmedRideFlowResult {
  const ConfirmedRideFlowResult({
    required this.pickup,
    required this.destination,
    required this.estimateResponse,
  });

  final MapLatLng pickup;
  final MapLatLng destination;
  final RideEstimateResponse estimateResponse;
}
