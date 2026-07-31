import 'package:bloc/bloc.dart';
import 'package:mashena_rider/features/home/domain/repositories/rating_repository.dart';

import 'trip_rating_state.dart';

class TripRatingCubit extends Cubit<TripRatingState> {
  TripRatingCubit(this._ratingRepository) : super(const TripRatingState()) {
    _fetchTags();
  }

  final RatingRepository _ratingRepository;

  Future<void> _fetchTags() async {
    emit(state.copyWith(isLoadingTags: true, clearError: true));

    // Fetch both simultaneously to have them cached
    final results = await Future.wait([
      _ratingRepository.getTags(targetType: 'DRIVER', sentiment: 'POSITIVE'),
      _ratingRepository.getTags(targetType: 'DRIVER', sentiment: 'NEGATIVE'),
    ]);

    final positiveRes = results[0];
    final negativeRes = results[1];

    if (positiveRes.isLeft() && negativeRes.isLeft()) {
      // Use the first failure as the representative API error
      final failure = positiveRes.fold((l) => l, (_) => null)!;
      emit(state.copyWith(isLoadingTags: false, errorMessage: failure));
      return;
    }

    emit(
      state.copyWith(
        isLoadingTags: false,
        positiveTags: positiveRes.fold((l) => [], (r) => r),
        negativeTags: negativeRes.fold((l) => [], (r) => r),
      ),
    );
  }

  void setScore(double score) {
    if (state.currentScore == score) return;

    // Determine if sentiment changed to clear old tags
    final oldSentimentIsPositive = state.currentScore >= 3;
    final newSentimentIsPositive = score >= 3;

    Set<int> selectedTags = state.selectedTagIds;
    if (state.currentScore != 0 &&
        (oldSentimentIsPositive != newSentimentIsPositive)) {
      // Clear selected tags if sentiment switches between POSITIVE/NEGATIVE
      selectedTags = {};
    }

    emit(state.copyWith(currentScore: score, selectedTagIds: selectedTags));
  }

  void toggleTag(int tagId) {
    final updatedTags = Set<int>.from(state.selectedTagIds);
    if (updatedTags.contains(tagId)) {
      updatedTags.remove(tagId);
    } else {
      updatedTags.add(tagId);
    }
    emit(state.copyWith(selectedTagIds: updatedTags));
  }

  Future<void> submitRating({
    required int tripId,
    required String? comment,
  }) async {
    if (state.currentScore == 0) {
      // Local UI validation — not an API failure
      emit(
        state.copyWith(
          validationError: 'Please select a rating score',
          clearValidationError: false,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        clearError: true,
        clearValidationError: true,
      ),
    );

    final result = await _ratingRepository.submitRating(
      tripId: tripId,
      score: state.currentScore,
      comment: comment,
      tagIds: state.selectedTagIds.toList(),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isSubmitting: false, errorMessage: failure)),
      (_) => emit(state.copyWith(isSubmitting: false, isSuccess: true)),
    );
  }
}
