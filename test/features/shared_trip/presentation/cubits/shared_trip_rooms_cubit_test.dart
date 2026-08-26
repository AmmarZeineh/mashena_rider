import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/home/domain/entities/place_entity.dart';
import 'package:mashena_rider/features/shared_trip/domain/entities/search_shared_ride_params.dart';
import 'package:mashena_rider/features/shared_trip/domain/entities/shared_ride_driver_entity.dart';
import 'package:mashena_rider/features/shared_trip/domain/entities/shared_ride_room_entity.dart';
import 'package:mashena_rider/features/shared_trip/domain/usecases/search_shared_rides_usecase.dart';
import 'package:mashena_rider/features/shared_trip/presentation/cubits/shared_trip_rooms_cubit/shared_trip_rooms_cubit.dart';
import 'package:mashena_rider/features/shared_trip/presentation/cubits/shared_trip_rooms_cubit/shared_trip_rooms_state.dart';
import 'package:mashena_rider/features/shared_trip/presentation/models/shared_trip_rooms_args.dart';

class MockSearchSharedRidesUsecase extends Mock
    implements SearchSharedRidesUsecase {}

class FakeSearchSharedRideParams extends Fake
    implements SearchSharedRideParams {}

void main() {
  late MockSearchSharedRidesUsecase mockSearchUsecase;
  late SharedTripRoomsCubit cubit;

  setUpAll(() {
    registerFallbackValue(FakeSearchSharedRideParams());
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

  final testRoom = SharedRideRoomEntity(
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

  setUp(() {
    mockSearchUsecase = MockSearchSharedRidesUsecase();
    cubit = SharedTripRoomsCubit(
      searchSharedRidesUsecase: mockSearchUsecase,
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
    test('initial state contains args locations and empty rooms', () {
      expect(cubit.state.pickupPlace, testPickup);
      expect(cubit.state.destinationPlace, testDest);
      expect(cubit.state.rooms, isEmpty);
      expect(cubit.state.isLoading, isFalse);
    });

    test('searchRooms emits loading then success with found rooms', () async {
      when(
        () => mockSearchUsecase(any()),
      ).thenAnswer((_) async => Right([testRoom]));

      final expectedStates = [
        predicate<SharedTripRoomsState>((s) => s.isLoading == true),
        predicate<SharedTripRoomsState>(
          (s) =>
              s.isLoading == false &&
              s.rooms.length == 1 &&
              s.rooms.first.id == 1,
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.searchRooms();
    });

    test('searchRooms emits failure on error', () async {
      when(() => mockSearchUsecase(any())).thenAnswer(
        (_) async => const Left(
          Failure(FailureCode.server, rawMessage: 'Search failed'),
        ),
      );

      final expectedStates = [
        predicate<SharedTripRoomsState>((s) => s.isLoading == true),
        predicate<SharedTripRoomsState>(
          (s) => s.isLoading == false && s.errorMessage == 'Search failed',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.searchRooms();
    });
  });
}
