import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/auth/domain/repositories/auth_repository.dart';

class ResendOtpUsecase {
  final AuthRepository repo;

  ResendOtpUsecase(this.repo);

  Future<Either<Failure, void>> call({String? email, String? phone}) {
    return repo.sendOtp(email: email, phone: phone);
  }
}
