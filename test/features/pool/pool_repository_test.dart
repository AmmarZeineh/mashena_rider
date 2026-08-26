import 'package:flutter_test/flutter_test.dart';
import 'package:mashena_rider/features/pool/data/datasources/pool_remote_data_source.dart';
import 'package:mashena_rider/features/pool/data/datasources/pool_socket_data_source.dart';
import 'package:mashena_rider/features/pool/data/models/pool_room_model.dart';
import 'package:mashena_rider/features/pool/data/repositories/pool_repository_impl.dart';
import 'package:mashena_rider/features/pool/domain/entities/create_pool_params.dart';
import 'package:mashena_rider/features/pool/domain/entities/join_pool_params.dart';
import 'package:mashena_rider/features/pool/domain/entities/pool_suggestion_params.dart';
import 'package:mocktail/mocktail.dart';

class MockPoolRemoteDataSource extends Mock implements PoolRemoteDataSource {}

class MockPoolSocketDataSource extends Mock implements PoolSocketDataSource {}

void main() {
  late MockPoolRemoteDataSource mockRemoteDataSource;
  late MockPoolSocketDataSource mockSocketDataSource;
  late PoolRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockPoolRemoteDataSource();
    mockSocketDataSource = MockPoolSocketDataSource();
    repository = PoolRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      socketDataSource: mockSocketDataSource,
    );
  });

  final testRoomModel = PoolRoomModel(
    id: 12,
    creatorRiderProfileId: 5,
    status: 'OPEN',
    meetingLat: 36.2021,
    meetingLng: 37.1343,
    destinationLat: 36.2121,
    destinationLng: 37.1443,
    maxPassengers: 4,
    currentPassengers: 1,
  );

  group('PoolRepositoryImpl', () {
    test('getSuggestions returns List of PoolRoomEntity on success', () async {
      const params = PoolSuggestionParams(
        pickupLat: 36.2021,
        pickupLng: 37.1343,
        destinationLat: 36.2121,
        destinationLng: 37.1443,
      );

      when(
        () => mockRemoteDataSource.getSuggestions(params),
      ).thenAnswer((_) async => [testRoomModel]);

      final result = await repository.getSuggestions(params);

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('Expected right'), (rooms) {
        expect(rooms.length, 1);
        expect(rooms.first.id, 12);
      });
    });

    test('createPoolRoom returns PoolRoomEntity on success', () async {
      final params = CreatePoolParams(
        pickupLat: 36.2021,
        pickupLng: 37.1343,
        pickupAddress: 'Pickup',
        destinationLat: 36.2121,
        destinationLng: 37.1443,
        destinationAddress: 'Dest',
        departureTime: DateTime.now(),
      );

      when(
        () => mockRemoteDataSource.createPoolRoom(params),
      ).thenAnswer((_) async => testRoomModel);

      final result = await repository.createPoolRoom(params);

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('Expected right'), (room) => expect(room.id, 12));
    });

    test('joinPoolRoom returns updated room on success', () async {
      const params = JoinPoolParams(
        pickupLat: 36.2050,
        pickupLng: 37.1380,
        pickupAddress: 'Address',
      );

      when(
        () => mockRemoteDataSource.joinPoolRoom(12, params),
      ).thenAnswer((_) async => testRoomModel);

      final result = await repository.joinPoolRoom(12, params);

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('Expected right'), (room) => expect(room.id, 12));
    });
  });
}
