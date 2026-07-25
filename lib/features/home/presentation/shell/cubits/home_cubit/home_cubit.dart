import 'dart:async';
import 'dart:developer' as developer;
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
import 'package:mashena_rider/features/home/data/models/driver_arrived_payload.dart';
import 'package:mashena_rider/features/home/domain/entities/trip_completed.dart';
import 'package:mashena_rider/features/home/domain/entities/trip_cancelled.dart';
import 'package:mashena_rider/features/home/domain/entities/matched_trip.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_submission_response.dart';
import 'package:mashena_rider/features/home/domain/repositories/ride_repository.dart';
import 'package:mashena_rider/features/home/domain/usecases/submit_ride_request_usecase.dart';
import 'package:mashena_rider/features/home/domain/usecases/cancel_ride_usecase.dart';
import 'package:mashena_rider/features/home/presentation/common/models/confirmed_ride_flow_result.dart';
import 'package:mashena_rider/core/auth/auth_event.dart';
import 'package:mashena_rider/core/auth/auth_event_bus.dart';
import 'package:mashena_rider/features/home/presentation/ride_flow/ride_flow_coordinator.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
    this._locationService,
    this._submitRideRequest,
    this._cancelRideUsecase,
    this._rideRepository,
    this._osrmRouteService,
    this._authEventBus,
  ) : super(const HomeState.initial()) {
    _subscribeToSocketStreams();
    _subscribeToAuthEvents();
  }

  final LocationService _locationService;
  final SubmitRideRequestUsecase _submitRideRequest;
  final CancelRideUsecase _cancelRideUsecase;
  final RideRepository _rideRepository;
  final OSRMRouteService _osrmRouteService;
  final AuthEventBus _authEventBus;

  StreamSubscription<int>? _rideMatchedSubscription;
  StreamSubscription<MapLatLng>? _driverLocationSubscription;
  StreamSubscription<DriverArrivedPayload>? _driverArrivedSubscription;
  StreamSubscription<int>? _driverStartedSubscription;
  StreamSubscription<TripCompleted>? _tripCompletedSubscription;
  StreamSubscription<TripCancelled>? _tripCancelledSubscription;
  StreamSubscription<AuthEvent>? _authEventSubscription;

  /// Called once when the home screen loads.
  /// Now requests permission (triggers the OS prompt) instead of just checking.
  Future<void> init() async {
    emit(state.copyWith(ui: HomeUiState.loading));

    // Connect socket early so the rider is registered in the gateway
    // before any ride is submitted. notifyRiderMatched checks riderSockets.
    // ignore: unawaited_futures
    _rideRepository.connectSocket().then((_) {
      developer.log(
        'Socket connect() called on init',
        name: 'features.home.cubit',
      );
    });

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
    final activeRideId = state.submissionResponse?.rideRequestId ?? state.matchedTrip?.rideRequestId;
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
        isTripEnded: false,
        isDriverArrived: false,
        isTripStarted: false,
        clearTripCompletedData: true,
        clearTripCancelledData: true,
      ),
    );
  }

  Future<void> submitRating(double rating, String? comment) async {
    // In a real app, you would make an API call here.
    // For now, we just clear the ride flow to return to the idle state.
    clearRideFlow();
  }

  Future<void> cancelRide() async {
    final rideRequestId = state.submissionResponse?.rideRequestId;
    if (rideRequestId == null) return;

    if (state.isTripStarted) {
      emit(
        state.copyWith(
          bookingErrorMessage: 'Cannot cancel ride after trip has started',
        ),
      );
      return;
    }

    emit(state.copyWith(isSubmittingRide: true, clearBookingError: true));

    final response = await _cancelRideUsecase(rideRequestId);

    response.fold(
      (error) => emit(
        state.copyWith(isSubmittingRide: false, bookingErrorMessage: error),
      ),
      (_) {
        _rideRepository.stopListeningToRide(rideRequestId);
        clearRideFlow();
      },
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

      await _fetchMatchedTripWithRetry(rideRequestId);
    });

    _driverLocationSubscription = _rideRepository.driverLocationStream.listen((
      location,
    ) async {
      await _updateDriverMarker(location);
    });

    _driverArrivedSubscription = _rideRepository.driverArrivedStream.listen((
      payload,
    ) {
      emit(
        state.copyWith(
          isDriverArrived: true,
          freeWaitTimeSeconds: payload.freeWaitTimeSeconds,
          arrivedAt: payload.arrivedAt,
        ),
      );
      // Once arrived, update the marker/route immediately using the last known location
      if (state.driverLocation != null) {
        _updateDriverMarker(state.driverLocation!);
      }
    });

    _driverStartedSubscription = _rideRepository.driverStartedStream.listen((
      tripId,
    ) {
      emit(state.copyWith(isTripStarted: true));
    });

    _tripCompletedSubscription = _rideRepository.tripCompletedStream.listen((
      payload,
    ) {
      final activeRideId = state.submissionResponse?.rideRequestId ?? state.matchedTrip?.rideRequestId;
      if (activeRideId != null) {
        _rideRepository.stopListeningToRide(activeRideId);
      }
      emit(
        state.copyWith(
          isTripEnded: true,
          tripCompletedData: payload,
          markers: [],
          polylines: [],
        ),
      );
    });

    _tripCancelledSubscription = _rideRepository.tripCancelledStream.listen((
      payload,
    ) {
      clearRideFlow();
      final String errorKey;
      if (payload.cancelledBy == 'driver') {
        errorKey = 'tripCancelledByDriver';
      } else if (payload.cancelledBy == 'admin') {
        errorKey = 'tripCancelledByAdmin';
      } else {
        errorKey = 'tripCancelled';
      }
      emit(
        state.copyWith(
          bookingErrorMessage: errorKey,
          tripCancelledData: payload,
        ),
      );
    });
  }

  /// Listens to auth events. When the token is refreshed, the socket is
  /// reconnected using the new token so ride:matched events are not missed.
  void _subscribeToAuthEvents() {
    _authEventSubscription = _authEventBus.stream.listen((event) {
      if (event == AuthEvent.tokenRefreshed) {
        developer.log(
          'Token refreshed, reconnecting socket...',
          name: 'features.home.cubit',
        );
        _rideRepository.connectSocket();
      }
    });
  }

  /// Fetches matched trip details with retry on failure.
  /// This guards against transient auth failures (token refresh in-flight)
  /// that can occur right when the ride:matched socket event arrives.
  Future<void> _fetchMatchedTripWithRetry(int rideRequestId) async {
    const int maxRetries = 4;
    const Duration delayBetweenRetries = Duration(milliseconds: 1500);

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      if (isClosed) return;

      developer.log(
        'Fetching matched trip details (Attempt $attempt/$maxRetries for ID: $rideRequestId)...',
        name: 'features.home.cubit',
      );

      final result = await _rideRepository.getMatchedTripDetails(
        rideRequestId,
      );

      if (isClosed) return;

      if (result.isRight()) {
        final matchedTrip = result.getOrElse(() => throw Exception());
        developer.log(
          'Successfully loaded matched trip: ${matchedTrip.driverFullName} (${matchedTrip.model})',
          name: 'features.home.cubit',
        );

        emit(
          state.copyWith(
            matchedTrip: matchedTrip,
            isLoadingMatchedTrip: false,
          ),
        );

        // If we already received a driver location via socket while fetching, update marker now
        if (state.driverLocation != null) {
          _updateDriverMarker(state.driverLocation!);
        }
        return;
      }

      final error = result.fold((l) => l, (r) => '');
      developer.log(
        'Attempt $attempt failed: $error',
        name: 'features.home.cubit',
      );

      if (attempt < maxRetries) {
        await Future.delayed(delayBetweenRetries);
      } else {
        developer.log(
          'All retries exhausted for matched trip details.',
          name: 'features.home.cubit',
        );
        emit(
          state.copyWith(
            isLoadingMatchedTrip: false,
            isDriverFound: false,
            bookingErrorMessage: 'failedToLoadDriverDetails',
          ),
        );
      }
    }
  }

  Future<void> _updateDriverMarker(MapLatLng driverLocation) async {
    final pickup =
        state.confirmedRideResult?.pickup ??
        (state.matchedTrip != null
            ? MapLatLng(
                latitude: state.matchedTrip!.pickupLat,
                longitude: state.matchedTrip!.pickupLng,
              )
            : null);
    final destination =
        state.confirmedRideResult?.destination ??
        (state.matchedTrip != null
            ? MapLatLng(
                latitude: state.matchedTrip!.destinationLat,
                longitude: state.matchedTrip!.destinationLng,
              )
            : null);
    if (pickup == null || destination == null) {
      emit(state.copyWith(driverLocation: driverLocation));
      return;
    }

    final targetLocation = state.isTripStarted ? destination : pickup;

    // 1. Calculate bearing
    double bearing = state.driverBearing;
    if (state.driverLocation != null) {
      bearing = _calculateBearing(state.driverLocation!, driverLocation);
    }

    // 2. Fetch OSRM street route details (points, distance, duration)
    List<MapLatLng> routePoints = [driverLocation, targetLocation];
    String? distanceText;
    String? etaText;

    final routeDetails = await _osrmRouteService.getRouteDetails([
      driverLocation,
      targetLocation,
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
    final polylineIdBorder = state.isDriverArrived
        ? 'driver_to_destination_border'
        : 'driver_to_pickup_border';
    final polylineId = state.isDriverArrived
        ? 'driver_to_destination'
        : 'driver_to_pickup';

    final updatedPolylines = List<MapPolyline>.from(state.polylines)
      ..removeWhere(
        (poly) =>
            poly.id == 'driver_to_pickup_border' ||
            poly.id == 'driver_to_pickup' ||
            poly.id == 'driver_to_destination_border' ||
            poly.id == 'driver_to_destination',
      )
      ..add(
        MapPolyline(
          id: polylineIdBorder,
          points: routePoints,
          color: Colors.amber.withValues(alpha: 0.3),
          width: 10,
        ),
      )
      ..add(
        MapPolyline(
          id: polylineId,
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
    _driverArrivedSubscription?.cancel();
    _driverStartedSubscription?.cancel();
    _tripCompletedSubscription?.cancel();
    _tripCancelledSubscription?.cancel();
    _authEventSubscription?.cancel();
    return super.close();
  }
}
