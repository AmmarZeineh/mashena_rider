import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/core/network/api_exception.dart';
import 'package:mashena_rider/core/network/api_failure_mapper.dart';
import '../../domain/entities/create_pool_params.dart';
import '../../domain/entities/join_pool_params.dart';
import '../../domain/entities/pool_room_entity.dart';
import '../../domain/entities/pool_suggestion_params.dart';
import '../../domain/repositories/pool_repository.dart';
import '../datasources/pool_remote_data_source.dart';
import '../datasources/pool_socket_data_source.dart';
import '../models/pool_socket_events.dart';

class PoolRepositoryImpl implements PoolRepository {
  final PoolRemoteDataSource _remoteDataSource;
  final PoolSocketDataSource _socketDataSource;

  const PoolRepositoryImpl({
    required PoolRemoteDataSource remoteDataSource,
    required PoolSocketDataSource socketDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _socketDataSource = socketDataSource;

  @override
  Future<Either<Failure, List<PoolRoomEntity>>> getSuggestions(
    PoolSuggestionParams params,
  ) async {
    try {
      final models = await _remoteDataSource.getSuggestions(params);
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PoolRoomEntity>> createPoolRoom(
    CreatePoolParams params,
  ) async {
    try {
      final model = await _remoteDataSource.createPoolRoom(params);
      return Right(model.toEntity());
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PoolRoomEntity>> getPoolRoomDetails(int roomId) async {
    try {
      final model = await _remoteDataSource.getPoolRoomDetails(roomId);
      return Right(model.toEntity());
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PoolRoomEntity>> joinPoolRoom(
    int roomId,
    JoinPoolParams params,
  ) async {
    try {
      final model = await _remoteDataSource.joinPoolRoom(roomId, params);
      return Right(model.toEntity());
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PoolRoomEntity>> leavePoolRoom(int roomId) async {
    try {
      final model = await _remoteDataSource.leavePoolRoom(roomId);
      return Right(model.toEntity());
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PoolRoomEntity>> cancelPoolRoom(int roomId) async {
    try {
      final model = await _remoteDataSource.cancelPoolRoom(roomId);
      return Right(model.toEntity());
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Stream<PoolMemberJoinedPayload> get memberJoinedStream =>
      _socketDataSource.memberJoinedStream;

  @override
  Stream<PoolMemberLeftPayload> get memberLeftStream =>
      _socketDataSource.memberLeftStream;

  @override
  Stream<PoolMeetingPointUpdatedPayload> get meetingPointUpdatedStream =>
      _socketDataSource.meetingPointUpdatedStream;

  @override
  Stream<PoolRoomReadyPayload> get roomReadyStream =>
      _socketDataSource.roomReadyStream;

  @override
  Stream<PoolMatchedPayload> get matchedStream =>
      _socketDataSource.matchedStream;

  @override
  Stream<PoolExpiredPayload> get expiredStream =>
      _socketDataSource.expiredStream;

  @override
  Stream<PoolCancelledPayload> get cancelledStream =>
      _socketDataSource.cancelledStream;

  @override
  Stream<PoolRemovedPayload> get removedStream =>
      _socketDataSource.removedStream;

  @override
  void listenToRoom(int roomId) {
    _socketDataSource.listenToRoom(roomId);
  }

  @override
  void stopListeningToRoom(int roomId) {
    _socketDataSource.stopListeningToRoom(roomId);
  }
}
