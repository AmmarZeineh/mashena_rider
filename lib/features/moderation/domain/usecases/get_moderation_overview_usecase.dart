import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/moderation/domain/entities/moderation_overview_entity.dart';
import 'package:mashena_rider/features/moderation/domain/repositories/moderation_repository.dart';

class GetModerationOverviewUsecase {
  final ModerationRepository repository;

  const GetModerationOverviewUsecase(this.repository);

  Future<Either<Failure, ModerationOverviewEntity>> call() =>
      repository.getModerationOverview();
}
