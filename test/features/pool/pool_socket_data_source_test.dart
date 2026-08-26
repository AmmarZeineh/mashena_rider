import 'package:flutter_test/flutter_test.dart';
import 'package:mashena_rider/core/network/socket_client.dart';
import 'package:mashena_rider/features/pool/data/datasources/pool_socket_data_source.dart';
import 'package:mashena_rider/features/pool/data/models/pool_socket_events.dart';
import 'package:mocktail/mocktail.dart';

class MockSocketClient extends Mock implements SocketClient {}

void main() {
  group('PoolSocketDataSourceImpl', () {
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
      when(() => mockSocketClient.emit(any(), any())).thenReturn(null);
      when(() => mockSocketClient.emit(any())).thenReturn(null);

      when(() => mockSocketClient.on(any(), any())).thenAnswer((invocation) {
        final event = invocation.positionalArguments[0] as String;
        final cb = invocation.positionalArguments[1] as void Function(dynamic);
        registeredCallbacks[event] = cb;
      });
    });

    test('registers listeners and emits member joined payload on stream', () async {
      final dataSource = PoolSocketDataSourceImpl(mockSocketClient);

      expect(registeredCallbacks.containsKey('pool:member_joined'), isTrue);

      expectLater(
        dataSource.memberJoinedStream,
        emits(
          isA<PoolMemberJoinedPayload>()
              .having((p) => p.roomId, 'roomId', 10)
              .having((p) => p.currentPassengers, 'currentPassengers', 2),
        ),
      );

      registeredCallbacks['pool:member_joined']!({
        'roomId': 10,
        'currentPassengers': 2,
        'member': {
          'id': 1,
          'riderProfileId': 5,
          'name': 'Test Rider',
          'seats': 1,
        },
      });

      await dataSource.dispose();
    });

    test('tracks and re-joins active rooms when socket reconnects', () async {
      final dataSource = PoolSocketDataSourceImpl(mockSocketClient);

      dataSource.listenToRoom(42);
      verify(() => mockSocketClient.emit('join_pool_room', 42)).called(1);

      dataSource.stopListeningToRoom(42);
      verify(() => mockSocketClient.emit('leave_pool_room', 42)).called(1);

      await dataSource.dispose();
    });
  });
}
