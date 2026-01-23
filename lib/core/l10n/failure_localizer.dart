import 'package:flutter/widgets.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';

String failureText(BuildContext context, Failure f) {
  final s = S.of(context);
  switch (f.code) {
    case FailureCode.networkConnection:
      return s.apiConnectionError;
    case FailureCode.networkTimeout:
      return s.apiConnectionTimeout;
    case FailureCode.requestCancelled:
      return s.apiRequestCancelled;
    case FailureCode.unauthorized:
      return s.apiUnauthorized;
    case FailureCode.forbidden:
      return s.apiForbidden;
    case FailureCode.notFound:
      return s.apiNotFound;
    case FailureCode.validation:
      return s.apiValidationError;
    case FailureCode.server:
      return s.apiServerError;
    case FailureCode.unknown:
      return s.apiUnknownError;
    case FailureCode.cache:
      return s.cacheError;
  }
}
