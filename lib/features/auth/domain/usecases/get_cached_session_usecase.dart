import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/auth/domain/entities/auth_session.dart';
import 'package:mashena_rider/features/auth/domain/repositories/auth_repository.dart';

class GetCachedSessionUsecase {
  final AuthRepository repo;
  GetCachedSessionUsecase(this.repo);
  Future<Either<Failure, AuthSession>> call() => repo.getCachedSession();
}
