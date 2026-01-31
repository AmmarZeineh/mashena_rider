part of 'signup_bloc.dart';

sealed class SignupEvent {
  const SignupEvent();
}

final class SignupSubmitted extends SignupEvent {
  const SignupSubmitted({
    required this.email,
    required this.password,
    required this.fullName,
    required this.phoneNumber,
  });

  final String email;
  final String password;
  final String fullName;
  final String phoneNumber;
}
