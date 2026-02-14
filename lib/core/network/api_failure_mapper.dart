import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/core/network/api_exception.dart';

Failure mapApiExceptionToFailure(ApiException e) {
  switch (e.code) {
    case ApiErrorCode.connectionTimeout:
    case ApiErrorCode.sendTimeout:
    case ApiErrorCode.receiveTimeout:
      return const Failure(FailureCode.networkTimeout);

    case ApiErrorCode.connectionError:
      return const Failure(FailureCode.networkConnection);

    case ApiErrorCode.cancel:
      return const Failure(FailureCode.requestCancelled);

    case ApiErrorCode.badResponse:
      final sc = e.statusCode;
      final raw = e.extractServerMessage();

      if (sc == 401) {
        return Failure(
          FailureCode.unauthorized,
          statusCode: sc,
          rawMessage: raw,
        );
      }
      if (sc == 403) {
        return Failure(FailureCode.forbidden, statusCode: sc, rawMessage: raw);
      }
      if (sc == 404) {
        return Failure(FailureCode.notFound, statusCode: sc, rawMessage: raw);
      }
      if (sc == 422) {
        return Failure(FailureCode.validation, statusCode: sc, rawMessage: raw);
      }
      if (sc != null && sc >= 500) {
        return Failure(FailureCode.server, statusCode: sc, rawMessage: raw);
      }

      return Failure(FailureCode.unknown, statusCode: sc, rawMessage: raw);

    case ApiErrorCode.badCertificate:
    case ApiErrorCode.unknown:
      return Failure(FailureCode.unknown, rawMessage: e.message);
  }
}
