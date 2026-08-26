import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import '../entities/pool_room_entity.dart';
import '../repositories/pool_repository.dart';

class LeavePoolRoomUsecase {
  final PoolRepository _repository;

  const LeavePoolRoomUsecase(this._repository);

  Future<Either<Failure, PoolRoomEntity>> call(int roomId) {
    return _repository.leavePoolRoom(roomId);
  }
}
