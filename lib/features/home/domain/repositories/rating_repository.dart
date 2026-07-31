import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/home/domain/entities/rating_tag.dart';

abstract interface class RatingRepository {
  Future<Either<Failure, List<RatingTag>>> getTags({
    required String targetType,
    required String sentiment,
  });

  Future<Either<Failure, void>> submitRating({
    required int tripId,
    required double score,
    String? comment,
    List<int>? tagIds,
  });
}
