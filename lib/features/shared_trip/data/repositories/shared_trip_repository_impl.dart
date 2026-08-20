import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/core/network/api_exception.dart';
import 'package:mashena_rider/core/network/api_failure_mapper.dart';
import '../../domain/entities/join_shared_ride_params.dart';
import '../../domain/entities/search_shared_ride_params.dart';
import '../../domain/entities/shared_ride_passenger_entity.dart';
import '../../domain/entities/shared_ride_room_details_entity.dart';
import '../../domain/entities/shared_ride_room_entity.dart';
import '../../domain/repositories/shared_trip_repository.dart';
import '../datasources/shared_trip_remote_data_source.dart';
import '../datasources/shared_trip_socket_data_source.dart';
import '../models/shared_ride_socket_events.dart';

class SharedTripRepositoryImpl implements SharedTripRepository {
  final SharedTripRemoteDataSource remoteDataSource;
  final SharedTripSocketDataSource socketDataSource;

  const SharedTripRepositoryImpl({
    required this.remoteDataSource,
    required this.socketDataSource,
  });

  @override
  Future<Either<Failure, List<SharedRideRoomEntity>>> searchSharedRides(
    SearchSharedRideParams params,
  ) async {
    try {
      final models = await remoteDataSource.searchSharedRides(params);
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SharedRideRoomDetailsEntity>> getSharedRideDetails(
    int id,
  ) async {
    try {
      final model = await remoteDataSource.getSharedRideDetails(id);
      return Right(model.toEntity());
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SharedRidePassengerEntity>> joinSharedRide(
    JoinSharedRideParams params,
  ) async {
    try {
      final model = await remoteDataSource.joinSharedRide(params);
      return Right(model.toEntity());
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SharedRideRoomDetailsEntity>> leaveSharedRide(
    int roomId,
  ) async {
    try {
      final model = await remoteDataSource.leaveSharedRide(roomId);
      return Right(model.toEntity());
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Stream<SharedRideDriverLocationPayload> get driverLocationStream =>
      socketDataSource.driverLocationStream;

  @override
  Stream<SharedRidePassengerJoinedPayload> get passengerJoinedStream =>
      socketDataSource.passengerJoinedStream;

  @override
  Stream<SharedRidePassengerLeftPayload> get passengerLeftStream =>
      socketDataSource.passengerLeftStream;

  @override
  Stream<SharedRidePassengerRemovedPayload> get passengerRemovedStream =>
      socketDataSource.passengerRemovedStream;

  @override
  Stream<SharedRideRemovedPayload> get riderRemovedStream =>
      socketDataSource.riderRemovedStream;

  @override
  Stream<SharedRideRoomReadyPayload> get roomReadyStream =>
      socketDataSource.roomReadyStream;

  @override
  Stream<SharedRideTripStartedPayload> get tripStartedStream =>
      socketDataSource.tripStartedStream;

  @override
  Stream<SharedRidePassengerOnBoardPayload> get passengerOnBoardStream =>
      socketDataSource.passengerOnBoardStream;

  @override
  Stream<SharedRidePassengerDroppedPayload> get passengerDroppedStream =>
      socketDataSource.passengerDroppedStream;

  @override
  Stream<SharedRideCompletedPayload> get tripCompletedStream =>
      socketDataSource.tripCompletedStream;

  @override
  Stream<SharedRideCancelledPayload> get tripCancelledStream =>
      socketDataSource.tripCancelledStream;

  @override
  Stream<SharedRidePresencePayload> get presenceStream =>
      socketDataSource.presenceStream;

  @override
  void listenToRoom(int sharedRideId) {
    socketDataSource.listenToRoom(sharedRideId);
  }

  @override
  void stopListeningToRoom(int sharedRideId) {
    socketDataSource.stopListeningToRoom(sharedRideId);
  }
}
