import 'package:mashena_rider/core/constants/app_backend_endpoints.dart';
import 'package:mashena_rider/core/network/api_client.dart';
import 'package:mashena_rider/features/moderation/data/models/appeal_model.dart';
import 'package:mashena_rider/features/moderation/data/models/moderation_overview_model.dart';
import 'package:mashena_rider/features/moderation/data/models/paginated_response_model.dart';
import 'package:mashena_rider/features/moderation/data/models/penalty_model.dart';
import 'package:mashena_rider/features/moderation/data/models/restriction_model.dart';
import 'package:mashena_rider/features/moderation/data/models/violation_model.dart';

abstract interface class ModerationRemoteDataSource {
  Future<ModerationOverviewModel> getModerationOverview();

  Future<PaginatedResponseModel<PenaltyModel>> getPenaltiesHistory({
    int skip = 0,
    int limit = 10,
  });

  Future<PaginatedResponseModel<ViolationModel>> getViolationsHistory({
    int skip = 0,
    int limit = 10,
  });

  Future<List<RestrictionModel>> getActiveRestrictions();

  Future<AppealModel> submitAppeal({
    required int penaltyId,
    required String reason,
    String? evidence,
  });

  Future<PaginatedResponseModel<AppealModel>> getAppealsHistory({
    int skip = 0,
    int limit = 10,
  });

  Future<AppealModel> getAppealById(int appealId);
}

class ModerationRemoteDataSourceImpl implements ModerationRemoteDataSource {
  final ApiClient _api;

  const ModerationRemoteDataSourceImpl(this._api);

  @override
  Future<ModerationOverviewModel> getModerationOverview() async {
    final response = await _api.get(BackendEndpoints.moderationOverview);
    return ModerationOverviewModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<PaginatedResponseModel<PenaltyModel>> getPenaltiesHistory({
    int skip = 0,
    int limit = 10,
  }) async {
    final response = await _api.get(
      BackendEndpoints.myPenalties,
      query: {'skip': skip, 'limit': limit},
    );
    return PaginatedResponseModel<PenaltyModel>.fromJson(
      response as Map<String, dynamic>,
      PenaltyModel.fromJson,
    );
  }

  @override
  Future<PaginatedResponseModel<ViolationModel>> getViolationsHistory({
    int skip = 0,
    int limit = 10,
  }) async {
    final response = await _api.get(
      BackendEndpoints.myViolations,
      query: {'skip': skip, 'limit': limit},
    );
    return PaginatedResponseModel<ViolationModel>.fromJson(
      response as Map<String, dynamic>,
      ViolationModel.fromJson,
    );
  }

  @override
  Future<List<RestrictionModel>> getActiveRestrictions() async {
    final response = await _api.get(BackendEndpoints.myRestrictions);
    final rawList = response as List<dynamic>? ?? [];
    return rawList
        .whereType<Map<String, dynamic>>()
        .map(RestrictionModel.fromJson)
        .toList();
  }

  @override
  Future<AppealModel> submitAppeal({
    required int penaltyId,
    required String reason,
    String? evidence,
  }) async {
    final body = <String, dynamic>{
      'reason': reason,
      if (evidence != null && evidence.trim().isNotEmpty)
        'evidence': evidence.trim(),
    };
    final response = await _api.post(
      BackendEndpoints.appealPenalty(penaltyId),
      body: body,
    );
    return AppealModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<PaginatedResponseModel<AppealModel>> getAppealsHistory({
    int skip = 0,
    int limit = 10,
  }) async {
    final response = await _api.get(
      BackendEndpoints.myAppeals,
      query: {'skip': skip, 'limit': limit},
    );
    return PaginatedResponseModel<AppealModel>.fromJson(
      response as Map<String, dynamic>,
      AppealModel.fromJson,
    );
  }

  @override
  Future<AppealModel> getAppealById(int appealId) async {
    final response = await _api.get(BackendEndpoints.appealDetails(appealId));
    return AppealModel.fromJson(response as Map<String, dynamic>);
  }
}
