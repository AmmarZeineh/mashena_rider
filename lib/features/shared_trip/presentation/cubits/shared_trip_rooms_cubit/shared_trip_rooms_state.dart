import 'package:mashena_rider/features/home/domain/entities/place_entity.dart';
import '../../../domain/entities/shared_ride_room_entity.dart';

class SharedTripRoomsState {
  final PlaceEntity pickupPlace;
  final PlaceEntity destinationPlace;
  final List<SharedRideRoomEntity> rooms;
  final bool isLoading;
  final String? errorMessage;
  final int seatsNeeded;
  final double maxDistanceKm;

  const SharedTripRoomsState({
    required this.pickupPlace,
    required this.destinationPlace,
    this.rooms = const [],
    this.isLoading = false,
    this.errorMessage,
    this.seatsNeeded = 1,
    this.maxDistanceKm = 2.0,
  });

  SharedTripRoomsState copyWith({
    PlaceEntity? pickupPlace,
    PlaceEntity? destinationPlace,
    List<SharedRideRoomEntity>? rooms,
    bool? isLoading,
    String? Function()? errorMessage,
    int? seatsNeeded,
    double? maxDistanceKm,
  }) {
    return SharedTripRoomsState(
      pickupPlace: pickupPlace ?? this.pickupPlace,
      destinationPlace: destinationPlace ?? this.destinationPlace,
      rooms: rooms ?? this.rooms,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      seatsNeeded: seatsNeeded ?? this.seatsNeeded,
      maxDistanceKm: maxDistanceKm ?? this.maxDistanceKm,
    );
  }
}
