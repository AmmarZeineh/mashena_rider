import 'package:equatable/equatable.dart';

class CreatePoolParams extends Equatable {
  final double pickupLat;
  final double pickupLng;
  final String pickupAddress;
  final double destinationLat;
  final double destinationLng;
  final String destinationAddress;
  final DateTime departureTime;
  final int maxPassengers;
  final int seatsNeeded;

  const CreatePoolParams({
    required this.pickupLat,
    required this.pickupLng,
    required this.pickupAddress,
    required this.destinationLat,
    required this.destinationLng,
    required this.destinationAddress,
    required this.departureTime,
    this.maxPassengers = 4,
    this.seatsNeeded = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'pickupLat': pickupLat,
      'pickupLng': pickupLng,
      'pickupAddress': pickupAddress,
      'destinationLat': destinationLat,
      'destinationLng': destinationLng,
      'destinationAddress': destinationAddress,
      'departureTime': departureTime.toIso8601String(),
      'maxPassengers': maxPassengers,
      'seatsNeeded': seatsNeeded,
    };
  }

  @override
  List<Object?> get props => [
    pickupLat,
    pickupLng,
    pickupAddress,
    destinationLat,
    destinationLng,
    destinationAddress,
    departureTime,
    maxPassengers,
    seatsNeeded,
  ];
}
