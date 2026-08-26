import 'package:equatable/equatable.dart';
import '../../../domain/entities/pool_room_entity.dart';

class PoolCreateState extends Equatable {
  final DateTime departureTime;
  final int maxPassengers;
  final int seatsNeeded;
  final bool isSubmitting;
  final PoolRoomEntity? createdRoom;
  final String? errorMessage;

  const PoolCreateState({
    required this.departureTime,
    this.maxPassengers = 4,
    this.seatsNeeded = 1,
    this.isSubmitting = false,
    this.createdRoom,
    this.errorMessage,
  });

  PoolCreateState copyWith({
    DateTime? departureTime,
    int? maxPassengers,
    int? seatsNeeded,
    bool? isSubmitting,
    PoolRoomEntity? createdRoom,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PoolCreateState(
      departureTime: departureTime ?? this.departureTime,
      maxPassengers: maxPassengers ?? this.maxPassengers,
      seatsNeeded: seatsNeeded ?? this.seatsNeeded,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      createdRoom: createdRoom ?? this.createdRoom,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    departureTime,
    maxPassengers,
    seatsNeeded,
    isSubmitting,
    createdRoom,
    errorMessage,
  ];
}
