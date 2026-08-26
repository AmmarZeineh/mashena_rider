import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mashena_rider/core/auth/auth_event.dart';
import 'package:mashena_rider/core/auth/auth_event_bus.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/home/domain/entities/driver_arrived.dart';
import 'package:mashena_rider/features/home/domain/entities/matched_trip.dart';
import 'package:mashena_rider/features/home/domain/entities/trip_cancelled.dart';
import 'package:mashena_rider/features/home/domain/entities/trip_completed.dart';
import 'package:mashena_rider/features/home/domain/repositories/ride_repository.dart';
import 'package:mashena_rider/features/home/presentation/trip/cubits/trip_lifecycle_cubit/trip_lifecycle_cubit.dart';

class MockRideRepository extends Mock implements RideRepository {}

void main() {
  late MockRideRepository mockRideRepo;
  late AuthEventBus authEventBus;
  late TripLifecycleCubit tripLifecycleCubit;

  late StreamController<int> rideMatchedController;
  late StreamController<DriverArrived> driverArrivedController;
  late StreamController<int> driverStartedController;
  late StreamController<TripCompleted> tripCompletedController;
  late StreamController<TripCancelled> tripCancelledController;
  late StreamController<int> rideExpiredController;
  late StreamController<bool> connectionStatusController;

  const testMatchedTrip = MatchedTrip(
    tripId: 100,
    tripStatus: 'assigned',
    rideRequestId: 25,
    pickupLat: 33.5138,
    pickupLng: 36.2765,
    destinationLat: 33.5200,
    destinationLng: 36.2800,
    driverId: 10,
    driverFullName: 'Ahmad Driver',
    driverRatingAvg: 4.9,
    stops: [],
  );

  setUp(() {
    mockRideRepo = MockRideRepository();
    authEventBus = AuthEventBus();

    rideMatchedController = StreamController<int>.broadcast();
    driverArrivedController = StreamController<DriverArrived>.broadcast();
    driverStartedController = StreamController<int>.broadcast();
    tripCompletedController = StreamController<TripCompleted>.broadcast();
    tripCancelledController = StreamController<TripCancelled>.broadcast();
    rideExpiredController = StreamController<int>.broadcast();
    connectionStatusController = StreamController<bool>.broadcast();

    when(
      () => mockRideRepo.rideMatchedStream,
    ).thenAnswer((_) => rideMatchedController.stream);
    when(
      () => mockRideRepo.driverArrivedStream,
    ).thenAnswer((_) => driverArrivedController.stream);
    when(
      () => mockRideRepo.driverStartedStream,
    ).thenAnswer((_) => driverStartedController.stream);
    when(
      () => mockRideRepo.tripCompletedStream,
    ).thenAnswer((_) => tripCompletedController.stream);
    when(
      () => mockRideRepo.tripCancelledStream,
    ).thenAnswer((_) => tripCancelledController.stream);
    when(
      () => mockRideRepo.rideExpiredStream,
    ).thenAnswer((_) => rideExpiredController.stream);
    when(
      () => mockRideRepo.connectionStatusStream,
    ).thenAnswer((_) => connectionStatusController.stream);
    when(() => mockRideRepo.connectSocket()).thenAnswer((_) async {});
    when(
      () => mockRideRepo.stopListeningToRide(any()),
    ).thenAnswer((_) async {});

    tripLifecycleCubit = TripLifecycleCubit(mockRideRepo, authEventBus);
  });

  tearDown(() {
    tripLifecycleCubit.close();
    authEventBus.dispose();
    rideMatchedController.close();
    driverArrivedController.close();
    driverStartedController.close();
    tripCompletedController.close();
    tripCancelledController.close();
    rideExpiredController.close();
    connectionStatusController.close();
  });

  group('TripLifecycleCubit', () {
    test('initial state has all flags false and empty data', () {
      expect(tripLifecycleCubit.state, const TripLifecycleState());
      expect(tripLifecycleCubit.state.isDriverFound, isFalse);
      expect(tripLifecycleCubit.state.isDriverArrived, isFalse);
      expect(tripLifecycleCubit.state.isTripStarted, isFalse);
      expect(tripLifecycleCubit.state.isTripEnded, isFalse);
    });

    test('handles rideMatched stream event and fetches trip details', () async {
      when(
        () => mockRideRepo.getMatchedTripDetails(25),
      ).thenAnswer((_) async => const Right(testMatchedTrip));

      rideMatchedController.add(25);

      await expectLater(
        tripLifecycleCubit.stream,
        emitsThrough(
          predicate<TripLifecycleState>(
            (state) =>
                state.isDriverFound == true &&
                state.isLoadingMatchedTrip == false &&
                state.matchedTrip == testMatchedTrip,
          ),
        ),
      );
    });

    test(
      'handles driverArrived stream event and sets isDriverArrived',
      () async {
        const arrivedEvent = DriverArrived(
          tripId: 100,
          arrivedAt: '2026-08-18T12:00:00Z',
          freeWaitTimeSeconds: 300,
        );

        driverArrivedController.add(arrivedEvent);

        await expectLater(
          tripLifecycleCubit.stream,
          emitsThrough(
            predicate<TripLifecycleState>(
              (state) =>
                  state.isDriverArrived == true &&
                  state.freeWaitTimeSeconds == 300 &&
                  state.arrivedAt == '2026-08-18T12:00:00Z',
            ),
          ),
        );
      },
    );

    test('handles driverStarted stream event and sets isTripStarted', () async {
      driverStartedController.add(100);

      await expectLater(
        tripLifecycleCubit.stream,
        emitsThrough(
          predicate<TripLifecycleState>((state) => state.isTripStarted == true),
        ),
      );
    });

    test('handles tripCompleted stream event and sets isTripEnded', () async {
      const completedEvent = TripCompleted(
        tripId: 100,
        completedAt: '2026-08-18T12:30:00Z',
        distanceKm: 12.5,
        durationSec: 1500,
      );

      tripCompletedController.add(completedEvent);

      await expectLater(
        tripLifecycleCubit.stream,
        emitsThrough(
          predicate<TripLifecycleState>(
            (state) =>
                state.isTripEnded == true &&
                state.tripCompletedData == completedEvent,
          ),
        ),
      );
    });

    test(
      'handles tripCancelled stream event and sets cancel failure',
      () async {
        const cancelledEvent = TripCancelled(
          tripId: 100,
          canceledAt: '2026-08-18T12:15:00Z',
          cancelledBy: 'driver',
        );

        tripCancelledController.add(cancelledEvent);

        await expectLater(
          tripLifecycleCubit.stream,
          emitsThrough(
            predicate<TripLifecycleState>(
              (state) =>
                  state.tripCancelledData == cancelledEvent &&
                  state.tripError?.code == FailureCode.tripCancelledByDriver,
            ),
          ),
        );
      },
    );

    test('reconnects socket on AuthEvent.tokenRefreshed', () async {
      authEventBus.emit(AuthEvent.tokenRefreshed);
      await pumpEventQueue();
      verify(() => mockRideRepo.connectSocket()).called(1);
    });

    test('reset clears state back to idle', () {
      tripLifecycleCubit.reset();
      expect(tripLifecycleCubit.state, const TripLifecycleState());
    });
  });
}
