import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import '../entities/pool_room_entity.dart';
import '../entities/pool_suggestion_params.dart';
import '../repositories/pool_repository.dart';

class GetPoolSuggestionsUsecase {
  final PoolRepository _repository;

  const GetPoolSuggestionsUsecase(this._repository);

  Future<Either<Failure, List<PoolRoomEntity>>> call(
    PoolSuggestionParams params,
  ) {
    return _repository.getSuggestions(params);
  }
}
