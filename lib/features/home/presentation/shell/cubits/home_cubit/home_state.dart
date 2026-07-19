part of 'home_cubit.dart';

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
  final bool isFetchingRoute;
  final bool isDriverFound;
  final bool isLoadingMatchedTrip;
  final MatchedTrip? matchedTrip;
  final bool isTripEnded;
  final bool isDriverArrived;
  final bool isTripStarted;
  final TripCompletedPayload? tripCompletedData;
  final TripCancelledPayload? tripCancelledData;

  /// Populated once the ride submission API succeeds.
  final RideSubmissionResponse? submissionResponse;

  // Real-time tracking fields
  final MapLatLng? driverLocation;
  final double driverBearing;
  final String? driverDistance;
  final String? driverEta;

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
    this.submissionResponse,
    this.isFetchingRoute = false,
    this.isDriverFound = false,
    this.isLoadingMatchedTrip = false,
    this.matchedTrip,
    this.driverLocation,
    this.driverBearing = 0.0,
    this.driverDistance,
    this.driverEta,
    this.isTripEnded = false,
    this.isDriverArrived = false,
    this.isTripStarted = false,
    this.tripCompletedData,
    this.tripCancelledData,
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
      bookingErrorMessage = null,
      submissionResponse = null,
      isFetchingRoute = false,
      isDriverFound = false,
      isLoadingMatchedTrip = false,
      matchedTrip = null,
      driverLocation = null,
      driverBearing = 0.0,
      driverDistance = null,
      driverEta = null,
      isTripEnded = false,
      isDriverArrived = false,
      isTripStarted = false,
      tripCompletedData = null,
      tripCancelledData = null;


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
    RideSubmissionResponse? submissionResponse,
    bool clearSubmissionResponse = false,
    bool? isFetchingRoute,
    bool? isDriverFound,
    bool clearDriverFound = false,
    bool? isLoadingMatchedTrip,
    MatchedTrip? matchedTrip,
    bool clearMatchedTrip = false,
    MapLatLng? driverLocation,
    bool clearDriverLocation = false,
    double? driverBearing,
    String? driverDistance,
    bool clearDriverDistance = false,
    String? driverEta,
    bool clearDriverEta = false,
    bool? isTripEnded,
    bool? isDriverArrived,
    bool? isTripStarted,
    TripCompletedPayload? tripCompletedData,
    bool clearTripCompletedData = false,
    TripCancelledPayload? tripCancelledData,
    bool clearTripCancelledData = false,
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
      submissionResponse: clearSubmissionResponse
          ? null
          : (submissionResponse ?? this.submissionResponse),
      isFetchingRoute: isFetchingRoute ?? this.isFetchingRoute,
      isDriverFound: clearDriverFound ? false : (isDriverFound ?? this.isDriverFound),
      isLoadingMatchedTrip: isLoadingMatchedTrip ?? this.isLoadingMatchedTrip,
      matchedTrip: clearMatchedTrip ? null : (matchedTrip ?? this.matchedTrip),
      driverLocation: clearDriverLocation ? null : (driverLocation ?? this.driverLocation),
      driverBearing: driverBearing ?? this.driverBearing,
      driverDistance: clearDriverDistance ? null : (driverDistance ?? this.driverDistance),
      driverEta: clearDriverEta ? null : (driverEta ?? this.driverEta),
      isTripEnded: isTripEnded ?? this.isTripEnded,
      isDriverArrived: isDriverArrived ?? this.isDriverArrived,
      isTripStarted: isTripStarted ?? this.isTripStarted,
      tripCompletedData: clearTripCompletedData ? null : (tripCompletedData ?? this.tripCompletedData),
      tripCancelledData: clearTripCancelledData ? null : (tripCancelledData ?? this.tripCancelledData),
    );
  }

}

