import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';

import '../repositories/auth_repository.dart';

class SignupUsecase {
  const SignupUsecase(this.repo);
  final AuthRepository repo;

  Future<Either<Failure, void>> call({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    return await repo.signup(
      email: email,
      password: password,
      fullName: fullName,
      phoneNumber: phoneNumber,
    );
  }
}
