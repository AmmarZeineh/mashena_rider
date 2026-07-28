import 'package:equatable/equatable.dart';
import 'package:mashena_rider/features/home/domain/entities/rating_tag.dart';

class TripRatingState extends Equatable {
  final bool isLoadingTags;
  final bool isSubmitting;
  final String? errorMessage;
  final bool isSuccess;

  final List<RatingTag> positiveTags;
  final List<RatingTag> negativeTags;

  final double currentScore;
  final Set<int> selectedTagIds;

  const TripRatingState({
    this.isLoadingTags = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.isSuccess = false,
    this.positiveTags = const [],
    this.negativeTags = const [],
    this.currentScore = 0.0,
    this.selectedTagIds = const {},
  });

  TripRatingState copyWith({
    bool? isLoadingTags,
    bool? isSubmitting,
    String? errorMessage,
    bool? clearError,
    bool? isSuccess,
    List<RatingTag>? positiveTags,
    List<RatingTag>? negativeTags,
    double? currentScore,
    Set<int>? selectedTagIds,
  }) {
    return TripRatingState(
      isLoadingTags: isLoadingTags ?? this.isLoadingTags,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError == true ? null : (errorMessage ?? this.errorMessage),
      isSuccess: isSuccess ?? this.isSuccess,
      positiveTags: positiveTags ?? this.positiveTags,
      negativeTags: negativeTags ?? this.negativeTags,
      currentScore: currentScore ?? this.currentScore,
      selectedTagIds: selectedTagIds ?? this.selectedTagIds,
    );
  }

  // Helper to get the relevant tags for current score
  List<RatingTag> get currentAvailableTags {
    if (currentScore == 0) return [];
    if (currentScore >= 3) return positiveTags;
    return negativeTags;
  }

  @override
  List<Object?> get props => [
        isLoadingTags,
        isSubmitting,
        errorMessage,
        isSuccess,
        positiveTags,
        negativeTags,
        currentScore,
        selectedTagIds,
      ];
}
