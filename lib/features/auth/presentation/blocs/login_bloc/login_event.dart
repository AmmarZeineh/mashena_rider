part of 'login_bloc.dart';

sealed class LoginEvent {
  const LoginEvent();
}

final class LoginSubmitted extends LoginEvent {
  const LoginSubmitted({
    required this.email,
    required this.password,
    required this.fcmToken,
  });

  final String email;
  final String password;
  final String? fcmToken;
}
