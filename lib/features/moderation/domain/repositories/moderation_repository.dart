import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/moderation/domain/entities/appeal_entity.dart';
import 'package:mashena_rider/features/moderation/domain/entities/moderation_overview_entity.dart';
import 'package:mashena_rider/features/moderation/domain/entities/paginated_list_entity.dart';
import 'package:mashena_rider/features/moderation/domain/entities/penalty_entity.dart';
import 'package:mashena_rider/features/moderation/domain/entities/restriction_entity.dart';
import 'package:mashena_rider/features/moderation/domain/entities/violation_entity.dart';

/// Contract interface for the Moderation repository.
abstract interface class ModerationRepository {
  /// Fetches the high-level moderation overview for the current rider.
  Future<Either<Failure, ModerationOverviewEntity>> getModerationOverview();

  /// Fetches the paginated history of penalties issued against the rider.
  Future<Either<Failure, PaginatedListEntity<PenaltyEntity>>>
  getPenaltiesHistory({int skip = 0, int limit = 10});

  /// Fetches the paginated history of violations recorded for the rider.
  Future<Either<Failure, PaginatedListEntity<ViolationEntity>>>
  getViolationsHistory({int skip = 0, int limit = 10});

  /// Fetches the active feature restrictions currently applied to the rider.
  Future<Either<Failure, List<RestrictionEntity>>> getActiveRestrictions();

  /// Submits an appeal against an active penalty.
  Future<Either<Failure, AppealEntity>> submitAppeal({
    required int penaltyId,
    required String reason,
    String? evidence,
  });

  /// Fetches the paginated history of appeals submitted by the rider.
  Future<Either<Failure, PaginatedListEntity<AppealEntity>>> getAppealsHistory({
    int skip = 0,
    int limit = 10,
  });

  /// Fetches detailed information about a specific appeal by ID.
  Future<Either<Failure, AppealEntity>> getAppealById(int appealId);

  /// Connects the real-time moderation socket.
  Future<void> connectSocket();

  /// Stream of real-time penalty issued socket events.
  Stream<Map<String, dynamic>> get penaltyIssuedStream;

  /// Stream of real-time restriction lifted socket events.
  Stream<Map<String, dynamic>> get restrictionLiftedStream;
}
