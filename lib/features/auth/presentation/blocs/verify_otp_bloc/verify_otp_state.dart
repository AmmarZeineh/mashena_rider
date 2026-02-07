part of 'verify_otp_bloc.dart';

sealed class VerifyOtpState {
  const VerifyOtpState();
}

final class VerifyOtpInitial extends VerifyOtpState {}

final class VerifyOtpLoading extends VerifyOtpState {}

final class VerifyOtpSuccess extends VerifyOtpState {}

final class VerifyOtpFailure extends VerifyOtpState {
  const VerifyOtpFailure(this.failure);
  final Failure failure;
}

