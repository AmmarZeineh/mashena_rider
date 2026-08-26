import 'package:equatable/equatable.dart';
import 'package:mashena_rider/features/pool/domain/entities/pool_room_entity.dart';

class PoolDiscoveryState extends Equatable {
  final bool isLoading;
  final bool isJoining;
  final List<PoolRoomEntity> rooms;
  final String? errorMessage;
  final PoolRoomEntity? joinedRoom;

  const PoolDiscoveryState({
    this.isLoading = false,
    this.isJoining = false,
    this.rooms = const [],
    this.errorMessage,
    this.joinedRoom,
  });

  PoolDiscoveryState copyWith({
    bool? isLoading,
    bool? isJoining,
    List<PoolRoomEntity>? rooms,
    String? errorMessage,
    PoolRoomEntity? joinedRoom,
    bool clearError = false,
    bool clearJoined = false,
  }) {
    return PoolDiscoveryState(
      isLoading: isLoading ?? this.isLoading,
      isJoining: isJoining ?? this.isJoining,
      rooms: rooms ?? this.rooms,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      joinedRoom: clearJoined ? null : (joinedRoom ?? this.joinedRoom),
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isJoining,
    rooms,
    errorMessage,
    joinedRoom,
  ];
}
