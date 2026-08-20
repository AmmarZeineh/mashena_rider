import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mashena_rider/core/auth/auth_event.dart';
import 'package:mashena_rider/core/auth/auth_event_bus.dart';
import 'package:mashena_rider/core/network/token_manager.dart';
import 'package:mashena_rider/core/network/token_refresh_service.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockTokenManager extends Mock implements TokenManager {}

void main() {
  late MockDio mockDio;
  late MockTokenManager mockTokenManager;
  late AuthEventBus authEventBus;
  late TokenRefreshServiceImpl service;

  setUp(() {
    mockDio = MockDio();
    mockTokenManager = MockTokenManager();
    authEventBus = AuthEventBus();
    service = TokenRefreshServiceImpl(
      dio: mockDio,
      tokenManager: mockTokenManager,
      authEventBus: authEventBus,
    );
  });

  String makeJwt({required int expSecondsFromNow}) {
    final header = base64UrlEncode(
      utf8.encode(jsonEncode({'alg': 'HS256', 'typ': 'JWT'})),
    );
    final exp =
        (DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000) +
        expSecondsFromNow;
    final payload = base64UrlEncode(
      utf8.encode(jsonEncode({'sub': '123', 'exp': exp})),
    );
    return '$header.$payload.signature';
  }

  group('TokenRefreshService', () {
    test('isTokenExpired returns true for expired token', () {
      final expiredToken = makeJwt(expSecondsFromNow: -100);
      expect(service.isTokenExpired(expiredToken), isTrue);
    });

    test('isTokenExpired returns false for valid token', () {
      final validToken = makeJwt(expSecondsFromNow: 3600);
      expect(service.isTokenExpired(validToken), isFalse);
    });

    test(
      'refreshToken calls /auth/refresh and saves tokens on success',
      () async {
        when(
          () => mockTokenManager.getRefreshToken(),
        ).thenAnswer((_) async => 'valid_refresh_token');
        when(
          () => mockTokenManager.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          ),
        ).thenAnswer((_) async {});
        when(
          () => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/auth/refresh'),
            statusCode: 200,
            data: {
              'accessToken': 'new_access_token',
              'refreshToken': 'new_refresh_token',
            },
          ),
        );

        final success = await service.refreshToken();
        expect(success, isTrue);
        verify(
          () => mockTokenManager.saveTokens(
            accessToken: 'new_access_token',
            refreshToken: 'new_refresh_token',
          ),
        ).called(1);
      },
    );

    test(
      'refreshToken clears tokens and emits loggedOut on 401 Unauthorized',
      () async {
        when(
          () => mockTokenManager.getRefreshToken(),
        ).thenAnswer((_) async => 'expired_refresh_token');
        when(() => mockTokenManager.clearTokens()).thenAnswer((_) async {});
        when(
          () => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/auth/refresh'),
            response: Response(
              requestOptions: RequestOptions(path: '/auth/refresh'),
              statusCode: 401,
            ),
            type: DioExceptionType.badResponse,
          ),
        );

        AuthEvent? emittedEvent;
        authEventBus.stream.listen((event) {
          emittedEvent = event;
        });

        final success = await service.refreshToken();
        await Future<void>.delayed(Duration.zero);
        expect(success, isFalse);
        verify(() => mockTokenManager.clearTokens()).called(1);
        expect(emittedEvent, equals(AuthEvent.loggedOut));
      },
    );

    test(
      'refreshToken does NOT clear tokens or logout on network timeout / connection error',
      () async {
        when(
          () => mockTokenManager.getRefreshToken(),
        ).thenAnswer((_) async => 'valid_refresh_token');
        when(() => mockTokenManager.clearTokens()).thenAnswer((_) async {});
        when(
          () => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/auth/refresh'),
            type: DioExceptionType.connectionTimeout,
            message: 'Connection timed out',
          ),
        );

        AuthEvent? emittedEvent;
        authEventBus.stream.listen((event) {
          emittedEvent = event;
        });

        final success = await service.refreshToken();
        expect(success, isFalse);
        verifyNever(() => mockTokenManager.clearTokens());
        expect(emittedEvent, isNull);
      },
    );
  });
}
