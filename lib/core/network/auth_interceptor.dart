import 'dart:async';
import 'package:dio/dio.dart';
import 'package:mashena_rider/core/network/network_constants.dart';
import 'package:mashena_rider/core/network/token_manager.dart';
import 'package:mashena_rider/core/network/token_refresh_service.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.dio,
    required this.tokenManager,
    required this.tokenRefreshService,
  });

  final Dio dio;
  final TokenManager tokenManager;
  final TokenRefreshService tokenRefreshService;

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

    final success = await tokenRefreshService.refreshToken();
    if (!success) return null;

    final newToken = await tokenManager.getAccessToken();
    if (newToken == null) return null;

    requestOptions.headers['Authorization'] = 'Bearer $newToken';
    requestOptions.extra[NetworkConstants.retryKey] = true;

    return dio.fetch(requestOptions);
  }
}
