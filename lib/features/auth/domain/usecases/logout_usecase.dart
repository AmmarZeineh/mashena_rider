import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/auth/domain/repositories/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository repo;
  LogoutUsecase(this.repo);
  Future<Either<Failure, Unit>> call() => repo.logout();
}
