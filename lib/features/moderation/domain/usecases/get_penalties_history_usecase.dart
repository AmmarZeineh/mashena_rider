import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/moderation/domain/entities/paginated_list_entity.dart';
import 'package:mashena_rider/features/moderation/domain/entities/penalty_entity.dart';
import 'package:mashena_rider/features/moderation/domain/repositories/moderation_repository.dart';

class GetPenaltiesHistoryUsecase {
  final ModerationRepository repository;

  const GetPenaltiesHistoryUsecase(this.repository);

  Future<Either<Failure, PaginatedListEntity<PenaltyEntity>>> call({
    int skip = 0,
    int limit = 10,
  }) => repository.getPenaltiesHistory(skip: skip, limit: limit);
}
