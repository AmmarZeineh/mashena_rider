import 'dart:async';
import 'package:mashena_rider/core/base/base_cubit.dart';
import 'package:mashena_rider/features/moderation/domain/repositories/moderation_repository.dart';
import 'package:mashena_rider/features/moderation/domain/usecases/get_moderation_overview_usecase.dart';
import 'package:mashena_rider/features/moderation/presentation/cubits/moderation_overview_cubit/moderation_overview_state.dart';

class ModerationOverviewCubit extends BaseCubit<ModerationOverviewState> {
  final GetModerationOverviewUsecase _getOverviewUsecase;
  final ModerationRepository _repository;

  StreamSubscription<Map<String, dynamic>>? _penaltyIssuedSubscription;
  StreamSubscription<Map<String, dynamic>>? _restrictionLiftedSubscription;

  ModerationOverviewCubit({
    required GetModerationOverviewUsecase getOverviewUsecase,
    required ModerationRepository repository,
  }) : _getOverviewUsecase = getOverviewUsecase,
       _repository = repository,
       super(const ModerationOverviewState()) {
    _listenToRealtimeEvents();
  }

  void _listenToRealtimeEvents() {
    _repository.connectSocket();
    _penaltyIssuedSubscription = _repository.penaltyIssuedStream.listen((data) {
      final penaltyType = data['penaltyType']?.toString() ?? '';
      final reason = data['reason']?.toString() ?? '';
      final msg = reason.isNotEmpty ? '$penaltyType: $reason' : penaltyType;
      emit(state.copyWith(realTimeNoticeMessage: msg));
      refreshOverview();
    });

    _restrictionLiftedSubscription = _repository.restrictionLiftedStream.listen((
      data,
    ) {
      final reason = data['reason']?.toString() ?? '';
      emit(state.copyWith(realTimeNoticeMessage: reason));
      refreshOverview();
    });
  }

  /// Fetches the overview from backend
  Future<void> fetchOverview() async {
    emit(
      state.copyWith(
        status: ModerationOverviewStatus.loading,
        failure: null,
        clearRealTimeNotice: true,
      ),
    );

    final result = await _getOverviewUsecase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ModerationOverviewStatus.failure,
          failure: failure,
        ),
      ),
      (overview) => emit(
        state.copyWith(
          status: ModerationOverviewStatus.success,
          overview: overview,
        ),
      ),
    );
  }

  /// Silent refresh
  Future<void> refreshOverview() async {
    final result = await _getOverviewUsecase();
    result.fold(
      (failure) {
        // Keep existing overview if refresh fails
      },
      (overview) => emit(
        state.copyWith(
          status: ModerationOverviewStatus.success,
          overview: overview,
        ),
      ),
    );
  }

  void clearRealTimeNotice() {
    emit(state.copyWith(clearRealTimeNotice: true));
  }

  @override
  Future<void> close() {
    _penaltyIssuedSubscription?.cancel();
    _restrictionLiftedSubscription?.cancel();
    return super.close();
  }
}
