import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/moderation/domain/entities/appeal_entity.dart';
import 'package:mashena_rider/features/moderation/domain/repositories/moderation_repository.dart';

class GetAppealDetailsUsecase {
  final ModerationRepository repository;

  const GetAppealDetailsUsecase(this.repository);

  Future<Either<Failure, AppealEntity>> call(int appealId) =>
      repository.getAppealById(appealId);
}
