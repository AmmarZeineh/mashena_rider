part of 'driver_tracking_cubit.dart';

/// Real-time driver tracking data: location, bearing, ETA, distance.
class DriverTrackingState extends Equatable {
  const DriverTrackingState({
    this.driverLocation,
    this.driverBearing = 0.0,
    this.driverDistance,
    this.driverEta,
    this.pickup,
    this.destination,
    this.isDriverArrived = false,
    this.isTripStarted = false,
  });

  final MapLatLng? driverLocation;
  final double driverBearing;
  final String? driverDistance;
  final String? driverEta;

  // Route targets (set on startTracking)
  final MapLatLng? pickup;
  final MapLatLng? destination;

  final bool isDriverArrived;
  final bool isTripStarted;

  bool get isTracking => pickup != null && destination != null;

  @override
  List<Object?> get props => [
        driverLocation,
        driverBearing,
        driverDistance,
        driverEta,
        pickup,
        destination,
        isDriverArrived,
        isTripStarted,
      ];

  @override
  bool get stringify => true;

  DriverTrackingState copyWith({
    MapLatLng? driverLocation,
    double? driverBearing,
    String? driverDistance,
    bool clearDriverDistance = false,
    String? driverEta,
    bool clearDriverEta = false,
    MapLatLng? pickup,
    MapLatLng? destination,
    bool? isDriverArrived,
    bool? isTripStarted,
  }) {
    return DriverTrackingState(
      driverLocation: driverLocation ?? this.driverLocation,
      driverBearing: driverBearing ?? this.driverBearing,
      driverDistance:
          clearDriverDistance ? null : (driverDistance ?? this.driverDistance),
      driverEta: clearDriverEta ? null : (driverEta ?? this.driverEta),
      pickup: pickup ?? this.pickup,
      destination: destination ?? this.destination,
      isDriverArrived: isDriverArrived ?? this.isDriverArrived,
      isTripStarted: isTripStarted ?? this.isTripStarted,
    );
  }
}
