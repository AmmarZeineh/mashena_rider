import 'package:equatable/equatable.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_location.dart';

class MatchedTrip extends Equatable {
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
  final List<RideLocation> stops;

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

  @override
  List<Object?> get props => [
    tripId,
    tripStatus,
    rideRequestId,
    pickupLat,
    pickupLng,
    destinationLat,
    destinationLng,
    matchedAt,
    driverId,
    driverFullName,
    driverProfileImage,
    driverRatingAvg,
    vehicleId,
    plateNumber,
    color,
    manufacturer,
    model,
    vehicleTypeId,
    stops,
  ];
}
