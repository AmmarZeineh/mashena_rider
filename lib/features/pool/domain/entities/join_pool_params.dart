import 'package:equatable/equatable.dart';

class JoinPoolParams extends Equatable {
  final double pickupLat;
  final double pickupLng;
  final String pickupAddress;
  final int seatsNeeded;

  const JoinPoolParams({
    required this.pickupLat,
    required this.pickupLng,
    required this.pickupAddress,
    this.seatsNeeded = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'pickupLat': pickupLat,
      'pickupLng': pickupLng,
      'pickupAddress': pickupAddress,
      'seatsNeeded': seatsNeeded,
    };
  }

  @override
  List<Object?> get props => [pickupLat, pickupLng, pickupAddress, seatsNeeded];
}
