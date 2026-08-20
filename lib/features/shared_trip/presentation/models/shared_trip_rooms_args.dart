import 'package:mashena_rider/features/home/domain/entities/place_entity.dart';

/// Arguments passed to the Shared Trip Rooms screen.
class SharedTripRoomsArgs {
  const SharedTripRoomsArgs({required this.pickup, required this.destination});

  final PlaceEntity pickup;
  final PlaceEntity destination;
}
