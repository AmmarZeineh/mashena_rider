import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mashena_rider/core/network/auth_interceptor.dart';
import 'package:mashena_rider/core/network/network_constants.dart';
import 'package:mashena_rider/core/network/token_manager.dart';
import 'package:mashena_rider/core/network/token_refresh_service.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockTokenManager extends Mock implements TokenManager {}

class MockTokenRefreshService extends Mock implements TokenRefreshService {}

class FakeRequestOptions extends Fake implements RequestOptions {}

void main() {
  late MockDio mockDio;
  late MockTokenManager mockTokenManager;
  late MockTokenRefreshService mockTokenRefreshService;
  late AuthInterceptor interceptor;

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  setUp(() {

    mockDio = MockDio();
    mockTokenManager = MockTokenManager();
    mockTokenRefreshService = MockTokenRefreshService();
    interceptor = AuthInterceptor(
      dio: mockDio,
      tokenManager: mockTokenManager,
      tokenRefreshService: mockTokenRefreshService,
    );
  });

  group('AuthInterceptor', () {
    test('onRequest attaches Authorization header when token exists', () async {
      when(() => mockTokenManager.getAccessToken())
          .thenAnswer((_) async => 'my_access_token');

      final options = RequestOptions(path: '/test');
      final handler = RequestInterceptorHandler();

      interceptor.onRequest(options, handler);
      await pumpEventQueue();

      expect(options.headers['Authorization'], 'Bearer my_access_token');
    });

    test('onRequest skips Authorization header when skipAuth is true', () async {
      final options = RequestOptions(
        path: '/test',
        extra: {NetworkConstants.skipAuth: true},
      );
      final handler = RequestInterceptorHandler();

      interceptor.onRequest(options, handler);
      await pumpEventQueue();

      expect(options.headers.containsKey('Authorization'), isFalse);
      verifyNever(() => mockTokenManager.getAccessToken());
    });

    test(
        'onError reuses updated token without second refresh if already refreshed',
        () async {
      final options = RequestOptions(
        path: '/test',
        headers: {'Authorization': 'Bearer old_stale_token'},
      );
      final dioException = DioException(
        requestOptions: options,
        response: Response(requestOptions: options, statusCode: 401),
      );

      when(() => mockTokenManager.getAccessToken())
          .thenAnswer((_) async => 'new_already_refreshed_token');
      when(() => mockTokenRefreshService.isTokenExpired(any()))
          .thenReturn(false);
      when(() => mockDio.fetch(any())).thenAnswer(
        (_) async => Response(requestOptions: options, statusCode: 200),
      );

      final handler = ErrorInterceptorHandler();
      interceptor.onError(dioException, handler);
      await pumpEventQueue();

      // Verify refreshToken() was NOT called because token in storage is already new
      verifyNever(() => mockTokenRefreshService.refreshToken());
      verify(() => mockDio.fetch(any())).called(1);
    });
  });
}
