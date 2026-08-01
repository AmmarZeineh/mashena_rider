import 'package:geolocator/geolocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/core/services/location_service.dart';
import 'package:mashena_rider/core/services/location_status.dart';

part 'location_state.dart';

/// Manages GPS permission state and the current device position.
class LocationCubit extends Cubit<LocationState> {
  LocationCubit(this._locationService) : super(const LocationState.initial());

  final LocationService _locationService;

  /// Called once on home screen mount. Requests the OS permission prompt
  /// and fetches the current position if already granted.
  Future<void> init() async {
    final status = await _locationService.requestPermissionIfNeeded();
    _applyStatus(status);

    if (state.isGranted) {
      final pos = await _locationService.getCurrentPosition();
      emit(state.copyWith(position: pos));
    }
  }

  /// Re-requests permission (e.g. from the overlay or pick-address flow).
  Future<void> requestPermission() async {
    final status = await _locationService.requestPermissionIfNeeded();
    _applyStatus(status);

    if (state.isGranted) {
      final pos = await _locationService.getCurrentPosition();
      emit(state.copyWith(position: pos));
    }
  }

  /// Re-checks status after returning from system settings.
  Future<void> recheckStatus() async {
    final status = await _locationService.checkStatus();
    _applyStatus(status);

    if (state.isGranted) {
      final pos = await _locationService.getCurrentPosition();
      emit(state.copyWith(position: pos));
    }
  }

  Future<void> openSettings() => _locationService.openAppSettings();

  Future<void> openLocationSettings() =>
      _locationService.openLocationSettings();

  void _applyStatus(LocationStatus status) {
    emit(
      state.copyWith(
        isGranted: status.permission == LocationPermissionState.granted,
        isServiceEnabled: status.serviceEnabled,
        isDeniedForever:
            status.permission == LocationPermissionState.deniedForever,
      ),
    );
  }
}
