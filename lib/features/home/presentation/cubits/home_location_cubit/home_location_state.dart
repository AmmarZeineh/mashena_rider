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
  final bool isSubmittingRide;
  final bool rideSubmittedSuccessfully;
  final String? bookingErrorMessage;

  const HomeState({
    required this.ui,
    required this.isLocationGranted,
    required this.isLocationServiceEnabled,
    this.isDeniedForever = false,
    this.position,
    this.polylines = const [],
    this.markers = const [],
    this.confirmedRideResult,
    this.isSubmittingRide = false,
    this.rideSubmittedSuccessfully = false,
    this.bookingErrorMessage,
  });

  const HomeState.initial()
    : ui = HomeUiState.initial,
      isLocationGranted = false,
      isLocationServiceEnabled = true,
      isDeniedForever = false,
      position = null,
      polylines = const [],
      markers = const [],
      confirmedRideResult = null,
      isSubmittingRide = false,
      rideSubmittedSuccessfully = false,
      bookingErrorMessage = null;

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
    bool? isSubmittingRide,
    bool? rideSubmittedSuccessfully,
    String? bookingErrorMessage,
    bool clearBookingError = false,
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
      isSubmittingRide: isSubmittingRide ?? this.isSubmittingRide,
      rideSubmittedSuccessfully:
          rideSubmittedSuccessfully ?? this.rideSubmittedSuccessfully,
      bookingErrorMessage: clearBookingError
          ? null
          : (bookingErrorMessage ?? this.bookingErrorMessage),
    );
  }
}
