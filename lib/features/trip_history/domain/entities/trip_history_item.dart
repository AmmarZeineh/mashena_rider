import 'package:equatable/equatable.dart';
import 'package:mashena_rider/features/trip_history/domain/entities/rider_trip_status.dart';

class TripDriverEntity extends Equatable {
  final int id;
  final String? fullName;
  final String? phoneNumber;
  final double? ratingAvg;

  const TripDriverEntity({
    required this.id,
    this.fullName,
    this.phoneNumber,
    this.ratingAvg,
  });

  @override
  List<Object?> get props => [id, fullName, phoneNumber, ratingAvg];
}

class TripVehicleEntity extends Equatable {
  final String? plateNumber;
  final String? model;
  final String? color;

  const TripVehicleEntity({this.plateNumber, this.model, this.color});

  @override
  List<Object?> get props => [plateNumber, model, color];
}

class TripHistoryItem extends Equatable {
  final int id;
  final int? rideRequestId;
  final String status;
  final RiderTripStatus? statusEnum;
  final String pickupAddress;
  final String destAddress;
  final double? pickupLat;
  final double? pickupLng;
  final double? destLat;
  final double? destLng;
  final num finalFare;
  final num? fareTotal;
  final double? distanceKm;
  final int? durationSec;
  final String? createdAt;
  final String? completedAt;
  final String? canceledAt;
  final String? cancelledBy;
  final TripDriverEntity? driver;
  final TripVehicleEntity? vehicle;

  const TripHistoryItem({
    required this.id,
    this.rideRequestId,
    required this.status,
    this.statusEnum,
    required this.pickupAddress,
    required this.destAddress,
    this.pickupLat,
    this.pickupLng,
    this.destLat,
    this.destLng,
    required this.finalFare,
    this.fareTotal,
    this.distanceKm,
    this.durationSec,
    this.createdAt,
    this.completedAt,
    this.canceledAt,
    this.cancelledBy,
    this.driver,
    this.vehicle,
  });

  bool get isCompleted =>
      statusEnum == RiderTripStatus.completed ||
      status.toLowerCase() == 'completed';

  bool get isCancelled =>
      statusEnum == RiderTripStatus.canceled ||
      status.toLowerCase() == 'cancelled' ||
      status.toLowerCase() == 'canceled';

  @override
  List<Object?> get props => [
    id,
    rideRequestId,
    status,
    statusEnum,
    pickupAddress,
    destAddress,
    finalFare,
    distanceKm,
    durationSec,
    createdAt,
    driver,
    vehicle,
  ];
}
