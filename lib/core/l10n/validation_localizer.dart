import 'package:flutter/widgets.dart';
import 'package:mashena_rider/core/enums/validation_error.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';

String validationText(
  BuildContext context,
  ValidationError error, {
  int? min,
  int? max,
}) {
  final s = S.of(context);

  return switch (error) {
    ValidationError.requiredField => s.validationRequired,
    ValidationError.invalidEmail => s.validationInvalidEmail,
    ValidationError.invalidPhone => s.validationInvalidPhone,
    ValidationError.weakPassword => s.validationWeakPassword,
    ValidationError.minLength => s.validationMinLength(min ?? 0),
    ValidationError.maxLength => s.validationMaxLength(max ?? 0),
    ValidationError.otpInvalid => s.validationOtpInvalid,
  };
}
