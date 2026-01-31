part of 'signup_bloc.dart';

sealed class SignupState {
  const SignupState();
}

final class SignupInitial extends SignupState {}

final class SignupLoading extends SignupState {}

final class SignupSuccess extends SignupState {}

final class SignupFailure extends SignupState {
  const SignupFailure(this.failure);
  final Failure failure;
}
