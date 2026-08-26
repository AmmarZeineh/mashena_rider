import 'package:equatable/equatable.dart';

class PoolSuggestionParams extends Equatable {
  final double pickupLat;
  final double pickupLng;
  final double destinationLat;
  final double destinationLng;
  final DateTime? departureTime;

  const PoolSuggestionParams({
    required this.pickupLat,
    required this.pickupLng,
    required this.destinationLat,
    required this.destinationLng,
    this.departureTime,
  });

  Map<String, dynamic> toQueryMap() {
    final map = <String, dynamic>{
      'pickupLat': pickupLat,
      'pickupLng': pickupLng,
      'destinationLat': destinationLat,
      'destinationLng': destinationLng,
    };
    if (departureTime != null) {
      map['departureTime'] = departureTime!.toIso8601String();
    }
    return map;
  }

  @override
  List<Object?> get props => [
    pickupLat,
    pickupLng,
    destinationLat,
    destinationLng,
    departureTime,
  ];
}
