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
    String channel = 'email',
  }) async {
    final signupRes = await repo.signup(
      email: email,
      password: password,
      fullName: fullName,
      phoneNumber: phoneNumber,
    );

    return signupRes.fold((f) => Left(f), (_) async {
      final otpRes = await repo.sendOtp(
        channel: channel,
        email: channel == 'email' ? email : null,
        phone: channel == 'phone' ? phoneNumber : null,
      );

      return otpRes.fold((f) => Left(f), (_) => Right(null));
    });
  }
}
