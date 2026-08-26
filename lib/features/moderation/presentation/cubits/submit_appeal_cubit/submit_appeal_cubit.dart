import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/features/moderation/domain/usecases/submit_appeal_usecase.dart';
import 'package:mashena_rider/features/moderation/presentation/cubits/submit_appeal_cubit/submit_appeal_state.dart';

class SubmitAppealCubit extends Cubit<SubmitAppealState> {
  final SubmitAppealUsecase _submitAppealUsecase;

  SubmitAppealCubit(this._submitAppealUsecase)
    : super(const SubmitAppealState());

  /// Submits an appeal after validating the fields
  Future<void> submit({
    required int penaltyId,
    required String reason,
    String? evidence,
  }) async {
    final trimmedReason = reason.trim();
    if (trimmedReason.isEmpty) {
      emit(state.copyWith(validationError: 'REASON_REQUIRED'));
      return;
    }

    if (trimmedReason.length > 2000) {
      emit(state.copyWith(validationError: 'REASON_TOO_LONG'));
      return;
    }

    if (evidence != null && evidence.trim().isNotEmpty) {
      final uri = Uri.tryParse(evidence.trim());
      if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
        emit(state.copyWith(validationError: 'INVALID_EVIDENCE_URL'));
        return;
      }
    }

    emit(
      state.copyWith(
        status: SubmitAppealStatus.submitting,
        clearValidationError: true,
        failure: null,
      ),
    );

    final result = await _submitAppealUsecase(
      penaltyId: penaltyId,
      reason: trimmedReason,
      evidence: evidence?.trim(),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SubmitAppealStatus.failure,
          failure: failure,
        ),
      ),
      (appeal) => emit(
        state.copyWith(
          status: SubmitAppealStatus.success,
          submittedAppeal: appeal,
        ),
      ),
    );
  }

  void reset() {
    emit(const SubmitAppealState());
  }
}
