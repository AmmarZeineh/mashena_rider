class MatchedTrip {
  final int tripId;
  final String tripStatus;
  final int rideRequestId;
  final double pickupLat;
  final double pickupLng;
  final double destinationLat;
  final double destinationLng;
  final String? matchedAt;
  final int driverId;
  final String driverFullName;
  final String? driverProfileImage;
  final double driverRatingAvg;
  final int? vehicleId;
  final String? plateNumber;
  final String? color;
  final String? manufacturer;
  final String? model;
  final int? vehicleTypeId;
  final List<dynamic> stops;

  const MatchedTrip({
    required this.tripId,
    required this.tripStatus,
    required this.rideRequestId,
    required this.pickupLat,
    required this.pickupLng,
    required this.destinationLat,
    required this.destinationLng,
    this.matchedAt,
    required this.driverId,
    required this.driverFullName,
    this.driverProfileImage,
    required this.driverRatingAvg,
    this.vehicleId,
    this.plateNumber,
    this.color,
    this.manufacturer,
    this.model,
    this.vehicleTypeId,
    required this.stops,
  });
}
