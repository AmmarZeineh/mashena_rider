import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/auth/domain/entities/auth_session.dart';

import '../repositories/auth_repository.dart';

class LoginUsecase {
  const LoginUsecase(this.repo);
  final AuthRepository repo;

  Future<Either<Failure, AuthSession>> call({
    required String email,
    required String password,
    required String? fcmToken,
  }) {
    return repo.login(email: email, password: password, fcmToken: fcmToken);
  }
}
