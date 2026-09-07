import 'package:mashena_rider/features/home/domain/entities/place_entity.dart';
import 'package:mashena_rider/features/pool/domain/entities/pool_room_entity.dart';
import '../../../domain/entities/shared_ride_room_entity.dart';

/// Available filters in the unified ride search view.
enum UnifiedRideFilter { all, driverRides, poolLobbies }

/// Sealed class representing items in the unified search results list.
sealed class UnifiedRideItem {
  const UnifiedRideItem();
}

class DriverRideItem extends UnifiedRideItem {
  final SharedRideRoomEntity room;
  const DriverRideItem(this.room);
}

class PoolLobbyItem extends UnifiedRideItem {
  final PoolRoomEntity room;
  const PoolLobbyItem(this.room);
}

class SharedTripRoomsState {
  final PlaceEntity pickupPlace;
  final PlaceEntity destinationPlace;
  final List<SharedRideRoomEntity> sharedRooms;
  final List<PoolRoomEntity> poolRooms;
  final UnifiedRideFilter activeFilter;
  final bool isLoading;
  final bool isJoiningPool;
  final PoolRoomEntity? joinedPoolRoom;
  final String? errorMessage;
  final int seatsNeeded;
  final double maxDistanceKm;

  const SharedTripRoomsState({
    required this.pickupPlace,
    required this.destinationPlace,
    this.sharedRooms = const [],
    this.poolRooms = const [],
    this.activeFilter = UnifiedRideFilter.all,
    this.isLoading = false,
    this.isJoiningPool = false,
    this.joinedPoolRoom,
    this.errorMessage,
    this.seatsNeeded = 1,
    this.maxDistanceKm = 2.0,
  });

  /// Backward-compatibility getter for existing code referencing `rooms`.
  List<SharedRideRoomEntity> get rooms => sharedRooms;

  int get totalCount => sharedRooms.length + poolRooms.length;
  int get driverRidesCount => sharedRooms.length;
  int get poolLobbiesCount => poolRooms.length;

  bool get hasAnyRooms => totalCount > 0;

  List<UnifiedRideItem> get displayedItems {
    return switch (activeFilter) {
      UnifiedRideFilter.all => [
        ...sharedRooms.map(DriverRideItem.new),
        ...poolRooms.map(PoolLobbyItem.new),
      ],
      UnifiedRideFilter.driverRides =>
        sharedRooms.map(DriverRideItem.new).toList(),
      UnifiedRideFilter.poolLobbies =>
        poolRooms.map(PoolLobbyItem.new).toList(),
    };
  }

  SharedTripRoomsState copyWith({
    PlaceEntity? pickupPlace,
    PlaceEntity? destinationPlace,
    List<SharedRideRoomEntity>? sharedRooms,
    List<SharedRideRoomEntity>? rooms,
    List<PoolRoomEntity>? poolRooms,
    UnifiedRideFilter? activeFilter,
    bool? isLoading,
    bool? isJoiningPool,
    PoolRoomEntity? Function()? joinedPoolRoom,
    String? Function()? errorMessage,
    int? seatsNeeded,
    double? maxDistanceKm,
  }) {
    return SharedTripRoomsState(
      pickupPlace: pickupPlace ?? this.pickupPlace,
      destinationPlace: destinationPlace ?? this.destinationPlace,
      sharedRooms: sharedRooms ?? rooms ?? this.sharedRooms,
      poolRooms: poolRooms ?? this.poolRooms,
      activeFilter: activeFilter ?? this.activeFilter,
      isLoading: isLoading ?? this.isLoading,
      isJoiningPool: isJoiningPool ?? this.isJoiningPool,
      joinedPoolRoom: joinedPoolRoom != null
          ? joinedPoolRoom()
          : this.joinedPoolRoom,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      seatsNeeded: seatsNeeded ?? this.seatsNeeded,
      maxDistanceKm: maxDistanceKm ?? this.maxDistanceKm,
    );
  }
}
