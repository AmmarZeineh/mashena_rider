import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/moderation/domain/entities/appeal_entity.dart';
import 'package:mashena_rider/features/moderation/domain/entities/paginated_list_entity.dart';
import 'package:mashena_rider/features/moderation/domain/repositories/moderation_repository.dart';

class GetAppealsHistoryUsecase {
  final ModerationRepository repository;

  const GetAppealsHistoryUsecase(this.repository);

  Future<Either<Failure, PaginatedListEntity<AppealEntity>>> call({
    int skip = 0,
    int limit = 10,
  }) => repository.getAppealsHistory(skip: skip, limit: limit);
}
