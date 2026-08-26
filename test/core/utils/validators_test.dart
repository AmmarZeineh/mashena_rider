import 'package:flutter_test/flutter_test.dart';
import 'package:mashena_rider/core/enums/validation_error.dart';
import 'package:mashena_rider/core/utils/validators.dart';

void main() {
  group('Validators (Rider App)', () {
    group('isNotEmpty & required', () {
      test('should return false / requiredField when null or empty string', () {
        expect(Validators.isNotEmpty(null), isFalse);
        expect(Validators.isNotEmpty(''), isFalse);
        expect(Validators.isNotEmpty('   '), isFalse);
        expect(Validators.required(null), ValidationError.requiredField);
        expect(Validators.required(''), ValidationError.requiredField);
      });

      test('should return true / null when string has content', () {
        expect(Validators.isNotEmpty('valid'), isTrue);
        expect(Validators.required('valid'), isNull);
      });
    });

    group('isEmail & email', () {
      test('should validate correct emails', () {
        expect(Validators.isEmail('rider@mashena.com'), isTrue);
        expect(Validators.isEmail('user.name+tag@domain.co'), isTrue);
        expect(Validators.email('rider@mashena.com'), isNull);
      });

      test('should reject invalid emails', () {
        expect(Validators.isEmail('plainaddress'), isFalse);
        expect(Validators.isEmail('@missingusername.com'), isFalse);
        expect(Validators.email('invalid-email'), ValidationError.invalidEmail);
        expect(Validators.email(null), ValidationError.requiredField);
      });
    });

    group('isPhoneNumber & phone (Syria formats)', () {
      test('should validate Syria numbers starting with +963 and 09', () {
        expect(Validators.isPhoneNumber('+963912345678'), isTrue);
        expect(Validators.isPhoneNumber('0912345678'), isTrue);
        expect(Validators.phone('+963912345678'), isNull);
        expect(Validators.phone('0912345678'), isNull);
      });

      test('should reject invalid numbers', () {
        expect(Validators.isPhoneNumber('12345'), isFalse);
        expect(Validators.isPhoneNumber('+1234567890'), isFalse);
        expect(Validators.isPhoneNumber('invalidphone'), isFalse);
        expect(Validators.phone('12345'), ValidationError.invalidPhone);
        expect(Validators.phone(null), ValidationError.requiredField);
      });
    });

    group('isStrongPassword & password', () {
      test('should validate strong passwords meeting all criteria', () {
        expect(Validators.isStrongPassword('Pass@1234'), isTrue);
        expect(Validators.isStrongPassword('Mashena#2026'), isTrue);
        expect(Validators.password('Pass@1234'), isNull);
      });

      test(
        'should reject passwords lacking uppercase, lowercase, numbers or special chars',
        () {
          expect(Validators.isStrongPassword('short1!'), isFalse); // < 8 chars
          expect(
            Validators.isStrongPassword('password123!'),
            isFalse,
          ); // no uppercase
          expect(
            Validators.isStrongPassword('PASSWORD123!'),
            isFalse,
          ); // no lowercase
          expect(
            Validators.isStrongPassword('Password!!!!'),
            isFalse,
          ); // no number
          expect(
            Validators.isStrongPassword('Password1234'),
            isFalse,
          ); // no special char
          expect(Validators.password('weakpass'), ValidationError.weakPassword);
          expect(Validators.password(null), ValidationError.requiredField);
        },
      );
    });

    group('passwordsMatch', () {
      test('should return null when passwords match', () {
        expect(Validators.passwordsMatch('Pass@1234', 'Pass@1234'), isNull);
      });

      test('should return passwordsNotMatch when passwords differ', () {
        expect(
          Validators.passwordsMatch('Pass@1234', 'Pass@9999'),
          ValidationError.passwordsNotMatch,
        );
      });

      test(
        'should return requiredField when either password is null or empty',
        () {
          expect(
            Validators.passwordsMatch(null, 'Pass@1234'),
            ValidationError.requiredField,
          );
          expect(
            Validators.passwordsMatch('Pass@1234', ''),
            ValidationError.requiredField,
          );
        },
      );
    });

    group('isOtp & otp', () {
      test('should validate 6-digit numeric OTP', () {
        expect(Validators.isOtp('123456'), isTrue);
        expect(Validators.isOtp('987654'), isTrue);
        expect(Validators.otp('123456'), isNull);
      });

      test('should reject non-numeric or wrong length OTPs', () {
        expect(Validators.isOtp('12345'), isFalse);
        expect(Validators.isOtp('1234567'), isFalse);
        expect(Validators.isOtp('12345a'), isFalse);
        expect(Validators.otp('12345'), ValidationError.otpInvalid);
        expect(Validators.otp(null), ValidationError.requiredField);
      });
    });
  });
}
