import 'dart:async';
import 'package:dio/dio.dart';
import 'package:mashena_rider/core/auth/auth_event.dart';
import 'package:mashena_rider/core/auth/auth_event_bus.dart';
import 'package:mashena_rider/core/constants/app_backend_endpoints.dart';
import 'package:mashena_rider/core/network/network_constants.dart';
import 'package:mashena_rider/core/network/token_manager.dart';
import 'package:mashena_rider/core/services/logger_service.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
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
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[NetworkConstants.skipAuth] == true) {
      return handler.next(options);
    }

    final token = await tokenManager.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRefresh(err)) {
      final response = await _handleRefresh(err);
      if (response != null) {
        return handler.resolve(response);
      }
    }

    handler.next(err);
  }

  bool _shouldRefresh(DioException err) {
    return err.response?.statusCode == 401 &&
        err.requestOptions.extra[NetworkConstants.retryKey] != true;
  }

  Future<Response?> _handleRefresh(DioException err) async {
    final requestOptions = err.requestOptions;

    if (!_isRefreshing) {
      _isRefreshing = true;
      _refreshCompleter = Completer<bool>();

      final success = await _refreshToken();

      if (!success) {
        await tokenManager.clearTokens();
        authEventBus.emit(AuthEvent.loggedOut);
      } else {
        authEventBus.emit(AuthEvent.tokenRefreshed);
      }

      _isRefreshing = false;
      _refreshCompleter?.complete(success);

      if (!success) return null;
    } else {
      final success = await _refreshCompleter?.future ?? false;
      if (!success) return null;
    }

    final newToken = await tokenManager.getAccessToken();
    if (newToken == null) return null;

    requestOptions.headers['Authorization'] = 'Bearer $newToken';
    requestOptions.extra[NetworkConstants.retryKey] = true;

    return dio.fetch(requestOptions);
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await tokenManager.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await dio.post(
        BackendEndpoints.refresh,
        data: {'refreshToken': refreshToken},
        options: Options(
          headers: {'Authorization': 'Bearer $refreshToken'},
          extra: {NetworkConstants.skipAuth: true},
        ),
      );

      final newAccess = response.data[NetworkConstants.accessTokenKey];
      final newRefresh = response.data[NetworkConstants.refreshTokenKey];

      await tokenManager.saveTokens(
        accessToken: newAccess,
        refreshToken: newRefresh,
      );

      return true;
    } catch (e, stackTrace) {
      LoggerService.error(
        'Refresh token failed',
        error: e,
        stackTrace: stackTrace,
        name: 'core.network.auth_interceptor',
      );
      return false;
    }
  }
}
