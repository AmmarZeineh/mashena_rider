part of 'trip_lifecycle_cubit.dart';

/// State for all post-submission trip lifecycle events.
class TripLifecycleState extends Equatable {
  const TripLifecycleState({
    this.isDriverFound = false,
    this.isLoadingMatchedTrip = false,
    this.matchedTrip,
    this.isDriverArrived = false,
    this.isTripStarted = false,
    this.isTripEnded = false,
    this.freeWaitTimeSeconds = 300,
    this.arrivedAt,
    this.tripCompletedData,
    this.tripCancelledData,
    this.tripError,
    this.isRideExpired = false,
    this.isConnected = false,
  });

  final bool isDriverFound;
  final bool isLoadingMatchedTrip;
  final MatchedTrip? matchedTrip;
  final bool isDriverArrived;
  final bool isTripStarted;
  final bool isTripEnded;
  final int freeWaitTimeSeconds;
  final String? arrivedAt;
  final TripCompleted? tripCompletedData;
  final TripCancelled? tripCancelledData;

  /// Set when the trip is cancelled by driver/admin or when the
  /// matched-trip fetch exhausts all retries.
  final Failure? tripError;

  /// Set when the ride request expires without finding a driver.
  final bool isRideExpired;

  /// Socket connection status
  final bool isConnected;

  @override
  List<Object?> get props => [
    isDriverFound,
    isLoadingMatchedTrip,
    matchedTrip,
    isDriverArrived,
    isTripStarted,
    isTripEnded,
    freeWaitTimeSeconds,
    arrivedAt,
    tripCompletedData,
    tripCancelledData,
    tripError,
    isRideExpired,
    isConnected,
  ];

  @override
  bool get stringify => true;

  TripLifecycleState copyWith({
    bool? isDriverFound,
    bool? isLoadingMatchedTrip,
    MatchedTrip? matchedTrip,
    bool clearMatchedTrip = false,
    bool? isDriverArrived,
    bool? isTripStarted,
    bool? isTripEnded,
    int? freeWaitTimeSeconds,
    String? arrivedAt,
    TripCompleted? tripCompletedData,
    TripCancelled? tripCancelledData,
    Failure? tripError,
    bool clearTripError = false,
    bool? isRideExpired,
    bool? isConnected,
  }) {
    return TripLifecycleState(
      isDriverFound: isDriverFound ?? this.isDriverFound,
      isLoadingMatchedTrip: isLoadingMatchedTrip ?? this.isLoadingMatchedTrip,
      matchedTrip: clearMatchedTrip ? null : (matchedTrip ?? this.matchedTrip),
      isDriverArrived: isDriverArrived ?? this.isDriverArrived,
      isTripStarted: isTripStarted ?? this.isTripStarted,
      isTripEnded: isTripEnded ?? this.isTripEnded,
      freeWaitTimeSeconds: freeWaitTimeSeconds ?? this.freeWaitTimeSeconds,
      arrivedAt: arrivedAt ?? this.arrivedAt,
      tripCompletedData: tripCompletedData ?? this.tripCompletedData,
      tripCancelledData: tripCancelledData ?? this.tripCancelledData,
      tripError: clearTripError ? null : (tripError ?? this.tripError),
      isRideExpired: isRideExpired ?? this.isRideExpired,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}
