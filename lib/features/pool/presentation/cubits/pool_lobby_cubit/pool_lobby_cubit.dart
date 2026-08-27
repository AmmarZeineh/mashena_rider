import 'dart:async';
import 'package:mashena_rider/core/base/base_cubit.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/core/services/osrm_route_service.dart';
import 'package:mashena_rider/features/auth/domain/usecases/get_cached_session_usecase.dart';
import 'package:mashena_rider/features/pool/domain/entities/pool_member_entity.dart';
import 'package:mashena_rider/features/pool/domain/entities/pool_room_entity.dart';
import 'package:mashena_rider/features/pool/domain/entities/pool_room_status.dart';
import 'package:mashena_rider/features/pool/domain/repositories/pool_repository.dart';
import 'package:mashena_rider/features/pool/domain/usecases/cancel_pool_room_usecase.dart';
import 'package:mashena_rider/features/pool/domain/usecases/get_pool_room_details_usecase.dart';
import 'package:mashena_rider/features/pool/domain/usecases/leave_pool_room_usecase.dart';
import 'pool_lobby_state.dart';

class PoolLobbyCubit extends BaseCubit<PoolLobbyState> {
  final GetPoolRoomDetailsUsecase _getPoolRoomDetailsUsecase;
  final LeavePoolRoomUsecase _leavePoolRoomUsecase;
  final CancelPoolRoomUsecase _cancelPoolRoomUsecase;
  final PoolRepository _repository;
  final GetCachedSessionUsecase _getCachedSessionUsecase;
  final OSRMRouteService _osrmRouteService;
  final int roomId;

  final List<StreamSubscription> _subscriptions = [];

  PoolLobbyCubit({
    required GetPoolRoomDetailsUsecase getPoolRoomDetailsUsecase,
    required LeavePoolRoomUsecase leavePoolRoomUsecase,
    required CancelPoolRoomUsecase cancelPoolRoomUsecase,
    required PoolRepository repository,
    required GetCachedSessionUsecase getCachedSessionUsecase,
    required OSRMRouteService osrmRouteService,
    required this.roomId,
  }) : _getPoolRoomDetailsUsecase = getPoolRoomDetailsUsecase,
       _leavePoolRoomUsecase = leavePoolRoomUsecase,
       _cancelPoolRoomUsecase = cancelPoolRoomUsecase,
       _repository = repository,
       _getCachedSessionUsecase = getCachedSessionUsecase,
       _osrmRouteService = osrmRouteService,
       super(const PoolLobbyState()) {
    _init();
  }

  Future<void> _init() async {
    await _initCurrentUser();
    await fetchRoomDetails();
    _initSocketSubscriptions();
    _repository.listenToRoom(roomId);
  }

  Future<void> _initCurrentUser() async {
    final result = await _getCachedSessionUsecase();
    result.fold(
      (_) {},
      (session) => emit(state.copyWith(currentUserId: session.user.id)),
    );
  }

  Future<void> fetchRoomDetails() async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await _getPoolRoomDetailsUsecase(roomId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          errorMessage: failure.rawMessage ?? failure.code.name,
        ),
      ),
      (room) {
        emit(state.copyWith(isLoading: false, room: room));
        _calculateWalkingRouteForCurrentRider(room);
      },
    );
  }

  void _initSocketSubscriptions() {
    // 1. Member Joined
    _subscriptions.add(
      _repository.memberJoinedStream.listen((payload) {
        if (payload.roomId != roomId) return;
        final currentRoom = state.room;
        if (currentRoom == null) return;

        List<PoolMemberEntity> updatedMembers = List.from(currentRoom.members);
        if (payload.member != null) {
          final newMember = payload.member!;
          final index = updatedMembers.indexWhere((m) => m.id == newMember.id);
          if (index >= 0) {
            updatedMembers[index] = newMember;
          } else {
            updatedMembers.add(newMember);
          }
        }

        final updatedRoom = currentRoom.copyWith(
          currentPassengers: payload.currentPassengers,
          members: updatedMembers,
          meetingLat: payload.meetingLat ?? currentRoom.meetingLat,
          meetingLng: payload.meetingLng ?? currentRoom.meetingLng,
          meetingAddress: payload.meetingAddress ?? currentRoom.meetingAddress,
        );

        emit(state.copyWith(room: updatedRoom));
        _calculateWalkingRouteForCurrentRider(updatedRoom);
      }),
    );

    // 2. Member Left
    _subscriptions.add(
      _repository.memberLeftStream.listen((payload) {
        if (payload.roomId != roomId) return;
        final currentRoom = state.room;
        if (currentRoom == null) return;

        List<PoolMemberEntity> updatedMembers = List.from(currentRoom.members);
        if (payload.riderProfileId != null) {
          final leftRiderId = payload.riderProfileId!;
          updatedMembers.removeWhere((m) => m.riderProfileId == leftRiderId);
        }

        final updatedRoom = currentRoom.copyWith(
          currentPassengers: payload.currentPassengers,
          members: updatedMembers,
          meetingLat: payload.meetingLat ?? currentRoom.meetingLat,
          meetingLng: payload.meetingLng ?? currentRoom.meetingLng,
          meetingAddress: payload.meetingAddress ?? currentRoom.meetingAddress,
        );

        emit(state.copyWith(room: updatedRoom));
        _calculateWalkingRouteForCurrentRider(updatedRoom);
      }),
    );

    // 3. Meeting Point Updated
    _subscriptions.add(
      _repository.meetingPointUpdatedStream.listen((payload) {
        if (payload.roomId != roomId) return;
        final currentRoom = state.room;
        if (currentRoom == null) return;

        final updatedRoom = currentRoom.copyWith(
          meetingLat: payload.meetingLat,
          meetingLng: payload.meetingLng,
          meetingAddress: payload.meetingAddress ?? currentRoom.meetingAddress,
        );

        emit(
          state.copyWith(
            room: updatedRoom,
            toastMessage: 'Meeting point updated to match all passengers!',
          ),
        );
        _calculateWalkingRouteForCurrentRider(updatedRoom);
      }),
    );

    // 4. Room Ready For Driver
    _subscriptions.add(
      _repository.roomReadyStream.listen((payload) {
        if (payload.roomId != roomId) return;
        final currentRoom = state.room;
        if (currentRoom == null) return;

        final updatedRoom = currentRoom.copyWith(
          status: PoolRoomStatus.fromString(payload.status),
          currentPassengers: payload.currentPassengers,
        );

        emit(
          state.copyWith(
            room: updatedRoom,
            toastMessage: 'Pool is full! Finding a driver for the ride.',
          ),
        );
      }),
    );

    // 5. Matched with Driver
    _subscriptions.add(
      _repository.matchedStream.listen((payload) {
        if (payload.roomId != roomId) return;

        emit(
          state.copyWith(
            matchedSharedRideId: payload.sharedRideId,
            matchedDriverProfileId: payload.driverProfileId,
          ),
        );
      }),
    );

    // 6. Expired
    _subscriptions.add(
      _repository.expiredStream.listen((payload) {
        if (payload.roomId != roomId) return;
        emit(state.copyWith(isExpired: true));
      }),
    );

    // 7. Cancelled
    _subscriptions.add(
      _repository.cancelledStream.listen((payload) {
        if (payload.roomId != roomId) return;
        emit(state.copyWith(isCancelled: true));
      }),
    );

    // 8. Removed
    _subscriptions.add(
      _repository.removedStream.listen((payload) {
        if (payload.roomId != roomId) return;
        emit(state.copyWith(isRemoved: true));
      }),
    );
  }

  Future<void> _calculateWalkingRouteForCurrentRider(
    PoolRoomEntity room,
  ) async {
    double myPickupLat = room.meetingLat;
    double myPickupLng = room.meetingLng;

    final myMember = room.members
        .where((m) => m.riderProfileId == state.currentUserId)
        .firstOrNull;
    if (myMember != null) {
      myPickupLat = myMember.pickupLat;
      myPickupLng = myMember.pickupLng;
    }

    final points = [
      MapLatLng(latitude: myPickupLat, longitude: myPickupLng),
      MapLatLng(latitude: room.meetingLat, longitude: room.meetingLng),
    ];

    if ((myPickupLat - room.meetingLat).abs() < 0.0001 &&
        (myPickupLng - room.meetingLng).abs() < 0.0001) {
      emit(
        state.copyWith(
          walkingRoutePoints: points,
          walkingDistanceMeters: 0,
          walkingDurationSeconds: 0,
        ),
      );
      return;
    }

    final routeDetails = await _osrmRouteService.getRouteDetails(points);
    if (routeDetails != null) {
      emit(
        state.copyWith(
          walkingRoutePoints: routeDetails.points,
          walkingDistanceMeters: routeDetails.distance,
          walkingDurationSeconds: routeDetails.duration,
        ),
      );
    }
  }

  Future<void> leaveRoom() async {
    emit(state.copyWith(isLeaving: true, clearError: true));

    final result = await _leavePoolRoomUsecase(roomId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLeaving: false,
          errorMessage: failure.rawMessage ?? failure.code.name,
        ),
      ),
      (room) =>
          emit(state.copyWith(isLeaving: false, hasLeftOrCancelled: true)),
    );
  }

  Future<void> cancelRoom() async {
    emit(state.copyWith(isCancelling: true, clearError: true));

    final result = await _cancelPoolRoomUsecase(roomId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isCancelling: false,
          errorMessage: failure.rawMessage ?? failure.code.name,
        ),
      ),
      (room) =>
          emit(state.copyWith(isCancelling: false, hasLeftOrCancelled: true)),
    );
  }

  @override
  Future<void> close() async {
    _repository.stopListeningToRoom(roomId);
    for (final sub in _subscriptions) {
      await sub.cancel();
    }
    _subscriptions.clear();
    return super.close();
  }
}
