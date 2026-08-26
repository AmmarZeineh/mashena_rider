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
  final int? currentUserId;
  final bool isJoining;
  final bool isLeaving;
  final bool hasLeft;
  final String? actionError;
  final SharedRidePassengerEntity? joinedPassenger;
  final MapLatLng? driverLocation;
  final Set<int> onlineUserIds;
  final bool? isDriverOnline;
  final bool isCurrentRiderRemoved;
  final String? removalReason;
  final SharedRidePassengerDroppedPayload? currentUserDroppedOffPayload;
  final SharedRidePassengerDroppedPayload? companionDroppedPayload;
  final String? liveNotice;

  const SharedTripRoomDetailsSuccess(
    this.details, {
    this.currentUserId,
    this.isJoining = false,
    this.isLeaving = false,
    this.hasLeft = false,
    this.actionError,
    this.joinedPassenger,
    this.driverLocation,
    this.onlineUserIds = const {},
    this.isDriverOnline,
    this.isCurrentRiderRemoved = false,
    this.removalReason,
    this.currentUserDroppedOffPayload,
    this.companionDroppedPayload,
    this.liveNotice,
  });

  bool get isDriverCurrentlyOnline =>
      isDriverOnline ?? (details.driver?.isOnline ?? false);

  bool get isUserJoined {
    if (joinedPassenger != null) return true;
    if (currentUserId == null) return false;
    return details.passengers.any(
      (p) =>
          p.riderProfileId == currentUserId &&
          (p.status.toUpperCase() == 'JOINED' ||
              p.status.toUpperCase() == 'ON_BOARD'),
    );
  }

  SharedTripRoomDetailsSuccess copyWith({
    SharedRideRoomDetailsEntity? details,
    int? currentUserId,
    bool? isJoining,
    bool? isLeaving,
    bool? hasLeft,
    String? Function()? actionError,
    SharedRidePassengerEntity? Function()? joinedPassenger,
    MapLatLng? Function()? driverLocation,
    Set<int>? onlineUserIds,
    bool? Function()? isDriverOnline,
    bool? isCurrentRiderRemoved,
    String? Function()? removalReason,
    SharedRidePassengerDroppedPayload? Function()? currentUserDroppedOffPayload,
    SharedRidePassengerDroppedPayload? Function()? companionDroppedPayload,
    String? Function()? liveNotice,
  }) {
    return SharedTripRoomDetailsSuccess(
      details ?? this.details,
      currentUserId: currentUserId ?? this.currentUserId,
      isJoining: isJoining ?? this.isJoining,
      isLeaving: isLeaving ?? this.isLeaving,
      hasLeft: hasLeft ?? this.hasLeft,
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
      companionDroppedPayload: companionDroppedPayload != null
          ? companionDroppedPayload()
          : this.companionDroppedPayload,
      liveNotice: liveNotice != null ? liveNotice() : this.liveNotice,
    );
  }
}

final class SharedTripRoomDetailsError extends SharedTripRoomDetailsState {
  final String message;

  const SharedTripRoomDetailsError(this.message);
}
