import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/core/network/api_exception.dart';
import 'package:mashena_rider/core/network/api_failure_mapper.dart';
import 'package:mashena_rider/features/moderation/data/datasources/moderation_remote_data_source.dart';
import 'package:mashena_rider/features/moderation/data/datasources/moderation_socket_data_source.dart';
import 'package:mashena_rider/features/moderation/domain/entities/appeal_entity.dart';
import 'package:mashena_rider/features/moderation/domain/entities/moderation_overview_entity.dart';
import 'package:mashena_rider/features/moderation/domain/entities/paginated_list_entity.dart';
import 'package:mashena_rider/features/moderation/domain/entities/penalty_entity.dart';
import 'package:mashena_rider/features/moderation/domain/entities/restriction_entity.dart';
import 'package:mashena_rider/features/moderation/domain/entities/violation_entity.dart';
import 'package:mashena_rider/features/moderation/domain/repositories/moderation_repository.dart';

class ModerationRepositoryImpl implements ModerationRepository {
  final ModerationRemoteDataSource _remoteDataSource;
  final ModerationSocketDataSource _socketDataSource;

  ModerationRepositoryImpl({
    required ModerationRemoteDataSource remoteDataSource,
    required ModerationSocketDataSource socketDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _socketDataSource = socketDataSource;

  @override
  Future<Either<Failure, ModerationOverviewEntity>>
  getModerationOverview() async {
    try {
      final model = await _remoteDataSource.getModerationOverview();
      return Right(model.toEntity());
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedListEntity<PenaltyEntity>>>
  getPenaltiesHistory({int skip = 0, int limit = 10}) async {
    try {
      final model = await _remoteDataSource.getPenaltiesHistory(
        skip: skip,
        limit: limit,
      );
      return Right(model.toEntity((item) => item.toEntity()));
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedListEntity<ViolationEntity>>>
  getViolationsHistory({int skip = 0, int limit = 10}) async {
    try {
      final model = await _remoteDataSource.getViolationsHistory(
        skip: skip,
        limit: limit,
      );
      return Right(model.toEntity((item) => item.toEntity()));
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RestrictionEntity>>>
  getActiveRestrictions() async {
    try {
      final list = await _remoteDataSource.getActiveRestrictions();
      return Right(list.map((e) => e.toEntity()).toList());
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppealEntity>> submitAppeal({
    required int penaltyId,
    required String reason,
    String? evidence,
  }) async {
    try {
      final model = await _remoteDataSource.submitAppeal(
        penaltyId: penaltyId,
        reason: reason,
        evidence: evidence,
      );
      return Right(model.toEntity());
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedListEntity<AppealEntity>>> getAppealsHistory({
    int skip = 0,
    int limit = 10,
  }) async {
    try {
      final model = await _remoteDataSource.getAppealsHistory(
        skip: skip,
        limit: limit,
      );
      return Right(model.toEntity((item) => item.toEntity()));
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppealEntity>> getAppealById(int appealId) async {
    try {
      final model = await _remoteDataSource.getAppealById(appealId);
      return Right(model.toEntity());
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<void> connectSocket() => _socketDataSource.connectSocket();

  @override
  Stream<Map<String, dynamic>> get penaltyIssuedStream =>
      _socketDataSource.penaltyIssuedStream;

  @override
  Stream<Map<String, dynamic>> get restrictionLiftedStream =>
      _socketDataSource.restrictionLiftedStream;
}
