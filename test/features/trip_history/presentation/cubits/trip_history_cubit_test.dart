import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/trip_history/domain/entities/rider_trip_status.dart';
import 'package:mashena_rider/features/trip_history/domain/entities/trip_history_item.dart';
import 'package:mashena_rider/features/trip_history/domain/repositories/trip_history_repository.dart';
import 'package:mashena_rider/features/trip_history/presentation/cubits/trip_history_cubit.dart';
import 'package:mashena_rider/features/trip_history/presentation/cubits/trip_history_state.dart';

class MockTripHistoryRepository extends Mock implements TripHistoryRepository {}

void main() {
  late MockTripHistoryRepository mockRepo;
  late TripHistoryCubit cubit;

  const testTrip1 = TripHistoryItem(
    id: 1,
    rideRequestId: 101,
    status: 'completed',
    statusEnum: RiderTripStatus.completed,
    pickupAddress: 'Pickup 1',
    destAddress: 'Dest 1',
    finalFare: 2500,
  );

  const testTrip2 = TripHistoryItem(
    id: 2,
    rideRequestId: 102,
    status: 'canceled',
    statusEnum: RiderTripStatus.canceled,
    pickupAddress: 'Pickup 2',
    destAddress: 'Dest 2',
    finalFare: 0,
  );

  setUp(() {
    mockRepo = MockTripHistoryRepository();
    cubit = TripHistoryCubit(mockRepo);
  });

  tearDown(() {
    cubit.close();
  });

  group('TripHistoryCubit', () {
    test('initial state has initial status and empty items', () {
      expect(cubit.state.status, TripHistoryStatus.initial);
      expect(cubit.state.items, isEmpty);
      expect(cubit.state.hasMore, isTrue);
    });

    test('fetchInitialTrips emits loading then success with items', () async {
      when(
        () => mockRepo.getRiderTripHistory(skip: 0, limit: any(named: 'limit')),
      ).thenAnswer((_) async => const Right([testTrip1, testTrip2]));

      final expectedStates = [
        predicate<TripHistoryState>((s) => s.status == TripHistoryStatus.loading),
        predicate<TripHistoryState>(
          (s) =>
              s.status == TripHistoryStatus.success &&
              s.items.length == 2 &&
              s.items.first.id == 1,
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.fetchInitialTrips();
    });

    test('fetchInitialTrips emits failure on repository error', () async {
      when(
        () => mockRepo.getRiderTripHistory(
          skip: 0,
          limit: any(named: 'limit'),
          status: any(named: 'status'),
        ),
      ).thenAnswer(
        (_) async => const Left(Failure(FailureCode.server, rawMessage: 'Fetch failed')),
      );

      final expectedStates = [
        predicate<TripHistoryState>((s) => s.status == TripHistoryStatus.loading),
        predicate<TripHistoryState>(
          (s) =>
              s.status == TripHistoryStatus.failure &&
              s.failure?.rawMessage == 'Fetch failed',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.fetchInitialTrips();
    });

    test('selectStatusFilter resets items and fetches with new filter', () async {
      when(
        () => mockRepo.getRiderTripHistory(
          skip: 0,
          limit: any(named: 'limit'),
          status: RiderTripStatus.completed,
        ),
      ).thenAnswer((_) async => const Right([testTrip1]));

      await cubit.selectStatusFilter(RiderTripStatus.completed);

      expect(cubit.state.selectedStatusFilter, RiderTripStatus.completed);
      expect(cubit.state.items, [testTrip1]);
    });

    test('loadNextPage appends items and increments page', () async {
      final initialTen = List.generate(
        10,
        (i) => TripHistoryItem(
          id: i,
          status: 'completed',
          pickupAddress: 'P$i',
          destAddress: 'D$i',
          finalFare: 1000,
        ),
      );

      when(
        () => mockRepo.getRiderTripHistory(skip: 0, limit: 10),
      ).thenAnswer((_) async => Right(initialTen));

      await cubit.fetchInitialTrips();
      expect(cubit.state.hasMore, isTrue);
      expect(cubit.state.page, 1);

      when(
        () => mockRepo.getRiderTripHistory(skip: 10, limit: 10),
      ).thenAnswer((_) async => const Right([testTrip1]));

      await cubit.loadNextPage();

      expect(cubit.state.items.length, 11);
      expect(cubit.state.page, 2);
    });
  });
}
