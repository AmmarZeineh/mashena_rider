import 'dart:async';
import 'dart:math' show atan2, cos, pi, sin;

import 'package:equatable/equatable.dart';
import 'package:mashena_rider/core/base/base_cubit.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_marker.dart';
import 'package:mashena_rider/core/services/logger_service.dart';
import 'package:mashena_rider/core/services/osrm_route_service.dart';
import 'package:mashena_rider/features/home/domain/repositories/ride_repository.dart';
import 'package:mashena_rider/features/home/presentation/ride_flow/ride_flow_coordinator.dart';
import 'package:mashena_rider/features/home/presentation/shell/cubits/map_state_cubit/map_state_cubit.dart';

part 'driver_tracking_state.dart';

/// Converts real-time driver location events into map overlays
/// (marker + polyline along road) and exposes ETA / distance.
///
/// Writes the visual result to [MapStateCubit] — it never owns the map.
class DriverTrackingCubit extends BaseCubit<DriverTrackingState> {
  DriverTrackingCubit(
    this._rideRepository,
    this._osrmRouteService,
    this._mapStateCubit,
  ) : super(const DriverTrackingState());

  final RideRepository _rideRepository;
  final OSRMRouteService _osrmRouteService;
  final MapStateCubit _mapStateCubit;

  StreamSubscription<MapLatLng>? _locationSubscription;
  Timer? _osrmDebounceTimer;
  int _osrmRequestId = 0;

  /// Starts listening to the driver location stream.
  /// [pickup] and [destination] are needed to compute route target.
  void startTracking({
    required MapLatLng pickup,
    required MapLatLng destination,
  }) {
    _locationSubscription?.cancel();
    _osrmDebounceTimer?.cancel();
    _mapStateCubit.removeMarker('driver');
    _mapStateCubit.clearDriverPolylines();
    emit(DriverTrackingState(pickup: pickup, destination: destination));

    _locationSubscription = _rideRepository.driverLocationStream.listen(
      (location) => _onLocation(location),
    );
  }

  /// Notifies the cubit that the trip has started so the route
  /// target switches from pickup to destination.
  void onTripStarted({required MapLatLng destination}) {
    _mapStateCubit.clearDriverPolylines();
    emit(state.copyWith(destination: destination, isTripStarted: true));
  }

  void stopTracking() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
    _osrmDebounceTimer?.cancel();
    _mapStateCubit.removeMarker('driver');
    _mapStateCubit.clearDriverPolylines();
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

    // 2. Write marker to MapStateCubit INSTANTLY (only driver position is drawn)
    _mapStateCubit.upsertMarker(
      MapMarker(
        id: 'driver',
        position: driverLocation,
        iconWidget: DriverMarkerWidget(bearing: bearing),
      ),
    );

    // 3. OSRM street route (debounced to prevent excessive requests)
    if (_osrmDebounceTimer?.isActive ?? false) {
      _osrmDebounceTimer!.cancel();
    }
    final int requestId = ++_osrmRequestId;
    _osrmDebounceTimer = Timer(const Duration(milliseconds: 300), () async {
      // Check if this is still the latest request
      if (requestId != _osrmRequestId) {
        return; // Stale request, ignore
      }

      String? distanceText;
      String? etaText;

      try {
        final routeDetails = await _osrmRouteService.getRouteDetails([
          driverLocation,
          targetLocation,
        ]);

        if (routeDetails != null) {
          final distMeters = routeDetails.distance;
          distanceText = distMeters < 1000
              ? '${distMeters.toStringAsFixed(0)} m'
              : '${(distMeters / 1000).toStringAsFixed(1)} km';

          final durationMinutes = (routeDetails.duration / 60).round();
          etaText = durationMinutes <= 0 ? '1 min' : '$durationMinutes min';
        }
      } catch (e) {
        // Ignored for UI - keep last valid values
      }

      // Emit state update with ETA/distance info (no polyline drawn between driver and rider)
      if (!isClosed) {
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
    });
  }

  /// Called when the driver has arrived at the pickup location.
  void onDriverArrived() {
    _mapStateCubit.clearDriverPolylines();
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
    _osrmDebounceTimer?.cancel();
    return super.close();
  }
}
