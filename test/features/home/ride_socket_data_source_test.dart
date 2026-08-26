import 'package:flutter_test/flutter_test.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/core/network/socket_client.dart';
import 'package:mashena_rider/features/home/data/datasources/ride_socket_data_source.dart';
import 'package:mashena_rider/features/home/data/models/driver_arrived_payload.dart';
import 'package:mocktail/mocktail.dart';

class MockSocketClient extends Mock implements SocketClient {}

void main() {
  group('RideSocketDataSourceImpl', () {
    late MockSocketClient mockSocketClient;
    final Map<String, void Function(dynamic)> registeredCallbacks = {};

    setUp(() {
      mockSocketClient = MockSocketClient();
      registeredCallbacks.clear();

      when(
        () => mockSocketClient.connectionStatusStream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSocketClient.off(any(), any())).thenReturn(null);
      when(() => mockSocketClient.off(any())).thenReturn(null);

      when(() => mockSocketClient.on(any(), any())).thenAnswer((invocation) {
        final event = invocation.positionalArguments[0] as String;
        final cb = invocation.positionalArguments[1] as void Function(dynamic);
        registeredCallbacks[event] = cb;
      });
    });

    test('registers listeners and emits ride matched & driver location', () async {
      final dataSource = RideSocketDataSourceImpl(mockSocketClient);

      expect(registeredCallbacks.containsKey('ride:matched'), isTrue);
      expect(registeredCallbacks.containsKey('driver:location'), isTrue);
      expect(registeredCallbacks.containsKey('trip:driver-arrived'), isTrue);

      expectLater(
        dataSource.rideMatchedStream,
        emits(123),
      );

      expectLater(
        dataSource.driverLocationStream,
        emits(
          isA<MapLatLng>()
              .having((p) => p.latitude, 'latitude', 33.51)
              .having((p) => p.longitude, 'longitude', 36.27),
        ),
      );

      expectLater(
        dataSource.driverArrivedStream,
        emits(
          isA<DriverArrivedPayload>()
              .having((p) => p.tripId, 'tripId', 99),
        ),
      );

      registeredCallbacks['ride:matched']!({'rideRequestId': 123});
      registeredCallbacks['driver:location']!({'lat': 33.51, 'lng': 36.27});
      registeredCallbacks['trip:driver-arrived']!({'tripId': 99});

      await dataSource.dispose();
    });
  });
}
