import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/core/constants/app_pagination.dart';
import 'package:mashena_rider/features/moderation/domain/usecases/get_appeals_history_usecase.dart';
import 'package:mashena_rider/features/moderation/presentation/cubits/appeals_history_cubit/appeals_history_state.dart';

class AppealsHistoryCubit extends Cubit<AppealsHistoryState> {
  final GetAppealsHistoryUsecase _getAppealsHistoryUsecase;

  AppealsHistoryCubit(this._getAppealsHistoryUsecase)
    : super(const AppealsHistoryState());

  /// Fetch initial page of appeals
  Future<void> fetchInitialAppeals() async {
    emit(
      state.copyWith(
        status: AppealsHistoryStatus.loading,
        failure: null,
        clearLoadMoreFailure: true,
      ),
    );

    final result = await _getAppealsHistoryUsecase(
      skip: 0,
      limit: AppPagination.defaultPageSize,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AppealsHistoryStatus.failure,
          failure: failure,
        ),
      ),
      (paginated) {
        final items = paginated.data;
        final hasMore = items.length >= AppPagination.defaultPageSize;
        emit(
          state.copyWith(
            status: AppealsHistoryStatus.success,
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
    final result = await _getAppealsHistoryUsecase(
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
    await fetchInitialAppeals();
  }
}
