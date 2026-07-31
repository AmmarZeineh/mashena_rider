import 'dart:async';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:mashena_rider/core/auth/auth_event.dart';
import 'package:mashena_rider/core/auth/auth_event_bus.dart';
import 'package:mashena_rider/core/constants/app_backend_endpoints.dart';
import 'package:mashena_rider/core/network/token_manager.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.tokenManager,
    required this.authEventBus,
    required this.baseUrl,
  });

  final TokenManager tokenManager;
  final AuthEventBus authEventBus;
  final String baseUrl;

  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
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
        err.requestOptions.extra['retry'] != true;
  }

  Future<Response?> _handleRefresh(DioException err) async {
    final requestOptions = err.requestOptions;

    if (!_isRefreshing) {
      _isRefreshing = true;
      _refreshCompleter = Completer();

      final success = await _refreshToken();

      _isRefreshing = false;
      _refreshCompleter?.complete();

      if (!success) {
        await tokenManager.clearTokens();
        authEventBus.emit(AuthEvent.loggedOut);
        return null;
      }

      // Notify listeners that a new token is available (e.g. to reconnect socket)
      authEventBus.emit(AuthEvent.tokenRefreshed);
    } else {
      await _refreshCompleter?.future;
    }

    final newToken = await tokenManager.getAccessToken();
    if (newToken == null) return null;

    requestOptions.headers['Authorization'] = 'Bearer $newToken';
    requestOptions.extra['retry'] = true;

    final dio = Dio(BaseOptions(baseUrl: baseUrl));
    return dio.fetch(requestOptions);
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await tokenManager.getRefreshToken();
      if (refreshToken == null) return false;

      final dio = Dio(BaseOptions(baseUrl: baseUrl));

      final response = await dio.post(
        BackendEndpoints.refresh,
        data: {'refreshToken': refreshToken},
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );

      final newAccess = response.data['accessToken'];
      final newRefresh = response.data['refreshToken'];

      await tokenManager.saveTokens(
        accessToken: newAccess,
        refreshToken: newRefresh,
      );

      return true;
    } catch (e, stackTrace) {
      developer.log(
        'Refresh token failed',
        error: e,
        stackTrace: stackTrace,
        name: 'core.network.auth_interceptor',
      );
      return false;
    }
  }
}
