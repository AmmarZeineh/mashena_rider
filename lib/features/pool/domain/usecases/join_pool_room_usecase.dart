import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import '../entities/join_pool_params.dart';
import '../entities/pool_room_entity.dart';
import '../repositories/pool_repository.dart';

class JoinPoolRoomUsecase {
  final PoolRepository _repository;

  const JoinPoolRoomUsecase(this._repository);

  Future<Either<Failure, PoolRoomEntity>> call(
    int roomId,
    JoinPoolParams params,
  ) {
    return _repository.joinPoolRoom(roomId, params);
  }
}
