part of 'home_location_cubit.dart';

enum HomeUiState { initial, loading, ready, error }

class HomeState {
  final HomeUiState ui;
  final bool isLocationGranted;
  final bool isLocationServiceEnabled;
  final bool isDeniedForever;
  final Position? position;
  final List<MapPolyline> polylines;
  final List<MapMarker> markers;
  final ConfirmedRideFlowResult? confirmedRideResult;

  const HomeState({
    required this.ui,
    required this.isLocationGranted,
    required this.isLocationServiceEnabled,
    this.isDeniedForever = false,
    this.position,
    this.polylines = const [],
    this.markers = const [],
    this.confirmedRideResult,
  });

  const HomeState.initial()
    : ui = HomeUiState.initial,
      isLocationGranted = false,
      isLocationServiceEnabled = true,
      isDeniedForever = false,
      position = null,
      polylines = const [],
      markers = const [],
      confirmedRideResult = null;

  HomeState copyWith({
    HomeUiState? ui,
    bool? isLocationGranted,
    bool? isLocationServiceEnabled,
    bool? isDeniedForever,
    Position? position,
    List<MapPolyline>? polylines,
    List<MapMarker>? markers,
    ConfirmedRideFlowResult? confirmedRideResult,
    bool clearConfirmedRide = false,
  }) {
    return HomeState(
      ui: ui ?? this.ui,
      isLocationGranted: isLocationGranted ?? this.isLocationGranted,
      isLocationServiceEnabled:
          isLocationServiceEnabled ?? this.isLocationServiceEnabled,
      isDeniedForever: isDeniedForever ?? this.isDeniedForever,
      position: position ?? this.position,
      polylines: polylines ?? this.polylines,
      markers: markers ?? this.markers,
      confirmedRideResult: clearConfirmedRide
          ? null
          : (confirmedRideResult ?? this.confirmedRideResult),
    );
  }
}
