import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/features/home/domain/entities/place_entity.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_estimate_response.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_request.dart';

/// Result returned when the user confirms pickup and destination.
///
/// This gives Home everything needed to draw a route and show available rides.
final class ConfirmedRideFlowResult {
  const ConfirmedRideFlowResult({
    required this.pickup,
    required this.destination,
    required this.pickupPlace,
    required this.destinationPlaces,
    required this.estimateResponse,
    required this.request,
  });

  final MapLatLng pickup;
  final MapLatLng destination;
  final PlaceEntity pickupPlace;
  final List<PlaceEntity> destinationPlaces;
  final RideEstimateResponse estimateResponse;
  final RideRequest request;
}
