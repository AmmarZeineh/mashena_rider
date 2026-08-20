import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:mashena_rider/core/auth/auth_event.dart';
import 'package:mashena_rider/core/auth/auth_event_bus.dart';
import 'package:mashena_rider/core/constants/app_backend_endpoints.dart';
import 'package:mashena_rider/core/network/network_constants.dart';
import 'package:mashena_rider/core/network/token_manager.dart';
import 'package:mashena_rider/core/services/logger_service.dart';

/// Contract for token refresh operations and JWT validity checks.
abstract interface class TokenRefreshService {
  /// Refreshes the access token using the stored refresh token.
  /// Concurrent calls will be de-duplicated to a single in-flight HTTP request.
  Future<bool> refreshToken();

  /// Returns the current access token if valid; otherwise, attempts a refresh
  /// and returns the newly acquired access token. Returns `null` if unauthenticated.
  Future<String?> getValidAccessToken();

  /// Inspects the JWT payload expiration without verifying cryptographic signatures.
  /// Returns `true` if the token is expired or within the [buffer] window.
  bool isTokenExpired(
    String token, {
    Duration buffer = const Duration(seconds: 30),
  });
}

/// Concrete implementation of [TokenRefreshService].
class TokenRefreshServiceImpl implements TokenRefreshService {
  TokenRefreshServiceImpl({
    required this.dio,
    required this.tokenManager,
    required this.authEventBus,
  });

  final Dio dio;
  final TokenManager tokenManager;
  final AuthEventBus authEventBus;

  bool _isRefreshing = false;
  Completer<bool>? _refreshCompleter;

  @override
  bool isTokenExpired(
    String token, {
    Duration buffer = const Duration(seconds: 30),
  }) {
    try {
      final cleanToken = token.startsWith('Bearer ')
          ? token.substring(7)
          : token;
      final parts = cleanToken.split('.');
      if (parts.length != 3) {
        return true; // Malformed token treated as expired
      }

      final normalizedPayload = base64Url.normalize(parts[1]);
      final payloadString = utf8.decode(base64Url.decode(normalizedPayload));
      final dynamic payload = jsonDecode(payloadString);

      if (payload is Map && payload.containsKey('exp')) {
        final exp = payload['exp'];
        if (exp is num) {
          final expDateTime = DateTime.fromMillisecondsSinceEpoch(
            exp.toInt() * 1000,
            isUtc: true,
          );
          final threshold = DateTime.now().toUtc().add(buffer);
          return expDateTime.isBefore(threshold);
        }
      }
      return false;
    } catch (e) {
      LoggerService.debug(
        'Failed to decode JWT expiration, treating as expired: $e',
        name: 'core.network.token_refresh_service',
      );
      return true;
    }
  }

  @override
  Future<String?> getValidAccessToken() async {
    final token = await tokenManager.getAccessToken();
    if (token == null || token.isEmpty) {
      return null;
    }

    if (isTokenExpired(token)) {
      LoggerService.debug(
        'Access token expired or expiring soon. Proactively refreshing...',
        name: 'core.network.token_refresh_service',
      );
      final refreshed = await refreshToken();
      if (!refreshed) {
        return null;
      }
      return tokenManager.getAccessToken();
    }

    return token;
  }

  @override
  Future<bool> refreshToken() async {
    if (_isRefreshing) {
      return await _refreshCompleter?.future ?? false;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<bool>();

    try {
      final refreshToken = await tokenManager.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        LoggerService.debug(
          'Refresh token failed: No refresh token stored.',
          name: 'core.network.token_refresh_service',
        );
        await tokenManager.clearTokens();
        authEventBus.emit(AuthEvent.loggedOut);
        _finishRefresh(false);
        return false;
      }

      final response = await dio.post(
        BackendEndpoints.refresh,
        data: {'refreshToken': refreshToken},
        options: Options(
          headers: {'Authorization': 'Bearer $refreshToken'},
          extra: {NetworkConstants.skipAuth: true},
        ),
      );

      final dynamic data = response.data;
      final newAccess = data is Map
          ? data[NetworkConstants.accessTokenKey] as String?
          : null;
      final newRefresh = data is Map
          ? data[NetworkConstants.refreshTokenKey] as String?
          : null;

      if (newAccess == null || newAccess.isEmpty) {
        LoggerService.debug(
          'Refresh token response did not contain new access token.',
          name: 'core.network.token_refresh_service',
        );
        await tokenManager.clearTokens();
        authEventBus.emit(AuthEvent.loggedOut);
        _finishRefresh(false);
        return false;
      }

      await tokenManager.saveTokens(
        accessToken: newAccess,
        refreshToken: newRefresh,
      );

      authEventBus.emit(AuthEvent.tokenRefreshed);
      _finishRefresh(true);
      return true;
    } on DioException catch (e, stackTrace) {
      final statusCode = e.response?.statusCode;
      final isAuthError = statusCode == 401 || statusCode == 403;

      LoggerService.error(
        'Refresh token request failed (statusCode: $statusCode, isAuthError: $isAuthError)',
        error: e,
        stackTrace: stackTrace,
        name: 'core.network.token_refresh_service',
      );

      if (isAuthError) {
        await tokenManager.clearTokens();
        authEventBus.emit(AuthEvent.loggedOut);
      }
      _finishRefresh(false);
      return false;
    } catch (e, stackTrace) {
      LoggerService.error(
        'Unexpected error during refresh token request',
        error: e,
        stackTrace: stackTrace,
        name: 'core.network.token_refresh_service',
      );
      _finishRefresh(false);
      return false;
    }
  }

  void _finishRefresh(bool success) {
    _isRefreshing = false;
    _refreshCompleter?.complete(success);
  }
}
