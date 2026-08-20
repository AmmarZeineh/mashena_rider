import 'package:flutter_test/flutter_test.dart';
import 'package:mashena_rider/core/network/socket_client.dart';
import 'package:mashena_rider/features/shared_trip/data/datasources/shared_trip_socket_data_source.dart';
import 'package:mashena_rider/features/shared_trip/data/models/shared_ride_socket_events.dart';
import 'package:mocktail/mocktail.dart';

class MockSocketClient extends Mock implements SocketClient {}

void main() {
  group('Shared Ride WebSocket Event Models Parsing', () {
    test('SharedRideDriverLocationPayload fromJson parses correctly', () {
      final json = {
        'sharedRideId': 12,
        'event': 'shared_ride:driver_location',
        'timestamp': '2026-08-17T09:01:25.000Z',
        'lat': 33.5145,
        'lng': 36.2770,
      };

      final payload = SharedRideDriverLocationPayload.fromJson(json);
      expect(payload.sharedRideId, 12);
      expect(payload.lat, 33.5145);
      expect(payload.lng, 36.2770);
      expect(payload.position.latitude, 33.5145);
      expect(payload.position.longitude, 36.2770);
    });

    test('SharedRidePassengerJoinedPayload fromJson parses correctly', () {
      final json = {
        'sharedRideId': 12,
        'event': 'shared_ride:passenger_joined',
        'timestamp': '2026-08-17T09:01:00.000Z',
        'userId': 15,
        'passenger': {
          'id': 102,
          'sharedRideId': 12,
          'riderProfileId': 9,
          'riderName': 'Kareem Nader',
          'status': 'JOINED',
          'paymentStatus': 'PAID',
          'seatsNeeded': 1,
          'activeSeats': 1,
          'totalPaidFare': 6250.0,
          'joinedAt': '2026-08-17T09:01:00.000Z',
        },
      };

      final payload = SharedRidePassengerJoinedPayload.fromJson(json);
      expect(payload.sharedRideId, 12);
      expect(payload.userId, 15);
      expect(payload.passenger.id, 102);
      expect(payload.passenger.riderName, 'Kareem Nader');
      expect(payload.passenger.totalPaidFare, 6250.0);
    });

    test('SharedRidePassengerRemovedPayload fromJson parses correctly', () {
      final json = {
        'sharedRideId': 12,
        'event': 'shared_ride:passenger_removed',
        'timestamp': '2026-08-17T09:03:00.000Z',
        'userId': 15,
        'reason': 'Passenger did not show up at pickup point',
      };

      final payload = SharedRidePassengerRemovedPayload.fromJson(json);
      expect(payload.sharedRideId, 12);
      expect(payload.userId, 15);
      expect(payload.reason, 'Passenger did not show up at pickup point');
    });

    test('SharedRidePassengerOnBoardPayload fromJson parses correctly', () {
      final json = {
        'sharedRideId': 12,
        'event': 'shared_ride:passenger_on_board',
        'timestamp': '2026-08-17T09:15:00.000Z',
        'userId': 10,
        'status': 'ON_BOARD',
        'passenger': {
          'id': 101,
          'sharedRideId': 12,
          'riderProfileId': 8,
          'status': 'ON_BOARD',
          'onBoardAt': '2026-08-17T09:15:00.000Z',
        },
      };

      final payload = SharedRidePassengerOnBoardPayload.fromJson(json);
      expect(payload.sharedRideId, 12);
      expect(payload.userId, 10);
      expect(payload.passengerId, 101);
      expect(payload.riderProfileId, 8);
      expect(payload.status, 'ON_BOARD');
    });

    test('SharedRidePassengerDroppedPayload fromJson parses correctly', () {
      final json = {
        'sharedRideId': 12,
        'event': 'shared_ride:passenger_dropped',
        'timestamp': '2026-08-17T09:30:00.000Z',
        'userId': 10,
        'status': 'DROPPED_OFF',
        'passenger': {
          'id': 101,
          'sharedRideId': 12,
          'riderProfileId': 8,
          'status': 'DROPPED_OFF',
          'droppedOffAt': '2026-08-17T09:30:00.000Z',
          'finalFare': 6250.0,
          'finalDistanceKm': 8.2,
          'finalDurationSec': 850,
        },
      };

      final payload = SharedRidePassengerDroppedPayload.fromJson(json);
      expect(payload.sharedRideId, 12);
      expect(payload.passengerId, 101);
      expect(payload.finalFare, 6250.0);
      expect(payload.finalDistanceKm, 8.2);
      expect(payload.finalDurationSec, 850);
    });

    test('SharedRideCancelledPayload fromJson parses correctly', () {
      final json = {
        'sharedRideId': 12,
        'event': 'shared_ride:cancelled',
        'timestamp': '2026-08-17T09:05:00.000Z',
        'status': 'CANCELED',
        'cancellationReason': 'Driver had a flat tire',
      };

      final payload = SharedRideCancelledPayload.fromJson(json);
      expect(payload.sharedRideId, 12);
      expect(payload.status, 'CANCELED');
      expect(payload.cancellationReason, 'Driver had a flat tire');
    });

    test('SharedRidePresencePayload fromJson parses correctly', () {
      final json = {
        'sharedRideId': 12,
        'timestamp': '2026-08-17T09:00:00.000Z',
        'userId': 3,
      };

      final payload = SharedRidePresencePayload.fromJson(
        json,
        isOnline: true,
        isDriver: true,
      );
      expect(payload.sharedRideId, 12);
      expect(payload.userId, 3);
      expect(payload.isOnline, true);
      expect(payload.isDriver, true);
    });
  });

  group('SharedTripSocketDataSourceImpl', () {
    late MockSocketClient mockSocketClient;
    final Map<String, void Function(dynamic)> registeredCallbacks = {};

    setUp(() {
      mockSocketClient = MockSocketClient();
      registeredCallbacks.clear();

      when(() => mockSocketClient.on(any(), any())).thenAnswer((invocation) {
        final event = invocation.positionalArguments[0] as String;
        final cb = invocation.positionalArguments[1] as void Function(dynamic);
        registeredCallbacks[event] = cb;
      });
    });

    test('registers listeners and emits driver location on stream', () async {
      final dataSource = SharedTripSocketDataSourceImpl(mockSocketClient);

      expect(registeredCallbacks.containsKey('shared_ride:driver_location'), true);

      expectLater(
        dataSource.driverLocationStream,
        emits(
          isA<SharedRideDriverLocationPayload>()
              .having((p) => p.lat, 'lat', 33.5145)
              .having((p) => p.lng, 'lng', 36.2770),
        ),
      );

      registeredCallbacks['shared_ride:driver_location']!({
        'sharedRideId': 12,
        'lat': 33.5145,
        'lng': 36.2770,
      });

      await dataSource.dispose();
    });
  });
}
