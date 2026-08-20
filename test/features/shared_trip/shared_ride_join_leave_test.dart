import 'package:flutter_test/flutter_test.dart';
import 'package:mashena_rider/core/network/api_client.dart';
import 'package:mashena_rider/features/shared_trip/data/datasources/shared_trip_remote_data_source.dart';
import 'package:mashena_rider/features/shared_trip/data/datasources/shared_trip_socket_data_source.dart';
import 'package:mashena_rider/features/shared_trip/data/repositories/shared_trip_repository_impl.dart';
import 'package:mashena_rider/features/shared_trip/domain/entities/join_shared_ride_params.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}
class MockSharedTripSocketDataSource extends Mock
    implements SharedTripSocketDataSource {}

void main() {
  group('JoinSharedRideParams', () {
    test('toJson serializes correctly', () {
      const params = JoinSharedRideParams(roomId: 12, seatsNeeded: 2);
      expect(params.roomId, 12);
      expect(params.toJson(), {'seatsNeeded': 2});
    });
  });

  group('Join & Leave Shared Ride Data Source and Repository', () {
    late MockApiClient mockApiClient;
    late MockSharedTripSocketDataSource mockSocketDataSource;
    late SharedTripRemoteDataSourceImpl dataSource;
    late SharedTripRepositoryImpl repository;

    setUp(() {
      mockApiClient = MockApiClient();
      mockSocketDataSource = MockSharedTripSocketDataSource();
      dataSource = SharedTripRemoteDataSourceImpl(mockApiClient);
      repository = SharedTripRepositoryImpl(
        remoteDataSource: dataSource,
        socketDataSource: mockSocketDataSource,
      );
    });

    test('joinSharedRide calls API and maps response to SharedRidePassengerEntity', () async {
      when(
        () => mockApiClient.post(
          '/shared-rides/12/join',
          body: {'seatsNeeded': 2},
        ),
      ).thenAnswer((_) async => {
            'id': 105,
            'sharedRideId': 12,
            'riderProfileId': 8,
            'riderName': 'Ahmad Ali',
            'status': 'JOINED',
            'paymentStatus': 'PENDING',
            'seatsNeeded': 2,
            'activeSeats': 2,
            'totalPaidFare': 0.0,
            'finalDistanceKm': null,
            'finalDurationSec': null,
            'finalFare': null,
            'joinedAt': '2026-08-17T09:15:00.000Z',
            'onBoardAt': null,
            'droppedOffAt': null,
            'accountHolderOnBoard': false,
            'accountHolderDroppedOffAt': null,
            'leftAt': null,
            'canceledAt': null,
            'removedAt': null,
            'removeReason': null,
          });

      final result = await repository.joinSharedRide(
        const JoinSharedRideParams(roomId: 12, seatsNeeded: 2),
      );

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should succeed'),
        (passenger) {
          expect(passenger.id, 105);
          expect(passenger.sharedRideId, 12);
          expect(passenger.riderName, 'Ahmad Ali');
          expect(passenger.seatsNeeded, 2);
          expect(passenger.status, 'JOINED');
          expect(passenger.paymentStatus, 'PENDING');
          expect(passenger.totalPaidFare, 0.0);
        },
      );
    });

    test('leaveSharedRide calls API and maps response to updated SharedRideRoomDetailsEntity', () async {
      when(
        () => mockApiClient.post('/shared-rides/12/leave'),
      ).thenAnswer((_) async => {
            'id': 12,
            'driverProfileId': 3,
            'vehicleId': 5,
            'status': 'OPEN',
            'endedBy': null,
            'notes': 'Non-smoking ride, please be on time.',
            'originLat': 33.5138,
            'originLng': 36.2765,
            'originAddress': 'Damascus, Baramkeh',
            'destLat': 33.5200,
            'destLng': 36.2800,
            'destAddress': 'Mezzeh, Auto-strad',
            'departureTime': '2026-08-17T09:00:00.000Z',
            'maxPassengers': 4,
            'occupiedSeats': 0,
            'totalDistanceKm': 8.5,
            'totalDurationSec': 900,
            'routeGeometry': null,
            'actualDistanceKm': null,
            'actualDurationSec': null,
            'actualRouteGeometry': null,
            'baseTripFare': 25000.0,
            'remainingTripCost': 25000.0,
            'occupiedSeatsAtStart': null,
            'fullRouteSeatFare': 6250.0,
            'minimumSeatFare': 5000.0,
            'startedAt': null,
            'completedAt': null,
            'canceledAt': null,
            'cancellationReason': null,
            'endType': null,
            'createdAt': '2026-08-17T07:30:00.000Z',
            'passengers': [],
          });

      final result = await repository.leaveSharedRide(12);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should succeed'),
        (details) {
          expect(details.id, 12);
          expect(details.occupiedSeats, 0);
          expect(details.availableSeats, 4);
          expect(details.status, 'OPEN');
          expect(details.passengers.isEmpty, true);
        },
      );
    });
  });
}
