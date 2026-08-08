import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_rating_model.freezed.dart';
part 'trip_rating_model.g.dart';

@freezed
abstract class TripRatingModel with _$TripRatingModel {
  const factory TripRatingModel({
    required int id,
    int? score,
    String? comment,
    int? fromUserId,
    int? toUserId,
    String? createdAt,
  }) = _TripRatingModel;

  factory TripRatingModel.fromJson(Map<String, dynamic> json) =>
      _$TripRatingModelFromJson(json);
}
