import 'package:equatable/equatable.dart';
import 'package:mashena_rider/features/home/domain/entities/place_entity.dart';

class PoolDiscoveryArgs extends Equatable {
  final PlaceEntity pickup;
  final PlaceEntity destination;
  final DateTime? departureTime;

  const PoolDiscoveryArgs({
    required this.pickup,
    required this.destination,
    this.departureTime,
  });

  @override
  List<Object?> get props => [pickup, destination, departureTime];
}
