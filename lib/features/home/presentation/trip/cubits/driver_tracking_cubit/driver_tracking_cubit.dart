import 'dart:async';
import 'package:mashena_rider/core/services/logger_service.dart';
import 'dart:math' show pi, sin, cos, atan2;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_marker.dart';
import 'package:mashena_rider/core/services/osrm_route_service.dart';
import 'package:mashena_rider/features/home/domain/repositories/ride_repository.dart';
import 'package:mashena_rider/features/home/presentation/ride_flow/ride_flow_coordinator.dart';
import 'package:mashena_rider/features/home/presentation/shell/cubits/map_state_cubit/map_state_cubit.dart';

part 'driver_tracking_state.dart';

/// Converts real-time driver location events into map overlays
/// (marker + polyline along road) and exposes ETA / distance.
///
/// Writes the visual result to [MapStateCubit] — it never owns the map.
class DriverTrackingCubit extends Cubit<DriverTrackingState> {
  DriverTrackingCubit(
    this._rideRepository,
    this._osrmRouteService,
    this._mapStateCubit,
  ) : super(const DriverTrackingState());

  final RideRepository _rideRepository;
  final OSRMRouteService _osrmRouteService;
  final MapStateCubit _mapStateCubit;

  StreamSubscription<MapLatLng>? _locationSubscription;

  /// Starts listening to the driver location stream.
  /// [pickup] and [destination] are needed to compute route target.
  void startTracking({
    required MapLatLng pickup,
    required MapLatLng destination,
  }) {
    _locationSubscription?.cancel();
    emit(state.copyWith(pickup: pickup, destination: destination));

    _locationSubscription = _rideRepository.driverLocationStream.listen(
      (location) => _onLocation(location),
    );
  }

  /// Notifies the cubit that the trip has started so the route
  /// target switches from pickup to destination.
  void onTripStarted({required MapLatLng destination}) {
    emit(state.copyWith(destination: destination));
  }

  void stopTracking() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
    _mapStateCubit.removeMarker('driver');
    emit(const DriverTrackingState());
  }

  Future<void> _onLocation(MapLatLng driverLocation) async {
    final pickup = state.pickup;
    final destination = state.destination;

    if (pickup == null || destination == null) {
      emit(state.copyWith(driverLocation: driverLocation));
      return;
    }

    // Determine current route target (destination after trip starts)
    final targetLocation = state.isTripStarted ? destination : pickup;

    // 1. Bearing
    double bearing = state.driverBearing;
    if (state.driverLocation != null) {
      bearing = _calculateBearing(state.driverLocation!, driverLocation);
    }

    // 2. Write marker to MapStateCubit INSTANTLY
    _mapStateCubit.upsertMarker(
      MapMarker(
        id: 'driver',
        position: driverLocation,
        iconWidget: DriverMarkerWidget(bearing: bearing),
      ),
    );

    // 3. OSRM street route (this can take time or rate limit, so do it after marker)
    String? distanceText;
    String? etaText;
    var routePoints = [driverLocation, targetLocation];

    try {
      final routeDetails = await _osrmRouteService.getRouteDetails([
        driverLocation,
        targetLocation,
      ]);

      if (routeDetails != null) {
        routePoints = routeDetails.points;
        final distMeters = routeDetails.distance;
        distanceText = distMeters < 1000
            ? '${distMeters.toStringAsFixed(0)} m'
            : '${(distMeters / 1000).toStringAsFixed(1)} km';

        final durationMinutes = (routeDetails.duration / 60).round();
        etaText = durationMinutes <= 0 ? '1 min' : '$durationMinutes min';
      }
    } catch (e) {
      // Ignored for UI
    }

    // 4. Write polyline to MapStateCubit
    final isArrived = state.isDriverArrived;
    _mapStateCubit.updateDriverPolylines(
      borderId: isArrived
          ? 'driver_to_destination_border'
          : 'driver_to_pickup_border',
      lineId: isArrived ? 'driver_to_destination' : 'driver_to_pickup',
      points: routePoints,
    );

    emit(
      state.copyWith(
        driverLocation: driverLocation,
        driverBearing: bearing,
        driverDistance: distanceText,
        driverEta: etaText,
      ),
    );

    LoggerService.debug(
      'Driver at $driverLocation → bearing $bearing°, ETA $etaText',
      name: 'features.home.driver_tracking',
    );
  }

  /// Called when the driver has arrived so the amber line refreshes.
  void onDriverArrived() {
    emit(state.copyWith(isDriverArrived: true));
    if (state.driverLocation != null) {
      _onLocation(state.driverLocation!);
    }
  }

  double _calculateBearing(MapLatLng start, MapLatLng end) {
    final lat1 = start.latitude * pi / 180;
    final lng1 = start.longitude * pi / 180;
    final lat2 = end.latitude * pi / 180;
    final lng2 = end.longitude * pi / 180;
    final dLng = lng2 - lng1;
    final y = sin(dLng) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLng);
    return (atan2(y, x) * 180 / pi + 360) % 360;
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
