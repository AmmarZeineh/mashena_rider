import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mashena_rider/features/home/domain/entities/rating_tag.dart';

part 'rating_tag_model.freezed.dart';
part 'rating_tag_model.g.dart';

@freezed
abstract class RatingTagModel with _$RatingTagModel {
  const RatingTagModel._();

  const factory RatingTagModel({
    required int id,
    required String code,
    String? name,
    List<RatingTagLocalizationModel>? localizations,
  }) = _RatingTagModel;

  factory RatingTagModel.fromJson(Map<String, dynamic> json) =>
      _$RatingTagModelFromJson(json);

  RatingTag toEntity() {
    String? finalName = name;
    if (localizations != null && localizations!.isNotEmpty) {
      // Just pick the first localization if name is null, ideally match language code
      finalName ??= localizations!.first.name;
    }
    return RatingTag(
      id: id,
      code: code,
      name: finalName,
    );
  }
}

@freezed
abstract class RatingTagLocalizationModel with _$RatingTagLocalizationModel {
  const factory RatingTagLocalizationModel({
    required String languageCode,
    required String name,
  }) = _RatingTagLocalizationModel;

  factory RatingTagLocalizationModel.fromJson(Map<String, dynamic> json) =>
      _$RatingTagLocalizationModelFromJson(json);
}
