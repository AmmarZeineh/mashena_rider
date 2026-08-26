import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/moderation/domain/entities/restriction_entity.dart';
import 'package:mashena_rider/features/moderation/domain/repositories/moderation_repository.dart';

class GetActiveRestrictionsUsecase {
  final ModerationRepository repository;

  const GetActiveRestrictionsUsecase(this.repository);

  Future<Either<Failure, List<RestrictionEntity>>> call() =>
      repository.getActiveRestrictions();
}
