import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/moderation/domain/entities/paginated_list_entity.dart';
import 'package:mashena_rider/features/moderation/domain/entities/violation_entity.dart';
import 'package:mashena_rider/features/moderation/domain/repositories/moderation_repository.dart';

class GetViolationsHistoryUsecase {
  final ModerationRepository repository;

  const GetViolationsHistoryUsecase(this.repository);

  Future<Either<Failure, PaginatedListEntity<ViolationEntity>>> call({
    int skip = 0,
    int limit = 10,
  }) => repository.getViolationsHistory(skip: skip, limit: limit);
}
