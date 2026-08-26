import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import '../entities/create_pool_params.dart';
import '../entities/pool_room_entity.dart';
import '../repositories/pool_repository.dart';

class CreatePoolRoomUsecase {
  final PoolRepository _repository;

  const CreatePoolRoomUsecase(this._repository);

  Future<Either<Failure, PoolRoomEntity>> call(CreatePoolParams params) {
    return _repository.createPoolRoom(params);
  }
}
