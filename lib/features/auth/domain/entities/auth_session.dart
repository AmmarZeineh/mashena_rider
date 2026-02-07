import 'package:mashena_rider/features/auth/domain/entities/user.dart';

class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.user,
  });

  final String accessToken;
  final User user;
}
