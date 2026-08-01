part of 'ride_booking_cubit.dart';

/// State for the ride booking flow.
class RideBookingState {
  const RideBookingState({
    this.confirmedRideResult,
    this.submissionResponse,
    this.isSubmitting = false,
    this.error,
  });

  final ConfirmedRideFlowResult? confirmedRideResult;
  final RideSubmissionResponse? submissionResponse;
  final bool isSubmitting;
  final Failure? error;

  /// True once a ride has been submitted successfully.
  bool get isSubmitted => submissionResponse != null;

  RideBookingState copyWith({
    ConfirmedRideFlowResult? confirmedRideResult,
    bool clearConfirmedRide = false,
    RideSubmissionResponse? submissionResponse,
    bool clearSubmissionResponse = false,
    bool? isSubmitting,
    Failure? error,
    bool clearError = false,
  }) {
    return RideBookingState(
      confirmedRideResult: clearConfirmedRide
          ? null
          : (confirmedRideResult ?? this.confirmedRideResult),
      submissionResponse: clearSubmissionResponse
          ? null
          : (submissionResponse ?? this.submissionResponse),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
