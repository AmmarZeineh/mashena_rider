import '../../domain/entities/rating_tag.dart';
import '../models/rating_tag_model.dart';

extension RatingTagModelMapper on RatingTagModel {
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
