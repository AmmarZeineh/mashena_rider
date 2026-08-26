import 'package:equatable/equatable.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/features/pool/domain/entities/pool_room_entity.dart';

class PoolLobbyState extends Equatable {
  final bool isLoading;
  final PoolRoomEntity? room;
  final int? currentUserId;
  final List<MapLatLng> walkingRoutePoints;
  final double? walkingDistanceMeters;
  final double? walkingDurationSeconds;
  final bool isLeaving;
  final bool isCancelling;
  final bool hasLeftOrCancelled;
  final int? matchedSharedRideId;
  final int? matchedDriverProfileId;
  final bool isExpired;
  final bool isCancelled;
  final bool isRemoved;
  final String? errorMessage;
  final String? toastMessage;

  const PoolLobbyState({
    this.isLoading = true,
    this.room,
    this.currentUserId,
    this.walkingRoutePoints = const [],
    this.walkingDistanceMeters,
    this.walkingDurationSeconds,
    this.isLeaving = false,
    this.isCancelling = false,
    this.hasLeftOrCancelled = false,
    this.matchedSharedRideId,
    this.matchedDriverProfileId,
    this.isExpired = false,
    this.isCancelled = false,
    this.isRemoved = false,
    this.errorMessage,
    this.toastMessage,
  });

  bool get isCreator =>
      room != null &&
      currentUserId != null &&
      room!.creatorRiderProfileId == currentUserId;

  PoolLobbyState copyWith({
    bool? isLoading,
    PoolRoomEntity? room,
    int? currentUserId,
    List<MapLatLng>? walkingRoutePoints,
    double? walkingDistanceMeters,
    double? walkingDurationSeconds,
    bool? isLeaving,
    bool? isCancelling,
    bool? hasLeftOrCancelled,
    int? matchedSharedRideId,
    int? matchedDriverProfileId,
    bool? isExpired,
    bool? isCancelled,
    bool? isRemoved,
    String? errorMessage,
    String? toastMessage,
    bool clearError = false,
    bool clearToast = false,
  }) {
    return PoolLobbyState(
      isLoading: isLoading ?? this.isLoading,
      room: room ?? this.room,
      currentUserId: currentUserId ?? this.currentUserId,
      walkingRoutePoints: walkingRoutePoints ?? this.walkingRoutePoints,
      walkingDistanceMeters:
          walkingDistanceMeters ?? this.walkingDistanceMeters,
      walkingDurationSeconds:
          walkingDurationSeconds ?? this.walkingDurationSeconds,
      isLeaving: isLeaving ?? this.isLeaving,
      isCancelling: isCancelling ?? this.isCancelling,
      hasLeftOrCancelled: hasLeftOrCancelled ?? this.hasLeftOrCancelled,
      matchedSharedRideId: matchedSharedRideId ?? this.matchedSharedRideId,
      matchedDriverProfileId:
          matchedDriverProfileId ?? this.matchedDriverProfileId,
      isExpired: isExpired ?? this.isExpired,
      isCancelled: isCancelled ?? this.isCancelled,
      isRemoved: isRemoved ?? this.isRemoved,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      toastMessage: clearToast ? null : (toastMessage ?? this.toastMessage),
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    room,
    currentUserId,
    walkingRoutePoints,
    walkingDistanceMeters,
    walkingDurationSeconds,
    isLeaving,
    isCancelling,
    hasLeftOrCancelled,
    matchedSharedRideId,
    matchedDriverProfileId,
    isExpired,
    isCancelled,
    isRemoved,
    errorMessage,
    toastMessage,
  ];
}
