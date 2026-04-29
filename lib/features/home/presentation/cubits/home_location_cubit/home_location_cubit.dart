import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_marker.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_polyline.dart';
import 'package:mashena_rider/core/services/location_service.dart';
import 'package:mashena_rider/core/services/location_status.dart';
import 'package:mashena_rider/features/home/domain/usecases/submit_ride_request_usecase.dart';
import 'package:mashena_rider/features/home/presentation/models/confirmed_ride_flow_result.dart';

part 'home_location_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
    this._locationService,
    this._submitRideRequest,
  ) : super(const HomeState.initial());

  final LocationService _locationService;
  final SubmitRideRequestUsecase _submitRideRequest;

  /// Called once when the home screen loads.
  /// Now requests permission (triggers the OS prompt) instead of just checking.
  Future<void> init() async {
    emit(state.copyWith(ui: HomeUiState.loading));

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

  /// Clears route, markers, and confirmed ride — back to idle.
  void clearRideFlow() {
    emit(state.copyWith(polylines: [], markers: [], clearConfirmedRide: true));
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
      (submissionResult) => emit(
        state.copyWith(
          isSubmittingRide: false,
          rideSubmittedSuccessfully: true,
        ),
      ),
    );
  }
}
