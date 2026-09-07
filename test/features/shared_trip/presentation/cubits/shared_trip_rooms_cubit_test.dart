import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/home/domain/entities/place_entity.dart';
import 'package:mashena_rider/features/pool/domain/entities/join_pool_params.dart';
import 'package:mashena_rider/features/pool/domain/entities/pool_room_entity.dart';
import 'package:mashena_rider/features/pool/domain/entities/pool_room_status.dart';
import 'package:mashena_rider/features/pool/domain/entities/pool_suggestion_params.dart';
import 'package:mashena_rider/features/pool/domain/usecases/get_pool_suggestions_usecase.dart';
import 'package:mashena_rider/features/pool/domain/usecases/join_pool_room_usecase.dart';
import 'package:mashena_rider/features/shared_trip/domain/entities/search_shared_ride_params.dart';
import 'package:mashena_rider/features/shared_trip/domain/entities/shared_ride_driver_entity.dart';
import 'package:mashena_rider/features/shared_trip/domain/entities/shared_ride_room_entity.dart';
import 'package:mashena_rider/features/shared_trip/domain/usecases/search_shared_rides_usecase.dart';
import 'package:mashena_rider/features/shared_trip/presentation/cubits/shared_trip_rooms_cubit/shared_trip_rooms_cubit.dart';
import 'package:mashena_rider/features/shared_trip/presentation/cubits/shared_trip_rooms_cubit/shared_trip_rooms_state.dart';
import 'package:mashena_rider/features/shared_trip/presentation/models/shared_trip_rooms_args.dart';

class MockSearchSharedRidesUsecase extends Mock
    implements SearchSharedRidesUsecase {}

class MockGetPoolSuggestionsUsecase extends Mock
    implements GetPoolSuggestionsUsecase {}

class MockJoinPoolRoomUsecase extends Mock implements JoinPoolRoomUsecase {}

class FakeSearchSharedRideParams extends Fake
    implements SearchSharedRideParams {}

class FakePoolSuggestionParams extends Fake implements PoolSuggestionParams {}

class FakeJoinPoolParams extends Fake implements JoinPoolParams {}

void main() {
  late MockSearchSharedRidesUsecase mockSearchUsecase;
  late MockGetPoolSuggestionsUsecase mockPoolSuggestionsUsecase;
  late MockJoinPoolRoomUsecase mockJoinPoolUsecase;
  late SharedTripRoomsCubit cubit;

  setUpAll(() {
    registerFallbackValue(FakeSearchSharedRideParams());
    registerFallbackValue(FakePoolSuggestionParams());
    registerFallbackValue(FakeJoinPoolParams());
  });

  const testPickup = PlaceEntity(
    id: 'p1',
    name: 'Pickup',
    address: 'Pickup Address',
    latitude: 33.5138,
    longitude: 36.2765,
  );

  const testDest = PlaceEntity(
    id: 'd1',
    name: 'Dest',
    address: 'Dest Address',
    latitude: 33.5200,
    longitude: 36.2800,
  );

  final testSharedRoom = SharedRideRoomEntity(
    id: 1,
    driverProfileId: 10,
    vehicleId: 5,
    status: 'open',
    originAddress: 'Origin Address',
    destAddress: 'Dest Address',
    originLat: 33.5138,
    originLng: 36.2765,
    destLat: 33.5200,
    destLng: 36.2800,
    maxPassengers: 4,
    occupiedSeats: 1,
    availableSeats: 3,
    baseTripFare: 2000,
    remainingTripCost: 1500,
    fullRouteSeatFare: 500,
    minimumSeatFare: 300,
    departureTime: DateTime(2026, 1, 1),
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
    driver: const SharedRideDriverEntity(
      id: 10,
      fullName: 'Ahmad Driver',
      ratingAvg: 4.8,
    ),
  );

  const testPoolRoom = PoolRoomEntity(
    id: 101,
    creatorRiderProfileId: 2,
    status: PoolRoomStatus.open,
    meetingLat: 33.5140,
    meetingLng: 36.2770,
    meetingAddress: 'Meeting Point',
    destinationLat: 33.5200,
    destinationLng: 36.2800,
    destinationAddress: 'Dest Address',
    maxPassengers: 4,
    currentPassengers: 2,
  );

  setUp(() {
    mockSearchUsecase = MockSearchSharedRidesUsecase();
    mockPoolSuggestionsUsecase = MockGetPoolSuggestionsUsecase();
    mockJoinPoolUsecase = MockJoinPoolRoomUsecase();

    cubit = SharedTripRoomsCubit(
      searchSharedRidesUsecase: mockSearchUsecase,
      getPoolSuggestionsUsecase: mockPoolSuggestionsUsecase,
      joinPoolRoomUsecase: mockJoinPoolUsecase,
      args: const SharedTripRoomsArgs(
        pickup: testPickup,
        destination: testDest,
      ),
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('SharedTripRoomsCubit', () {
    test(
      'initial state contains args locations, empty lists, and all filter',
      () {
        expect(cubit.state.pickupPlace, testPickup);
        expect(cubit.state.destinationPlace, testDest);
        expect(cubit.state.sharedRooms, isEmpty);
        expect(cubit.state.poolRooms, isEmpty);
        expect(cubit.state.activeFilter, UnifiedRideFilter.all);
        expect(cubit.state.isLoading, isFalse);
      },
    );

    test(
      'searchRooms executes both usecases in parallel and emits shared and pool rooms',
      () async {
        when(
          () => mockSearchUsecase(any()),
        ).thenAnswer((_) async => Right([testSharedRoom]));
        when(
          () => mockPoolSuggestionsUsecase(any()),
        ).thenAnswer((_) async => const Right([testPoolRoom]));

        final expectedStates = [
          predicate<SharedTripRoomsState>((s) => s.isLoading == true),
          predicate<SharedTripRoomsState>(
            (s) =>
                s.isLoading == false &&
                s.sharedRooms.length == 1 &&
                s.poolRooms.length == 1 &&
                s.totalCount == 2 &&
                s.displayedItems.length == 2,
          ),
        ];

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        await cubit.searchRooms();

        verify(() => mockSearchUsecase(any())).called(1);
        verify(() => mockPoolSuggestionsUsecase(any())).called(1);
      },
    );

    test('setFilter correctly filters displayed items', () async {
      when(
        () => mockSearchUsecase(any()),
      ).thenAnswer((_) async => Right([testSharedRoom]));
      when(
        () => mockPoolSuggestionsUsecase(any()),
      ).thenAnswer((_) async => const Right([testPoolRoom]));

      await cubit.searchRooms();

      expect(cubit.state.displayedItems.length, 2);

      cubit.setFilter(UnifiedRideFilter.driverRides);
      expect(cubit.state.activeFilter, UnifiedRideFilter.driverRides);
      expect(cubit.state.displayedItems.length, 1);
      expect(cubit.state.displayedItems.first, isA<DriverRideItem>());

      cubit.setFilter(UnifiedRideFilter.poolLobbies);
      expect(cubit.state.activeFilter, UnifiedRideFilter.poolLobbies);
      expect(cubit.state.displayedItems.length, 1);
      expect(cubit.state.displayedItems.first, isA<PoolLobbyItem>());
    });

    test(
      'joinPoolRoom emits isJoiningPool then success with joinedPoolRoom',
      () async {
        when(
          () => mockJoinPoolUsecase(any(), any()),
        ).thenAnswer((_) async => const Right(testPoolRoom));

        final expectedStates = [
          predicate<SharedTripRoomsState>(
            (s) => s.isJoiningPool == true && s.errorMessage == null,
          ),
          predicate<SharedTripRoomsState>(
            (s) =>
                s.isJoiningPool == false &&
                s.joinedPoolRoom != null &&
                s.joinedPoolRoom!.id == 101,
          ),
        ];

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        await cubit.joinPoolRoom(roomId: 101);

        verify(() => mockJoinPoolUsecase(101, any())).called(1);
      },
    );

    test('joinPoolRoom emits error when join fails', () async {
      when(() => mockJoinPoolUsecase(any(), any())).thenAnswer(
        (_) async =>
            const Left(Failure(FailureCode.server, rawMessage: 'Room is full')),
      );

      final expectedStates = [
        predicate<SharedTripRoomsState>((s) => s.isJoiningPool == true),
        predicate<SharedTripRoomsState>(
          (s) => s.isJoiningPool == false && s.errorMessage == 'Room is full',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.joinPoolRoom(roomId: 101);
    });

    test('searchRooms emits failure when both use cases fail', () async {
      when(() => mockSearchUsecase(any())).thenAnswer(
        (_) async => const Left(
          Failure(FailureCode.server, rawMessage: 'Search failed'),
        ),
      );
      when(() => mockPoolSuggestionsUsecase(any())).thenAnswer(
        (_) async => const Left(
          Failure(FailureCode.server, rawMessage: 'Pool search failed'),
        ),
      );

      final expectedStates = [
        predicate<SharedTripRoomsState>((s) => s.isLoading == true),
        predicate<SharedTripRoomsState>(
          (s) => s.isLoading == false && s.errorMessage != null,
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.searchRooms();
    });
  });
}
