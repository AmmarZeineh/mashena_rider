import 'package:equatable/equatable.dart';
import 'package:mashena_rider/core/base/base_cubit.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/core/services/logger_service.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_submission_response.dart';
import 'package:mashena_rider/features/home/domain/repositories/ride_repository.dart';
import 'package:mashena_rider/features/home/domain/usecases/cancel_ride_usecase.dart';
import 'package:mashena_rider/features/home/domain/usecases/submit_ride_request_usecase.dart';
import 'package:mashena_rider/features/home/presentation/common/models/confirmed_ride_flow_result.dart';
import 'package:mashena_rider/features/home/presentation/shell/cubits/map_state_cubit/map_state_cubit.dart';
import 'package:mashena_rider/features/home/presentation/trip/cubits/driver_tracking_cubit/driver_tracking_cubit.dart';
import 'package:mashena_rider/features/home/presentation/trip/cubits/trip_lifecycle_cubit/trip_lifecycle_cubit.dart';

part 'ride_booking_state.dart';

/// Manages the ride booking flow: storing the confirmed ride details,
/// submitting the ride request, and cancelling it.
///
/// Coordinates with [TripLifecycleCubit], [DriverTrackingCubit], and
/// [MapStateCubit] to reset/start them at the right moments.
class RideBookingCubit extends BaseCubit<RideBookingState> {
  RideBookingCubit(
    this._submitRideRequest,
    this._cancelRideUsecase,
    this._rideRepository,
    this._tripLifecycleCubit,
    this._driverTrackingCubit,
    this._mapStateCubit,
  ) : super(const RideBookingState());

  final SubmitRideRequestUsecase _submitRideRequest;
  final CancelRideUsecase _cancelRideUsecase;
  final RideRepository _rideRepository;
  final TripLifecycleCubit _tripLifecycleCubit;
  final DriverTrackingCubit _driverTrackingCubit;
  final MapStateCubit _mapStateCubit;

  /// Stores the confirmed ride from the pick-address flow.
  void setConfirmedRide(ConfirmedRideFlowResult result) {
    _tripLifecycleCubit.reset();
    _driverTrackingCubit.stopTracking();
    emit(
      state.copyWith(
        confirmedRideResult: result,
        clearSubmissionResponse: true,
        clearError: true,
      ),
    );
  }

  /// Submits the selected vehicle type to the API.
  /// On success, starts socket listening and driver tracking.
  Future<void> submitRideSelection(int vehicleTypeId) async {
    final result = state.confirmedRideResult;
    if (result == null) return;

    _tripLifecycleCubit.reset();
    _driverTrackingCubit.stopTracking();

    emit(
      state.copyWith(
        isSubmitting: true,
        clearError: true,
        clearSubmissionResponse: true,
      ),
    );

    // Ensure the socket is connected before/during ride submission
    // to avoid missing initial real-time events.
    await _rideRepository.connectSocket();

    final response = await _submitRideRequest(
      request: result.request,
      vehicleTypeId: vehicleTypeId,
    );

    response.fold(
      (failure) => emit(state.copyWith(isSubmitting: false, error: failure)),
      (submissionResult) {
        _rideRepository.listenToRide(submissionResult.rideRequestId);
        _driverTrackingCubit.startTracking(
          pickup: result.pickup,
          destination: result.destination,
        );

        emit(
          state.copyWith(
            isSubmitting: false,
            submissionResponse: submissionResult,
          ),
        );

        LoggerService.debug(
          'Ride submitted: ${submissionResult.rideRequestId}',
          name: 'features.home.booking',
        );
      },
    );
  }

  /// Cancels the active ride. Blocked if the trip has already started.
  Future<void> cancelRide({required bool isTripStarted}) async {
    final rideRequestId = state.submissionResponse?.rideRequestId;
    if (rideRequestId == null) return;

    if (isTripStarted) {
      emit(
        state.copyWith(
          error: const Failure(
            FailureCode.unknown,
            rawMessage: 'error_cannot_cancel_started_trip',
          ),
        ),
      );
      return;
    }

    emit(state.copyWith(isSubmitting: true, clearError: true));

    final response = await _cancelRideUsecase(rideRequestId);

    response.fold(
      (failure) => emit(state.copyWith(isSubmitting: false, error: failure)),
      (_) {
        _rideRepository.stopListeningToRide(rideRequestId);
        clearBooking();
      },
    );
  }

  /// Resets all booking state and dependent cubits back to idle.
  void clearBooking() {
    final rideRequestId = state.submissionResponse?.rideRequestId;
    if (rideRequestId != null) {
      _rideRepository.stopListeningToRide(rideRequestId);
    }
    _driverTrackingCubit.stopTracking();
    _tripLifecycleCubit.reset();
    _mapStateCubit.clearAll();
    emit(const RideBookingState());
  }
}
