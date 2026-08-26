import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mashena_rider/core/auth/auth_event_bus.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/core/services/osrm_route_service.dart';
import 'package:mashena_rider/features/home/domain/entities/driver_arrived.dart';
import 'package:mashena_rider/features/home/domain/entities/place_entity.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_estimate_response.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_location.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_request.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_submission_response.dart';
import 'package:mashena_rider/features/home/domain/entities/trip_cancelled.dart';
import 'package:mashena_rider/features/home/domain/entities/trip_completed.dart';
import 'package:mashena_rider/features/home/domain/repositories/ride_repository.dart';
import 'package:mashena_rider/features/home/domain/usecases/cancel_ride_usecase.dart';
import 'package:mashena_rider/features/home/domain/usecases/submit_ride_request_usecase.dart';
import 'package:mashena_rider/features/home/presentation/booking/cubits/ride_booking_cubit/ride_booking_cubit.dart';
import 'package:mashena_rider/features/home/presentation/common/models/confirmed_ride_flow_result.dart';
import 'package:mashena_rider/features/home/presentation/shell/cubits/map_state_cubit/map_state_cubit.dart';
import 'package:mashena_rider/features/home/presentation/trip/cubits/driver_tracking_cubit/driver_tracking_cubit.dart';
import 'package:mashena_rider/features/home/presentation/trip/cubits/trip_lifecycle_cubit/trip_lifecycle_cubit.dart';

class MockRideRepository extends Mock implements RideRepository {}

class MockSubmitRideRequestUsecase extends Mock
    implements SubmitRideRequestUsecase {}

class MockCancelRideUsecase extends Mock implements CancelRideUsecase {}

class MockOSRMRouteService extends Mock implements OSRMRouteService {}

void main() {
  late MockRideRepository mockRideRepo;
  late MockSubmitRideRequestUsecase mockSubmitRide;
  late MockCancelRideUsecase mockCancelRide;
  late MockOSRMRouteService mockOsrm;
  late AuthEventBus authEventBus;
  late TripLifecycleCubit tripLifecycleCubit;
  late DriverTrackingCubit driverTrackingCubit;
  late MapStateCubit mapStateCubit;
  late RideBookingCubit rideBookingCubit;

  const testPickup = MapLatLng(latitude: 33.5138, longitude: 36.2765);
  const testDest = MapLatLng(latitude: 33.5200, longitude: 36.2800);

  final testConfirmedRide = ConfirmedRideFlowResult(
    pickup: testPickup,
    destination: testDest,
    pickupPlace: const PlaceEntity(
      id: 'p1',
      name: 'Pickup',
      address: 'Pickup Address',
      latitude: 33.5138,
      longitude: 36.2765,
    ),
    destinationPlaces: const [
      PlaceEntity(
        id: 'd1',
        name: 'Dest',
        address: 'Dest Address',
        latitude: 33.5200,
        longitude: 36.2800,
      ),
    ],
    estimateResponse: const RideEstimateResponse(
      distanceKm: 2.5,
      durationMin: 10,
      stopsCount: 0,
      estimates: [],
      isNight: false,
    ),
    request: const RideRequest(
      pickup: RideLocation(lat: 33.5138, lng: 36.2765, address: 'Pickup'),
      destination: RideLocation(lat: 33.5200, lng: 36.2800, address: 'Dest'),
    ),
  );

  const testSubmission = RideSubmissionResponse(
    rideRequestId: 777,
    status: 'pending',
    distanceKm: 2.5,
    durationMin: 10,
    isNight: false,
    estimatedFare: 1500,
    currency: 'SYP',
  );

  setUp(() {
    mockRideRepo = MockRideRepository();
    mockSubmitRide = MockSubmitRideRequestUsecase();
    mockCancelRide = MockCancelRideUsecase();
    mockOsrm = MockOSRMRouteService();
    authEventBus = AuthEventBus();

    when(
      () => mockRideRepo.rideMatchedStream,
    ).thenAnswer((_) => const Stream<int>.empty());
    when(
      () => mockRideRepo.driverArrivedStream,
    ).thenAnswer((_) => const Stream<DriverArrived>.empty());
    when(
      () => mockRideRepo.driverStartedStream,
    ).thenAnswer((_) => const Stream<int>.empty());
    when(
      () => mockRideRepo.tripCompletedStream,
    ).thenAnswer((_) => const Stream<TripCompleted>.empty());
    when(
      () => mockRideRepo.tripCancelledStream,
    ).thenAnswer((_) => const Stream<TripCancelled>.empty());
    when(
      () => mockRideRepo.rideExpiredStream,
    ).thenAnswer((_) => const Stream<int>.empty());
    when(
      () => mockRideRepo.driverLocationStream,
    ).thenAnswer((_) => const Stream<MapLatLng>.empty());
    when(
      () => mockRideRepo.connectionStatusStream,
    ).thenAnswer((_) => const Stream<bool>.empty());
    when(() => mockRideRepo.connectSocket()).thenAnswer((_) async {});
    when(() => mockRideRepo.listenToRide(any())).thenReturn(null);
    when(() => mockRideRepo.stopListeningToRide(any())).thenReturn(null);

    tripLifecycleCubit = TripLifecycleCubit(mockRideRepo, authEventBus);
    mapStateCubit = MapStateCubit();
    driverTrackingCubit = DriverTrackingCubit(
      mockRideRepo,
      mockOsrm,
      mapStateCubit,
    );

    rideBookingCubit = RideBookingCubit(
      mockSubmitRide,
      mockCancelRide,
      mockRideRepo,
      tripLifecycleCubit,
      driverTrackingCubit,
      mapStateCubit,
    );
  });

  tearDown(() {
    rideBookingCubit.close();
    tripLifecycleCubit.close();
    driverTrackingCubit.close();
    mapStateCubit.close();
    authEventBus.dispose();
  });

  group('RideBookingCubit', () {
    test('initial state has null ride and isSubmitting false', () {
      expect(rideBookingCubit.state.confirmedRideResult, isNull);
      expect(rideBookingCubit.state.isSubmitting, isFalse);
      expect(rideBookingCubit.state.submissionResponse, isNull);
    });

    test('setConfirmedRide updates confirmedRideResult in state', () {
      rideBookingCubit.setConfirmedRide(testConfirmedRide);
      expect(rideBookingCubit.state.confirmedRideResult, testConfirmedRide);
    });

    test(
      'submitRideSelection connects socket, submits request, and starts tracking on success',
      () async {
        rideBookingCubit.setConfirmedRide(testConfirmedRide);

        when(
          () => mockSubmitRide(
            request: testConfirmedRide.request,
            vehicleTypeId: 1,
          ),
        ).thenAnswer((_) async => const Right(testSubmission));

        final expectedStates = [
          predicate<RideBookingState>((s) => s.isSubmitting == true),
          predicate<RideBookingState>(
            (s) =>
                s.isSubmitting == false &&
                s.submissionResponse == testSubmission,
          ),
        ];

        expectLater(rideBookingCubit.stream, emitsInOrder(expectedStates));

        await rideBookingCubit.submitRideSelection(1);

        verify(() => mockRideRepo.connectSocket()).called(1);
        verify(() => mockRideRepo.listenToRide(777)).called(1);
      },
    );

    test('submitRideSelection emits failure on API error', () async {
      rideBookingCubit.setConfirmedRide(testConfirmedRide);

      when(
        () => mockSubmitRide(
          request: testConfirmedRide.request,
          vehicleTypeId: 1,
        ),
      ).thenAnswer(
        (_) async => const Left(
          Failure(FailureCode.server, rawMessage: 'No drivers available'),
        ),
      );

      final expectedStates = [
        predicate<RideBookingState>((s) => s.isSubmitting == true),
        predicate<RideBookingState>(
          (s) =>
              s.isSubmitting == false &&
              s.error?.rawMessage == 'No drivers available',
        ),
      ];

      expectLater(rideBookingCubit.stream, emitsInOrder(expectedStates));

      await rideBookingCubit.submitRideSelection(1);
    });

    test(
      'cancelRide blocks cancellation when trip has already started',
      () async {
        rideBookingCubit.setConfirmedRide(testConfirmedRide);
        when(
          () => mockSubmitRide(
            request: testConfirmedRide.request,
            vehicleTypeId: 1,
          ),
        ).thenAnswer((_) async => const Right(testSubmission));
        await rideBookingCubit.submitRideSelection(1);

        await rideBookingCubit.cancelRide(isTripStarted: true);

        expect(
          rideBookingCubit.state.error?.rawMessage,
          'error_cannot_cancel_started_trip',
        );
        verifyNever(() => mockCancelRide(any()));
      },
    );

    test(
      'cancelRide calls cancelRideUsecase and clears booking on success',
      () async {
        rideBookingCubit.setConfirmedRide(testConfirmedRide);
        when(
          () => mockSubmitRide(
            request: testConfirmedRide.request,
            vehicleTypeId: 1,
          ),
        ).thenAnswer((_) async => const Right(testSubmission));
        await rideBookingCubit.submitRideSelection(1);

        when(
          () => mockCancelRide(777),
        ).thenAnswer((_) async => const Right(null));

        await rideBookingCubit.cancelRide(isTripStarted: false);

        expect(rideBookingCubit.state.submissionResponse, isNull);
        verify(() => mockCancelRide(777)).called(1);
        verify(() => mockRideRepo.stopListeningToRide(777)).called(2);
      },
    );

    test('clearBooking resets state and dependent cubits', () {
      rideBookingCubit.setConfirmedRide(testConfirmedRide);
      rideBookingCubit.clearBooking();

      expect(rideBookingCubit.state, const RideBookingState());
    });
  });
}
