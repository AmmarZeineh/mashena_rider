part of 'verify_otp_bloc.dart';

sealed class VerifyOtpState extends Equatable {
  const VerifyOtpState();

  @override
  List<Object?> get props => [];

  @override
  bool get stringify => true;
}

final class VerifyOtpInitial extends VerifyOtpState {}

final class VerifyOtpLoading extends VerifyOtpState {}

final class VerifyOtpSuccess extends VerifyOtpState {}

final class VerifyOtpFailure extends VerifyOtpState {
  const VerifyOtpFailure(this.failure);
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
