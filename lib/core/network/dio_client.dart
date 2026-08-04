import 'package:dio/dio.dart';
import 'package:mashena_rider/core/network/api_client.dart';
import 'package:mashena_rider/core/network/api_exception.dart';

final class DioApiClient implements ApiClient {
  DioApiClient({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<dynamic> _execute(Future<Response<dynamic>> Function() request) async {
    try {
      final res = await request();
      return _handle(res);
    } on DioException catch (e) {
      throw _map(e);
    }
  }

  @override
  Future<dynamic> get(String path, {Map<String, dynamic>? query}) {
    return _execute(() => _dio.get(path, queryParameters: query));
  }

  @override
  Future<dynamic> post(
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
  }) {
    return _execute(() => _dio.post(path, data: body, queryParameters: query));
  }

  @override
  Future<dynamic> put(
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
  }) {
    return _execute(() => _dio.put(path, data: body, queryParameters: query));
  }

  @override
  Future<dynamic> patch(
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
  }) {
    return _execute(() => _dio.patch(path, data: body, queryParameters: query));
  }

  @override
  Future<dynamic> delete(
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
  }) {
    return _execute(() => _dio.delete(path, data: body, queryParameters: query));
  }

  @override
  Future<dynamic> postFormData(
    String path, {
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
  }) {
    final form = FormData.fromMap(data);
    return _execute(
      () => _dio.post(
        path,
        data: form,
        queryParameters: query,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      ),
    );
  }

  dynamic _handle(Response response) {
    final code = response.statusCode ?? 0;
    if (code >= 200 && code < 300) return response.data;
    throw ApiException(
      ApiErrorCode.badResponse,
      statusCode: code,
      data: response.data,
      message: 'Non-2xx response',
    );
  }

  ApiException _map(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return const ApiException(ApiErrorCode.connectionTimeout);
      case DioExceptionType.sendTimeout:
        return const ApiException(ApiErrorCode.sendTimeout);
      case DioExceptionType.receiveTimeout:
        return const ApiException(ApiErrorCode.receiveTimeout);
      case DioExceptionType.cancel:
        return const ApiException(ApiErrorCode.cancel);
      case DioExceptionType.connectionError:
        return const ApiException(ApiErrorCode.connectionError);
      case DioExceptionType.badCertificate:
        return const ApiException(ApiErrorCode.badCertificate);
      case DioExceptionType.badResponse:
        return ApiException(
          ApiErrorCode.badResponse,
          statusCode: e.response?.statusCode,
          data: e.response?.data,
          message: e.message,
        );
      case DioExceptionType.transformTimeout:
        return const ApiException(ApiErrorCode.receiveTimeout);
      case DioExceptionType.unknown:
        return ApiException(ApiErrorCode.unknown, message: e.message);
    }
  }
}
