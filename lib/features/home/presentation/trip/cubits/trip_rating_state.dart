import 'package:equatable/equatable.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/home/domain/entities/rating_tag.dart';

class TripRatingState extends Equatable {
  final bool isLoadingTags;
  final bool isSubmitting;

  /// API/repository errors — displayed via failureText(context, failure).
  final Failure? errorMessage;

  /// Local UI validation errors (e.g. "Please select a rating score").
  /// Shown directly as a string without going through failureText().
  final String? validationError;

  final bool isSuccess;

  final List<RatingTag> positiveTags;
  final List<RatingTag> negativeTags;

  final double currentScore;
  final Set<int> selectedTagIds;

  const TripRatingState({
    this.isLoadingTags = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.validationError,
    this.isSuccess = false,
    this.positiveTags = const [],
    this.negativeTags = const [],
    this.currentScore = 0.0,
    this.selectedTagIds = const {},
  });

  TripRatingState copyWith({
    bool? isLoadingTags,
    bool? isSubmitting,
    Failure? errorMessage,
    bool clearError = false,
    String? validationError,
    bool clearValidationError = false,
    bool? isSuccess,
    List<RatingTag>? positiveTags,
    List<RatingTag>? negativeTags,
    double? currentScore,
    Set<int>? selectedTagIds,
  }) {
    return TripRatingState(
      isLoadingTags: isLoadingTags ?? this.isLoadingTags,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      validationError: clearValidationError
          ? null
          : (validationError ?? this.validationError),
      isSuccess: isSuccess ?? this.isSuccess,
      positiveTags: positiveTags ?? this.positiveTags,
      negativeTags: negativeTags ?? this.negativeTags,
      currentScore: currentScore ?? this.currentScore,
      selectedTagIds: selectedTagIds ?? this.selectedTagIds,
    );
  }

  /// Returns the relevant tags for the current score.
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
        validationError,
        isSuccess,
        positiveTags,
        negativeTags,
        currentScore,
        selectedTagIds,
      ];
}
