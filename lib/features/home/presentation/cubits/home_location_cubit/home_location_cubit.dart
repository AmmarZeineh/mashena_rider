import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mashena_rider/core/services/location_service.dart';
import 'package:mashena_rider/core/services/location_status.dart';

part 'home_location_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._locationService) : super(const HomeState.initial());

  final LocationService _locationService;

  Future<void> init() async {
    emit(state.copyWith(loading: true));

    final status = await _locationService.checkStatus();
    if (!status.serviceEnabled) {
      emit(
        state.copyWith(
          loading: false,
          locationStatus: status,
          ui: HomeUiState.locationServiceOff,
        ),
      );
      return;
    }

    if (status.permission != LocationPermissionState.granted) {
      emit(
        state.copyWith(
          loading: false,
          locationStatus: status,
          ui: HomeUiState.permissionNeeded,
        ),
      );
      return;
    }

    final pos = await _locationService.getCurrentPosition();
    emit(
      state.copyWith(
        loading: false,
        locationStatus: status,
        position: pos,
        ui: HomeUiState.ready,
      ),
    );
  }

  Future<void> requestPermission() async {
    emit(state.copyWith(loading: true));

    final status = await _locationService.requestPermissionIfNeeded();

    if (!status.serviceEnabled) {
      emit(
        state.copyWith(
          loading: false,
          locationStatus: status,
          ui: HomeUiState.locationServiceOff,
        ),
      );
      return;
    }

    if (status.permission == LocationPermissionState.deniedForever) {
      emit(
        state.copyWith(
          loading: false,
          locationStatus: status,
          ui: HomeUiState.permissionPermanentlyDenied,
        ),
      );
      return;
    }

    if (status.permission != LocationPermissionState.granted) {
      emit(
        state.copyWith(
          loading: false,
          locationStatus: status,
          ui: HomeUiState.permissionNeeded,
        ),
      );
      return;
    }

    final pos = await _locationService.getCurrentPosition();
    emit(
      state.copyWith(
        loading: false,
        locationStatus: status,
        position: pos,
        ui: HomeUiState.ready,
      ),
    );
  }

  Future<void> openSettings() async {
    await _locationService.openAppSettings();
  }

  Future<void> openLocationSettings() async {
    await _locationService.openLocationSettings();
  }
}
