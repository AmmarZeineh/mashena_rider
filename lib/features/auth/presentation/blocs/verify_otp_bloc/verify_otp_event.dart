part of 'verify_otp_bloc.dart';

sealed class VerifyOtpEvent {
  const VerifyOtpEvent();
}

final class VerifyOtpSubmitted extends VerifyOtpEvent {
  const VerifyOtpSubmitted({
    required this.email,
    required this.phoneNumber,
    required this.code,
    required this.channel,
  });

  final String email;
  final String phoneNumber;
  final String code;
  final String channel;
}
