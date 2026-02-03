import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/auth/data/models/login_response.dart';

import '../repositories/auth_repository.dart';

class LoginUsecase {
  const LoginUsecase(this.repo);
  final AuthRepository repo;

  Future<Either<Failure, LoginResponseDto>> call({
    required String email,
    required String password,
    required String? fcmToken,
  }) {
    return repo.login(email: email, password: password, fcmToken: fcmToken);
  }
}
