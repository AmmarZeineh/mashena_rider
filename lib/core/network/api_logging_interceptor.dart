import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mashena_rider/core/utils/logger.dart';

/// Logs request/response/error details for every Dio call.
///
/// Enabled only in debug mode.
final class ApiLoggingInterceptor extends Interceptor {
  ApiLoggingInterceptor({
    this.maxBodyChars = 4000,
    this.maxHeaderValueChars = 200,
  });

  final int maxBodyChars;
  final int maxHeaderValueChars;

  static const _redactedHeaderKeys = <String>{
    'authorization',
    'cookie',
    'set-cookie',
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!kDebugMode) return handler.next(options);

    final uri = options.uri;
    final headers = _sanitizeHeaders(options.headers);
    final query = options.queryParameters;
    final body = options.data;

    AppLogger.d(
      '➡️ ${options.method} $uri\n'
      'headers: $headers\n'
      'query: ${_formatValue(query)}\n'
      'body: ${_formatValue(body)}',
    );

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (!kDebugMode) return handler.next(response);

    final req = response.requestOptions;
    final uri = req.uri;
    final status = response.statusCode;
    final data = response.data;

    AppLogger.d(
      '✅ ${req.method} $uri [$status]\n'
      'response: ${_formatValue(data)}',
    );

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!kDebugMode) return handler.next(err);

    final req = err.requestOptions;
    final uri = req.uri;
    final status = err.response?.statusCode;
    final data = err.response?.data;

    AppLogger.e(
      '❌ ${req.method} $uri [$status]\n'
      'type: ${err.type}\n'
      'message: ${err.message}\n'
      'response: ${_formatValue(data)}',
    );

    handler.next(err);
  }

  Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> headers) {
    return headers.map((key, value) {
      final lower = key.toLowerCase();
      if (_redactedHeaderKeys.contains(lower)) {
        return MapEntry(key, '***');
      }

      final str = value?.toString() ?? '';
      if (str.length <= maxHeaderValueChars) return MapEntry(key, str);
      return MapEntry(key, '${str.substring(0, maxHeaderValueChars)}…');
    });
  }

  String _formatValue(Object? value) {
    if (value == null) return 'null';

    try {
      if (value is Map || value is List) {
        final pretty = const JsonEncoder.withIndent('  ').convert(value);
        return _truncate(pretty);
      }
    } catch (_) {}

    return _truncate(value.toString());
  }

  String _truncate(String s) {
    if (s.length <= maxBodyChars) return s;
    return '${s.substring(0, maxBodyChars)}…';
  }
}
