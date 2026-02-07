part of 'home_location_cubit.dart';

enum HomeUiState {
  initial,
  ready,
  permissionNeeded,
  permissionPermanentlyDenied,
  locationServiceOff,
}

class HomeState {
  final bool loading;
  final HomeUiState ui;
  final LocationStatus? locationStatus;
  final Position? position;

  const HomeState({
    required this.loading,
    required this.ui,
    this.locationStatus,
    this.position,
  });

  const HomeState.initial()
    : loading = false,
      ui = HomeUiState.initial,
      locationStatus = null,
      position = null;

  HomeState copyWith({
    bool? loading,
    HomeUiState? ui,
    LocationStatus? locationStatus,
    Position? position,
  }) {
    return HomeState(
      loading: loading ?? this.loading,
      ui: ui ?? this.ui,
      locationStatus: locationStatus ?? this.locationStatus,
      position: position ?? this.position,
    );
  }
}
