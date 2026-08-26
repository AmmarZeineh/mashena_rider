import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import '../../data/models/pool_socket_events.dart';
import '../entities/create_pool_params.dart';
import '../entities/join_pool_params.dart';
import '../entities/pool_room_entity.dart';
import '../entities/pool_suggestion_params.dart';

abstract interface class PoolRepository {
  Future<Either<Failure, List<PoolRoomEntity>>> getSuggestions(
    PoolSuggestionParams params,
  );

  Future<Either<Failure, PoolRoomEntity>> createPoolRoom(
    CreatePoolParams params,
  );

  Future<Either<Failure, PoolRoomEntity>> getPoolRoomDetails(int roomId);

  Future<Either<Failure, PoolRoomEntity>> joinPoolRoom(
    int roomId,
    JoinPoolParams params,
  );

  Future<Either<Failure, PoolRoomEntity>> leavePoolRoom(int roomId);

  Future<Either<Failure, PoolRoomEntity>> cancelPoolRoom(int roomId);

  // Real-time socket streams
  Stream<PoolMemberJoinedPayload> get memberJoinedStream;
  Stream<PoolMemberLeftPayload> get memberLeftStream;
  Stream<PoolMeetingPointUpdatedPayload> get meetingPointUpdatedStream;
  Stream<PoolRoomReadyPayload> get roomReadyStream;
  Stream<PoolMatchedPayload> get matchedStream;
  Stream<PoolExpiredPayload> get expiredStream;
  Stream<PoolCancelledPayload> get cancelledStream;
  Stream<PoolRemovedPayload> get removedStream;

  void listenToRoom(int roomId);
  void stopListeningToRoom(int roomId);
}
