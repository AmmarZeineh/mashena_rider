import 'package:mashena_rider/core/base/base_cubit.dart';
import 'package:mashena_rider/core/constants/app_pagination.dart';
import 'package:mashena_rider/features/moderation/domain/entities/penalty_status.dart';
import 'package:mashena_rider/features/moderation/domain/usecases/get_penalties_history_usecase.dart';
import 'package:mashena_rider/features/moderation/presentation/cubits/penalties_history_cubit/penalties_history_state.dart';

class PenaltiesHistoryCubit extends BaseCubit<PenaltiesHistoryState> {
  final GetPenaltiesHistoryUsecase _getPenaltiesHistoryUsecase;

  PenaltiesHistoryCubit(this._getPenaltiesHistoryUsecase)
    : super(const PenaltiesHistoryState());

  /// Fetch initial page of penalties
  Future<void> fetchInitialPenalties() async {
    emit(
      state.copyWith(
        status: PenaltiesHistoryStatus.loading,
        failure: null,
        clearLoadMoreFailure: true,
      ),
    );

    final result = await _getPenaltiesHistoryUsecase(
      skip: 0,
      limit: AppPagination.defaultPageSize,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PenaltiesHistoryStatus.failure,
          failure: failure,
        ),
      ),
      (paginated) {
        final items = paginated.data;
        final hasMore = items.length >= AppPagination.defaultPageSize;
        emit(
          state.copyWith(
            status: PenaltiesHistoryStatus.success,
            items: items,
            hasMore: hasMore,
          ),
        );
      },
    );
  }

  /// Load next page
  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true, clearLoadMoreFailure: true));

    final currentSkip = state.items.length;
    final result = await _getPenaltiesHistoryUsecase(
      skip: currentSkip,
      limit: AppPagination.defaultPageSize,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingMore: false, loadMoreFailure: failure),
      ),
      (paginated) {
        final newItems = paginated.data;
        final hasMore = newItems.length >= AppPagination.defaultPageSize;
        emit(
          state.copyWith(
            items: [...state.items, ...newItems],
            hasMore: hasMore,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  /// Filter penalties locally or set filter
  void setFilterStatus(PenaltyStatus? filter) {
    if (filter == null) {
      emit(state.copyWith(clearFilter: true));
    } else {
      emit(state.copyWith(filterStatus: filter));
    }
  }

  Future<void> refresh() async {
    await fetchInitialPenalties();
  }
}
