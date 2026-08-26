import 'package:flutter_test/flutter_test.dart';
import 'package:mashena_rider/app/config/app_config.dart';
import 'package:mashena_rider/core/auth/auth_event.dart';
import 'package:mashena_rider/core/auth/auth_event_bus.dart';
import 'package:mashena_rider/core/network/socket_io_client_impl.dart';
import 'package:mashena_rider/core/network/token_refresh_service.dart';
import 'package:mocktail/mocktail.dart';

class MockTokenRefreshService extends Mock implements TokenRefreshService {}

void main() {
  late MockTokenRefreshService mockTokenRefreshService;
  late AuthEventBus authEventBus;
  late AppConfig config;
  late SocketIOClientImpl client;

  setUp(() {
    mockTokenRefreshService = MockTokenRefreshService();
    authEventBus = AuthEventBus();
    config = const AppConfig(
      baseUrl: 'https://api.example.com',
      socketUrl: 'https://api.example.com',
      apiKey: 'test-key',
    );
    client = SocketIOClientImpl(config, mockTokenRefreshService, authEventBus);
  });

  tearDown(() {
    client.dispose();
    authEventBus.dispose();
  });

  group('SocketIOClientImpl', () {
    test('initial state has isConnected as false', () {
      expect(client.isConnected, isFalse);
    });

    test('connect does nothing if access token is null or empty', () async {
      when(
        () => mockTokenRefreshService.getValidAccessToken(),
      ).thenAnswer((_) async => null);

      final statusEvents = <bool>[];
      final sub = client.connectionStatusStream.listen(statusEvents.add);

      await client.connect();
      await pumpEventQueue();

      expect(client.isConnected, isFalse);
      expect(statusEvents, contains(false));
      await sub.cancel();
    });

    test('disconnect sets connected to false and clears socket', () async {
      client.disconnect();
      expect(client.isConnected, isFalse);
    });

    test('AuthEvent.loggedOut triggers disconnect', () async {
      authEventBus.emit(AuthEvent.loggedOut);
      await pumpEventQueue();
      expect(client.isConnected, isFalse);
    });

    test('ensureConnected returns false when token is unavailable', () async {
      when(
        () => mockTokenRefreshService.getValidAccessToken(),
      ).thenAnswer((_) async => null);

      final connected = await client.ensureConnected(
        timeout: const Duration(milliseconds: 100),
      );
      expect(connected, isFalse);
      expect(client.isConnected, isFalse);
    });

    test('AuthEvent.tokenRefreshed triggers reconnect with valid token',
        () async {
      when(
        () => mockTokenRefreshService.getValidAccessToken(),
      ).thenAnswer((_) async => 'fresh_access_token');

      authEventBus.emit(AuthEvent.tokenRefreshed);
      await pumpEventQueue();

      verify(() => mockTokenRefreshService.getValidAccessToken()).called(1);
    });

    test('concurrent connect calls coalesce onto single operation', () async {
      when(
        () => mockTokenRefreshService.getValidAccessToken(),
      ).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 20));
        return null;
      });

      final f1 = client.connect();
      final f2 = client.connect();
      await Future.wait([f1, f2]);

      verify(() => mockTokenRefreshService.getValidAccessToken()).called(1);
    });

    test('on and off unregisters specific callbacks without error', () {
      void callback1(dynamic data) {}
      void callback2(dynamic data) {}

      client.on('test:event', callback1);
      client.on('test:event', callback2);

      // Remove specific callback
      client.off('test:event', callback1);

      // Remove all remaining
      client.off('test:event');
    });
  });
}

