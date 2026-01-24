import 'package:mashena_rider/core/enums/validation_error.dart';

final class Validators {
  const Validators._();

  static bool isNotEmpty(String? value) =>
      value != null && value.trim().isNotEmpty;

  static bool isEmail(String? value) {
    if (!isNotEmpty(value)) return false;
    final email = value!.trim();
    return RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@'
      r'[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$',
    ).hasMatch(email);
  }

  static bool isPhoneNumber(String? value) {
    if (!isNotEmpty(value)) return false;
    final phone = value!.trim();
    return RegExp(r'^\+?963\d{9}$|^0\d{9}$').hasMatch(phone);
  }

  static bool hasUpperCase(String v) => RegExp(r'[A-Z]').hasMatch(v);
  static bool hasLowerCase(String v) => RegExp(r'[a-z]').hasMatch(v);
  static bool hasNumber(String v) => RegExp(r'\d').hasMatch(v);
  static bool hasSpecialChar(String v) =>
      RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(v);

  static bool isStrongPassword(String? value, {int minLength = 8}) {
    if (!isNotEmpty(value)) return false;
    final v = value!;
    return v.length >= minLength &&
        hasUpperCase(v) &&
        hasLowerCase(v) &&
        hasNumber(v) &&
        hasSpecialChar(v);
  }

  static bool isOtp(String? value, {int length = 6}) {
    if (!isNotEmpty(value)) return false;
    return RegExp('^\\d{$length}\$').hasMatch(value!.trim());
  }

  // -------------------------
  // Field validators (return ValidationError?)
  // -------------------------

  static ValidationError? required(String? value) {
    return isNotEmpty(value) ? null : ValidationError.requiredField;
  }

  static ValidationError? email(String? value) {
    if (!isNotEmpty(value)) return ValidationError.requiredField;
    if (!isEmail(value)) return ValidationError.invalidEmail;
    return null;
  }

  static ValidationError? phone(String? value) {
    if (!isNotEmpty(value)) return ValidationError.requiredField;
    if (!isPhoneNumber(value)) return ValidationError.invalidPhone;
    return null;
  }

  static ValidationError? password(String? value, {int minLen = 8}) {
    if (!isNotEmpty(value)) return ValidationError.requiredField;
    if (!isStrongPassword(value, minLength: minLen)) {
      return ValidationError.weakPassword;
    }
    return null;
  }

  static ValidationError? otp(String? value, {int length = 6}) {
    if (!isNotEmpty(value)) return ValidationError.requiredField;
    if (!isOtp(value, length: length)) return ValidationError.otpInvalid;
    return null;
  }
}
