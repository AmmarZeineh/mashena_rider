import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/auth/domain/entities/auth_session.dart';
import 'package:mashena_rider/features/auth/domain/entities/user.dart';
import 'package:mashena_rider/features/auth/domain/usecases/get_cached_session_usecase.dart';
import 'package:mashena_rider/features/shared_trip/data/models/shared_ride_socket_events.dart';
import 'package:mashena_rider/features/shared_trip/domain/entities/join_shared_ride_params.dart';
import 'package:mashena_rider/features/shared_trip/domain/entities/shared_ride_passenger_entity.dart';
import 'package:mashena_rider/features/shared_trip/domain/entities/shared_ride_room_details_entity.dart';
import 'package:mashena_rider/features/shared_trip/domain/repositories/shared_trip_repository.dart';
import 'package:mashena_rider/features/shared_trip/domain/usecases/get_shared_ride_details_usecase.dart';
import 'package:mashena_rider/features/shared_trip/domain/usecases/join_shared_ride_usecase.dart';
import 'package:mashena_rider/features/shared_trip/domain/usecases/leave_shared_ride_usecase.dart';
import 'package:mashena_rider/features/shared_trip/presentation/cubits/shared_trip_room_details_cubit/shared_trip_room_details_cubit.dart';
import 'package:mashena_rider/features/shared_trip/presentation/cubits/shared_trip_room_details_cubit/shared_trip_room_details_state.dart';

class MockSharedTripRepository extends Mock implements SharedTripRepository {}

class MockGetSharedRideDetailsUsecase extends Mock
    implements GetSharedRideDetailsUsecase {}

class MockJoinSharedRideUsecase extends Mock implements JoinSharedRideUsecase {}

class MockLeaveSharedRideUsecase extends Mock
    implements LeaveSharedRideUsecase {}

class MockGetCachedSessionUsecase extends Mock
    implements GetCachedSessionUsecase {}

class FakeJoinSharedRideParams extends Fake implements JoinSharedRideParams {}

void main() {
  late MockSharedTripRepository mockRepo;
  late MockGetSharedRideDetailsUsecase mockGetDetails;
  late MockJoinSharedRideUsecase mockJoin;
  late MockLeaveSharedRideUsecase mockLeave;
  late MockGetCachedSessionUsecase mockGetCachedSession;
  late SharedTripRoomDetailsCubit cubit;

  final testDetails = SharedRideRoomDetailsEntity(
    id: 10,
    driverProfileId: 1,
    vehicleId: 2,
    status: 'OPEN',
    originLat: 33.5,
    originLng: 36.2,
    originAddress: 'Origin',
    destLat: 33.6,
    destLng: 36.3,
    destAddress: 'Dest',
    departureTime: DateTime(2026, 1, 1),
    maxPassengers: 4,
    occupiedSeats: 1,
    createdAt: DateTime(2026, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(FakeJoinSharedRideParams());
  });

  setUp(() {
    mockRepo = MockSharedTripRepository();
    mockGetDetails = MockGetSharedRideDetailsUsecase();
    mockJoin = MockJoinSharedRideUsecase();
    mockLeave = MockLeaveSharedRideUsecase();
    mockGetCachedSession = MockGetCachedSessionUsecase();

    when(
      () => mockGetCachedSession(),
    ).thenAnswer((_) async => const Left(Failure(FailureCode.cache)));
    when(
      () => mockRepo.driverLocationStream,
    ).thenAnswer((_) => const Stream.empty());
    when(
      () => mockRepo.passengerJoinedStream,
    ).thenAnswer((_) => const Stream.empty());
    when(
      () => mockRepo.passengerLeftStream,
    ).thenAnswer((_) => const Stream.empty());
    when(
      () => mockRepo.passengerRemovedStream,
    ).thenAnswer((_) => const Stream.empty());
    when(
      () => mockRepo.riderRemovedStream,
    ).thenAnswer((_) => const Stream.empty());
    when(
      () => mockRepo.roomReadyStream,
    ).thenAnswer((_) => const Stream.empty());
    when(
      () => mockRepo.tripStartedStream,
    ).thenAnswer((_) => const Stream.empty());
    when(
      () => mockRepo.passengerOnBoardStream,
    ).thenAnswer((_) => const Stream.empty());
    when(
      () => mockRepo.passengerDroppedStream,
    ).thenAnswer((_) => const Stream.empty());
    when(
      () => mockRepo.tripCompletedStream,
    ).thenAnswer((_) => const Stream.empty());
    when(
      () => mockRepo.tripCancelledStream,
    ).thenAnswer((_) => const Stream.empty());
    when(() => mockRepo.presenceStream).thenAnswer((_) => const Stream.empty());
    when(() => mockRepo.listenToRoom(any())).thenReturn(null);
    when(() => mockRepo.stopListeningToRoom(any())).thenReturn(null);

    cubit = SharedTripRoomDetailsCubit(
      roomId: 10,
      getSharedRideDetailsUsecase: mockGetDetails,
      joinSharedRideUsecase: mockJoin,
      leaveSharedRideUsecase: mockLeave,
      getCachedSessionUsecase: mockGetCachedSession,
      repository: mockRepo,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('SharedTripRoomDetailsCubit', () {
    test('initial state is SharedTripRoomDetailsInitial', () {
      expect(cubit.state, isA<SharedTripRoomDetailsInitial>());
    });

    test('fetchRoomDetails emits loading then success with details', () async {
      when(
        () => mockGetDetails(10),
      ).thenAnswer((_) async => Right(testDetails));

      final expectedStates = [
        isA<SharedTripRoomDetailsLoading>(),
        predicate<SharedTripRoomDetailsState>(
          (s) => s is SharedTripRoomDetailsSuccess && s.details.id == 10,
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.fetchRoomDetails();
    });

    test('fetchRoomDetails emits error on failure', () async {
      when(() => mockGetDetails(10)).thenAnswer(
        (_) async => const Left(
          Failure(FailureCode.notFound, rawMessage: 'Room not found'),
        ),
      );

      final expectedStates = [
        isA<SharedTripRoomDetailsLoading>(),
        predicate<SharedTripRoomDetailsState>(
          (s) =>
              s is SharedTripRoomDetailsError && s.message == 'Room not found',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.fetchRoomDetails();
    });

    test('joinRoom sets isJoining and updates details on success', () async {
      when(
        () => mockGetDetails(10),
      ).thenAnswer((_) async => Right(testDetails));
      await cubit.fetchRoomDetails();

      final joinedPassenger = SharedRidePassengerEntity(
        id: 100,
        sharedRideId: 10,
        riderProfileId: 5,
        riderName: 'Passenger',
        status: 'JOINED',
        paymentStatus: 'PAID',
        seatsNeeded: 1,
        activeSeats: 1,
        totalPaidFare: 500,
        joinedAt: DateTime(2026, 1, 1),
      );

      when(
        () => mockJoin(any()),
      ).thenAnswer((_) async => Right(joinedPassenger));

      await cubit.joinRoom(seatsNeeded: 1);

      expect(cubit.state, isA<SharedTripRoomDetailsSuccess>());
      verify(() => mockJoin(any())).called(1);
    });

    test('leaveRoom sets isLeaving and updates details on success', () async {
      when(
        () => mockGetDetails(10),
      ).thenAnswer((_) async => Right(testDetails));
      await cubit.fetchRoomDetails();

      final updatedDetails = testDetails;
      when(() => mockLeave(10)).thenAnswer((_) async => Right(updatedDetails));

      await cubit.leaveRoom();

      expect(cubit.state, isA<SharedTripRoomDetailsSuccess>());
      verify(() => mockLeave(10)).called(1);
    });

    test(
      'passengerDropped with accountHolderOnBoard: true emits companionDroppedPayload and keeps tracking active',
      () async {
        final session = AuthSession(
          accessToken: 'token',
          user: User(
            id: 5,
            fullName: 'Test Rider',
            email: 'test@test.com',
            phoneNumber: '+123456789',
            createdAt: DateTime(2026, 1, 1),
            updatedAt: DateTime(2026, 1, 1),
          ),
        );
        when(
          () => mockGetCachedSession(),
        ).thenAnswer((_) async => Right(session));

        final dropController =
            StreamController<SharedRidePassengerDroppedPayload>.broadcast();
        when(
          () => mockRepo.passengerDroppedStream,
        ).thenAnswer((_) => dropController.stream);

        // Recreate cubit with stream controller
        final testCubit = SharedTripRoomDetailsCubit(
          roomId: 10,
          getSharedRideDetailsUsecase: mockGetDetails,
          joinSharedRideUsecase: mockJoin,
          leaveSharedRideUsecase: mockLeave,
          getCachedSessionUsecase: mockGetCachedSession,
          repository: mockRepo,
        );

        final initialPassenger = SharedRidePassengerEntity(
          id: 81,
          sharedRideId: 10,
          riderProfileId: 5,
          riderName: 'Test Rider',
          status: 'ON_BOARD',
          paymentStatus: 'PENDING',
          seatsNeeded: 2,
          activeSeats: 2,
          totalPaidFare: 0,
          joinedAt: DateTime(2026, 1, 1),
          accountHolderOnBoard: true,
        );

        final detailsWithPassenger = SharedRideRoomDetailsEntity(
          id: 10,
          driverProfileId: 1,
          vehicleId: 2,
          status: 'IN_PROGRESS',
          originLat: 0,
          originLng: 0,
          originAddress: 'Origin',
          destLat: 1,
          destLng: 1,
          destAddress: 'Dest',
          departureTime: DateTime(2026, 1, 1),
          maxPassengers: 4,
          occupiedSeats: 2,
          passengers: [initialPassenger],
          createdAt: DateTime(2026, 1, 1),
        );

        when(
          () => mockGetDetails(10),
        ).thenAnswer((_) async => Right(detailsWithPassenger));
        await testCubit.fetchRoomDetails();

        // Emit companion dropped event
        final payload = SharedRidePassengerDroppedPayload(
          sharedRideId: 10,
          userId: 5,
          status: 'DROPPED_OFF',
          passengerId: 81,
          riderProfileId: 5,
          timestamp: DateTime.now(),
          accountHolderOnBoard: true,
          passengerStatus: 'ON_BOARD',
          activeSeats: 1,
          seatsNeeded: 2,
          totalPaidFare: 2062.2,
        );

        dropController.add(payload);
        await Future.delayed(Duration.zero);

        final state = testCubit.state as SharedTripRoomDetailsSuccess;
        expect(state.companionDroppedPayload, payload);
        expect(state.currentUserDroppedOffPayload, isNull);
        expect(state.details.passengers.first.activeSeats, 1);
        expect(state.details.passengers.first.status, 'ON_BOARD');
        expect(state.details.passengers.first.accountHolderOnBoard, true);

        await testCubit.close();
        await dropController.close();
      },
    );

    test(
      'passengerDropped with accountHolderOnBoard: false emits currentUserDroppedOffPayload',
      () async {
        final session = AuthSession(
          accessToken: 'token',
          user: User(
            id: 5,
            fullName: 'Test Rider',
            email: 'test@test.com',
            phoneNumber: '+123456789',
            createdAt: DateTime(2026, 1, 1),
            updatedAt: DateTime(2026, 1, 1),
          ),
        );
        when(
          () => mockGetCachedSession(),
        ).thenAnswer((_) async => Right(session));

        final dropController =
            StreamController<SharedRidePassengerDroppedPayload>.broadcast();
        when(
          () => mockRepo.passengerDroppedStream,
        ).thenAnswer((_) => dropController.stream);

        final testCubit = SharedTripRoomDetailsCubit(
          roomId: 10,
          getSharedRideDetailsUsecase: mockGetDetails,
          joinSharedRideUsecase: mockJoin,
          leaveSharedRideUsecase: mockLeave,
          getCachedSessionUsecase: mockGetCachedSession,
          repository: mockRepo,
        );

        final initialPassenger = SharedRidePassengerEntity(
          id: 81,
          sharedRideId: 10,
          riderProfileId: 5,
          riderName: 'Test Rider',
          status: 'ON_BOARD',
          paymentStatus: 'PENDING',
          seatsNeeded: 2,
          activeSeats: 1,
          totalPaidFare: 2062.2,
          joinedAt: DateTime(2026, 1, 1),
          accountHolderOnBoard: true,
        );

        final detailsWithPassenger = SharedRideRoomDetailsEntity(
          id: 10,
          driverProfileId: 1,
          vehicleId: 2,
          status: 'IN_PROGRESS',
          originLat: 0,
          originLng: 0,
          originAddress: 'Origin',
          destLat: 1,
          destLng: 1,
          destAddress: 'Dest',
          departureTime: DateTime(2026, 1, 1),
          maxPassengers: 4,
          occupiedSeats: 1,
          passengers: [initialPassenger],
          createdAt: DateTime(2026, 1, 1),
        );

        when(
          () => mockGetDetails(10),
        ).thenAnswer((_) async => Right(detailsWithPassenger));
        await testCubit.fetchRoomDetails();

        // Emit final drop off event
        final payload = SharedRidePassengerDroppedPayload(
          sharedRideId: 10,
          userId: 5,
          status: 'DROPPED_OFF',
          passengerId: 81,
          riderProfileId: 5,
          timestamp: DateTime.now(),
          accountHolderOnBoard: false,
          passengerStatus: 'DROPPED_OFF',
          activeSeats: 0,
          seatsNeeded: 2,
          totalPaidFare: 4124.4,
          finalFare: 4124.4,
        );

        dropController.add(payload);
        await Future.delayed(Duration.zero);

        final state = testCubit.state as SharedTripRoomDetailsSuccess;
        expect(state.currentUserDroppedOffPayload, payload);
        expect(state.companionDroppedPayload, isNull);
        expect(state.details.passengers.first.activeSeats, 0);
        expect(state.details.passengers.first.status, 'DROPPED_OFF');
        expect(state.details.passengers.first.accountHolderOnBoard, false);

        await testCubit.close();
        await dropController.close();
      },
    );
  });
}
