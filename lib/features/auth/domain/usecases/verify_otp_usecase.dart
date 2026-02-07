import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';

import '../repositories/auth_repository.dart';

class VerifyOtpUsecase {
  const VerifyOtpUsecase(this.repo);
  final AuthRepository repo;

  Future<Either<Failure, void>> call({
    required String email,
    required String code,
    required String phone,
    required String channel,
  }) {
    return repo.verifyOtp(email: email, code: code, phone: phone);
  }
}
