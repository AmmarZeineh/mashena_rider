import 'dart:async';
import 'package:mashena_rider/core/base/base_cubit.dart';
import 'package:mashena_rider/features/auth/domain/usecases/get_cached_session_usecase.dart';
import '../../../domain/entities/join_shared_ride_params.dart';
import '../../../domain/entities/shared_ride_passenger_entity.dart';
import '../../../domain/entities/shared_ride_room_details_entity.dart';
import '../../../domain/repositories/shared_trip_repository.dart';
import '../../../domain/usecases/get_shared_ride_details_usecase.dart';
import '../../../domain/usecases/join_shared_ride_usecase.dart';
import '../../../domain/usecases/leave_shared_ride_usecase.dart';
import 'shared_trip_room_details_state.dart';

class SharedTripRoomDetailsCubit extends BaseCubit<SharedTripRoomDetailsState> {
  final GetSharedRideDetailsUsecase _getSharedRideDetailsUsecase;
  final JoinSharedRideUsecase _joinSharedRideUsecase;
  final LeaveSharedRideUsecase _leaveSharedRideUsecase;
  final SharedTripRepository _repository;
  final GetCachedSessionUsecase _getCachedSessionUsecase;
  final int roomId;

  final List<StreamSubscription> _subscriptions = [];
  int? _currentUserId;

  SharedTripRoomDetailsCubit({
    required GetSharedRideDetailsUsecase getSharedRideDetailsUsecase,
    required JoinSharedRideUsecase joinSharedRideUsecase,
    required LeaveSharedRideUsecase leaveSharedRideUsecase,
    required SharedTripRepository repository,
    required GetCachedSessionUsecase getCachedSessionUsecase,
    required this.roomId,
  }) : _getSharedRideDetailsUsecase = getSharedRideDetailsUsecase,
       _joinSharedRideUsecase = joinSharedRideUsecase,
       _leaveSharedRideUsecase = leaveSharedRideUsecase,
       _repository = repository,
       _getCachedSessionUsecase = getCachedSessionUsecase,
       super(const SharedTripRoomDetailsInitial()) {
    _initCurrentUser();
    _initSocketSubscriptions();
    _repository.listenToRoom(roomId);
  }

  Future<void> _initCurrentUser() async {
    final result = await _getCachedSessionUsecase();
    result.fold((_) {}, (session) {
      _currentUserId = session.user.id;
      final currentState = state;
      if (currentState is SharedTripRoomDetailsSuccess) {
        emit(currentState.copyWith(currentUserId: _currentUserId));
      }
    });
  }

  void _initSocketSubscriptions() {
    // 1. Driver location updates
    _subscriptions.add(
      _repository.driverLocationStream.listen((payload) {
        if (payload.sharedRideId != roomId) return;
        final currentState = state;
        if (currentState is SharedTripRoomDetailsSuccess) {
          emit(currentState.copyWith(driverLocation: () => payload.position));
        }
      }),
    );

    // 2. Passenger joined room
    _subscriptions.add(
      _repository.passengerJoinedStream.listen((payload) {
        if (payload.sharedRideId != roomId) return;
        final currentState = state;
        if (currentState is SharedTripRoomDetailsSuccess) {
          final newPassenger = payload.passenger.toEntity();
          final updatedPassengers = List<SharedRidePassengerEntity>.from(
            currentState.details.passengers,
          );

          // Avoid duplicating if already present
          final index = updatedPassengers.indexWhere(
            (p) => p.id == newPassenger.id,
          );
          if (index >= 0) {
            updatedPassengers[index] = newPassenger;
          } else {
            updatedPassengers.add(newPassenger);
          }

          final updatedOccupied =
              currentState.details.occupiedSeats +
              (index >= 0 ? 0 : newPassenger.seatsNeeded);

          final updatedDetails = SharedRideRoomDetailsEntity(
            id: currentState.details.id,
            driverProfileId: currentState.details.driverProfileId,
            vehicleId: currentState.details.vehicleId,
            driver: currentState.details.driver,
            vehicle: currentState.details.vehicle,
            status: currentState.details.status,
            endedBy: currentState.details.endedBy,
            notes: currentState.details.notes,
            originLat: currentState.details.originLat,
            originLng: currentState.details.originLng,
            originAddress: currentState.details.originAddress,
            destLat: currentState.details.destLat,
            destLng: currentState.details.destLng,
            destAddress: currentState.details.destAddress,
            departureTime: currentState.details.departureTime,
            maxPassengers: currentState.details.maxPassengers,
            occupiedSeats: updatedOccupied,
            totalDistanceKm: currentState.details.totalDistanceKm,
            totalDurationSec: currentState.details.totalDurationSec,
            routeGeometry: currentState.details.routeGeometry,
            actualDistanceKm: currentState.details.actualDistanceKm,
            actualDurationSec: currentState.details.actualDurationSec,
            actualRouteGeometry: currentState.details.actualRouteGeometry,
            baseTripFare: currentState.details.baseTripFare,
            remainingTripCost: currentState.details.remainingTripCost,
            occupiedSeatsAtStart: currentState.details.occupiedSeatsAtStart,
            fullRouteSeatFare: currentState.details.fullRouteSeatFare,
            minimumSeatFare: currentState.details.minimumSeatFare,
            startedAt: currentState.details.startedAt,
            completedAt: currentState.details.completedAt,
            canceledAt: currentState.details.canceledAt,
            cancellationReason: currentState.details.cancellationReason,
            endType: currentState.details.endType,
            createdAt: currentState.details.createdAt,
            passengers: updatedPassengers,
          );

          final name = newPassenger.riderName?.isNotEmpty == true
              ? newPassenger.riderName!
              : 'A passenger';

          emit(
            currentState.copyWith(
              details: updatedDetails,
              liveNotice: () => '$name joined the room',
            ),
          );
        }
      }),
    );

    // 3. Passenger left room (voluntary)
    _subscriptions.add(
      _repository.passengerLeftStream.listen((payload) {
        if (payload.sharedRideId != roomId) return;
        final currentState = state;
        if (currentState is SharedTripRoomDetailsSuccess) {
          final updatedDetails = payload.ride != null
              ? payload.ride!.toEntity()
              : currentState.details;

          emit(
            currentState.copyWith(
              details: updatedDetails,
              liveNotice: () => 'A passenger left the room',
            ),
          );
        }
      }),
    );

    // 4. Passenger removed by driver (broadcast to room)
    _subscriptions.add(
      _repository.passengerRemovedStream.listen((payload) {
        if (payload.sharedRideId != roomId) return;
        final currentState = state;
        if (currentState is SharedTripRoomDetailsSuccess) {
          if (_currentUserId != null && payload.userId == _currentUserId) {
            emit(
              currentState.copyWith(
                isCurrentRiderRemoved: true,
                removalReason: () => payload.reason,
              ),
            );
            return;
          }

          final updatedDetails = payload.ride != null
              ? payload.ride!.toEntity()
              : currentState.details;

          emit(
            currentState.copyWith(
              details: updatedDetails,
              liveNotice: () => 'A passenger was removed from the ride',
            ),
          );
        }
      }),
    );

    // 5. Private removed event for rider
    _subscriptions.add(
      _repository.riderRemovedStream.listen((payload) {
        if (payload.sharedRideId != roomId) return;
        final currentState = state;
        if (currentState is SharedTripRoomDetailsSuccess) {
          if (_currentUserId != null && payload.userId == _currentUserId) {
            emit(
              currentState.copyWith(
                isCurrentRiderRemoved: true,
                removalReason: () => payload.reason,
              ),
            );
          }
        }
      }),
    );

    // 6. Room ready
    _subscriptions.add(
      _repository.roomReadyStream.listen((payload) {
        if (payload.sharedRideId != roomId) return;
        final currentState = state;
        if (currentState is SharedTripRoomDetailsSuccess) {
          final updatedDetails = payload.ride != null
              ? payload.ride!.toEntity()
              : currentState.details;

          emit(
            currentState.copyWith(
              details: updatedDetails,
              liveNotice: () =>
                  'The driver is ready and heading to start the route!',
            ),
          );
        }
      }),
    );

    // 7. Trip started (IN_PROGRESS)
    _subscriptions.add(
      _repository.tripStartedStream.listen((payload) {
        if (payload.sharedRideId != roomId) return;
        final currentState = state;
        if (currentState is SharedTripRoomDetailsSuccess) {
          final updatedDetails = payload.ride != null
              ? payload.ride!.toEntity()
              : currentState.details;

          emit(
            currentState.copyWith(
              details: updatedDetails,
              liveNotice: () => 'Trip has started! Tracking live route.',
            ),
          );
        }
      }),
    );

    // 8. Passenger boarded
    _subscriptions.add(
      _repository.passengerOnBoardStream.listen((payload) {
        if (payload.sharedRideId != roomId) return;
        final currentState = state;
        if (currentState is SharedTripRoomDetailsSuccess) {
          final isCurrentUser =
              _currentUserId != null && payload.userId == _currentUserId;

          final updatedPassengers = currentState.details.passengers.map((p) {
            if (p.id == payload.passengerId ||
                p.riderProfileId == payload.riderProfileId) {
              return SharedRidePassengerEntity(
                id: p.id,
                sharedRideId: p.sharedRideId,
                riderProfileId: p.riderProfileId,
                riderName: p.riderName,
                status: 'ON_BOARD',
                paymentStatus: p.paymentStatus,
                seatsNeeded: p.seatsNeeded,
                activeSeats: p.activeSeats,
                totalPaidFare: p.totalPaidFare,
                finalDistanceKm: p.finalDistanceKm,
                finalDurationSec: p.finalDurationSec,
                finalFare: p.finalFare,
                joinedAt: p.joinedAt,
                onBoardAt: payload.onBoardAt ?? p.onBoardAt ?? DateTime.now(),
                droppedOffAt: p.droppedOffAt,
                accountHolderOnBoard: true,
                accountHolderDroppedOffAt: p.accountHolderDroppedOffAt,
                leftAt: p.leftAt,
                canceledAt: p.canceledAt,
                removedAt: p.removedAt,
                removeReason: p.removeReason,
              );
            }
            return p;
          }).toList();

          final updatedDetails = SharedRideRoomDetailsEntity(
            id: currentState.details.id,
            driverProfileId: currentState.details.driverProfileId,
            vehicleId: currentState.details.vehicleId,
            driver: currentState.details.driver,
            vehicle: currentState.details.vehicle,
            status: currentState.details.status,
            endedBy: currentState.details.endedBy,
            notes: currentState.details.notes,
            originLat: currentState.details.originLat,
            originLng: currentState.details.originLng,
            originAddress: currentState.details.originAddress,
            destLat: currentState.details.destLat,
            destLng: currentState.details.destLng,
            destAddress: currentState.details.destAddress,
            departureTime: currentState.details.departureTime,
            maxPassengers: currentState.details.maxPassengers,
            occupiedSeats: currentState.details.occupiedSeats,
            totalDistanceKm: currentState.details.totalDistanceKm,
            totalDurationSec: currentState.details.totalDurationSec,
            routeGeometry: currentState.details.routeGeometry,
            actualDistanceKm: currentState.details.actualDistanceKm,
            actualDurationSec: currentState.details.actualDurationSec,
            actualRouteGeometry: currentState.details.actualRouteGeometry,
            baseTripFare: currentState.details.baseTripFare,
            remainingTripCost: currentState.details.remainingTripCost,
            occupiedSeatsAtStart: currentState.details.occupiedSeatsAtStart,
            fullRouteSeatFare: currentState.details.fullRouteSeatFare,
            minimumSeatFare: currentState.details.minimumSeatFare,
            startedAt: currentState.details.startedAt,
            completedAt: currentState.details.completedAt,
            canceledAt: currentState.details.canceledAt,
            cancellationReason: currentState.details.cancellationReason,
            endType: currentState.details.endType,
            createdAt: currentState.details.createdAt,
            passengers: updatedPassengers,
          );

          emit(
            currentState.copyWith(
              details: updatedDetails,
              liveNotice: () =>
                  isCurrentUser ? 'You are onboard! Have a safe trip.' : null,
            ),
          );
        }
      }),
    );

    // 9. Passenger dropped off
    _subscriptions.add(
      _repository.passengerDroppedStream.listen((payload) {
        if (payload.sharedRideId != roomId) return;
        final currentState = state;
        if (currentState is SharedTripRoomDetailsSuccess) {
          final isCurrentUser =
              _currentUserId != null && payload.userId == _currentUserId;

          final isAccountHolderDropped = !payload.accountHolderOnBoard ||
              payload.passengerStatus == 'DROPPED_OFF' ||
              payload.accountHolderDroppedOffAt != null ||
              (payload.activeSeats != null && payload.activeSeats == 0);

          final updatedPassengers = currentState.details.passengers.map((p) {
            if (p.id == payload.passengerId ||
                p.riderProfileId == payload.riderProfileId) {
              return SharedRidePassengerEntity(
                id: p.id,
                sharedRideId: p.sharedRideId,
                riderProfileId: p.riderProfileId,
                riderName: p.riderName,
                status: payload.passengerStatus ??
                    (isAccountHolderDropped ? 'DROPPED_OFF' : p.status),
                paymentStatus:
                    payload.passenger?.paymentStatus ?? p.paymentStatus,
                seatsNeeded: payload.seatsNeeded ?? p.seatsNeeded,
                activeSeats: payload.activeSeats ??
                    (isAccountHolderDropped
                        ? 0
                        : (p.activeSeats > 1 ? p.activeSeats - 1 : 1)),
                totalPaidFare: payload.totalPaidFare ?? p.totalPaidFare,
                finalDistanceKm: payload.finalDistanceKm ?? p.finalDistanceKm,
                finalDurationSec:
                    payload.finalDurationSec ?? p.finalDurationSec,
                finalFare: payload.finalFare ?? p.finalFare,
                joinedAt: p.joinedAt,
                onBoardAt: p.onBoardAt,
                droppedOffAt: isAccountHolderDropped
                    ? (payload.droppedOffAt ?? p.droppedOffAt ?? DateTime.now())
                    : p.droppedOffAt,
                accountHolderOnBoard: payload.accountHolderOnBoard,
                accountHolderDroppedOffAt: payload.accountHolderDroppedOffAt ??
                    (isAccountHolderDropped
                        ? (payload.droppedOffAt ?? DateTime.now())
                        : p.accountHolderDroppedOffAt),
                leftAt: p.leftAt,
                canceledAt: p.canceledAt,
                removedAt: p.removedAt,
                removeReason: p.removeReason,
              );
            }
            return p;
          }).toList();

          final updatedDetails = SharedRideRoomDetailsEntity(
            id: currentState.details.id,
            driverProfileId: currentState.details.driverProfileId,
            vehicleId: currentState.details.vehicleId,
            driver: currentState.details.driver,
            vehicle: currentState.details.vehicle,
            status: currentState.details.status,
            endedBy: currentState.details.endedBy,
            notes: currentState.details.notes,
            originLat: currentState.details.originLat,
            originLng: currentState.details.originLng,
            originAddress: currentState.details.originAddress,
            destLat: currentState.details.destLat,
            destLng: currentState.details.destLng,
            destAddress: currentState.details.destAddress,
            departureTime: currentState.details.departureTime,
            maxPassengers: currentState.details.maxPassengers,
            occupiedSeats: currentState.details.occupiedSeats,
            totalDistanceKm: currentState.details.totalDistanceKm,
            totalDurationSec: currentState.details.totalDurationSec,
            routeGeometry: currentState.details.routeGeometry,
            actualDistanceKm: currentState.details.actualDistanceKm,
            actualDurationSec: currentState.details.actualDurationSec,
            actualRouteGeometry: currentState.details.actualRouteGeometry,
            baseTripFare: currentState.details.baseTripFare,
            remainingTripCost: currentState.details.remainingTripCost,
            occupiedSeatsAtStart: currentState.details.occupiedSeatsAtStart,
            fullRouteSeatFare: currentState.details.fullRouteSeatFare,
            minimumSeatFare: currentState.details.minimumSeatFare,
            startedAt: currentState.details.startedAt,
            completedAt: currentState.details.completedAt,
            canceledAt: currentState.details.canceledAt,
            cancellationReason: currentState.details.cancellationReason,
            endType: currentState.details.endType,
            createdAt: currentState.details.createdAt,
            passengers: updatedPassengers,
          );

          if (isCurrentUser) {
            if (isAccountHolderDropped) {
              emit(
                currentState.copyWith(
                  details: updatedDetails,
                  currentUserDroppedOffPayload: () => payload,
                  companionDroppedPayload: () => null,
                  liveNotice: () => 'You have arrived at your destination!',
                ),
              );
            } else {
              emit(
                currentState.copyWith(
                  details: updatedDetails,
                  companionDroppedPayload: () => payload,
                  currentUserDroppedOffPayload: () => null,
                  liveNotice: () => null,
                ),
              );
            }
          } else {
            emit(
              currentState.copyWith(
                details: updatedDetails,
              ),
            );
          }
        }
      }),
    );

    // 10. Trip completed
    _subscriptions.add(
      _repository.tripCompletedStream.listen((payload) {
        if (payload.sharedRideId != roomId) return;
        final currentState = state;
        if (currentState is SharedTripRoomDetailsSuccess) {
          final updatedDetails = payload.ride != null
              ? payload.ride!.toEntity()
              : currentState.details;

          emit(
            currentState.copyWith(
              details: updatedDetails,
              liveNotice: () => 'Trip completed! Thank you for riding.',
            ),
          );
        }
      }),
    );

    // 11. Trip cancelled
    _subscriptions.add(
      _repository.tripCancelledStream.listen((payload) {
        if (payload.sharedRideId != roomId) return;
        final currentState = state;
        if (currentState is SharedTripRoomDetailsSuccess) {
          final updatedDetails = payload.ride != null
              ? payload.ride!.toEntity()
              : currentState.details;

          emit(
            currentState.copyWith(
              details: updatedDetails,
              liveNotice: () => 'The ride has been canceled by the driver.',
            ),
          );
        }
      }),
    );

    // 12. Presence updates
    _subscriptions.add(
      _repository.presenceStream.listen((payload) {
        if (payload.sharedRideId != roomId) return;
        final currentState = state;
        if (currentState is SharedTripRoomDetailsSuccess) {
          if (payload.isDriver) {
            emit(currentState.copyWith(isDriverOnline: () => payload.isOnline));
          } else {
            final updatedOnlineIds = Set<int>.from(currentState.onlineUserIds);
            if (payload.isOnline) {
              updatedOnlineIds.add(payload.userId);
            } else {
              updatedOnlineIds.remove(payload.userId);
            }
            emit(currentState.copyWith(onlineUserIds: updatedOnlineIds));
          }
        }
      }),
    );
  }

  Future<void> fetchRoomDetails() async {
    emit(const SharedTripRoomDetailsLoading());

    final result = await _getSharedRideDetailsUsecase(roomId);

    result.fold(
      (failure) =>
          emit(SharedTripRoomDetailsError(failure.rawMessage ?? 'Unknown')),
      (details) => emit(
        SharedTripRoomDetailsSuccess(details, currentUserId: _currentUserId),
      ),
    );
  }

  Future<void> joinRoom({int seatsNeeded = 1}) async {
    final currentState = state;
    if (currentState is! SharedTripRoomDetailsSuccess) return;

    emit(currentState.copyWith(isJoining: true, actionError: () => null));

    final params = JoinSharedRideParams(
      roomId: roomId,
      seatsNeeded: seatsNeeded,
    );

    final result = await _joinSharedRideUsecase(params);

    result.fold(
      (failure) {
        emit(
          currentState.copyWith(
            isJoining: false,
            actionError: () => failure.rawMessage ?? 'An error occurred',
          ),
        );
      },
      (passenger) async {
        final refreshResult = await _getSharedRideDetailsUsecase(roomId);
        refreshResult.fold(
          (_) {
            emit(
              currentState.copyWith(
                isJoining: false,
                joinedPassenger: () => passenger,
              ),
            );
          },
          (updatedDetails) {
            emit(
              SharedTripRoomDetailsSuccess(
                updatedDetails,
                currentUserId: _currentUserId,
                joinedPassenger: passenger,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> leaveRoom() async {
    final currentState = state;
    if (currentState is! SharedTripRoomDetailsSuccess) return;

    emit(currentState.copyWith(isLeaving: true, actionError: () => null));

    final result = await _leaveSharedRideUsecase(roomId);

    result.fold(
      (failure) {
        emit(
          currentState.copyWith(
            isLeaving: false,
            actionError: () => failure.rawMessage ?? 'An error occurred',
          ),
        );
      },
      (updatedDetails) {
        emit(
          currentState.copyWith(
            details: updatedDetails,
            isLeaving: false,
            joinedPassenger: () => null,
            hasLeft: true,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
    _repository.stopListeningToRoom(roomId);
    return super.close();
  }
}
