import 'dart:async';
import 'dart:math' show pi, sin, cos, atan2;
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:geolocator/geolocator.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_marker.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_polyline.dart';
import 'package:mashena_rider/core/services/location_service.dart';
import 'package:mashena_rider/core/services/location_status.dart';
import 'package:mashena_rider/core/services/osrm_route_service.dart';
import 'package:mashena_rider/features/home/domain/entities/matched_trip.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_submission_response.dart';
import 'package:mashena_rider/features/home/domain/repositories/ride_repository.dart';
import 'package:mashena_rider/features/home/domain/usecases/submit_ride_request_usecase.dart';
import 'package:mashena_rider/features/home/presentation/common/models/confirmed_ride_flow_result.dart';
import 'package:mashena_rider/features/home/presentation/ride_flow/ride_flow_coordinator.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
    this._locationService,
    this._submitRideRequest,
    this._rideRepository,
    this._osrmRouteService,
  ) : super(const HomeState.initial()) {
    _subscribeToSocketStreams();
  }

  final LocationService _locationService;
  final SubmitRideRequestUsecase _submitRideRequest;
  final RideRepository _rideRepository;
  final OSRMRouteService _osrmRouteService;

  StreamSubscription<int>? _rideMatchedSubscription;
  StreamSubscription<MapLatLng>? _driverLocationSubscription;

  /// Called once when the home screen loads.
  /// Now requests permission (triggers the OS prompt) instead of just checking.
  Future<void> init() async {
    emit(state.copyWith(ui: HomeUiState.loading));

    // Connect socket early so the rider is registered in the gateway
    // before any ride is submitted. notifyRiderMatched checks riderSockets.
    // ignore: unawaited_futures
    _rideRepository.connectSocket();

    final status = await _locationService.requestPermissionIfNeeded();

    emit(
      state.copyWith(
        ui: HomeUiState.ready,
        isLocationGranted: status.permission == LocationPermissionState.granted,
        isLocationServiceEnabled: status.serviceEnabled,
        isDeniedForever:
            status.permission == LocationPermissionState.deniedForever,
      ),
    );

    if (status.permission == LocationPermissionState.granted &&
        status.serviceEnabled) {
      final pos = await _locationService.getCurrentPosition();
      emit(state.copyWith(position: pos));
    }
  }

  /// Re-request permission (e.g. from the overlay or pick-address flow).
  Future<void> requestPermission() async {
    final status = await _locationService.requestPermissionIfNeeded();

    emit(
      state.copyWith(
        isLocationGranted: status.permission == LocationPermissionState.granted,
        isLocationServiceEnabled: status.serviceEnabled,
        isDeniedForever:
            status.permission == LocationPermissionState.deniedForever,
      ),
    );

    if (status.permission == LocationPermissionState.granted &&
        status.serviceEnabled) {
      final pos = await _locationService.getCurrentPosition();
      emit(state.copyWith(position: pos));
    }
  }

  /// Re-check status (e.g. after returning from system settings).
  Future<void> recheckStatus() async {
    final status = await _locationService.checkStatus();

    emit(
      state.copyWith(
        isLocationGranted: status.permission == LocationPermissionState.granted,
        isLocationServiceEnabled: status.serviceEnabled,
        isDeniedForever:
            status.permission == LocationPermissionState.deniedForever,
      ),
    );

    if (status.permission == LocationPermissionState.granted &&
        status.serviceEnabled) {
      final pos = await _locationService.getCurrentPosition();
      emit(state.copyWith(position: pos));
    }
  }

  Future<void> openSettings() => _locationService.openAppSettings();

  Future<void> openLocationSettings() =>
      _locationService.openLocationSettings();

  void setPolylines(List<MapPolyline> polylines) {
    emit(state.copyWith(polylines: polylines));
  }

  /// Updates the markers displayed on the map.
  void setMarkers(List<MapMarker> markers) {
    emit(state.copyWith(markers: markers));
  }

  /// Stores the confirmed ride result so the bottom sheet
  /// can be shown persistently in the Stack.
  void setConfirmedRide(ConfirmedRideFlowResult result) {
    emit(state.copyWith(confirmedRideResult: result));
  }

  void setFetchingRoute(bool isFetching) {
    emit(state.copyWith(isFetchingRoute: isFetching));
  }

  /// Clears route, markers, and confirmed ride — back to idle.
  void clearRideFlow() {
    final activeRideId = state.submissionResponse?.rideRequestId;
    if (activeRideId != null) {
      _rideRepository.stopListeningToRide(activeRideId);
    }
    emit(
      state.copyWith(
        polylines: [],
        markers: [],
        clearConfirmedRide: true,
        clearSubmissionResponse: true,
        clearDriverFound: true,
        rideSubmittedSuccessfully: false,
        clearMatchedTrip: true,
        isLoadingMatchedTrip: false,
        clearDriverLocation: true,
        driverBearing: 0.0,
        clearDriverDistance: true,
        clearDriverEta: true,
      ),
    );
  }

  Future<void> submitRideSelection(int vehicleTypeId) async {
    final result = state.confirmedRideResult;
    if (result == null) return;

    emit(
      state.copyWith(
        isSubmittingRide: true,
        clearBookingError: true,
        rideSubmittedSuccessfully: false,
      ),
    );

    final response = await _submitRideRequest(
      request: result.request,
      vehicleTypeId: vehicleTypeId,
    );

    response.fold(
      (error) => emit(
        state.copyWith(isSubmittingRide: false, bookingErrorMessage: error),
      ),
      (submissionResult) {
        _rideRepository.listenToRide(submissionResult.rideRequestId);
        emit(
          state.copyWith(
            isSubmittingRide: false,
            rideSubmittedSuccessfully: true,
            submissionResponse: submissionResult,
            isDriverFound: false,
          ),
        );
      },
    );
  }

  void _subscribeToSocketStreams() {
    _rideMatchedSubscription = _rideRepository.rideMatchedStream.listen((
      rideRequestId,
    ) async {
      emit(
        state.copyWith(
          isDriverFound: true,
          isLoadingMatchedTrip: true,
          clearBookingError: true,
        ),
      );

      final result = await _rideRepository.getMatchedTripDetails(rideRequestId);

      result.fold(
        (error) => emit(
          state.copyWith(
            isLoadingMatchedTrip: false,
            bookingErrorMessage: error,
          ),
        ),
        (matchedTrip) => emit(
          state.copyWith(isLoadingMatchedTrip: false, matchedTrip: matchedTrip),
        ),
      );
    });

    _driverLocationSubscription = _rideRepository.driverLocationStream.listen((
      location,
    ) async {
      await _updateDriverMarker(location);
    });
  }

  Future<void> _updateDriverMarker(MapLatLng driverLocation) async {
    final pickup = state.confirmedRideResult?.pickup;
    if (pickup == null) return;

    // 1. Calculate bearing
    double bearing = state.driverBearing;
    if (state.driverLocation != null) {
      bearing = _calculateBearing(state.driverLocation!, driverLocation);
    }

    // 2. Fetch OSRM street route details (points, distance, duration)
    List<MapLatLng> routePoints = [driverLocation, pickup];
    String? distanceText;
    String? etaText;

    final routeDetails = await _osrmRouteService.getRouteDetails([
      driverLocation,
      pickup,
    ]);
    if (routeDetails != null) {
      routePoints = routeDetails.points;

      // Distance conversion
      final distMeters = routeDetails.distance;
      if (distMeters < 1000) {
        distanceText = '${distMeters.toStringAsFixed(0)} m';
      } else {
        distanceText = '${(distMeters / 1000).toStringAsFixed(1)} km';
      }

      // Duration/ETA conversion
      final durationMinutes = (routeDetails.duration / 60).round();
      if (durationMinutes <= 0) {
        etaText = '1 min';
      } else {
        etaText = '$durationMinutes min';
      }
    }

    // 3. Update/Add driver marker with bearing
    final updatedMarkers = List<MapMarker>.from(state.markers)
      ..removeWhere((marker) => marker.id == 'driver')
      ..add(
        MapMarker(
          id: 'driver',
          position: driverLocation,
          iconWidget: DriverMarkerWidget(bearing: bearing),
        ),
      );

    // 4. Update/Add driver to pickup polyline (along streets)
    final updatedPolylines = List<MapPolyline>.from(state.polylines)
      ..removeWhere(
        (poly) =>
            poly.id == 'driver_to_pickup_border' ||
            poly.id == 'driver_to_pickup',
      )
      ..add(
        MapPolyline(
          id: 'driver_to_pickup_border',
          points: routePoints,
          color: Colors.amber.withValues(alpha: 0.3),
          width: 10,
        ),
      )
      ..add(
        MapPolyline(
          id: 'driver_to_pickup',
          points: routePoints,
          color: Colors.amber,
          width: 4,
        ),
      );

    emit(
      state.copyWith(
        markers: updatedMarkers,
        polylines: updatedPolylines,
        driverLocation: driverLocation,
        driverBearing: bearing,
        driverDistance: distanceText,
        driverEta: etaText,
      ),
    );
  }

  double _calculateBearing(MapLatLng start, MapLatLng end) {
    final double lat1 = start.latitude * pi / 180;
    final double lng1 = start.longitude * pi / 180;
    final double lat2 = end.latitude * pi / 180;
    final double lng2 = end.longitude * pi / 180;

    final double dLng = lng2 - lng1;

    final double y = sin(dLng) * cos(lat2);
    final double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLng);

    final double bearingRad = atan2(y, x);
    final double bearingDeg = (bearingRad * 180 / pi + 360) % 360;

    return bearingDeg;
  }

  @override
  Future<void> close() {
    _rideMatchedSubscription?.cancel();
    _driverLocationSubscription?.cancel();
    return super.close();
  }
}
