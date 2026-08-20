import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/auth/domain/usecases/get_cached_session_usecase.dart';
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
class MockGetSharedRideDetailsUsecase extends Mock implements GetSharedRideDetailsUsecase {}
class MockJoinSharedRideUsecase extends Mock implements JoinSharedRideUsecase {}
class MockLeaveSharedRideUsecase extends Mock implements LeaveSharedRideUsecase {}
class MockGetCachedSessionUsecase extends Mock implements GetCachedSessionUsecase {}
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

    when(() => mockGetCachedSession()).thenAnswer(
      (_) async => const Left(Failure(FailureCode.cache)),
    );
    when(() => mockRepo.driverLocationStream).thenAnswer((_) => const Stream.empty());
    when(() => mockRepo.passengerJoinedStream).thenAnswer((_) => const Stream.empty());
    when(() => mockRepo.passengerLeftStream).thenAnswer((_) => const Stream.empty());
    when(() => mockRepo.passengerRemovedStream).thenAnswer((_) => const Stream.empty());
    when(() => mockRepo.riderRemovedStream).thenAnswer((_) => const Stream.empty());
    when(() => mockRepo.roomReadyStream).thenAnswer((_) => const Stream.empty());
    when(() => mockRepo.tripStartedStream).thenAnswer((_) => const Stream.empty());
    when(() => mockRepo.passengerOnBoardStream).thenAnswer((_) => const Stream.empty());
    when(() => mockRepo.passengerDroppedStream).thenAnswer((_) => const Stream.empty());
    when(() => mockRepo.tripCompletedStream).thenAnswer((_) => const Stream.empty());
    when(() => mockRepo.tripCancelledStream).thenAnswer((_) => const Stream.empty());
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
      when(() => mockGetDetails(10)).thenAnswer((_) async => Right(testDetails));

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
        (_) async => const Left(Failure(FailureCode.notFound, rawMessage: 'Room not found')),
      );

      final expectedStates = [
        isA<SharedTripRoomDetailsLoading>(),
        predicate<SharedTripRoomDetailsState>(
          (s) => s is SharedTripRoomDetailsError && s.message == 'Room not found',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.fetchRoomDetails();
    });

    test('joinRoom sets isJoining and updates details on success', () async {
      when(() => mockGetDetails(10)).thenAnswer((_) async => Right(testDetails));
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

      when(() => mockJoin(any())).thenAnswer((_) async => Right(joinedPassenger));

      await cubit.joinRoom(seatsNeeded: 1);

      expect(cubit.state, isA<SharedTripRoomDetailsSuccess>());
      verify(() => mockJoin(any())).called(1);
    });

    test('leaveRoom sets isLeaving and updates details on success', () async {
      when(() => mockGetDetails(10)).thenAnswer((_) async => Right(testDetails));
      await cubit.fetchRoomDetails();

      final updatedDetails = testDetails;
      when(() => mockLeave(10)).thenAnswer((_) async => Right(updatedDetails));

      await cubit.leaveRoom();

      expect(cubit.state, isA<SharedTripRoomDetailsSuccess>());
      verify(() => mockLeave(10)).called(1);
    });
  });
}
