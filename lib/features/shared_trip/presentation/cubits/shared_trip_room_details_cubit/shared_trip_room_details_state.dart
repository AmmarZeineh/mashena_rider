import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import '../../../data/models/shared_ride_socket_events.dart';
import '../../../domain/entities/shared_ride_passenger_entity.dart';
import '../../../domain/entities/shared_ride_room_details_entity.dart';

sealed class SharedTripRoomDetailsState {
  const SharedTripRoomDetailsState();
}

final class SharedTripRoomDetailsInitial extends SharedTripRoomDetailsState {
  const SharedTripRoomDetailsInitial();
}

final class SharedTripRoomDetailsLoading extends SharedTripRoomDetailsState {
  const SharedTripRoomDetailsLoading();
}

final class SharedTripRoomDetailsSuccess extends SharedTripRoomDetailsState {
  final SharedRideRoomDetailsEntity details;
  final bool isJoining;
  final bool isLeaving;
  final String? actionError;
  final SharedRidePassengerEntity? joinedPassenger;
  final MapLatLng? driverLocation;
  final Set<int> onlineUserIds;
  final bool? isDriverOnline;
  final bool isCurrentRiderRemoved;
  final String? removalReason;
  final SharedRidePassengerDroppedPayload? currentUserDroppedOffPayload;
  final String? liveNotice;

  const SharedTripRoomDetailsSuccess(
    this.details, {
    this.isJoining = false,
    this.isLeaving = false,
    this.actionError,
    this.joinedPassenger,
    this.driverLocation,
    this.onlineUserIds = const {},
    this.isDriverOnline,
    this.isCurrentRiderRemoved = false,
    this.removalReason,
    this.currentUserDroppedOffPayload,
    this.liveNotice,
  });

  bool get isDriverCurrentlyOnline =>
      isDriverOnline ?? (details.driver?.isOnline ?? false);

  SharedTripRoomDetailsSuccess copyWith({
    SharedRideRoomDetailsEntity? details,
    bool? isJoining,
    bool? isLeaving,
    String? Function()? actionError,
    SharedRidePassengerEntity? Function()? joinedPassenger,
    MapLatLng? Function()? driverLocation,
    Set<int>? onlineUserIds,
    bool? Function()? isDriverOnline,
    bool? isCurrentRiderRemoved,
    String? Function()? removalReason,
    SharedRidePassengerDroppedPayload? Function()? currentUserDroppedOffPayload,
    String? Function()? liveNotice,
  }) {
    return SharedTripRoomDetailsSuccess(
      details ?? this.details,
      isJoining: isJoining ?? this.isJoining,
      isLeaving: isLeaving ?? this.isLeaving,
      actionError: actionError != null ? actionError() : this.actionError,
      joinedPassenger: joinedPassenger != null
          ? joinedPassenger()
          : this.joinedPassenger,
      driverLocation: driverLocation != null
          ? driverLocation()
          : this.driverLocation,
      onlineUserIds: onlineUserIds ?? this.onlineUserIds,
      isDriverOnline: isDriverOnline != null
          ? isDriverOnline()
          : this.isDriverOnline,
      isCurrentRiderRemoved:
          isCurrentRiderRemoved ?? this.isCurrentRiderRemoved,
      removalReason: removalReason != null
          ? removalReason()
          : this.removalReason,
      currentUserDroppedOffPayload: currentUserDroppedOffPayload != null
          ? currentUserDroppedOffPayload()
          : this.currentUserDroppedOffPayload,
      liveNotice: liveNotice != null ? liveNotice() : this.liveNotice,
    );
  }
}

final class SharedTripRoomDetailsError extends SharedTripRoomDetailsState {
  final String message;

  const SharedTripRoomDetailsError(this.message);
}
