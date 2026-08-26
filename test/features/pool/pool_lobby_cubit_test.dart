import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mashena_rider/core/services/osrm_route_service.dart';
import 'package:mashena_rider/features/auth/domain/entities/auth_session.dart';
import 'package:mashena_rider/features/auth/domain/entities/user.dart';
import 'package:mashena_rider/features/auth/domain/usecases/get_cached_session_usecase.dart';
import 'package:mashena_rider/features/pool/data/models/pool_socket_events.dart';
import 'package:mashena_rider/features/pool/domain/entities/pool_room_entity.dart';
import 'package:mashena_rider/features/pool/domain/entities/pool_room_status.dart';
import 'package:mashena_rider/features/pool/domain/repositories/pool_repository.dart';
import 'package:mashena_rider/features/pool/domain/usecases/cancel_pool_room_usecase.dart';
import 'package:mashena_rider/features/pool/domain/usecases/get_pool_room_details_usecase.dart';
import 'package:mashena_rider/features/pool/domain/usecases/leave_pool_room_usecase.dart';
import 'package:mashena_rider/features/pool/presentation/cubits/pool_lobby_cubit/pool_lobby_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPoolRoomDetailsUsecase extends Mock
    implements GetPoolRoomDetailsUsecase {}

class MockLeavePoolRoomUsecase extends Mock implements LeavePoolRoomUsecase {}

class MockCancelPoolRoomUsecase extends Mock implements CancelPoolRoomUsecase {}

class MockPoolRepository extends Mock implements PoolRepository {}

class MockGetCachedSessionUsecase extends Mock
    implements GetCachedSessionUsecase {}

class MockOSRMRouteService extends Mock implements OSRMRouteService {}

void main() {
  late MockGetPoolRoomDetailsUsecase mockGetDetails;
  late MockLeavePoolRoomUsecase mockLeave;
  late MockCancelPoolRoomUsecase mockCancel;
  late MockPoolRepository mockRepo;
  late MockGetCachedSessionUsecase mockGetSession;
  late MockOSRMRouteService mockOsrm;

  late StreamController<PoolMemberJoinedPayload> memberJoinedController;
  late StreamController<PoolMemberLeftPayload> memberLeftController;
  late StreamController<PoolMeetingPointUpdatedPayload> meetingPointController;
  late StreamController<PoolRoomReadyPayload> roomReadyController;
  late StreamController<PoolMatchedPayload> matchedController;
  late StreamController<PoolExpiredPayload> expiredController;
  late StreamController<PoolCancelledPayload> cancelledController;
  late StreamController<PoolRemovedPayload> removedController;

  const testRoom = PoolRoomEntity(
    id: 12,
    creatorRiderProfileId: 5,
    status: PoolRoomStatus.open,
    meetingLat: 36.2021,
    meetingLng: 37.1343,
    destinationLat: 36.2121,
    destinationLng: 37.1443,
    maxPassengers: 4,
    currentPassengers: 1,
  );

  final testSession = AuthSession(
    accessToken: 'test_token',
    user: User(
      id: 5,
      fullName: 'Ammar',
      email: 'test@example.com',
      phoneNumber: '+963999999999',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  );

  setUp(() {
    mockGetDetails = MockGetPoolRoomDetailsUsecase();
    mockLeave = MockLeavePoolRoomUsecase();
    mockCancel = MockCancelPoolRoomUsecase();
    mockRepo = MockPoolRepository();
    mockGetSession = MockGetCachedSessionUsecase();
    mockOsrm = MockOSRMRouteService();

    memberJoinedController = StreamController.broadcast();
    memberLeftController = StreamController.broadcast();
    meetingPointController = StreamController.broadcast();
    roomReadyController = StreamController.broadcast();
    matchedController = StreamController.broadcast();
    expiredController = StreamController.broadcast();
    cancelledController = StreamController.broadcast();
    removedController = StreamController.broadcast();

    when(
      () => mockRepo.memberJoinedStream,
    ).thenAnswer((_) => memberJoinedController.stream);
    when(
      () => mockRepo.memberLeftStream,
    ).thenAnswer((_) => memberLeftController.stream);
    when(
      () => mockRepo.meetingPointUpdatedStream,
    ).thenAnswer((_) => meetingPointController.stream);
    when(
      () => mockRepo.roomReadyStream,
    ).thenAnswer((_) => roomReadyController.stream);
    when(
      () => mockRepo.matchedStream,
    ).thenAnswer((_) => matchedController.stream);
    when(
      () => mockRepo.expiredStream,
    ).thenAnswer((_) => expiredController.stream);
    when(
      () => mockRepo.cancelledStream,
    ).thenAnswer((_) => cancelledController.stream);
    when(
      () => mockRepo.removedStream,
    ).thenAnswer((_) => removedController.stream);
    when(() => mockRepo.listenToRoom(any())).thenReturn(null);
    when(() => mockRepo.stopListeningToRoom(any())).thenReturn(null);

    when(() => mockGetSession()).thenAnswer((_) async => Right(testSession));
    when(
      () => mockGetDetails(12),
    ).thenAnswer((_) async => const Right(testRoom));
    when(() => mockOsrm.getRouteDetails(any())).thenAnswer((_) async => null);
  });

  tearDown(() {
    memberJoinedController.close();
    memberLeftController.close();
    meetingPointController.close();
    roomReadyController.close();
    matchedController.close();
    expiredController.close();
    cancelledController.close();
    removedController.close();
  });

  test('PoolLobbyCubit initializes and fetches details', () async {
    final cubit = PoolLobbyCubit(
      getPoolRoomDetailsUsecase: mockGetDetails,
      leavePoolRoomUsecase: mockLeave,
      cancelPoolRoomUsecase: mockCancel,
      repository: mockRepo,
      getCachedSessionUsecase: mockGetSession,
      osrmRouteService: mockOsrm,
      roomId: 12,
    );

    await Future.delayed(const Duration(milliseconds: 50));

    expect(cubit.state.room, testRoom);
    expect(cubit.state.currentUserId, 5);
    expect(cubit.state.isCreator, isTrue);

    await cubit.close();
  });

  test(
    'PoolLobbyCubit updates matchedSharedRideId on matchedStream event',
    () async {
      final cubit = PoolLobbyCubit(
        getPoolRoomDetailsUsecase: mockGetDetails,
        leavePoolRoomUsecase: mockLeave,
        cancelPoolRoomUsecase: mockCancel,
        repository: mockRepo,
        getCachedSessionUsecase: mockGetSession,
        osrmRouteService: mockOsrm,
        roomId: 12,
      );

      await Future.delayed(const Duration(milliseconds: 50));

      matchedController.add(
        const PoolMatchedPayload(
          roomId: 12,
          sharedRideId: 88,
          driverProfileId: 3,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 50));

      expect(cubit.state.matchedSharedRideId, 88);
      expect(cubit.state.matchedDriverProfileId, 3);

      await cubit.close();
    },
  );
}
