import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/moderation/domain/entities/appeal_entity.dart';
import 'package:mashena_rider/features/moderation/domain/repositories/moderation_repository.dart';

class SubmitAppealUsecase {
  final ModerationRepository repository;

  const SubmitAppealUsecase(this.repository);

  Future<Either<Failure, AppealEntity>> call({
    required int penaltyId,
    required String reason,
    String? evidence,
  }) => repository.submitAppeal(
    penaltyId: penaltyId,
    reason: reason,
    evidence: evidence,
  );
}
