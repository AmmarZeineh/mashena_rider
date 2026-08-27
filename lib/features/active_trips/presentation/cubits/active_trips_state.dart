import 'package:equatable/equatable.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import '../../domain/entities/active_trip_context.dart';

enum ActiveTripsStatus { initial, loading, success, failure }

class ActiveTripsState extends Equatable {
  final ActiveTripsStatus status;
  final List<ActiveTripContext> trips;
  final bool isRefreshing;
  final Failure? failure;

  const ActiveTripsState({
    this.status = ActiveTripsStatus.initial,
    this.trips = const [],
    this.isRefreshing = false,
    this.failure,
  });

  bool get isLoading => status == ActiveTripsStatus.loading && !isRefreshing;
  bool get hasActiveTrips => trips.isNotEmpty;

  ActiveTripsState copyWith({
    ActiveTripsStatus? status,
    List<ActiveTripContext>? trips,
    bool? isRefreshing,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return ActiveTripsState(
      status: status ?? this.status,
      trips: trips ?? this.trips,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [status, trips, isRefreshing, failure];
}
