import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/constants/app_backend_endpoints.dart';
import 'package:mashena_rider/core/network/api_client.dart';
import 'package:mashena_rider/features/home/data/models/rating_tag_model.dart';
import 'package:mashena_rider/features/home/domain/entities/rating_tag.dart';
import 'package:mashena_rider/features/home/domain/repositories/rating_repository.dart';

class RatingRepositoryImpl implements RatingRepository {
  final ApiClient _apiClient;

  RatingRepositoryImpl(this._apiClient);

  @override
  Future<Either<String, List<RatingTag>>> getTags({
    required String targetType,
    required String sentiment,
  }) async {
    try {
      final response = await _apiClient.get(
        BackendEndpoints.ratingTags,
        query: {
          'targetType': targetType,
          'sentiment': sentiment,
          'skip': 0,
          'limit': 100,
        },
      );

      if (response is! Map) {
        return const Left('Invalid rating tags response');
      }

      final jsonMap = Map<String, dynamic>.from(response);
      final data = jsonMap['data'];

      if (data is List) {
        final tags = data
            .map(
              (e) => RatingTagModel.fromJson(
                Map<String, dynamic>.from(e),
              ).toEntity(),
            )
            .toList();
        return Right(tags);
      }

      return const Right([]);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> submitRating({
    required int tripId,
    required double score,
    String? comment,
    List<int>? tagIds,
  }) async {
    try {
      final body = {
        'score': score,
        if (comment != null && comment.isNotEmpty) 'comment': comment,
        if (tagIds != null && tagIds.isNotEmpty) 'tagIds': tagIds,
      };

      await _apiClient.post(
        BackendEndpoints.getSubmitRatingEndpoint(tripId),
        body: body,
      );

      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
