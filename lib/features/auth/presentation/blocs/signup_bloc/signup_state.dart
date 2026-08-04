part of 'signup_bloc.dart';

sealed class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object?> get props => [];

  @override
  bool get stringify => true;
}

final class SignupInitial extends SignupState {}

final class SignupLoading extends SignupState {}

final class SignupSuccess extends SignupState {}

final class SignupFailure extends SignupState {
  const SignupFailure(this.failure);
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
