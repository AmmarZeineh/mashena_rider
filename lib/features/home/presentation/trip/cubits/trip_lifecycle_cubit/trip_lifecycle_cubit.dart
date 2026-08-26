import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:mashena_rider/core/services/logger_service.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/core/auth/auth_event.dart';
import 'package:mashena_rider/core/auth/auth_event_bus.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/home/domain/entities/driver_arrived.dart';
import 'package:mashena_rider/features/home/domain/entities/matched_trip.dart';
import 'package:mashena_rider/features/home/domain/entities/trip_cancelled.dart';
import 'package:mashena_rider/features/home/domain/entities/trip_completed.dart';
import 'package:mashena_rider/features/home/domain/repositories/ride_repository.dart';

part 'trip_lifecycle_state.dart';

/// Manages the full lifecycle of an active trip via socket events.
///
/// Responsibilities:
///  - Subscribing to all socket streams (matched, arrived, started, completed, cancelled)
///  - Fetching matched trip details with retry
///  - Reconnecting the socket on token refresh
///
/// Downstream cubits ([DriverTrackingCubit]) react to state changes from here.
class TripLifecycleCubit extends Cubit<TripLifecycleState> {
  TripLifecycleCubit(this._rideRepository, this._authEventBus)
    : super(const TripLifecycleState()) {
    _subscribeToSocketStreams();
    _subscribeToAuthEvents();
    _subscribeToConnectionStatus();
  }

  final RideRepository _rideRepository;
  final AuthEventBus _authEventBus;

  StreamSubscription<int>? _rideMatchedSubscription;
  StreamSubscription<DriverArrived>? _driverArrivedSubscription;
  StreamSubscription<int>? _driverStartedSubscription;
  StreamSubscription<TripCompleted>? _tripCompletedSubscription;
  StreamSubscription<TripCancelled>? _tripCancelledSubscription;
  StreamSubscription<int>? _rideExpiredSubscription;
  StreamSubscription<AuthEvent>? _authEventSubscription;
  StreamSubscription<bool>? _connectionStatusSubscription;

  void _subscribeToSocketStreams() {
    _rideMatchedSubscription = _rideRepository.rideMatchedStream.listen((
      rideRequestId,
    ) async {
      if (isClosed) return;
      emit(
        state.copyWith(
          isDriverFound: true,
          isLoadingMatchedTrip: true,
          clearTripError: true,
        ),
      );
      await _fetchMatchedTripWithRetry(rideRequestId);
    });

    _driverArrivedSubscription = _rideRepository.driverArrivedStream.listen((
      payload,
    ) {
      if (isClosed) return;
      emit(
        state.copyWith(
          isDriverArrived: true,
          freeWaitTimeSeconds: payload.freeWaitTimeSeconds,
          arrivedAt: payload.arrivedAt,
        ),
      );
    });

    _driverStartedSubscription = _rideRepository.driverStartedStream.listen(
      (_) {
        if (isClosed) return;
        emit(state.copyWith(isTripStarted: true));
      },
    );

    _tripCompletedSubscription = _rideRepository.tripCompletedStream.listen((
      payload,
    ) {
      if (isClosed) return;
      final activeRideId = state.matchedTrip?.rideRequestId;
      if (activeRideId != null) {
        _rideRepository.stopListeningToRide(activeRideId);
      }
      emit(state.copyWith(isTripEnded: true, tripCompletedData: payload));
    });

    _tripCancelledSubscription = _rideRepository.tripCancelledStream.listen((
      payload,
    ) {
      if (isClosed) return;
      final Failure cancelFailure;
      if (payload.cancelledBy == 'driver') {
        cancelFailure = const Failure(FailureCode.tripCancelledByDriver);
      } else if (payload.cancelledBy == 'admin') {
        cancelFailure = const Failure(FailureCode.tripCancelledByAdmin);
      } else {
        cancelFailure = const Failure(FailureCode.tripCancelled);
      }
      emit(
        state.copyWith(
          tripError: cancelFailure,
          tripCancelledData: payload,
          clearMatchedTrip: true,
        ),
      );
    });

    _rideExpiredSubscription = _rideRepository.rideExpiredStream.listen((_) {
      if (isClosed) return;
      emit(state.copyWith(isRideExpired: true, clearMatchedTrip: true));
    });
  }

  void _subscribeToAuthEvents() {
    _authEventSubscription = _authEventBus.stream.listen((event) {
      if (isClosed) return;
      if (event == AuthEvent.tokenRefreshed) {
        LoggerService.debug(
          'Token refreshed, reconnecting socket...',
          name: 'features.home.trip_lifecycle',
        );
        _rideRepository.connectSocket();
      }
    });
  }

  void _subscribeToConnectionStatus() {
    _connectionStatusSubscription = _rideRepository.connectionStatusStream.listen(
      (isConnected) {
        LoggerService.debug(
          'Socket connection status changed: $isConnected',
          name: 'features.home.trip_lifecycle',
        );
        emit(state.copyWith(isConnected: isConnected));

        // If we were disconnected and now reconnected, try to restore socket if needed
        if (isConnected &&
            (state.isDriverFound || state.isDriverArrived || state.isTripStarted)) {
          // We were in the middle of a trip and socket reconnected
          LoggerService.debug(
            'Socket reconnected during active trip, ensuring connection...',
            name: 'features.home.trip_lifecycle',
          );
          // The socket should already be connected via the SocketIOClientImpl's reconnect logic
          // but we can ensure it's properly set up if needed
        }
      },
    );
  }

  Future<void> _fetchMatchedTripWithRetry(int rideRequestId) async {
    const int maxRetries = 4;
    const Duration retryDelay = Duration(milliseconds: 1500);

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      if (isClosed) return;

      LoggerService.debug(
        'Fetching matched trip (attempt $attempt/$maxRetries, id: $rideRequestId)',
        name: 'features.home.trip_lifecycle',
      );

      final result = await _rideRepository.getMatchedTripDetails(rideRequestId);
      if (isClosed) return;

      if (result.isRight()) {
        final trip = result.getOrElse(() => throw Exception());
        LoggerService.debug(
          'Matched trip loaded: ${trip.driverFullName} (${trip.model}) - status: ${trip.tripStatus}',
          name: 'features.home.trip_lifecycle',
        );

        bool arrived = false;
        bool started = false;
        if (trip.tripStatus == 'driver_arrived') {
          arrived = true;
        } else if (trip.tripStatus == 'in_progress') {
          arrived = true;
          started = true;
        }

        emit(
          state.copyWith(
            matchedTrip: trip,
            isLoadingMatchedTrip: false,
            isDriverArrived: arrived,
            isTripStarted: started,
          ),
        );
        return;
      }

      final errMsg = result.fold((l) => l.rawMessage ?? l.code.name, (r) => '');
      LoggerService.debug(
        'Attempt $attempt failed: $errMsg',
        name: 'features.home.trip_lifecycle',
      );

      if (attempt < maxRetries) {
        await Future.delayed(retryDelay);
      } else {
        emit(
          state.copyWith(
            isLoadingMatchedTrip: false,
            isDriverFound: false,
            tripError: const Failure(
              FailureCode.unknown,
              rawMessage: 'failedToLoadDriverDetails',
            ),
          ),
        );
      }
    }
  }

  /// Resets all trip state back to idle (called from [RideBookingCubit.clearBooking]).
  void reset() {
    emit(const TripLifecycleState());
  }

  @override
  Future<void> close() {
    _rideMatchedSubscription?.cancel();
    _driverArrivedSubscription?.cancel();
    _driverStartedSubscription?.cancel();
    _tripCompletedSubscription?.cancel();
    _tripCancelledSubscription?.cancel();
    _rideExpiredSubscription?.cancel();
    _authEventSubscription?.cancel();
    _connectionStatusSubscription?.cancel();
    return super.close();
  }
}
