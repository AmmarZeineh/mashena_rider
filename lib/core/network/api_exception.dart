enum ApiErrorCode {
  connectionTimeout,
  sendTimeout,
  receiveTimeout,
  connectionError,
  cancel,
  badResponse,
  badCertificate,
  unknown,
}

final class ApiException implements Exception {
  const ApiException(this.code, {this.statusCode, this.data, this.message});

  final ApiErrorCode code;
  final int? statusCode;
  final dynamic data;
  final String? message;

  String? extractServerMessage() {
    if (data == null) return null;

    if (data is Map<String, dynamic>) {
      const keys = ['message', 'error', 'msg', 'detail', 'details'];
      for (final k in keys) {
        final v = data[k];
        if (v is String && v.isNotEmpty) return v;
        if (v is List && v.isNotEmpty) return v.first.toString();
      }
    }

    return data.toString();
  }

  @override
  String toString() =>
      'ApiException(code: $code, statusCode: $statusCode, message: $message)';
}
