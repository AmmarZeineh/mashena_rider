import 'package:flutter_test/flutter_test.dart';
import 'package:mashena_rider/core/network/api_client.dart';
import 'package:mashena_rider/features/shared_trip/data/datasources/shared_trip_remote_data_source.dart';
import 'package:mashena_rider/features/shared_trip/data/datasources/shared_trip_socket_data_source.dart';
import 'package:mashena_rider/features/shared_trip/data/models/shared_ride_details_response_model.dart';
import 'package:mashena_rider/features/shared_trip/data/models/shared_ride_search_result_model.dart';
import 'package:mashena_rider/features/shared_trip/data/repositories/shared_trip_repository_impl.dart';
import 'package:mashena_rider/features/shared_trip/domain/entities/search_shared_ride_params.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockSharedTripSocketDataSource extends Mock
    implements SharedTripSocketDataSource {}

void main() {

  group('SearchSharedRideParams', () {
    test('toQueryMap formats parameters correctly', () {
      const params = SearchSharedRideParams(
        pickupLat: 33.5138,
        pickupLng: 36.2765,
        dropoffLat: 33.5200,
        dropoffLng: 36.2800,
        seatsNeeded: 2,
        maxDistanceKm: 1.5,
        departureDate: '2026-08-17',
      );

      final map = params.toQueryMap();
      expect(map['pickupLat'], 33.5138);
      expect(map['pickupLng'], 36.2765);
      expect(map['dropoffLat'], 33.5200);
      expect(map['dropoffLng'], 36.2800);
      expect(map['seatsNeeded'], 2);
      expect(map['maxDistanceKm'], 1.5);
      expect(map['departureDate'], '2026-08-17');
    });
  });

  group('SharedRideSearchResultModel', () {
    final sampleSearchJson = <String, dynamic>{
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
      'occupiedSeats': 1,
      'availableSeats': 3,
      'totalDistanceKm': 8.5,
      'totalDurationSec': 900,
      'routeGeometry': null,
      'actualDistanceKm': null,
      'actualDurationSec': null,
      'actualRouteGeometry': null,
      'baseTripFare': 25000.0,
      'remainingTripCost': 18750.0,
      'occupiedSeatsAtStart': null,
      'fullRouteSeatFare': 6250.0,
      'minimumSeatFare': 5000.0,
      'startedAt': null,
      'completedAt': null,
      'canceledAt': null,
      'cancellationReason': null,
      'createdAt': '2026-08-17T07:30:00.000Z',
      'updatedAt': '2026-08-17T07:35:00.000Z',
      'searchDetails': {
        'originDistanceKm': 0.45,
        'destinationDistanceKm': 0.80,
      },
      'driverProfile': {
        'id': 3,
        'userId': 10,
        'city': 'Damascus',
        'ratingAvg': 4.9,
        'isOnline': true,
        'user': {
          'id': 10,
          'fullName': 'Samer Homsi',
        },
      },
      'vehicle': {
        'id': 5,
        'driverProfileId': 3,
        'vehicleTypeId': 1,
        'plateNumber': 'DAM-12345',
        'model': 'Kia Cerato',
        'color': 'Silver',
        'year': 2020,
        'photoUrl': 'https://example.com/uploads/car.jpg',
        'vehicleType': {
          'id': 1,
          'name': 'Sedan',
          'imageUrl': 'https://example.com/uploads/sedan.png',
        },
      },
    };

    test('parses fromJson and converts toEntity accurately', () {
      final model = SharedRideSearchResultModel.fromJson(sampleSearchJson);

      expect(model.id, 12);
      expect(model.driverProfileId, 3);
      expect(model.vehicleId, 5);
      expect(model.status, 'OPEN');
      expect(model.notes, 'Non-smoking ride, please be on time.');
      expect(model.originLat, 33.5138);
      expect(model.originLng, 36.2765);
      expect(model.originAddress, 'Damascus, Baramkeh');
      expect(model.destLat, 33.5200);
      expect(model.destLng, 36.2800);
      expect(model.destAddress, 'Mezzeh, Auto-strad');
      expect(model.maxPassengers, 4);
      expect(model.occupiedSeats, 1);
      expect(model.availableSeats, 3);
      expect(model.totalDistanceKm, 8.5);
      expect(model.totalDurationSec, 900);
      expect(model.baseTripFare, 25000.0);
      expect(model.remainingTripCost, 18750.0);
      expect(model.fullRouteSeatFare, 6250.0);
      expect(model.minimumSeatFare, 5000.0);

      // Driver
      expect(model.driver?.fullName, 'Samer Homsi');
      expect(model.driver?.ratingAvg, 4.9);
      expect(model.driver?.isOnline, true);

      // Vehicle
      expect(model.vehicle?.plateNumber, 'DAM-12345');
      expect(model.vehicle?.model, 'Kia Cerato');
      expect(model.vehicle?.vehicleType?.name, 'Sedan');

      // Search Details
      expect(model.searchDetails?.originDistanceKm, 0.45);
      expect(model.searchDetails?.destinationDistanceKm, 0.80);

      // Entity
      final entity = model.toEntity();
      expect(entity.isOpen, true);
      expect(entity.isCanceled, false);
      expect(entity.farePerSeat, 6250.0);
    });
  });

  group('SharedRideDetailsResponseModel', () {
    final sampleDetailsJson = <String, dynamic>{
      'id': 12,
      'driverProfileId': 3,
      'vehicleId': 5,
      'driver': {
        'id': 3,
        'fullName': 'Samer Homsi',
        'city': 'Damascus',
        'ratingAvg': 4.9,
        'isOnline': true,
      },
      'vehicle': {
        'id': 5,
        'vehicleTypeId': 1,
        'plateNumber': 'DAM-12345',
        'model': 'Kia Cerato',
        'color': 'Silver',
        'year': 2020,
        'photoUrl': 'https://example.com/uploads/car.jpg',
        'vehicleType': {
          'id': 1,
          'name': 'Sedan',
          'imageUrl': 'https://example.com/uploads/sedan.png',
        },
      },
      'status': 'READY',
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
      'occupiedSeats': 2,
      'totalDistanceKm': 8.5,
      'totalDurationSec': 900,
      'routeGeometry': null,
      'actualDistanceKm': null,
      'actualDurationSec': null,
      'actualRouteGeometry': null,
      'baseTripFare': 25000.0,
      'remainingTripCost': 12500.0,
      'occupiedSeatsAtStart': null,
      'fullRouteSeatFare': 6250.0,
      'minimumSeatFare': 5000.0,
      'startedAt': null,
      'completedAt': null,
      'canceledAt': null,
      'cancellationReason': null,
      'endType': null,
      'createdAt': '2026-08-17T07:30:00.000Z',
      'passengers': [
        {
          'id': 101,
          'sharedRideId': 12,
          'riderProfileId': 8,
          'riderName': 'Ahmad Ali',
          'status': 'JOINED',
          'paymentStatus': 'PAID',
          'seatsNeeded': 2,
          'activeSeats': 2,
          'totalPaidFare': 12500.0,
          'finalDistanceKm': null,
          'finalDurationSec': null,
          'finalFare': null,
          'joinedAt': '2026-08-17T07:45:00.000Z',
          'onBoardAt': null,
          'droppedOffAt': null,
          'accountHolderOnBoard': false,
          'accountHolderDroppedOffAt': null,
          'leftAt': null,
          'canceledAt': null,
          'removedAt': null,
          'removeReason': null,
        },
      ],
    };

    test('parses fromJson and converts toEntity accurately', () {
      final model = SharedRideDetailsResponseModel.fromJson(sampleDetailsJson);

      expect(model.id, 12);
      expect(model.status, 'READY');
      expect(model.passengers.length, 1);

      final passenger = model.passengers.first;
      expect(passenger.id, 101);
      expect(passenger.riderName, 'Ahmad Ali');
      expect(passenger.seatsNeeded, 2);
      expect(passenger.totalPaidFare, 12500.0);
      expect(passenger.paymentStatus, 'PAID');

      final entity = model.toEntity();
      expect(entity.availableSeats, 2);
      expect(entity.isFull, false);
      expect(entity.effectiveSeatFare, 6250.0);
      expect(entity.passengers.first.isPaid, true);
    });
  });

  group('SharedTripRemoteDataSource and SharedTripRepositoryImpl', () {
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

    test('searchSharedRides fetches and maps results', () async {
      when(
        () => mockApiClient.get(
          any(),
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) async => [
            {
              'id': 1,
              'driverProfileId': 2,
              'vehicleId': 3,
              'status': 'OPEN',
              'originLat': 33.5,
              'originLng': 36.2,
              'originAddress': 'Origin',
              'destLat': 33.6,
              'destLng': 36.3,
              'destAddress': 'Dest',
              'departureTime': '2026-08-17T09:00:00.000Z',
              'maxPassengers': 4,
              'occupiedSeats': 0,
              'baseTripFare': 10000.0,
              'remainingTripCost': 10000.0,
              'createdAt': '2026-08-17T07:00:00.000Z',
              'updatedAt': '2026-08-17T07:00:00.000Z',
            },
          ]);

      final result = await repository.searchSharedRides(
        const SearchSharedRideParams(
          pickupLat: 33.5,
          pickupLng: 36.2,
          dropoffLat: 33.6,
          dropoffLng: 36.3,
        ),
      );

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should succeed'),
        (rooms) {
          expect(rooms.length, 1);
          expect(rooms.first.id, 1);
          expect(rooms.first.isOpen, true);
        },
      );
    });

    test('getSharedRideDetails fetches and maps room details', () async {
      when(
        () => mockApiClient.get(any()),
      ).thenAnswer((_) async => {
            'id': 12,
            'driverProfileId': 3,
            'vehicleId': 5,
            'status': 'OPEN',
            'originLat': 33.5,
            'originLng': 36.2,
            'originAddress': 'Origin',
            'destLat': 33.6,
            'destLng': 36.3,
            'destAddress': 'Dest',
            'departureTime': '2026-08-17T09:00:00.000Z',
            'maxPassengers': 4,
            'occupiedSeats': 1,
            'baseTripFare': 20000.0,
            'remainingTripCost': 15000.0,
            'createdAt': '2026-08-17T07:00:00.000Z',
            'passengers': [],
          });

      final result = await repository.getSharedRideDetails(12);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should succeed'),
        (details) {
          expect(details.id, 12);
          expect(details.availableSeats, 3);
        },
      );
    });
  });
}
