import 'package:flutter_test/flutter_test.dart';
import 'package:mashena_rider/core/network/socket_client.dart';
import 'package:mashena_rider/features/moderation/data/datasources/moderation_socket_data_source.dart';
import 'package:mocktail/mocktail.dart';

class MockSocketClient extends Mock implements SocketClient {}

void main() {
  group('ModerationSocketDataSourceImpl', () {
    late MockSocketClient mockSocketClient;
    final Map<String, void Function(dynamic)> registeredCallbacks = {};

    setUp(() {
      mockSocketClient = MockSocketClient();
      registeredCallbacks.clear();

      when(() => mockSocketClient.connect()).thenAnswer((_) async {});
      when(() => mockSocketClient.off(any(), any())).thenReturn(null);
      when(() => mockSocketClient.off(any())).thenReturn(null);

      when(() => mockSocketClient.on(any(), any())).thenAnswer((invocation) {
        final event = invocation.positionalArguments[0] as String;
        final cb = invocation.positionalArguments[1] as void Function(dynamic);
        registeredCallbacks[event] = cb;
      });
    });

    test('registers listeners and emits penalty and restriction events', () async {
      final dataSource = ModerationSocketDataSourceImpl(mockSocketClient);

      expect(registeredCallbacks.containsKey('moderation:penalty_issued'), isTrue);
      expect(registeredCallbacks.containsKey('moderation:restriction_lifted'), isTrue);

      expectLater(
        dataSource.penaltyIssuedStream,
        emits(
          predicate<Map<String, dynamic>>(
            (map) => map['penaltyType'] == 'SUSPENSION' && map['reason'] == 'Late cancellation',
          ),
        ),
      );

      registeredCallbacks['moderation:penalty_issued']!({
        'penaltyType': 'SUSPENSION',
        'reason': 'Late cancellation',
      });

      await dataSource.dispose();
    });
  });
}
