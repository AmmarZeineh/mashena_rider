import 'package:mashena_rider/core/base/base_cubit.dart';
import 'package:mashena_rider/core/constants/app_constants.dart';
import 'package:mashena_rider/features/home/domain/repositories/rating_repository.dart';
import 'package:mashena_rider/features/home/domain/usecases/pay_trip_with_wallet_usecase.dart';
import 'package:mashena_rider/features/wallet/domain/usecases/get_my_wallet_usecase.dart';

import 'trip_rating_state.dart';

class TripRatingCubit extends BaseCubit<TripRatingState> {
  final RatingRepository _ratingRepository;
  final PayTripWithWalletUsecase _payTripWithWalletUsecase;
  final GetMyWalletUsecase _getMyWalletUsecase;

  TripRatingCubit(
    this._ratingRepository, {
    required PayTripWithWalletUsecase payTripWithWalletUsecase,
    required GetMyWalletUsecase getMyWalletUsecase,
  }) : _payTripWithWalletUsecase = payTripWithWalletUsecase,
       _getMyWalletUsecase = getMyWalletUsecase,
       super(const TripRatingState()) {
    _fetchTags();
    fetchWalletBalance();
  }

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

  void selectPaymentMethod(TripPaymentMethod method) {
    emit(state.copyWith(paymentMethod: method, clearPaymentError: true));
  }

  Future<void> fetchWalletBalance() async {
    emit(state.copyWith(isLoadingWallet: true, clearPaymentError: true));
    final result = await _getMyWalletUsecase();
    result.fold(
      (failure) => emit(state.copyWith(isLoadingWallet: false)),
      (wallet) => emit(
        state.copyWith(isLoadingWallet: false, walletBalance: wallet.balance),
      ),
    );
  }

  Future<void> payWithWallet(int rideRequestId) async {
    if (state.isPayingWithWallet || state.isWalletPaid) return;

    emit(state.copyWith(isPayingWithWallet: true, clearPaymentError: true));

    final result = await _payTripWithWalletUsecase(rideRequestId);

    result.fold(
      (failure) => emit(
        state.copyWith(isPayingWithWallet: false, paymentError: failure),
      ),
      (paymentResult) => emit(
        state.copyWith(
          isPayingWithWallet: false,
          isWalletPaid: true,
          walletBalance: paymentResult.riderBalanceAfter,
          walletPaymentResult: paymentResult,
          clearPaymentError: true,
        ),
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

    emit(
      state.copyWith(
        currentScore: score,
        selectedTagIds: selectedTags,
        clearValidationError: true,
      ),
    );
  }

  void toggleTag(int tagId) {
    final updatedTags = Set<int>.from(state.selectedTagIds);
    if (updatedTags.contains(tagId)) {
      updatedTags.remove(tagId);
    } else {
      updatedTags.add(tagId);
    }
    emit(
      state.copyWith(selectedTagIds: updatedTags, clearValidationError: true),
    );
  }

  Future<void> submitRating({
    required int tripId,
    required String? comment,
  }) async {
    if (state.currentScore == 0) {
      // Local UI validation — missing star score
      emit(
        state.copyWith(
          validationError: AppConstants.errorSelectRatingScore,
          clearValidationError: false,
        ),
      );
      return;
    }

    if (state.selectedTagIds.isEmpty) {
      // Local UI validation — missing tag
      emit(
        state.copyWith(
          validationError: AppConstants.errorSelectRatingTag,
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
