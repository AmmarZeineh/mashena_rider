import 'package:mashena_rider/core/base/base_cubit.dart';
import 'package:mashena_rider/core/constants/app_pagination.dart';
import 'package:mashena_rider/features/moderation/domain/usecases/get_violations_history_usecase.dart';
import 'package:mashena_rider/features/moderation/presentation/cubits/violations_history_cubit/violations_history_state.dart';

class ViolationsHistoryCubit extends BaseCubit<ViolationsHistoryState> {
  final GetViolationsHistoryUsecase _getViolationsHistoryUsecase;

  ViolationsHistoryCubit(this._getViolationsHistoryUsecase)
    : super(const ViolationsHistoryState());

  /// Fetch initial page of violations
  Future<void> fetchInitialViolations() async {
    emit(
      state.copyWith(
        status: ViolationsHistoryStatus.loading,
        failure: null,
        clearLoadMoreFailure: true,
      ),
    );

    final result = await _getViolationsHistoryUsecase(
      skip: 0,
      limit: AppPagination.defaultPageSize,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ViolationsHistoryStatus.failure,
          failure: failure,
        ),
      ),
      (paginated) {
        final items = paginated.data;
        final hasMore = items.length >= AppPagination.defaultPageSize;
        emit(
          state.copyWith(
            status: ViolationsHistoryStatus.success,
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
    final result = await _getViolationsHistoryUsecase(
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

  Future<void> refresh() async {
    await fetchInitialViolations();
  }
}
