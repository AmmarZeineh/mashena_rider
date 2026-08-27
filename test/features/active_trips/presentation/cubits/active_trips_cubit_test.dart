import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/active_trips/domain/entities/active_trip_context.dart';
import 'package:mashena_rider/features/active_trips/domain/usecases/get_active_trips_usecase.dart';
import 'package:mashena_rider/features/active_trips/presentation/cubits/active_trips_cubit.dart';
import 'package:mashena_rider/features/active_trips/presentation/cubits/active_trips_state.dart';

class MockGetActiveTripsUsecase extends Mock implements GetActiveTripsUsecase {}

void main() {
  late MockGetActiveTripsUsecase mockUsecase;
  late ActiveTripsCubit cubit;

  setUp(() {
    mockUsecase = MockGetActiveTripsUsecase();
    cubit = ActiveTripsCubit(mockUsecase);
  });

  tearDown(() {
    cubit.close();
  });

  final testTrips = [
    const ActiveTripContext(
      type: ActiveTripType.regularTrip,
      trackingRole: ActiveTrackingRole.self,
      status: 'started',
      tripId: 20,
      rideRequestId: 109,
    ),
    const ActiveTripContext(
      type: ActiveTripType.sharedRide,
      trackingRole: ActiveTrackingRole.companionBooking,
      status: 'IN_PROGRESS',
      tripId: 300,
      rideRequestId: 250,
      sharedRideId: 100,
      sharedRidePassengerId: 501,
      accountHolderOnBoard: false,
      activeSeats: 1,
    ),
  ];

  test('initial state should be ActiveTripsStatus.initial', () {
    expect(cubit.state.status, equals(ActiveTripsStatus.initial));
    expect(cubit.state.trips, isEmpty);
  });

  test('fetchActiveTrips emits [loading, success] when usecase succeeds', () async {
    when(() => mockUsecase()).thenAnswer((_) async => Right(testTrips));

    expectLater(
      cubit.stream,
      emitsInOrder([
        const ActiveTripsState(status: ActiveTripsStatus.loading),
        ActiveTripsState(
          status: ActiveTripsStatus.success,
          trips: testTrips,
          isRefreshing: false,
        ),
      ]),
    );

    await cubit.fetchActiveTrips();
    verify(() => mockUsecase()).called(1);
  });

  test('fetchActiveTrips emits [loading, failure] when usecase fails', () async {
    const failure = Failure(FailureCode.networkConnection);
    when(() => mockUsecase()).thenAnswer((_) async => const Left(failure));

    expectLater(
      cubit.stream,
      emitsInOrder([
        const ActiveTripsState(status: ActiveTripsStatus.loading),
        const ActiveTripsState(
          status: ActiveTripsStatus.failure,
          failure: failure,
          isRefreshing: false,
        ),
      ]),
    );

    await cubit.fetchActiveTrips();
    verify(() => mockUsecase()).called(1);
  });
}
