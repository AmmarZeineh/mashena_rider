import 'package:dartz/dartz.dart';
import 'package:mashena_rider/features/home/domain/entities/rating_tag.dart';

abstract interface class RatingRepository {
  Future<Either<String, List<RatingTag>>> getTags({
    required String targetType,
    required String sentiment,
  });

  Future<Either<String, void>> submitRating({
    required int tripId,
    required double score,
    String? comment,
    List<int>? tagIds,
  });
}
